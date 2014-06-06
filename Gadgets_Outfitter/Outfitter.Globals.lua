local toc, data = ...
WykkydOutfitterAddonId = toc.identifier
WykkydOutfitterVersion = toc.toc.Version
WykkydOutfitter = toc.toc

Wykkyd = {
    Outfitter = {
        Globals = {},
        Window = nil,
        TooltipWindow = nil,
    },
}

wykkydImageSource = "Gadgets_Outfitter"

Wykkyd.Outfitter.Context = {}
Wykkyd.Outfitter.ContextConfig = {}
Wykkyd.Outfitter.ContextWindow = {}
Wykkyd.Outfitter.MassReplacementWindow = {}
Wykkyd.Outfitter.ContextImageSlider = {}
Wykkyd.Outfitter.ContextForm = {}
Wykkyd.Outfitter.ContextTip = {}

Wykkyd.Outfitter.Anchor = {}

Wykkyd.Outfitter.ContextWindowOpen = {}
Wykkyd.Outfitter.ContextWindowPrepped = {}

Wykkyd.Outfitter.chosenEquipmentSet = {}

Wykkyd.Outfitter.ComboBox = {}
Wykkyd.Outfitter.TextBox = {}

Wykkyd.Outfitter.displayedGear = {}
Wykkyd.Outfitter.displayedGearSlot = {}
Wykkyd.Outfitter.ignoredSlots = {}
Wykkyd.Outfitter.draggedSlots = {}

Wykkyd.Outfitter.Globals.notFound = {}
Wykkyd.Outfitter.Globals.IgnoredSlots = {
    helmet = false,
    shoulders = false,
    chest = false,
    cape = false,
    gloves = false,
    belt = false, 
    legs = false, 
    feet = false,
    seal = false,
    handmain = false,
    handoff = false,
    ranged = false,
    neck = false,
    trinket = false,
    ring1 = false,
    ring2 = false,
    synergy = false,
    focus = false,
}

Wykkyd.Outfitter.ContextChildren = {}
function Wykkyd.Outfitter.addWindowChild(cnt, obj)
    if Wykkyd.Outfitter.ContextChildren[cnt] == nil then Wykkyd.Outfitter.ContextChildren[cnt] = {} end
    table.insert(Wykkyd.Outfitter.ContextChildren[cnt], obj)
end

function Wykkyd.Outfitter.ReleaseCursor(cnt)
    if Wykkyd.Outfitter.ContextChildren[cnt] ~= nil then
        for _, obj in pairs(Wykkyd.Outfitter.ContextChildren[cnt]) do
            WT.Utility.ClearKeyFocus(obj)
        end
    end
end

function Wykkyd.Outfitter.PrepList(myCount)
    local doIt = true
    if Wykkyd.Outfitter.ContextConfig[myCount] == nil then Wykkyd.Outfitter.ContextConfig[myCount] = {} end
    if Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList == nil then Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList = {} end
    for _, v in pairs(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList) do
        if v.value == 0 then
            doIt = false
            break
        end
    end
    if doIt then
        table.insert(Wykkyd.Outfitter.ContextConfig[myCount].EquipSetList, { text="NEW EQUIPMENT SET", value=0 })
    end
end


