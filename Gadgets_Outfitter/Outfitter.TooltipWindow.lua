local tipReady = false

function Wykkyd.Outfitter.ParseRarityColor(rarityName)
    rc = wyk.vars.RarityColors
	retVal = {}
	if rarityName == "trash"        then retVal = rc.sellable
	elseif rarityName == "common"   then retVal = rc.common
	elseif rarityName == "uncommon" then retVal = rc.uncommon
	elseif rarityName == "rare"     then retVal = rc.rare
	elseif rarityName == "epic"     then retVal = rc.epic
	elseif rarityName == "quest"    then retVal = rc.quest
	elseif rarityName == "relic"    then retVal = rc.relic
	else retVal = rc.transcendent end
	return retVal
end

function Wykkyd.Outfitter.ParseBind(item)
    retVal = {}
    if item.bound then
        if item.bind == "account" then
            retVal.color = { r = .8, g = .75, b = 0 }
            retVal.text = "Bound to Account"
        else
            retVal.color = { r = 1, g = 1, b = 1 }
            retVal.text = "Soulbound"
        end
    else
        if item.bind == "account" then
            retVal.color = { r = .8, g = .75, b = 0 }
            retVal.text = "Bound to Account"
        elseif item.bind == "pickup" then
            retVal.color = { r = 1, g = 1, b = 1 }
            retVal.text = "Bind on Pickup"
        elseif item.bind == "use" then
            retVal.color = { r = 1, g = 1, b = 1 }
            retVal.text = "Bind on Use"
        elseif item.bind == "equip" then
            retVal.color = { r = 1, g = 1, b = 1 }
            retVal.text = "Bind on Equip"
        end
    end
    return retVal
end

local function deriveArmor(category)
    if string.match(category, "armor") ~= nil then
        return true
    else
        return false
    end
end

local function deriveCostume(category)
    if string.match(category, "costume") ~= nil or string.match(category, "misc other") ~= nil then
        return true
    else
        return false
    end
end

local function deriveWeapon(category)
    if string.match(category, "weapon") ~= nil then
        return true
    else
        return false
    end
end

local function deriveAccessory(category)
    if string.match(category, "accessory") ~= nil then
        return true
    else
        return false
    end
end

local function derivePlanarFocus(category)
    if string.match(category, "planar") ~= nil then
        return true
    else
        return false
    end
end

