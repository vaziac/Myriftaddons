local toc, data = ...
local id = toc.identifier

function wyk.frame.ImageSlider(name, context, options, value, emptyImage, imageList)
	if name == nil then return end
	if context == nil then return end
	if imageList == nil then imageList = wyk.vars.Icons end
	local imageCount = wyk.func.Count(imageList)
	if emptyImage == nil then emptyImage = wyk.vars.Images.other.gadgetsBtn end

    local icoSize = 46
    local brdSize = 64
    local icoScale1 = 1.55
    local icoScale2 = 1.25
    local icoScale3 = 1
    local brdSz = brdSize*icoScale1
    local icoSz1 = icoSize*icoScale1
    local icoSz2 = icoSize*icoScale2
    local icoSz3 = icoSize*icoScale3
    local icoShift1 = 0
    local icoShift2 = icoSz3*.999
    local icoShift3 = icoSz3*.75
	
	local function setPos(obj, iMod)
		local iMax = wyk.func.Count(obj.imageList)
		local iMin = 1
		if iMod < iMin then obj.imageSlider.slider:SetPosition(iMin)
		elseif iMod > iMax then obj.imageSlider.slider:SetPosition(iMax)
		else obj.imageSlider.slider:SetPosition(iMod)
		end
	end
	
	local function movePos(obj, iMod)
		local iPos = obj.imageSlider.slider:GetPosition()
		local iMax = wyk.func.Count(obj.imageList)
		local iMin = 1
		if iPos+iMod < iMin then obj.imageSlider.slider:SetPosition(iMin)
		elseif iPos+iMod > iMax then obj.imageSlider.slider:SetPosition(iMax)
		else obj.imageSlider.slider:SetPosition(iPos+iMod)
		end
	end

	if options == nil then options = {} end
	if options.layer == nil then options.layer = 1 end
			
	local obj = wyk.frame.CreateFrame(name.."_frame", context, {
		point = {point="CENTER", target=context, targetpoint="CENTER", x=0, y=0},
		layer = options.layer or 2,
		w = options.w or 340,
		h = options.h or 200,
		bg = options.bg or {r=0,g=0,b=0,a=0},
	}, true)
	obj.context = context
	obj.imageList = imageList
	obj.options = options
	obj.nameRoot = name
	
	obj.lens = wyk.frame.CreateTexture(name.."_lens", obj, {
		h = brdSz,
		w = brdSz,
		a = 1,
		layer = options.layer+23,
		image = wyk.vars.Images.borders.gray,
	})
	
	obj.selectedImage = wyk.frame.CreateTexture(name.."_selectedImage", obj, {
		h = icoSz1,
		w = icoSz1,
		a = 0,
		layer = options.layer+28
	})
	
	obj.leftImage = wyk.frame.CreateTexture(name.."_leftImage", obj, {
		h = icoSz2,
		w = icoSz2,
		a = 0,
		layer = options.layer+22
	})
	
	obj.leftmostImage = wyk.frame.CreateTexture(name.."_leftmostImage", obj, {
		h = icoSz3,
		w = icoSz3,
		a = 0,
		layer = options.layer+21
	})
	
	obj.rightImage = wyk.frame.CreateTexture(name.."_rightImage", obj, {
		h = icoSz2,
		w = icoSz2,
		a = 0,
		layer = options.layer+22
	})
	
	obj.rightmostImage = wyk.frame.CreateTexture(name.."_rightmostImage", obj, {
		h = icoSz3,
		w = icoSz3,
		a = 0,
		layer = options.layer+21
	})
	
	obj.imageSlider = wyk.frame.SlideFrame(name.."_imgSlider", obj, 240, { low = 1, high = wyk.func.Count(imageList) }, value, nil)
        
	--obj.imageSlider.Event.WheelForward = function() movePos(obj, 1) end
    --obj.imageSlider.Event.WheelBack = function() movePos(obj, -1) end
	obj.imageSlider:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.imageSlider:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")
	
	--obj.imageSlider.slider.Event.WheelForward = function() movePos(obj, 1) end
    --obj.imageSlider.slider.Event.WheelBack = function() movePos(obj, -1) end
	obj.imageSlider.slider:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.imageSlider.slider:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")


    --obj.selectedImage.Event.WheelForward = function() movePos(obj, 1) end
    --obj.selectedImage.Event.WheelBack = function() movePos(obj, -1) end
	obj.selectedImage:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.selectedImage:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")

    --obj.lens.Event.WheelForward = function() movePos(obj, 1) end
    --obj.lens.Event.WheelBack = function() movePos(obj, -1) end
	obj.lens:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.lens:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")


    --obj.leftImage.Event.WheelForward = function() movePos(obj, 1) end
    --obj.leftImage.Event.WheelBack = function() movePos(obj, -1) end
	obj.leftImage:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.leftImage:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")
    
	
	--obj.leftmostImage.Event.WheelForward = function() movePos(obj, 1) end
    --obj.leftmostImage.Event.WheelBack = function() movePos(obj, -1) end
    obj.leftmostImage:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.leftmostImage:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")
	--obj.rightImage.Event.WheelForward = function() movePos(obj, 1) end
    --obj.rightImage.Event.WheelBack = function() movePos(obj, -1) end
    obj.rightImage:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.rightImage:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")

    --obj.rightmostImage.Event.WheelForward = function() movePos(obj, 1) end
    --obj.rightmostImage.Event.WheelBack = function() movePos(obj, -1) end
    obj.rightmostImage:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self, h) movePos(obj, 1) end, "Event.UI.Input.Mouse.Wheel.Forward")
	obj.rightmostImage:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self, h) movePos(obj, -1) end, "Event.UI.Input.Mouse.Wheel.Back")
	
	local lst = imageList
	local cnt = wyk.func.Count(imageList)
	
	wyk.frame.setLayer(obj.imageSlider, options.layer+20)
    obj.imageSlider.slider.Event.SliderChange = function()
        local sel = obj.imageSlider.slider:GetPosition()
        if sel == 1 then
            wyk.frame.setTexture(obj.leftmostImage, emptyImage)
            obj.leftmostImage:SetAlpha(0)
            wyk.frame.setTexture(obj.leftImage, emptyImage)
            obj.leftImage:SetAlpha(0)
            wyk.frame.setTexture(obj.selectedImage, lst[sel])
            obj.selectedImage:SetAlpha(1)
            wyk.frame.setTexture(obj.rightImage, lst[sel+1])
            obj.rightImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.rightmostImage, lst[sel+2])
            obj.rightmostImage:SetAlpha(.65)
        elseif sel == 2 then
            wyk.frame.setTexture(obj.leftmostImage, emptyImage)
            obj.leftmostImage:SetAlpha(0)
            wyk.frame.setTexture(obj.leftImage, lst[sel-1])
            obj.leftImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.selectedImage, lst[sel])
            obj.selectedImage:SetAlpha(1)
            wyk.frame.setTexture(obj.rightImage, lst[sel+1])
            obj.rightImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.rightmostImage, lst[sel+2])
            obj.rightmostImage:SetAlpha(.65)
        elseif sel == cnt then
            wyk.frame.setTexture(obj.leftmostImage, lst[sel-2])
            obj.leftmostImage:SetAlpha(.65)
            wyk.frame.setTexture(obj.leftImage, lst[sel-1])
            obj.leftImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.selectedImage, lst[sel])
            obj.selectedImage:SetAlpha(1)
            wyk.frame.setTexture(obj.rightImage, emptyImage)
            obj.rightImage:SetAlpha(0)
            wyk.frame.setTexture(obj.rightmostImage, emptyImage)
            obj.rightmostImage:SetAlpha(0)
        elseif sel == (cnt - 1) then
            wyk.frame.setTexture(obj.leftmostImage, lst[sel-2])
            obj.leftmostImage:SetAlpha(.65)
            wyk.frame.setTexture(obj.leftImage, lst[sel-1])
            obj.leftImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.selectedImage, lst[sel])
            obj.selectedImage:SetAlpha(1)
            wyk.frame.setTexture(obj.rightImage, lst[sel+1])
            obj.rightImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.rightImage, emptyImage)
            obj.rightmostImage:SetAlpha(0)
        else
            wyk.frame.setTexture(obj.leftmostImage, lst[sel-2])
            obj.leftmostImage:SetAlpha(.65)
            wyk.frame.setTexture(obj.leftImage, lst[sel-1])
            obj.leftImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.selectedImage, lst[sel])
            obj.selectedImage:SetAlpha(1)
            wyk.frame.setTexture(obj.rightImage, lst[sel+1])
            obj.rightImage:SetAlpha(.85)
            wyk.frame.setTexture(obj.rightmostImage, lst[sel+2])
            obj.rightmostImage:SetAlpha(.65)
        end
    end
    
    obj.imageSlider:SetPoint("TOPCENTER", obj, "TOPCENTER", 0, 32)
    obj.selectedImage:SetPoint("TOPCENTER", obj.imageSlider, "BOTTOMCENTER", icoShift1, -6)
    obj.lens:SetPoint("CENTER", obj.selectedImage, "CENTER", 0, 0)
    obj.leftImage:SetPoint("CENTER", obj.selectedImage, "CENTER", (icoShift2*-1), -3)
    obj.rightImage:SetPoint("CENTER", obj.selectedImage, "CENTER", icoShift2, -3)
    obj.leftmostImage:SetPoint("CENTER", obj.leftImage, "CENTER", (icoShift3*-1), -3)
    obj.rightmostImage:SetPoint("CENTER", obj.rightImage, "CENTER", icoShift3, -3)

    wyk.frame.BlockDrop(obj)
    wyk.frame.BlockDrop(obj.imageSlider)
    wyk.frame.BlockDrop(obj.selectedImage)
    wyk.frame.BlockDrop(obj.lens)
    wyk.frame.BlockDrop(obj.leftImage)
    wyk.frame.BlockDrop(obj.rightImage)
    wyk.frame.BlockDrop(obj.leftmostImage)
    wyk.frame.BlockDrop(obj.rightmostImage)
    
    local sel = obj.imageSlider.slider:GetPosition()
    
    if sel == 1 then
        wyk.frame.setTexture(obj.selectedImage, lst[sel])
        obj.selectedImage:SetAlpha(1)
        wyk.frame.setTexture(obj.leftImage, emptyImage)
        obj.leftImage:SetAlpha(0)
        wyk.frame.setTexture(obj.rightmostImage, lst[sel+1])
        obj.rightmostImage:SetAlpha(.65)
        wyk.frame.setTexture(obj.leftmostImage, emptyImage)
        obj.leftmostImage:SetAlpha(0)
        wyk.frame.setTexture(obj.rightImage, lst[sel+2])
        obj.rightImage:SetAlpha(.85)
    elseif sel == 2 then
        wyk.frame.setTexture(obj.leftmostImage, emptyImage)
        obj.leftmostImage:SetAlpha(0)
        wyk.frame.setTexture(obj.leftImage, lst[sel-1])
        obj.leftImage:SetAlpha(.85)
        wyk.frame.setTexture(obj.selectedImage, lst[sel])
        obj.selectedImage:SetAlpha(1)
        wyk.frame.setTexture(obj.rightImage, lst[sel+2])
        obj.rightImage:SetAlpha(.85)
        wyk.frame.setTexture(obj.rightmostImage, lst[sel+1])
        obj.rightmostImage:SetAlpha(.65)
    elseif sel == cnt then
        wyk.frame.setTexture(obj.leftmostImage, lst[sel-2])
        obj.leftmostImage:SetAlpha(.65)
        wyk.frame.setTexture(obj.leftImage, lst[sel-1])
        obj.leftImage:SetAlpha(.85)
        wyk.frame.setTexture(obj.selectedImage, lst[sel])
        obj.selectedImage:SetAlpha(1)
        wyk.frame.setTexture(obj.rightmostImage, emptyImage)
        obj.rightmostImage:SetAlpha(0)
        wyk.frame.setTexture(obj.rightImage, emptyImage)
        obj.rightImage:SetAlpha(0)
    elseif sel == (cnt - 1) then
        wyk.frame.setTexture(obj.leftmostImage, lst[sel-2])
        obj.leftmostImage:SetAlpha(.65)
        wyk.frame.setTexture(obj.leftImage, lst[sel-1])
        obj.leftImage:SetAlpha(.85)
        wyk.frame.setTexture(obj.selectedImage, lst[sel])
        obj.selectedImage:SetAlpha(1)
        wyk.frame.setTexture(obj.rightmostImage, lst[sel+1])
        obj.rightmostImage:SetAlpha(.65)
        wyk.frame.setTexture(obj.rightImage, emptyImage)
        obj.rightImage:SetAlpha(0)
    else
        wyk.frame.setTexture(obj.leftmostImage, lst[sel-2])
        obj.leftmostImage:SetAlpha(.65)
        wyk.frame.setTexture(obj.leftImage, lst[sel-1])
        obj.leftImage:SetAlpha(.85)
        wyk.frame.setTexture(obj.selectedImage, lst[sel])
        obj.selectedImage:SetAlpha(1)
        wyk.frame.setTexture(obj.rightmostImage, lst[sel+1])
        obj.rightmostImage:SetAlpha(.65)
        wyk.frame.setTexture(obj.rightImage, lst[sel+2])
        obj.rightImage:SetAlpha(.85)
    end
    
    return obj
