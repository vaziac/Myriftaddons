-- ***************************************************************************************************************************************************
-- * DataGrid.lua                                                                                                                                    *
-- ***************************************************************************************************************************************************
-- * Data display                                                                                                                                    *
-- ***************************************************************************************************************************************************
-- * 0.4.12/ 2013.09.17 / Baanano: Updated to the new event model                                                                                    *
-- * 0.4.4 / 2012.08.28 / Baanano: TextCellType's FontSize can be a function too now                                                                 *
-- * 0.4.1 / 2012.07.18 / Baanano: Rewritten                                                                                                         *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local CEAttach = Command.Event.Attach
local CreateTask = LibScheduler.CreateTask
local ITFrame = Inspect.Time.Frame
local ITReal = Inspect.Time.Real
local MCeil = math.ceil
local MCos = math.cos
local MFloor = math.floor
local MMax = math.max
local MMin = math.min
local Panel = PublicInterface.Panel
local Release = LibScheduler.Release
local ShadowedText = PublicInterface.ShadowedText
local TInsert = table.insert
local TRemove = table.remove
local TSort = table.sort
local UICreateFrame = UI.CreateFrame
local ipairs = ipairs
local pairs = pairs
local tostring = tostring
local type = type
local unpack = unpack

local HEADER_FRAME_HEIGHT = 26
local HEADER_FRAME_HORIZONTAL_MARGIN = 0
local HEADER_FRAME_VERTICAL_MARGIN = 2
local HEADER_FONT_SIZE = 13
local HEADER_SORT_GLYPH_WIDTH = 12
local HEADER_SORT_OUT_COLOR = { 1, 1, 1, 1 }
local HEADER_SORT_IN_COLOR = { 0.5, 0.5, 0.5, 1 }
local HEADER_SORT_SHADOW_SELECTED_COLOR = { 0.25, 0.25, 0, 0.25 }
local HEADER_SORT_SHADOW_UNSELECTED_COLOR = { 0, 0, 0, 0.25}
local ROW_DEFAULT_HEIGHT = 20
local ROW_DEFAULT_MARGIN = 0
local ROW_DEFAULT_BACKGROUND_COLOR = { 0, 0, 0, 0 }
local VERTICAL_SCROLLBAR_WIDTH = 20
local VERTICAL_SCROLLBAR_HORIZONTAL_MARGIN = 2
local PAGESIZE = 1000

-- Cell Types
local registeredCellTypes = {}

function PublicInterface.RegisterCellType(name, constructor)
	if type(constructor) ~= "function" then return false end
	registeredCellTypes[name] = constructor
	return true
end

--[[ 		Text CellType
Extra params:
 * Alignment
  + left: Aligns text to left (default)
  + center: Aligns text to center
  + right: Aligns text to right
 * Formatter
  + none: Doesn't apply any format to the value (default)
  + date: Formats the value as a date (using "%a %X")
  + function
 * Color
  + {r, g, b, a} -- Color to use
  + function
 * FontSize
  + fontSize
]]
local function TextCellType(name, parent)
	local cell = UICreateFrame("Frame", name, parent)
	local textCell = UICreateFrame("Text", name .. ".Text", cell)
	
	function textCell:SetValue(key, value, width, extra)
		-- Apply Formatter
		local text = ""
		if extra and extra.Formatter == "date" and type(value) == "number" then
			text = ODate("%a %X", value)
		elseif extra and type(extra.Formatter) == "function" then
			text = extra.Formatter(value, key)
		else
			text = tostring(value)
		end
		self:SetText(text)
		
		if extra and type(extra.FontSize) == "number" then
			self:SetFontSize(extra.FontSize)
		elseif extra and type(extra.FontSize) == "function" then
			self:SetFontSize(extra.FontSize(value, key))
		end
		
		-- Apply alignment
		local offset = 0
		if extra and extra.Alignment == "center" then
			offset = offset + (width - self:GetWidth()) / 2
		elseif extra and extra.Alignment == "right" then
			offset = offset + width - self:GetWidth()
		end
		self:ClearAll()
		self:SetPoint("CENTERLEFT", cell, "CENTERLEFT", offset, 0)
		
		-- Apply Color
		if extra and type(extra.Color) == "table" then
			self:SetFontColor(unpack(extra.Color))
		elseif extra and type(extra.Color) == "function" then
			self:SetFontColor(unpack(extra.Color(value, key)))
		end
	end
	
	function cell:SetValue(key, value, width, extra) textCell:SetValue(key, value, width, extra) end
	
	return cell