function Wykkyd.Outfitter.ParseItemType(category)
    if category == nil then return nil; end
    local slots = wyk.vars.eqpSlots
    local isArmor = deriveArmor(category)
    local isCostume = deriveCostume(category)
    local isWeapon = deriveWeapon(category)
    local isAccessory = deriveAccessory(category)
    local isPlanarFocus = derivePlanarFocus(category)
    local equipSlot = {
        slotID = {},
        slotName = {},
        displayType = nil,
        displaySubType = nil,
        typeArmor = isArmor,
        typeCostume = isCostume,
        typeWeapon = isWeapon,
        typeAccessory = isAccessory,
        typePlanarFocus = isPlanarFocus,
    }
    if isAccessory then
        if string.match(category, "neck") ~= nil then
            equipSlot.slotID = { slots.neck }
            equipSlot.slotName = { "neck" }
            equipSlot.displayType = "Neck"
            equipSlot.displaySubType = "Accessory"
        elseif string.match(category, "ring") ~= nil then
            equipSlot.slotID = { slots.ring1, slots.ring2 }
            equipSlot.slotName = { "ring1", "ring2" }
            equipSlot.displayType = "Ring"
            equipSlot.displaySubType = "Accessory"
        elseif string.match(category, "seal") ~= nil then
            equipSlot.slotID = { slots.seal }
            equipSlot.slotName = { "seal" }
            equipSlot.displayType = "Seal"
            equipSlot.displaySubType = "Accessory"
        elseif string.match(category, "trinket") ~= nil then
            equipSlot.slotID = { slots.trinket }
            equipSlot.slotName = { "trinket" }
            equipSlot.displayType = "Trinket"
            equipSlot.displaySubType = "Accessory"
        else
            equipSlot.slotID = { slots.synergy }
            equipSlot.slotName = { "synergy" }
            equipSlot.displayType = "Synergy Crystal"
            equipSlot.displaySubType = "Accessory"
        end
    elseif isArmor or isCostume then
        if string.match(category, "head") ~= nil then
            equipSlot.slotID = { slots.helmet }
            equipSlot.slotName = { "helmet" }
            equipSlot.displayType = "Helmet"
        elseif string.match(category, "shoulders") ~= nil then
            equipSlot.slotID = { slots.shoulders }
            equipSlot.slotName = { "shoulders" }
            equipSlot.displayType = "Shoulders"
        elseif string.match(category, "chest") ~= nil then
            equipSlot.slotID = { slots.chest }
            equipSlot.slotName = { "chest" }
            equipSlot.displayType = "Chest"
        elseif string.match(category, "hands") ~= nil then
            equipSlot.slotID = { slots.gloves }
            equipSlot.slotName = { "gloves" }
            equipSlot.displayType = "Gloves"
        elseif string.match(category, "waist") ~= nil then
            equipSlot.slotID = { slots.belt }
            equipSlot.slotName = { "belt" }
            equipSlot.displayType = "Belt"
        elseif string.match(category, "legs") ~= nil then
            equipSlot.slotID = { slots.legs }
            equipSlot.slotName = { "legs" }
            equipSlot.displayType = "Legs"
        elseif string.match(category, "feet") ~= nil then
            equipSlot.slotID = { slots.feet }
            equipSlot.slotName = { "feet" }
            equipSlot.displayType = "Feet"
        else
			if string.match(category, "misc other") ~= nil or isArmor then
				equipSlot.slotID = { slots.cape }
				equipSlot.slotName = { "cape" }
				equipSlot.displayType = "Cape"
				equipSlot.displaySubType = "Cloth"
			end
        end
        if equipSlot.displayType ~= nil and equipSlot.displaySubType == nil then
            if string.match(category, "plate") ~= nil then
                equipSlot.displaySubType = "Plate"
            elseif string.match(category, "cloth") ~= nil then
                equipSlot.displaySubType = "Cloth"
            elseif string.match(category, "chain") ~= nil then
                equipSlot.displaySubType = "Chain"
            elseif string.match(category, "leather") ~= nil then
                equipSlot.displaySubType = "Leather"
            end
        end
    elseif isWeapon then
        if string.match(category, "twohand") ~= nil then
            equipSlot.slotID = { slots.handmain }
            equipSlot.slotName = { "handmain" }
            equipSlot.displayType = "Two Handed"
        elseif string.match(category, "onehand") ~= nil then
            equipSlot.slotID = { slots.handmain, slots.handoff }
            equipSlot.slotName = { "handmain", "handoff" }
            equipSlot.displayType = "One Hand"
        elseif string.match(category, "mainhand") ~= nil then
            equipSlot.slotID = { slots.handmain }
            equipSlot.slotName = { "handmain" }
            equipSlot.displayType = "Main Hand"
        elseif string.match(category, "offhand") ~= nil then
            equipSlot.slotID = { slots.handoff }
            equipSlot.slotName = { "handoff" }
            equipSlot.displayType = "Off Hand"
        elseif string.match(category, "ranged") ~= nil then
            equipSlot.slotID = { slots.ranged }
            equipSlot.slotName = { "ranged" }
            equipSlot.displayType = "Ranged"
        elseif string.match(category, "shield") ~= nil then
            equipSlot.slotID = { slots.handoff }
            equipSlot.slotName = { "handoff" }
            equipSlot.displayType = "Off Hand"
            equipSlot.displaySubType = "Shield"
        elseif string.match(category, "totem") ~= nil then
            equipSlot.slotID = { slots.handoff }
            equipSlot.slotName = { "handoff" }
            equipSlot.displayType = "Off Hand"
            equipSlot.displaySubType = "Totem"
        end
        if equipSlot.displayType ~= nil and equipSlot.displaySubType == nil then
            if string.match(category, "axe") ~= nil then
                equipSlot.displaySubType = "Axe"
            elseif string.match(category, "sword") ~= nil then
                equipSlot.displaySubType = "Sword"
            elseif string.match(category, "dagger") ~= nil then
                equipSlot.displaySubType = "Dagger"
            elseif string.match(category, "polearm") ~= nil then
                equipSlot.displaySubType = "Polearm"
            elseif string.match(category, "wand") ~= nil then
                equipSlot.displaySubType = "Wand"
            elseif string.match(category, "totem") ~= nil then
                equipSlot.displaySubType = "Totem"
            elseif string.match(category, "bow") ~= nil then
                equipSlot.displaySubType = "Bow"
            elseif string.match(category, "gun") ~= nil then
                equipSlot.displaySubType = "Gun"
            end
        end
    elseif isPlanarFocus then
        equipSlot.slotID = { slots.focus }
        equipSlot.slotName = { "focus" }
        equipSlot.displayType = "Planar Focus"
        equipSlot.displaySubType = ""
    end
    return equipSlot
end