end

function wyk.frame.DeluxeImageSlider(name, context, options, value, emptyImage, imageList, borderValue)
	if name == nil then return end
	if context == nil then return end
	if imageList == nil then imageList = wyk.vars.Icons end
	local imageCount = wyk.func.Count(imageList)
	if emptyImage == nil then emptyImage = wyk.vars.Images.other.gadgetsBtn end

	local base = wyk.frame.ImageSlider(name, context, options, value or 1, emptyImage, imageList)
	
	local brdrSlider = wyk.frame.SlideFrame("brdrSlider", context, options.w or 240, {L=1, H=8}, borderValue or 2, "Choose a Border & Image:")
	brdrSlider:SetLayer(10)
    brdrSlider.slider.Event.SliderChange = function()
        local sel = brdrSlider.slider:GetPosition()
        if sel == 1 then
            base.lens:SetTexture( wyk.vars.Images.borders.dark.src, wyk.vars.Images.borders.dark.file )
        elseif sel == 2 then
            base.lens:SetTexture( wyk.vars.Images.borders.gray.src, wyk.vars.Images.borders.gray.file )
        elseif sel == 3 then
            base.lens:SetTexture( wyk.vars.Images.borders.air.src, wyk.vars.Images.borders.air.file )
        elseif sel == 4 then
            base.lens:SetTexture( wyk.vars.Images.borders.death.src, wyk.vars.Images.borders.death.file )
        elseif sel == 5 then
            base.lens:SetTexture( wyk.vars.Images.borders.earth.src, wyk.vars.Images.borders.earth.file )
        elseif sel == 6 then
            base.lens:SetTexture( wyk.vars.Images.borders.fire.src, wyk.vars.Images.borders.fire.file )
        elseif sel == 7 then
            base.lens:SetTexture( wyk.vars.Images.borders.life.src, wyk.vars.Images.borders.life.file )
        elseif sel == 8 then
            base.lens:SetTexture( wyk.vars.Images.borders.water.src, wyk.vars.Images.borders.water.file )
        end
    end
	
	brdrSlider:SetPoint("BOTTOMCENTER", base.imageSlider, "TOPCENTER", 0, 0)
	
	base.iconChooser = base.imageSlider
	base.borderChooser = brdrSlider
	
	return base
end