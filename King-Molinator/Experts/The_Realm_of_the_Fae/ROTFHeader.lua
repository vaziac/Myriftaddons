﻿-- The Realm of the Fae Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXROTF_Settings = nil
chKBMEXROTF_Settings = nil

local MOD = {
	Directory = "Experts/The_Realm_of_the_Fae/",
	File = "ROTFHeader.lua",
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "The Realm of the Fae",
	Type = "Expert",
	ID = "The_Realm_of_the_Fae",
	Object = "MOD",
	Rift = "Rift",
}

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
KBM.RegisterMod(MOD.Name, MOD)

-- Header Dictionary
MOD.Lang = {}
MOD.Lang.Main = {}
MOD.Lang.Main.Name = KBM.Language:Add(MOD.Name)
MOD.Lang.Main.Name:SetGerman("Das Reich der Feen")
MOD.Lang.Main.Name:SetFrench("Le Royaume des Fées")
MOD.Lang.Main.Name:SetRussian("Королевство Фей")
MOD.Lang.Main.Name:SetKorean("파에 왕국")

MOD.Name = MOD.Lang.Main.Name[KBM.Lang]
MOD.Descript = MOD.Name

function MOD:AddBosses(KBM_Boss)
end

function MOD:InitVars()
end

function MOD:LoadVars()
end

function MOD:SaveVars()
end

function MOD:Start()
end