local function getStat( displayDetail, itemStats, itemType, item, tbl )
    local wykStats = wyk.vars.eqpStats
    local wykWpnStats = wyk.vars.wpnStats
    if displayDetail.stat == "dps" then
        if itemType.typeWeapon then
            if item.damageMax ~= nil then
                local dmax = item.damageMax
                local dmin = item.damageMin
                local dsec = item.damageDelay
                local dtyp = item.damageType
                if dtyp == nil then dtyp = ""; end
                local dps = (wyk.func.Round((((dmin+dmax)/2)/dsec)*10)/10)
                dsec = (wyk.func.Round(dsec*10)/10)
                local dpsLine = "Damage per second: "..dps
                local damageLine = dmin.."-"..dmax.." "..dtyp.." damage ever "..dsec.." seconds"
                if tbl == nil then
                    tbl = {}
                end
                table.insert( tbl, {
                    stat = "dps",
                    detail = {
                        addbr = true,
                        value = nil,
                        display = nil,
                        desc = dpsLine.."\r"..damageLine,
                    }
                })
            end
        end
    else
        local val = itemStats[displayDetail.stat]
        if val ~= nil then
            if tbl == nil then
                tbl = {}
            end
            table.insert( tbl, {
                stat = wykStats[displayDetail.stat].stat,
                detail = {
                    addbr = displayDetail.addbr,
                    value = val,
                    display = wykStats[displayDetail.stat].display,
                    desc = wykStats[displayDetail.stat].display..wykStats[displayDetail.stat].delimiter..val..wykStats[displayDetail.stat].post,
                }
            })
        end
    end
    return tbl
end

function Wykkyd.Outfitter.ParseStats(itemStats, itemType, item)
    if itemStats == nil then return ""; end
    local wykStats = wyk.vars.eqpStats
    local wykWpnStats = wyk.vars.wpnStats
    local wykDisplay = wyk.vars.displayStats
    equipStats = nil
    equipStats = getStat( wykDisplay.detail1, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail2, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail3, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail4, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail5, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail6, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail7, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail8, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail9, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail10, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail11, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail12, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail13, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail14, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail15, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail16, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail17, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail18, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail19, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail20, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail21, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail22, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail23, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail24, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail25, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail26, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail27, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail28, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail29, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail30, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail31, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail32, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail33, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail34, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail35, itemStats, itemType, item, equipStats )
    equipStats = getStat( wykDisplay.detail36, itemStats, itemType, item, equipStats )
    if equipStats ~= nil then
        return equipStats
    else
        return nil
    end
end

function Wykkyd.Outfitter.ParseStatus_ForDisplay(itemStats, itemType, item)
    local stats = Wykkyd.Outfitter.ParseStats(itemStats, itemType, item)
    local retVal = ""
    if stats ~= nil then
        if type(stats) == "string" then
            return stats
        else
            for idx, tbl in pairs(stats) do
                if tbl.detail ~= nil then
                    if tbl.detail.addbr then
                        retVal = retVal..tbl.detail.desc.."\r\r"
                    else
                        retVal = retVal..tbl.detail.desc.."\r"
                    end
                end
            end
            return retVal
        end
    else
        return nil
    end
end

function Wykkyd.Outfitter.FillTooltipWindow(myCount, item)
    if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
    if not Wykkyd.Outfitter.ContextTip[myCount] then return end
    local tip = Wykkyd.Outfitter.ContextTip[myCount]
    if item then
        local tc = Wykkyd.Outfitter.ParseRarityColor( wyk.func.NilSafe(item.rarity) )
        tip.content.title:SetText( wyk.func.NilSafe(item.name) )
        tip.content.title:SetFontColor( tc.r, tc.g, tc.b, 1 )
        local bindStatus = Wykkyd.Outfitter.ParseBind(item)
        tip.content.bind:SetText( wyk.func.NilSafe(bindStatus.text) )
        tip.content.bind:SetFontColor( bindStatus.color.r, bindStatus.color.g, bindStatus.color.b, 1 )
        local typeValues = Wykkyd.Outfitter.ParseItemType(wyk.func.NilSafe(item.category))
        tip.content.type:SetText( wyk.func.NilSafe(typeValues.displayType) )
        tip.content.subtype:SetText( wyk.func.NilSafe(typeValues.displaySubType) )
        local statText = Wykkyd.Outfitter.ParseStatus_ForDisplay( wyk.func.NilSafe(item.stats), typeValues, item )
        tip.content.stats:SetText(wyk.func.NilSafe(statText))
        if item.requiredCalling ~= nil then
            tip.content.callings:SetText("Calling: "..wyk.func.NilSafe(item.requiredCalling))
            tip.content.callings:SetVisible(true)
        else
            tip.content.callings:SetText("")
            tip.content.callings:SetVisible(false)
        end
        if item.requiredLevel ~= nil then tip.content.level:SetText("Requires Level "..item.requiredLevel); end
        if item.requiredPrestige ~= nil then
            local calText = tip.content.callings:GetText()
            if calText == nil then
                tip.content.callings:SetText("Requires Prestige Level "..item.requiredPrestige)
                tip.content.callings:SetVisible(true)
            else
                if calText == "" then
                    tip.content.callings:SetText("Requires Prestige Level "..item.requiredPrestige)
                    tip.content.callings:SetVisible(true)
                else
                    tip.content.callings:SetText(calText.."\rRequires Prestige Rank "..item.requiredPrestige)
                    tip.content.callings:SetVisible(true)
                end
            end
        end
        tipReady = true
    else
        tipReady = false
    end
    return