end
PublicInterface.RegisterCellType("Text", TextCellType)

function PublicInterface.DataGrid(name, parent)
	local bDataGrid = UICreateFrame("Frame", name, parent)
	
	local externalPanel = Panel(bDataGrid:GetName() .. ".ExternalPanel", bDataGrid)
	local externalPanelContent = externalPanel:GetContent()
	local headerFrame = UICreateFrame("Mask", bDataGrid:GetName() .. ".HeaderFrame", externalPanel:GetContent())
	local verticalScrollBar = UICreateFrame("RiftScrollbar", bDataGrid:GetName() .. ".VerticalScrollBar", externalPanel:GetContent())
	local internalPanel = Panel(bDataGrid:GetName() .. ".InternalPanel", externalPanel:GetContent())
	local internalPanelContent = internalPanel:GetContent()
	local loadingOverlay = UICreateFrame("Frame", bDataGrid:GetName() .. ".LoadingOverlay", externalPanel:GetContent())
	local loadingPanel = Panel(loadingOverlay:GetName() .. ".LoadingPanel", loadingOverlay)
	local loadingPanelContent = loadingPanel:GetContent()
	local loadingBar = UICreateFrame("Texture", loadingOverlay:GetName() .. ".LoadingBar", loadingPanelContent)
	
	externalPanel:SetAllPoints()

	headerFrame:SetVisible(false)
	
	verticalScrollBar:SetRange(0, 0)
	verticalScrollBar:SetPosition(0)

	internalPanel:SetInvertedBorder(true)
	
	loadingOverlay:SetBackgroundColor(0, 0, 0, 0.5)
	loadingOverlay:SetAllPoints(internalPanelContent)
	loadingOverlay:SetLayer(internalPanel:GetLayer() + 1)
	loadingOverlay:SetVisible(false)
	
	loadingPanel:SetPoint("CENTER", loadingOverlay, "CENTER")
	loadingPanel:SetHeight(30)
	loadingPanel:GetContent():SetBackgroundColor(0, 0, 0, 0.75)
	
	loadingBar:SetPoint("CENTER", loadingPanelContent, 0.5, 0.5)
	loadingBar:SetTextureAsync("Rift", "bar_rogue.png.dds")
	loadingBar:SetHeight(20)

	local paddings = { left = 0, top = 0, right = 0, bottom = 0 }
	local rowHeight, rowMargin = ROW_DEFAULT_HEIGHT, ROW_DEFAULT_MARGIN
	local unselectedRowBackgroundColorSelector, selectedRowBackgroundColorSelector = ROW_DEFAULT_BACKGROUND_COLOR, ROW_DEFAULT_BACKGROUND_COLOR
	
	local rows = {}
	local numDisplayedRows = 0
	
	local columns = {}
	local columnHeaders = {}
	local columnOrder = {}

	local data = {}
	local selectedKey = nil

	local filterKeys = {}
	local filterFunction = nil
	local filterCallback = nil

	local keyOrdering = {}
	local orderings = {}
	local filterKeyOrdering = {}
	local filterOrderings = {}

	local dataCount = 0
	local filterCount = 0
	
	local orderColumn = nil
	local orderReverse = false
	
	local loadingBarEnabled = false
	local loadingOffset = MFloor(ITReal() * 1000000) % 1000

	local function ResetLayout()
		local internalPanelPaddingTop = paddings.top + (headerFrame:GetVisible() and HEADER_FRAME_HEIGHT or 0)
		local internalPanelPaddingRight = paddings.right + (verticalScrollBar:GetVisible() and VERTICAL_SCROLLBAR_WIDTH or 0)
		
		internalPanel:ClearAll()
		internalPanel:SetPoint("TOPLEFT", externalPanelContent, "TOPLEFT", paddings.left, internalPanelPaddingTop)
		internalPanel:SetPoint("BOTTOMRIGHT", externalPanelContent, "BOTTOMRIGHT", -internalPanelPaddingRight, -paddings.bottom)
		
		headerFrame:ClearAll()
		headerFrame:SetPoint("TOPLEFT", internalPanel, "TOPLEFT", HEADER_FRAME_HORIZONTAL_MARGIN, HEADER_FRAME_VERTICAL_MARGIN - HEADER_FRAME_HEIGHT)
		headerFrame:SetPoint("BOTTOMRIGHT", internalPanel, "TOPRIGHT", -HEADER_FRAME_HORIZONTAL_MARGIN, -HEADER_FRAME_VERTICAL_MARGIN)
		
		verticalScrollBar:ClearAll()
		verticalScrollBar:SetPoint("TOPLEFT", internalPanel, "TOPRIGHT", VERTICAL_SCROLLBAR_HORIZONTAL_MARGIN, 0)
		verticalScrollBar:SetPoint("BOTTOMRIGHT", internalPanel, "BOTTOMRIGHT", VERTICAL_SCROLLBAR_WIDTH - VERTICAL_SCROLLBAR_HORIZONTAL_MARGIN, 0)
	end
	
	local function CreateColumnHeader(columnID)
		local header = UICreateFrame("Frame", headerFrame:GetName() .. "." .. columnID, headerFrame)
	
		local headerTitle = ShadowedText(header:GetName() .. ".Title", header)
		local headerGlyph = UICreateFrame("Texture", header:GetName() .. ".Glyph", header)
		
		local reverseSort = false
	
		headerTitle:SetFontSize(HEADER_FONT_SIZE)
		headerTitle:SetShadowOffset(2, 2)
		headerTitle:SetFontColor(unpack(HEADER_SORT_OUT_COLOR))
		headerTitle:SetShadowColor(unpack(HEADER_SORT_SHADOW_UNSELECTED_COLOR))
		headerTitle:SetText(columns[columnID].headerText or "")

		headerGlyph:SetVisible(false)
		
		if columns[columnID].orderSelector then
			headerTitle:SetPoint("CENTER", header, "CENTER", -HEADER_SORT_GLYPH_WIDTH / 2, 0)
			headerGlyph:SetPoint("CENTERLEFT", header, "CENTERRIGHT", - HEADER_SORT_GLYPH_WIDTH, 0)
			headerGlyph:SetPoint("CENTERRIGHT", header, "CENTERRIGHT", 0, 0)

			header:EventAttach(Event.UI.Input.Mouse.Cursor.In,
				function()
					headerTitle:SetFontColor(unpack(HEADER_SORT_IN_COLOR))
				end, header:GetName() .. "OnMouseIn")
			
			header:EventAttach(Event.UI.Input.Mouse.Cursor.Out,
				function()
					headerTitle:SetFontColor(unpack(HEADER_SORT_OUT_COLOR))
				end, header:GetName() .. "OnMouseOut")
			
			header:EventAttach(Event.UI.Input.Mouse.Left.Click,
				function()
					bDataGrid:SetOrder(columnID, reverseSort)
				end, header:GetName() .. "OnLeftClick")
		else
			headerTitle:SetPoint("CENTER", header, "CENTER", 0, 0)
		end
		
		function header:ResetHeader()
			if columnID == orderColumn then
				headerGlyph:SetVisible(true)
				headerTitle:SetShadowColor(unpack(HEADER_SORT_SHADOW_SELECTED_COLOR))
				headerGlyph:SetTextureAsync(addonID, orderReverse and "Textures/SortedDescendingGlyph.png" or "Textures/SortedAscendingGlyph.png")
				reverseSort = not orderReverse
			else
				headerTitle:SetShadowColor(unpack(HEADER_SORT_SHADOW_UNSELECTED_COLOR))
				headerGlyph:SetVisible(false)
				reverseSort = false
			end
		end
		
		function header:ChangeHeaderText(text)
			headerTitle:SetText(text)
		end
	
		return header
	end
	
	local function CreateCell(row, columnID, cellType)
		local cellConstructor = type(cellType) == "function" and cellType or registeredCellTypes[cellType] or registeredCellTypes["Text"]
		return cellConstructor(row:GetName() .. "." .. columnID, row)
	end

	local function RefreshCells()
		local width = MFloor(internalPanelContent:GetWidth() + 0.5) - 2 * rowMargin
		if width <= 0 then return end

		local columnWidths = {}

		local remainingWidth = width
		local skipNext = false
		local totalWeight = 0
		for _, columnID in ipairs(columnOrder) do
			local columnData = columns[columnID]
			if not columnData.hidden then
				if not skipNext and columnData.minSize <= remainingWidth then
					columnWidths[columnID] = columnData.minSize
					remainingWidth = remainingWidth - columnData.minSize
					totalWeight = totalWeight + columnData.weightSize
				else
					columnWidths[columnID] = 0
					skipNext = true
				end
			end
		end
		
		if remainingWidth > 0 and totalWeight > 0 then
			remainingWidth = remainingWidth / totalWeight
			for columnID, columnData in pairs(columns) do
				if not columnData.hidden and columnWidths[columnID] > 0 then
					columnWidths[columnID] = columnWidths[columnID] + remainingWidth * columnData.weightSize
				end
			end
		end

		local ordering = filterOrderings[orderColumn] or filterKeyOrdering
		
		remainingWidth = 0
		for columnIndex, columnID in ipairs(columnOrder) do
			local columnData = columns[columnID]
			if not columnData.hidden then
				if bDataGrid:GetHeadersVisible() then
					columnHeaders[columnID]:ClearAll()
					columnHeaders[columnID]:SetPoint("TOPLEFT", headerFrame, "TOPLEFT", remainingWidth, 0)
					columnHeaders[columnID]:SetPoint("BOTTOMRIGHT", headerFrame, "BOTTOMLEFT", remainingWidth + columnWidths[columnID], 0)
					columnHeaders[columnID]:ResetHeader()
				end
				
				for index = 1, numDisplayedRows do
					local row = rows[index]
				
					local dataIndex = index + MFloor(verticalScrollBar:GetPosition())
					if orderReverse then dataIndex = #ordering - dataIndex + 1 end
					
					local dataKey = ordering[dataIndex]
					if dataKey then
						row.cells[columnID]:ClearAll()
						row.cells[columnID]:SetPoint("TOPLEFT", row, "TOPLEFT", remainingWidth, 0)
						row.cells[columnID]:SetPoint("BOTTOMRIGHT", row, "BOTTOMLEFT", remainingWidth + columnWidths[columnID], 0)
						row.cells[columnID]:SetValue(dataKey, not columnData.valueSelector and data[dataKey] or data[dataKey][columnData.valueSelector], columnWidths[columnID], columnData.extra)
						if columnIndex == 1 then
							local colorSelector = dataKey == selectedKey and selectedRowBackgroundColorSelector or unselectedRowBackgroundColorSelector
							if type(colorSelector) == "function" then
								colorSelector = colorSelector(dataKey, data[dataKey])
							end
							
							row:SetBackgroundColor(unpack(colorSelector))
							row:SetVisible(true)
							
							row.dataKey = dataKey
						end
					else
						if columnIndex == 1 then
							row:SetVisible(false)
						end
					end
				end
				remainingWidth = remainingWidth + columnWidths[columnID]
			end
		end
	end
	
	local function RefreshScrollbar()
		verticalScrollBar:SetRange(0, MMax(dataCount - filterCount - numDisplayedRows + 1, 0))
		RefreshCells()
	end
	
	local function RefreshFilter()
		filterKeys = {}
		filterCount = 0

		for key, value in pairs(data) do
			if filterFunction and not filterFunction(key, value) then
				filterKeys[key] = true
				filterCount = filterCount + 1
			end
		end
		
		if filterCount > 0 then
			filterKeyOrdering = {}
			for _, key in ipairs(keyOrdering) do
				if not filterKeys[key] then
					TInsert(filterKeyOrdering, key)
				end
			end
			
			filterOrderings = {}
			for orderID, ordering in pairs(orderings) do
				filterOrderings[orderID] = {}
				for _, key in ipairs(ordering) do
					if not filterKeys[key] then
						TInsert(filterOrderings[orderID], key)
					end
				end
			end
		else
			filterKeyOrdering = keyOrdering
			filterOrderings = orderings
		end
		
		RefreshScrollbar()	
	end
	
	local function ResetRows()
		local numRowsDisplayable = MMax(MCeil(internalPanelContent:GetHeight() / rowHeight), 0)
		
		for newIndex = #rows + 1, numRowsDisplayable do
			local newRow = UICreateFrame("Frame", bDataGrid:GetName() .. ".Rows." .. newIndex, internalPanelContent)
			
			newRow.cells = {}
			newRow.dataKey = nil
			for columnID, columnData in pairs(columns) do
				newRow.cells[columnID] = CreateCell(newRow, columnID, columnData.cellType)
			end
			
			newRow:EventAttach(Event.UI.Input.Mouse.Left.Click.Dive,
				function(self, h)
					if h:GetTarget() ~= newRow then
						bDataGrid:SetSelectedKey(newRow.dataKey)
					end
				end, newRow:GetName() .. ".OnLeftClickDive")
			
			newRow:EventAttach(Event.UI.Input.Mouse.Left.Click,
				function()
					bDataGrid:SetSelectedKey(newRow.dataKey)
				end, newRow:GetName() .. ".OnLeftClick")
			
			newRow:EventAttach(Event.UI.Input.Mouse.Right.Click.Dive,
				function()
					bDataGrid:SetSelectedKey(newRow.dataKey)
					if bDataGrid.Event.RowRightClick then
						bDataGrid.Event.RowRightClick(bDataGrid, newRow.dataKey, newRow.dataKey and data[newRow.dataKey] or nil)
					end
				end, newRow:GetName() .. ".OnRightClickDive")			
			
			TInsert(rows, newRow)
		end
		
		for rowIndex, row in ipairs(rows) do
			row:SetVisible(rowIndex <= numRowsDisplayable)
			row:ClearAll()
			row:SetPoint("TOPLEFT", internalPanelContent, "TOPLEFT", rowMargin, (rowIndex - 1) * rowHeight + rowMargin)
			row:SetPoint("BOTTOMRIGHT", internalPanelContent, "TOPRIGHT", -rowMargin, rowIndex * rowHeight - rowMargin)
		end

		if numRowsDisplayable ~= numDisplayedRows then
			numDisplayedRows = numRowsDisplayable
			RefreshScrollbar()
		end
	end
	
	local function ResetColumns()
		for columnID, columnData in pairs(columns) do
			columnHeaders[columnID] = columnHeaders[columnID] or CreateColumnHeader(columnID)
			columnHeaders[columnID]:ChangeHeaderText(columns[columnID].headerText or "")
			for _, row in ipairs(rows) do
				row.cells[columnID] = row.cells[columnID] or CreateCell(row, columnID, columnData.cellType)
			end
		end
		for columnID, columnHeader in pairs(columnHeaders) do
			columnHeader:SetVisible(columns[columnID] and not columns[columnID].hidden and true or false)
		end
		for _, row in ipairs(rows) do
			for columnID, cell in pairs(row.cells) do
				cell:SetVisible(columns[columnID] and not columns[columnID].hidden and true or false)
			end
		end
		RefreshCells()
	end
	
	local function CreateOrdering(columnID, datum)
		local columnData = columns[columnID]
		if not columnData or not columnData.orderSelector then return end

		local sortedData = {}
		for key in pairs(datum) do TInsert(sortedData, key) end
		
		local orderSelector = columnData.orderSelector
		local valueSelector = columnData.valueSelector
		
		if type(orderSelector) == "string" then
			valueSelector = orderSelector
		end
		
		if type(orderSelector) ~= "function" then
			orderSelector = 
				function(keyA, keyB, valueA, valueB)
					valueA, valueB = valueA or 0, valueB or 0
					if valueA == valueB then return keyA < keyB end
					return valueA < valueB
				end
		end
		
		local orderFunction = function(a, b) return orderSelector(a, b, not valueSelector and datum[a] or datum[a][valueSelector], not valueSelector and datum[b] or datum[b][valueSelector]) end
		
		local orderPages = {}
		for index, key in ipairs(sortedData) do
			local page = MFloor(index / PAGESIZE) + 1
			orderPages[page] = orderPages[page] or {}
			TInsert(orderPages[page], key)
			Release()
		end
		
		for _, page in pairs(orderPages) do
			TSort(page, orderFunction)
			Release()
		end
		
		sortedData = {}
		repeat
			local minPageIndex = nil
			
			for pageIndex, page in pairs(orderPages) do
				if #page > 0 then
					if not minPageIndex or orderFunction(page[1], orderPages[minPageIndex][1]) then
						minPageIndex = pageIndex
					end
				end
			end
			
			if minPageIndex then
				TInsert(sortedData, orderPages[minPageIndex][1])
				TRemove(orderPages[minPageIndex], 1)
			end
			
			Release()
		until not minPageIndex		
		
		orderings[columnID] = sortedData
		
		if not orderColumn then
			orderColumn = columnID
			orderReverse = false
		end
	end
	
	local function RemoveOrdering(columnID)
		if orderColumn == columnID then
			orderColumn = nil
			for columnID, columnData in pairs(columns) do
				if columnData.orderSelector and not columnData.hidden then
					orderColumn = columnID
					orderReverse = false
					break
				end
			end
		end
	end

	local function GetSelectedIndex()
		local selectedIndex = nil
		local ordering = filterOrderings[orderColumn] or filterKeyOrdering
		for index, orderKey in ipairs(ordering) do
			if orderKey == selectedKey then
				selectedIndex = index
				if orderReverse then selectedIndex = #ordering - selectedIndex + 1 end
				break
			end
		end
		return selectedIndex
	end
	
	

	verticalScrollBar:EventAttach(Event.UI.Scrollbar.Change,	
		function()
			RefreshCells()
		end, verticalScrollBar:GetName() .. ".OnScrollbarChange")
	
	internalPanelContent:EventAttach(Event.UI.Layout.Size,
		function()
			ResetRows()
			ResetColumns()
			loadingPanel:SetWidth(internalPanelContent:GetWidth() / 3)
		end, internalPanelContent:GetName() .. ".OnSize")
	
	loadingPanelContent:EventAttach(Event.UI.Layout.Size,
		function()
			loadingBar:SetWidth(loadingPanelContent:GetWidth() / 4)
		end, loadingPanelContent:GetName() .. ".OnSize")
	
	internalPanelContent:EventAttach(Event.UI.Input.Mouse.Wheel.Forward,
		function()
			local minRange = verticalScrollBar:GetRange()
			verticalScrollBar:SetPosition(MMax(verticalScrollBar:GetPosition() - 1, minRange))
		end, internalPanelContent:GetName() .. ".OnWheelForward")

	internalPanelContent:EventAttach(Event.UI.Input.Mouse.Wheel.Back,
		function()
			local _, maxRange = verticalScrollBar:GetRange()
			verticalScrollBar:SetPosition(MMin(verticalScrollBar:GetPosition() + 1, maxRange))
		end, internalPanelContent:GetName() .. ".OnWheelBack")

	
	
	function bDataGrid:GetContent()
		return externalPanelContent
	end
	
	function bDataGrid:GetInternalContent()
		return internalPanelContent
	end
	
	function bDataGrid:GetPadding()
		return paddings.left, paddings.top, paddings.right, paddings.bottom
	end

	function bDataGrid:SetPadding(left, top, right, bottom)
		paddings.left = MMax(left or 0, 0)
		paddings.top = MMax(top or 0, 0)
		paddings.right = MMax(right or 0, 0)
		paddings.bottom = MMax(bottom or 0, 0)
		ResetLayout()
		RefreshCells()
	end

	function bDataGrid:GetHeadersVisible()
		return headerFrame:GetVisible()
	end

	function bDataGrid:SetHeadersVisible(visible)
		headerFrame:SetVisible(visible and true or false)
		ResetLayout()
		RefreshCells()
	end	

	function bDataGrid:GetRowHeight()
		return rowHeight
	end

	function bDataGrid:SetRowHeight(height)
		rowHeight = MMax(height, 0)
		rowMargin = MMin(MMax(rowMargin, 0), MFloor(rowHeight / 2))
		ResetRows()
	end

	function bDataGrid:GetRowMargin()
		return rowMargin
	end

	function bDataGrid:SetRowMargin(margin)
		rowMargin = MMin(MMax(margin, 0), MFloor(rowHeight / 2))
		ResetRows()
	end

	function bDataGrid:GetSelectedRowBackgroundColor()
		return selectedRowBackgroundColor
	end

	function bDataGrid:SetSelectedRowBackgroundColor(colorSelector)
		selectedRowBackgroundColorSelector = colorSelector
		RefreshCells()
	end

	function bDataGrid:GetUnselectedRowBackgroundColor()
		return unselectedRowBackgroundColor
	end

	function bDataGrid:SetUnselectedRowBackgroundColor(colorSelector)
		unselectedRowBackgroundColorSelector = colorSelector
		RefreshCells()
	end
	
	function bDataGrid:AddColumn(id, headerText, cellType, minSize, weightSize, valueSelector, orderSelector, extra, hidden)
		columns[id] =
		{
			headerText = headerText,
			cellType = cellType,
			minSize = minSize or 0,
			weightSize = weightSize or 0,
			valueSelector = valueSelector,
			orderSelector = orderSelector,
			extra = extra,
			hidden = hidden or nil,
		}
		TInsert(columnOrder, id)
		if orderSelector then
			CreateOrdering(id, data)
		end
		ResetColumns()
	end
	
	function bDataGrid:ModifyColumn(id, headerText, valueSelector, orderSelector, hidden)
		if not id or not columns[id] then return end
		
		local hadOrderSelector = columns[id].orderSelector
		
		columns[id].headerText = headerText
		columns[id].valueSelector = valueSelector
		columns[id].orderSelector = orderSelector
		columns[id].hidden = hidden or nil
		
		if hadOrderSelector and (not orderSelector or hidden) then
			RemoveOrdering(id)
		end
		
		if orderSelector then
			CreateOrdering(id, data)
		end
		
		ResetColumns()
	end
	
	function bDataGrid:RefreshFilter()
		local lastIndex = GetSelectedIndex() or 1
		
		RefreshFilter()
		
		if not selectedKey or not data[selectedKey] or filterKeys[selectedKey] then
			local ordering = filterOrderings[orderColumn] or filterKeyOrdering
			lastIndex = MMax(MMin(lastIndex, #ordering), 1)
			if orderReverse then lastIndex = #ordering - lastIndex + 1 end
			self:SetSelectedKey(ordering[lastIndex])
		end
	end
	
	function bDataGrid:SetFilter(filter, callback)
		if type(filter) ~= "function" then
			filterFunction = nil
			filterCallback = nil
		else
			filterFunction = filter
			filterCallback = callback
		end
		self:RefreshFilter()
	end
	
	function bDataGrid:SetOrder(columnID, reverse)
		if not columnID or not columns[columnID] or not columns[columnID].orderSelector or columns[columnID].hidden then return end
		orderColumn = columnID
		orderReverse = reverse and true or false
		RefreshCells()
	end
	
	function bDataGrid:GetData()
		local ret = {}
		for key, value in pairs(data) do
			ret[key] = value
		end
		return ret
	end
	
	function bDataGrid:GetFilteredData()
		local ret = {}
		for key, value in pairs(data) do
			if not filterKeys[key] then
				ret[key] = value
			end
		end
		return ret
	end
	
	function bDataGrid:SetData(datum, firstKey, callback, immediate)
		local lastIndex = GetSelectedIndex()
		local lastScrollbarPosition = verticalScrollBar:GetPosition()
		firstKey = firstKey or selectedKey
		
		data = {}
		dataCount = 0
		selectedKey = nil
		
		if loadingBarEnabled then
			loadingOverlay:SetVisible(true)
		end
		
		datum = datum or {}

		orderings = {}
		keyOrdering = {}
		
		RefreshFilter()
		
		local function CreateOrderings()
			for columnID in pairs(columns) do
				CreateOrdering(columnID, datum)
				Release()
			end
			
			Release()

			for key in pairs(datum) do 
				TInsert(keyOrdering, key)
				dataCount = dataCount + 1
				Release()
			end
			
			local orderFunction = function(a, b) return a < b end
		
			local orderPages = {}
			for index, key in ipairs(keyOrdering) do
				local page = MFloor(index / PAGESIZE) + 1
				orderPages[page] = orderPages[page] or {}
				TInsert(orderPages[page], key)
				Release()
			end
		
			for _, page in pairs(orderPages) do
				TSort(page, orderFunction)
				Release()
			end
		
			keyOrdering = {}
			repeat
				local minPageIndex = nil
			
				for pageIndex, page in pairs(orderPages) do
					if #page > 0 then
						if not minPageIndex or orderFunction(page[1], orderPages[minPageIndex][1]) then
							minPageIndex = pageIndex
						end
					end
				end
			
				if minPageIndex then
					TInsert(keyOrdering, orderPages[minPageIndex][1])
					TRemove(orderPages[minPageIndex], 1)
				end
				Release()
			until not minPageIndex		
		end
		
		local function EndSetData()
			data = datum

			RefreshFilter()

			loadingOverlay:SetVisible(false)
			
			local minRange, maxRange = verticalScrollBar:GetRange()
			verticalScrollBar:SetPosition(MMin(MMax(lastScrollbarPosition, minRange), maxRange))

			local ordering = filterOrderings[orderColumn] or filterKeyOrdering
			if firstKey and data[firstKey] and not filterKeys[firstKey] then
				bDataGrid:SetSelectedKey(firstKey)
				if type(callback) == "function" then callback() end
				return
			elseif lastIndex then
				lastIndex = MMax(MMin(lastIndex, #ordering), 1)
			else
				lastIndex = 1
			end
			
			if orderReverse then lastIndex = #ordering - lastIndex + 1 end
			bDataGrid:SetSelectedKey(ordering[lastIndex])
			
			if type(callback) == "function" then callback() end
		end
		
		if immediate then
			CreateOrderings()
			EndSetData()
		else
			CreateTask(CreateOrderings, EndSetData)
		end
	end
	
	function bDataGrid:GetSelectedData()
		if selectedKey then
			return selectedKey, data[selectedKey]
		end
	end
	
	function bDataGrid:SetSelectedKey(key)
		if not key or not data[key] or filterKeys[key] then key = nil end
		
		local previousKey = selectedKey
		selectedKey = key
		
		local selectedIndex = (GetSelectedIndex() or 1) - 1
		
		local scrollbarPosition = verticalScrollBar:GetPosition()
		
		if selectedIndex < scrollbarPosition then
			verticalScrollBar:SetPosition(selectedIndex)
		elseif selectedIndex > scrollbarPosition + numDisplayedRows then
			verticalScrollBar:SetPosition(selectedIndex - numDisplayedRows + 1)
		end
		
		if selectedKey == nil or selectedKey ~= previousKey then
			RefreshCells()
			if bDataGrid.Event.SelectionChanged then
				bDataGrid.Event.SelectionChanged(bDataGrid, selectedKey, selectedKey and data[selectedKey] or nil)
			end
		end
	end
	
	function bDataGrid:SetLoadingBarEnabled(enabled)
		loadingBarEnabled = enabled and true or false
	end
	
	function bDataGrid:ShowLoadingBar()
		if loadingBarEnabled then
			loadingOverlay:SetVisible(true)
		end
	end
	
	function bDataGrid:HideLoadingBar()
		loadingOverlay:SetVisible(false)
	end
	
	function bDataGrid:SetBarVisible(visible)
		verticalScrollBar:SetVisible(visible and true or false)
		ResetLayout()
	end
	
	local function UpdateLoadingBar()
		if loadingOverlay:GetVisible() then
			loadingBar:SetPoint("CENTER", loadingPanelContent, (MCos(ITFrame() * 3 + loadingOffset) + 1) / 2, 0.5)
		end
	end
	CEAttach(Event.System.Update.Begin, UpdateLoadingBar, bDataGrid:GetName() .. ".OnUpdate")
	
	PublicInterface.EventHandler(bDataGrid, { "SelectionChanged", "RowRightClick", })
	
	ResetLayout()
	
	return bDataGrid
end