end

function Wykkyd.Outfitter.CreateTooltipWindow(myCount)
    --if not Wykkyd.Outfitter.ContextWindow[myCount] then return end
    local parent = Wykkyd.Outfitter.ContextWindow[myCount]
    Wykkyd.Outfitter.ContextTip[myCount] = wyk.frame.CreateFrame("outfitTooltip", parent )
    local tipFrame = Wykkyd.Outfitter.ContextTip[myCount]
    tipFrame:SetVisible( false )
    tipFrame:SetHeight( 380 )
    tipFrame:SetWidth( 240 )
    tipFrame:SetLayer( 24 )
    tipFrame:SetBackgroundColor(0,0,0,.75)
    tipFrame:SetPoint( "TOPCENTER", parent, "TOPCENTER", 0, 80 )
        
    local tipContent = wyk.frame.CreateFrame( "outfitTooltipContent", tipFrame )
    tipContent:SetBackgroundColor(.15,.15,.15,1)
    tipContent:SetPoint("TOPLEFT", tipFrame, "TOPLEFT", 1, 1)
    tipContent:SetPoint("BOTTOMRIGHT", tipFrame, "BOTTOMRIGHT", -1, -1)	
    tipFrame.content = tipContent
    
    local tipTitle = wyk.frame.CreateText("outfitTooltipTitle", tipContent )
    tipTitle:SetFontSize( 15 )
    tipTitle:SetPoint( "TOPCENTER", tipContent, "TOPCENTER", 0, 0 )
    tipFrame.content.title = tipTitle
    
    local tipBind = wyk.frame.CreateText("outfitTooltipTitle", tipContent )
    tipBind:SetFontSize( 12 )
    tipBind:SetFontColor( 1, 1, 1, 1 )
    tipBind:SetPoint( "TOPLEFT", tipTitle, "BOTTOMCENTER", -116, 0 )
    tipFrame.content.bind = tipBind
    
    local tipType = wyk.frame.CreateText("outfitTooltipType", tipContent )
    tipType:SetFontSize( 12 )
    tipType:SetFontColor( 1, 1, 1, 1 )
    tipType:SetPoint( "TOPLEFT", tipBind, "BOTTOMLEFT", 0, 0 )
    tipFrame.content.type = tipType
    
    local tipSubType = wyk.frame.CreateText("outfitTooltipSubType", tipContent )
    tipSubType:SetFontSize( 12 )
    tipSubType:SetFontColor( 1, 1, 1, 1 )
    tipSubType:SetPoint( "TOPRIGHT", tipType, "TOPLEFT", 231, 0 )
    tipFrame.content.subtype = tipSubType
    
    local tipStats = wyk.frame.CreateText("outfitTooltipStats", tipContent )
    tipStats:SetFontSize( 12 )
    tipStats:SetFontColor( 1, 1, 1, 1 )
    tipStats:SetPoint( "TOPLEFT", tipType, "BOTTOMLEFT", 0, 8 )
    tipFrame.content.stats = tipStats
    
    local tipCallings = wyk.frame.CreateText("outfitTooltipCallings", tipContent )
    tipCallings:SetFontSize( 12 )
    tipCallings:SetFontColor( 1, 1, 1, 1 )
    tipCallings:SetPoint( "BOTTOMLEFT", tipContent, "BOTTOMLEFT", 4, -4 )
    tipFrame.content.callings = tipCallings
    
    local tipLevel = wyk.frame.CreateText("outfitTooltipLevel", tipContent )
    tipLevel:SetFontSize( 12 )
    tipLevel:SetFontColor( 1, 1, 1, 1 )
    tipLevel:SetPoint( "BOTTOMLEFT", tipCallings, "TOPLEFT", 0, 0 )
    tipFrame.content.level = tipLevel
end

function Wykkyd.Outfitter.OpenTooltipWindow(myCount, item)
	if item == nil then
        if not Wykkyd.Outfitter.ContextTip[myCount] then return end
        local tip = Wykkyd.Outfitter.ContextTip[myCount]
        tip:SetVisible(false)
    else
        if not Wykkyd.Outfitter.ContextTip[myCount] then Wykkyd.Outfitter.CreateTooltipWindow(myCount) end
        if not Wykkyd.Outfitter.ContextTip[myCount] then return end
        local tip = Wykkyd.Outfitter.ContextTip[myCount]
        Wykkyd.Outfitter.FillTooltipWindow(myCount, item)
        tip:SetVisible(true)
    end
end