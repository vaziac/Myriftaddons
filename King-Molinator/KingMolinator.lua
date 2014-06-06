﻿-- King Boss Mods
-- Written By Paul Snart
-- Copyright 2011

local IBDReserved = Inspect.Buff.Detail

KBM_GlobalOptions = nil
chKBM_GlobalOptions = nil

local KingMol_Main = {}
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBMIni = AddonData
local KBM = AddonData.data
local LocaleManager = Inspect.Addon.Detail("KBMLocaleManager")
local KBMLM = LocaleManager.data

local LibSGui = Inspect.Addon.Detail("SafesGUILib").data
local LibSBuff = Inspect.Addon.Detail("SafesBuffLib").data

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local LSCIni = Inspect.Addon.Detail("SafesCastbarLib")
local LibSCast = LSCIni.data

local LSAIni = Inspect.Addon.Detail("SafesTableLib")
local LibSata = LSAIni.data

KBMLM.Start(KBM)
KBM.BossMod = {}
KBM.Event = {
	Mark = {},
	System = {
		Start = {},
		TankSwap = {
			Start = {},
			End = {},
		},
		Player = {
			Join = {},
			Leave = {},
		},
		Group = {
			Join = {},
			Leave = {},
		},
	},
	Unit = {
		Cast = {
			Start = {},
			End = {},
			Interrupt = {},
		},
	},
	Encounter = {
		Start = {},
		End = {},
	}
}
KBM.Unit = {}
KBM.Layer = {
	ReadyCheck = 11,
	DragActive = 99,
	DragInactive = 90,
	Alerts = 8,
	Timers = 9,
	Castbars = 15,
	Info = 10,
	Menu = 1,
}
KBM.CPU = {}
KBM.Lang = Inspect.System.Language()
KBM.Player = {
	Rezes = {},
	Resume = {},
}
KBM.Raid = {}
KBM.ID = AddonData.id
KBM.ModList = {}
KBM.Testing = false
KBM.ValidTime = false
KBM.IsAlpha = false
KBM.Debug = false
KBM.Aux = {}
KBM.TestFilters = {}
KBM.IgnoreList = {}
KBM.Watchdog = {
	Buffs = {
		Count = 0,
		Total = 0,
		Peak = 0,
		Average = 0,
		wTime = 99,
	},
	Avail = {
		Count = 0,
		Total = 0,
		Peak = 0,
		Average = 0,
		wTime = 99,
	},
	Main = {
		Count = 0,
		Total = 0,
		Peak = 0,
		Averahe = 0,
		wTime = 99,
	},
}
KBM.Idle = {
	Until = 0,
	Duration = 5,
	Wait = false,
	Combat = {
		Until = 0,
		Duration = 5,
		Wait = false,
		StoreTime = 0,
	},
	Trigger = {
		Duration = 5, 
	}
}

--KBM.DistanceCalc = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
KBM.Defaults = {}
KBM.Constant = {}
KBM.Buffs = {}
KBM.Buffs.Active = {}
KBM.Buffs.WatchID = {}

function KBM.AlphaComp(Comp, With)
	if type(Comp) == "string" and type(With) == "string" then
		local CompLen = string.len(Comp)
		local WithLen = string.len(With)
		for i = 1, CompLen do
			if i > WithLen then
				return true
			end
			local cByte = string.byte(Comp, i)
			local wByte = string.byte(With, i)
			if cByte ~= wByte then
				if cByte < wByte then
					return true
				else
					return false
				end
			end
		end
	end
end

function KBM.Defaults.EncTimer()
	local EncTimer = {
		Type = "EncTimer",
		Override = false,
		x = false,
		y = false,
		w = 150,
		h = 25,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 15,
		TextScale = false,
		Enrage = true,
		Duration = true,
	}
	return EncTimer
end

KBM.Version = {}
function KBM.Version:Load()
	local s = 0
	local e = 0
	s, e, self.High, self.Mid, self.Low, self.Revision = string.find(AddonData.toc.Version, "(%d+).(%d+).(%d+).(%d+)")
	if self.High then
		self.High = tonumber(self.High)
	else
		self.High = 0
	end
	if self.Mid then
		self.Mid = tonumber(self.Mid)
	else
		self.Mid = 0
	end
	if self.Low then
		self.Low = tonumber(self.Low)
	else
		self.Low = 0
	end
	if self.Revision then
		self.Revision = tonumber(self.Revision)
	else
		self.Revision = 0
	end
end
KBM.Version:Load()

function KBM.VersionToNumber(High, Mid, Low, Rev)
	return Rev
end

function KBM.Version:Check(High, Mid, Low, Revision)
	if Revision then
		if Revision > self.Revision then
			return false
		else
			return true
		end
	else
		if High <= self.High then
			if High < self.High then
				return true
			else
				if Mid <= self.Mid then
					if Mid < self.Mid then
						return true
					else
						if Low <= self.Low then
							return true
						else
							return false
						end
					end
				else
					return
				end
			end
		else
			return false
		end
	end
end

KBM.Defaults.CastFilter = {}
function KBM.Defaults.CastFilter.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for CastFilter.Create ("..Color..")")
		print("Color does not exist.")
	end
	local FilterObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Default_Color = Color,
		Custom = false,
	}
	return FilterObj
end
function KBM.Defaults.CastFilter.Assign(BossObj)
	if BossObj.HasCastFilters then
		for ID, Data in pairs(BossObj.Settings.Filters) do
			if type(Data) == "table" then
				Data.ID = ID
			end
		end
		for Name, Data in pairs(BossObj.CastFilters) do
			if type(Data) == "table" then
				Data.Prefix = ""
				Data.Settings = BossObj.Settings.Filters[Data.ID]
				if BossObj.Settings.Filters.Enabled then
					Data.Enabled = Data.Settings.Enabled
				else
					Data.Enabled = false
				end
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				Data.Color = Data.Settings.Color
				Data.Custom = Data.Settings.Custom
			end
		end
	end
end

KBM.Defaults.MechObj = {}
function KBM.Defaults.MechObj.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		error("Color error for MechObj.Create ("..tostring(Color)..")\nColor Index does not exist.")
	end
	local TimerObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Default_Color = Color,
		Custom = false,
	}
	return TimerObj
end
function KBM.Defaults.MechObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.MechRef) do
		if BossObj.Settings.MechRef[ID] then
			if type(BossObj.Settings.MechRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.MechRef.Enabled then
					Data.Enabled = BossObj.Settings.MechRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.MechRef[ID]
				BossObj.Settings.MechRef[ID].ID = ID
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				if not KBM.Colors.List[Data.Settings.Color] then
					print("TimerObj Assign Error: "..Data.ID)
					print("Color Index ("..Data.Settings.Color..") does not exist, ignoring settings.")
					print("For: "..BossObj.Name)
					Data.Color = Data.Default_Color
				end
				if Data.Settings.Custom then
					Data.Color = Data.Settings.Color
				else
					Data.Color = Data.Default_Color
				end
			end
		else
			print("Warning: "..ID.." is undefined in MechRef")
			print("for boss: "..BossObj.Name)
			print("---------------")
		end
	end
end

KBM.Defaults.TimerObj = {}
function KBM.Defaults.TimerObj.Create(Color)
	if not Color then
		Color = "blue"
	end
	if not KBM.Colors.List[Color] then
		error("Color error for TimerObj.Create ("..tostring(Color)..")\nColor Index does not exist.")
	end
	local TimerObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Default_Color = Color,
		Custom = false,
	}
	return TimerObj
end
function KBM.Defaults.TimerObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.TimersRef) do
		if BossObj.Settings.TimersRef[ID] then
			if type(BossObj.Settings.TimersRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.TimersRef.Enabled then
					Data.Enabled = BossObj.Settings.TimersRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.TimersRef[ID]
				BossObj.Settings.TimersRef[ID].ID = ID
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				if not KBM.Colors.List[Data.Settings.Color] then
					print("TimerObj Assign Error: "..Data.ID)
					print("Color Index ("..Data.Settings.Color..") does not exist, ignoring settings.")
					print("For: "..BossObj.Name)
					Data.Settings.Color = Data.Default_Color
				end
				if Data.Custom then
					Data.Color = Data.Settings.Color
				else
					Data.Color = Data.Default_Color
				end
				--Data.Settings.Default_Color = nil
			end
		else
			print("Warning: "..ID.." is undefined in TimersRef")
			print("for boss: "..BossObj.Name)
			print("---------------")
		end
	end
end	

KBM.Defaults.AlertObj = {}
function KBM.Defaults.AlertObj.Create(Color, OldData)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for AlertObj.Create ("..Color..")")
		print("Color Index does not exist, setting to Red")
		Color = "red"
	end
	if OldData ~= nil then
		error("Incorrect Format: AlertObj.Create.HasMenu no longer a setting")
	end
	local AlertObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Default_Color = Color,
		Custom = false,
		Border = true,
		Notify = true,
		Sound = true,
	}
	return AlertObj
end
function KBM.Defaults.AlertObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.AlertsRef) do
		if BossObj.Settings.AlertsRef[ID] then
			if type(BossObj.Settings.AlertsRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.AlertsRef.Enabled then
					Data.Enabled = BossObj.Settings.AlertsRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.AlertsRef[ID]
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				if not KBM.Colors.List[Data.Settings.Color] then
					error(	"AlertObj Assign Error: "..Data.ID..
							"/nColor Index ("..Data.Settings.Color..") does not exist, ignoring settings."..
							"/nFor: "..BossObj.Name)
					Data.Settings.Color = Data.Default_Color
				else
					if Data.Settings.Custom then
						Data.Color = Data.Settings.Color
					else
						Data.Color = Data.Default_Color
					end
				end
				BossObj.Settings.AlertsRef[ID].ID = ID
			end
		else
			error(	"Warning: "..ID.." is undefined in AlertsRef"..
					"\nfor boss: "..BossObj.Name)
		end
	end
end

KBM.Defaults.ChatObj = {}
function KBM.Defaults.ChatObj.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for ChatObj.Create ("..Color..")")
		print("Color Index does not exist, setting to Red")
		Color = "red"
	end
	if OldData ~= nil then
		error("Incorrect Format: ChatObj.Create.HasMenu no longer a setting")
	end
	local ChatObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Default_Color = Color,
		Custom = false,
	}
	return ChatObj
end
function KBM.Defaults.ChatObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.ChatRef) do
		if BossObj.Settings.ChatRef[ID] then
			if type(BossObj.Settings.ChatRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.ChatRef.Enabled then
					Data.Enabled = BossObj.Settings.ChatRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.ChatRef[ID]
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				if KBM.Colors.List[Data.Settings.Color] then
					if Data.Settings.Custom then
						Data.Color = Data.Settings.Color
					else
						Data.Color = Data.Default_Color
					end
				else
					error(	"ChatObj Assign Error: "..Data.ID..
							"/nColor Index ("..Data.Settings.Color..") does not exist, ignoring settings."..
							"/nFor: "..BossObj.Name)
					Data.Settings.Color = Data.Color
				end
				BossObj.Settings.ChatRef[ID].ID = ID
			end
		else
			error(	"Warning: "..ID.." is undefined in ChatRef"..
					"\nfor boss: "..BossObj.Name)
		end
	end
end

function KBM.Defaults.Castbar()
	-- local CastBar = {
		-- Override = false,
		-- x = false,
		-- y = false,
		-- Enabled = true,
		-- Style = "rift",
		-- RiftBar = true,
		-- Shadow = true,
		-- Unlocked = true,
		-- Visible = true,
		-- ScaleWidth = false,
		-- wScale = 1,
		-- hScale = 1,
		-- tScale = 1,
		-- Shadow = true,
		-- Texture = true,
		-- TextureAlpha = 0.75,
		-- ScaleHeight = false,
		-- TextScale = false,
		-- Pinned = false,
		-- Color = "red",
		-- Custom = false,
		-- Type = "CastBar",
	-- }
	local Castbar = LibSCast.Default.BarSettings()
	Castbar.override = false
	Castbar.riftBar = true
	Castbar.pinned = false
	Castbar.pack = "Rift"
	Castbar.custom = false
	return Castbar
end

function KBM.Defaults.PhaseMon()
	local PhaseMon = {
		Override = false,
		x = false,
		y = false,
		w = 225,
		h = 50,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 14,
		TextScale = false,
		Objectives = true,
		PhaseDisplay = true,
		Type = "PhaseMon",
	}
	return PhaseMon
end

function KBM.Constant:Init()
	self.PhaseMon = {
		w = 225,
		h = 50,
		TextSize = 14,
	}
	self.Alerts = {
		TextSize = 32,
	}
	self.MechSpy = {
		w = 275,
		h = 25,
		TextSize = 14,
		TextureAlpha = 0.75,
	}
	self.MechTimer = {
		w = 350,
		h = 32,
	}
	self.ResMaster = {
		w = 250,
		h = 26,
		TextSize = 12,
		TextureAlpha = 0.75,
	}
	self.CastBar = {
		w = 280,
		h = 32,
		TextSize = 14,
	}
	self.Button = {
		s = 32,
	}
	self.TankSwap = {
		w = 150,
		h = 40,
		TextSize = 14,
	}
end

KBM.Constant:Init()

function KBM.Defaults.MechTimer()
	local MechTimer = {
		Override = false,
		x = false,
		y = false,
		w = 350,
		h = 32,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Shadow = true,
		Texture = true,
		TextureAlpha = 0.75,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 16,
		TextScale = false,
		Custom = false,
		Color = "blue",
		Type = "MechTimer",
	}
	return MechTimer
end

function KBM.Defaults.Alerts()
	local Alerts = {
		Override = false,
		Enabled = true,
		Flash = true,
		Notify = true,
		Visible = false,
		Unlocked = false,
		FlashUnlocked = false,
		Vertical = true,
		Horizontal = false,
		ScaleText = false,
		fScale = 0.2,
		tScale = 1,
		x = false,
		y = false,
		Type = "Alerts",
	}
	return Alerts
end

function KBM.Defaults.MechSpy()
	local MechSpy = {
		Override = false,
		Enabled = true,
		Visible = true,
		Unlocked = true,
		Show = false,
		Pin = true,
		ScaleText = false,
		ScaleWidth = false,
		ScaleHeight = false,
		tScale = 1,
		wScale = 1,
		hScale = 1,
		x = false, 
		y = false,
		Type = "MechSpy",
	}
	return MechSpy
end

function KBM.Defaults.Records()

	local RecordObj = {
		Attempts = 0,
		Wipes = 0,
		Kills = 0,
		Best = 0,
		Date = "n/a",
	}
	return RecordObj
	
end

function KBM.Defaults.Menu()
	
	local MenuObj = {
		Collapse = false,
	}
	return MenuObj

end

function KBM.Defaults.Button()
	local ButtonObj = {
		x = false,
		y = false,
		Unlocked = true,
		Visible = true,
	}
	return ButtonObj
end

local function KBM_DefineVars(handle, AddonID)
	if AddonID == "KingMolinator" then
		KBM.Options = {
			Castbar = {
				Player = {},
				Global = KBM.Defaults.Castbar(),
			},
			Character = false,
			Enabled = true,
			Debug = false,
			MenuState = {},
			MenuExpac = "Rift",
			UnitCache = {
				Raid = {},
				Sliver = {},
				Master = {},
				Expert = {},
				Normal = {},
				List = {},
			},
			UnitTotal = 0,
			CPU = {
				Enabled = false,
				x = false,
				y = false,
			},
			DebugSettings = {
				x = false,
				y = false,
			},
			Frame = {
				RelX = false,
				RelY= false,
			},
			Button = KBM.Defaults.Button(),
			Alerts = KBM.Defaults.Alerts(),
			EncTimer = KBM.Defaults.EncTimer(),
			PhaseMon = KBM.Defaults.PhaseMon(),
			MechTimer = KBM.Defaults.MechTimer(),
			MechSpy = KBM.Defaults.MechSpy(),
			Chat = {
				Enabled = true,
			},
			ResMaster = {
				Enabled = true,
				x = false,
				y = false,
				ScaleWidth = false,
				ScaleHeight = false,
				ScaleText = false,
				Enabled = true,
				Visible = true,
				Unlocked = true,
				wScale = 1,
				hScale = 1,
				tScale = 1,
				Cascade = true,
			},
			TankSwap = {
				x = false,
				y = false,
				wScale = 1,
				hScale = 1,
				tScale = 1,
				ScaleUnlocked = false,
				ScaleWidth = false,
				ScaleHeight = false,
				TextScale = false,
				Enabled = true,
				Visible = true,
				Unlocked = true,
				Tank = false,
			},
			BestTimes = {
			},
			Sheep = {
				Protect = false,
			},
		}
		KBM.Marks = {
			Location = {
				[19] = KBMIni.id,
				[20] = KBMIni.id,
				[21] = KBMIni.id,
				[27] = KBMIni.id,
				[28] = KBMIni.id,
				[29] = KBMIni.id,
			},
			LocationFull = {
			},
			File = {
				[1] = "vfx_ui_mob_tag_01_mini.png.dds",
				[2] = "vfx_ui_mob_tag_02_mini.png.dds",
				[3] = "vfx_ui_mob_tag_03_mini.png.dds",
				[4] = "vfx_ui_mob_tag_04_mini.png.dds",
				[5] = "vfx_ui_mob_tag_05_mini.png.dds",
				[6] = "vfx_ui_mob_tag_06_mini.png.dds",
				[7] = "vfx_ui_mob_tag_07_mini.png.dds",
				[8] = "vfx_ui_mob_tag_08_mini.png.dds",
				[9] = "vfx_ui_mob_tag_tank_mini.png.dds",
				[10] = "vfx_ui_mob_tag_heal_mini.png.dds",
				[11] = "vfx_ui_mob_tag_damage_mini.png.dds",
				[12] = "vfx_ui_mob_tag_support_mini.png.dds",
				[13] = "vfx_ui_mob_tag_arrow_mini.png.dds",
				[14] = "vfx_ui_mob_tag_skull_mini.png.dds",
				[15] = "vfx_ui_mob_tag_no_mini.png.dds",
				[16] = "vfx_ui_mob_tag_smile_mini.png.dds",
				[17] = "vfx_ui_mob_tag_squirrel_mini.png.dds",
				[18] = "vfx_ui_mob_tag_crown_mini.png.dds",
				[19] = "media/heal_two_small.png",
				[20] = "media/heal_three_small.png",
				[21] = "media/heal_four_small.png",
				[22] = "vfx_ui_mob_tag_heart_mini.png.dds",
				[23] = "vfx_ui_mob_tag_heart_leftside_mini.png.dds",
				[24] = "vfx_ui_mob_tag_heart_rightside_mini.png.dds",
				[25] = "vfx_ui_mob_tag_radioactive_mini.png.dds",
				[26] = "vfx_ui_mob_tag_sad_mini.png.dds",
				[27] = "media/tank_two_small.png",
				[28] = "media/tank_three_small.png",
				[29] = "media/tank_four_small.png",
				[30] = "vfx_ui_mob_tag_clover_mini.png.dds",
			},
			FileFull = {
				[1] = "vfx_ui_mob_tag_01.png.dds",
				[2] = "vfx_ui_mob_tag_02.png.dds",
				[3] = "vfx_ui_mob_tag_03.png.dds",
				[4] = "vfx_ui_mob_tag_04.png.dds",
				[5] = "vfx_ui_mob_tag_05.png.dds",
				[6] = "vfx_ui_mob_tag_06.png.dds",
				[7] = "vfx_ui_mob_tag_07.png.dds",
				[8] = "vfx_ui_mob_tag_08.png.dds",
				[9] = "vfx_ui_mob_tag_tank.png.dds",
				[10] = "vfx_ui_mob_tag_heal.png.dds",
				[11] = "vfx_ui_mob_tag_damage.png.dds",
				[12] = "vfx_ui_mob_tag_support.png.dds",
				[13] = "vfx_ui_mob_tag_arrow.png.dds",
				[14] = "vfx_ui_mob_tag_skull.png.dds",
				[15] = "vfx_ui_mob_tag_no.png.dds",
				[16] = "vfx_ui_mob_tag_smile.png.dds",
				[17] = "vfx_ui_mob_tag_squirrel.png.dds",
				[18] = "vfx_ui_mob_tag_crown.png.dds",
				[19] = "vfx_ui_mob_tag_heal2.png.dds",
				[20] = "vfx_ui_mob_tag_heal3.png.dds",
				[21] = "vfx_ui_mob_tag_heal4.png.dds",
				[22] = "vfx_ui_mob_tag_heart.png.dds",
				[23] = "vfx_ui_mob_tag_heart_leftside.png.dds",
				[24] = "vfx_ui_mob_tag_heart_rightside.png.dds",
				[25] = "vfx_ui_mob_tag_radioactive.png.dds",
				[26] = "vfx_ui_mob_tag_sad.png.dds",
				[27] = "vfx_ui_mob_tag_tank2.png.dds",
				[28] = "vfx_ui_mob_tag_tank3.png.dds",
				[29] = "vfx_ui_mob_tag_tank4.png.dds",
				[30] = "vfx_ui_mob_tag_clover.png.dds",
			},			
			Icon = {},
			Name = {
				[1] = "1",
				[2] = "2",
				[3] = "3",
				[4] = "4",
				[5] = "5",
				[6] = "6",
				[7] = "7",
				[8] = "8",
				[9] = KBM.Language.Marks.Tank[KBM.Lang],
				[10] = KBM.Language.Marks.Heal[KBM.Lang],
				[11] = KBM.Language.Marks.Damage[KBM.Lang],
				[12] = KBM.Language.Marks.Support[KBM.Lang],
				[13] = KBM.Language.Marks.Arrow[KBM.Lang],
				[14] = KBM.Language.Marks.Skull[KBM.Lang],
				[15] = KBM.Language.Marks.Avoid[KBM.Lang],
				[16] = KBM.Language.Marks.Smile[KBM.Lang],
				[17] = KBM.Language.Marks.Squirrel[KBM.Lang],
				[18] = KBM.Language.Marks.Crown[KBM.Lang],
				[19] = KBM.Language.Marks.HealTwo[KBM.Lang],
				[20] = KBM.Language.Marks.HealThree[KBM.Lang],
				[21] = KBM.Language.Marks.HealFour[KBM.Lang],
				[22] = KBM.Language.Marks.Heart[KBM.Lang],
				[23] = KBM.Language.Marks.HeartLeft[KBM.Lang],
				[24] = KBM.Language.Marks.HeartRight[KBM.Lang],
				[25] = KBM.Language.Marks.HeartLeft[KBM.Lang],
				[26] = KBM.Language.Marks.Sad[KBM.Lang],
				[27] = KBM.Language.Marks.TankTwo[KBM.Lang],
				[28] = KBM.Language.Marks.TankThree[KBM.Lang],
				[29] = KBM.Language.Marks.TankFour[KBM.Lang],
				[30] = KBM.Language.Marks.Luck[KBM.Lang],
			},
		}
		KBM_GlobalOptions = KBM.Options
		chKBM_GlobalOptions = KBM.Options
		for ID, Castbar in pairs(KBM.Castbar.Player) do
			KBM.Options.Castbar.Player[ID] = KBM.Defaults.Castbar()
			Castbar.Settings = KBM.Options.Castbar.Player[ID]
			Castbar.Settings.relX = Castbar.relX
			Castbar.Settings.relY = Castbar.relY
		end
		for _, Mod in ipairs(KBM.ModList) do
			Mod:InitVars()
			if not Mod.IsInstance then
				if Mod.Settings then
					if not Mod.Settings.Records then
						Mod.Settings.Records = KBM.Defaults.Records()
						if Mod.HasChronicle then
							Mod.Settings.Records.Chronicle = KBM.Defaults.Records()
						end
					end
				end
			end
			if not Mod.Descript then
				print("Warning: "..Mod.ID.." has no description.")
			end
		end
		KBM.Options.PercentageMon = KBM.PercentageMon.Defaults()
		KBM.PercentageMon.Settings = KBM.Options.PercentageMon
	elseif KBM.PlugIn.List[AddonID] then
		KBM.PlugIn.List[AddonID]:InitVars()
	end
end

function KBM.LoadTable(Source, Target)
	if type(Source) == "table" then
		for Setting, Value in pairs(Source) do
			if type(Value) == "table" then
				if Target[Setting] ~= nil then
					if type(Target[Setting]) == "table" then
						KBM.LoadTable(Value, Target[Setting])
					end
				end
			else
				if(Target[Setting]) ~= nil then
					if type(Target[Setting]) ~= "table" then
						Target[Setting] = Value
					end
				end
			end
		end
	end
end

local function KBM_LoadVars(handle, AddonID)
	local TargetLoad = nil
	if AddonID == "KingMolinator" then
		if chKBM_GlobalOptions.Character then
			KBM.LoadTable(chKBM_GlobalOptions, KBM.Options)
		else
			KBM.LoadTable(KBM_GlobalOptions, KBM.Options)
		end		

		if KBM_GlobalOptions.UnitCache then
			KBM.Options.UnitCache = KBM_GlobalOptions.UnitCache
			KBM.Options.UnitTotal = KBM_GlobalOptions.UnitTotal
		end
		
		if KBM.Options.Character then
			if chKBM_GlobalOptions.MenuState then
				KBM.Options.MenuState = chKBM_GlobalOptions.MenuState
			end
			chKBM_GlobalOptions = KBM.Options
		else
			if KBM_GlobalOptions.MenuState then
				KBM.Options.MenuState = KBM_GlobalOptions.MenuState
			end
			KBM_GlobalOptions = KBM.Options		
		end
				
		for _, Mod in ipairs(KBM.ModList) do
			Mod:LoadVars()
		end
		
		KBM.Debug = KBM.Options.Debug
		KBM.InitVars()
		KBM.PercentageMon:Init()
	elseif KBM.PlugIn.List[AddonID] then
		KBM.PlugIn.List[AddonID]:LoadVars()
	end
end

local function KBM_SaveVars(handle, AddonID)
	if AddonID == "KingMolinator" then
		KBM_GlobalOptions.UnitCache = KBM.Options.UnitCache
		KBM_GlobalOptions.UnitTotal = KBM.Options.UnitTotal
		if not KBM.Options.Character then
			KBM_GlobalOptions = KBM.Options
		else
			chKBM_GlobalOptions = KBM.Options
		end
		for _, Mod in ipairs(KBM.ModList) do
			Mod:SaveVars()
		end
	elseif KBM.PlugIn.List[AddonID] then
		KBM.PlugIn.List[AddonID]:SaveVars()
	end
end

function KBM.ToAbilityID(num)
	return string.format("a%016X", num)
end

KBM.MenuGroup = {}
KBM.Boss = {
	Template = {},
	Raid = {},
	Sliver = {},
	Dungeon = {
		List = {},
	},
	Master = {},
	Expert = {},
	Normal = {},
	Chronicle = {},
	Rift = {},
	ExRift = {},
	RaidRift = {},
	World = {},
	Trash = {},
	TypeList = {},
	Name = {},
}

KBM.SubBoss = {}
KBM.SubBossID = {}
KBM.BossID = {}
KBM.BossLocation = {}
KBM.Encounter = false
KBM.HeaderList = {}
KBM.CurrentBoss = ""
KBM.CurrentMod = nil
local KBM_TestIsCasting = false
local KBM_TestAbility = nil

KBM.HeldTime = Inspect.Time.Real()
KBM.StartTime = 0
KBM.EnrageTime = 0
KBM.EnrageTimer = 0
KBM.TimeElapsed = 0
KBM.UpdateTime = 0
KBM.LastAction = 0
KBM.CastBar = {}
KBM.CastBar.List = {}

-- Addon Primary Context
KBM.Context = UI.CreateContext("KBM_Context")
KBM.Context:SetMouseMasking("limited")
local KM_Name = "King Boss Mods"

-- Addon KBM Primary Frames
KBM.TimeVisual = {}
KBM.TimeVisual.String = "00"
KBM.TimeVisual.Seconds = 0
KBM.TimeVisual.Minutes = 0
KBM.TimeVisual.Hours = 0

KBM.MechTimer = {}
KBM.MechTimer.testTimerList = {}

KBM.TankSwap = {}
KBM.TankSwap.Triggers = {}

KBM.EncTimer = {}
KBM.Button = {}
KBM.PhaseMonitor = {}
KBM.Trigger = {}
KBM.Alert = {}
KBM.MechSpy = {}
KBM.Chat = {}

function KBM.Numbers.GetPlace(Number)
	local Check = 0
	local Last = 0
	if Number < 4 or Number > 20 then
		Last = tonumber(string.sub(tostring(Number), -1))
		if Last > 0 and Last < 4 then
			Check = Last
		end
	end
	return Number..KBM.Numbers.Place[Check]
end

-- Main Color Library.
-- Colors will remain preset based to avoid ugly videos :)
KBM.Colors = {
	Count = 8,
	List = {
		red = {
			Name = KBM.Language.Color.Red[KBM.Lang],
			Red = 1,
			Green = 0,
			Blue = 0,
		},
		dark_green = {
			Name = KBM.Language.Color.Dark_Green[KBM.Lang],
			Red = 0,
			Green = 0.6,
			Blue = 0,
		},
		orange = {
			Name = KBM.Language.Color.Orange[KBM.Lang],
			Red = 1,
			Green = 0.5,
			Blue = 0,
		},
		blue = {
			Name = KBM.Language.Color.Blue[KBM.Lang],
			Red = 0,
			Green = 0,
			Blue = 1,
		},
		cyan = {
			Name = KBM.Language.Color.Cyan[KBM.Lang],
			Red = 0,
			Green = 1,
			Blue = 1,
		},
		yellow = {
			Name = KBM.Language.Color.Yellow[KBM.Lang],
			Red = 1,
			Green = 1,
			Blue = 0,
		},
		purple = {
			Name = KBM.Language.Color.Purple[KBM.Lang],
			Red = 0.5,
			Green = 0,
			Blue = 0.38,
		},
		pink = {
			Name = KBM.Language.Color.Pink[KBM.Lang],
			Red = 0.93,
			Green = 0.36,
			Blue = 0.65,
		},
		dark_grey = {
			Name = KBM.Language.Color.Dark_Grey[KBM.Lang],
			Red = 0.3,
			Green = 0.3,
			Blue = 0.3,
		},
	}
}
function KBM.MechTimer:ApplySettings()
	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(self.Settings.w * self.Settings.wScale)
	self.Anchor:SetHeight(self.Settings.h * self.Settings.hScale)
	self.Anchor.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
	if KBM.Menu.Active then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end	
end

function KBM.MechTimer:Init()
	self.TimerList = {}
	self.ActiveTimers = {}
	self.RemoveTimers = {}
	self.RemoveCount = 0
	self.StartTimers = {}
	self.StartCount = 0
	self.LastTimer = nil
	self.Store = {}
	self.Cached = 0
	self.TempGUI = {}
	self.Settings = KBM.Options.MechTimer
	self.Anchor = UI.CreateFrame("Frame", "Timer Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
		
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.MechTimer.Settings.x = self:GetLeft()
			KBM.MechTimer.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "Timer Info", self.Anchor)
	self.Anchor.Text:SetText(" 0.0 "..KBM.Language.Anchors.Timers[KBM.Lang])
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.MechTimer.Settings.ScaleWidth then
			if KBM.MechTimer.Settings.wScale < 1.5 then
				KBM.MechTimer.Settings.wScale = KBM.MechTimer.Settings.wScale + 0.025
				if KBM.MechTimer.Settings.wScale > 1.5 then
					KBM.MechTimer.Settings.wScale = 1.5
				end
				KBM.MechTimer.Anchor:SetWidth(KBM.MechTimer.Settings.wScale * KBM.MechTimer.Settings.w)
			end
		end
		
		if KBM.MechTimer.Settings.ScaleHeight then
			if KBM.MechTimer.Settings.hScale < 1.5 then
				KBM.MechTimer.Settings.hScale = KBM.MechTimer.Settings.hScale + 0.025
				if KBM.MechTimer.Settings.hScale > 1.5 then
					KBM.MechTimer.Settings.hScale = 1.5
				end
				KBM.MechTimer.Anchor:SetHeight(KBM.MechTimer.Settings.hScale * KBM.MechTimer.Settings.h)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
					end
				end
			end
		end
		
		if KBM.MechTimer.Settings.TextScale then
			if KBM.MechTimer.Settings.tScale < 1.5 then
				KBM.MechTimer.Settings.tScale = KBM.MechTimer.Settings.tScale + 0.025
				if KBM.MechTimer.Settings.tScale > 1.5 then
					KBM.MechTimer.Settings.tScale = 1.5
				end
				KBM.MechTimer.Anchor.Text:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
						Timer.GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
					end
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if KBM.MechTimer.Settings.ScaleWidth then
			if KBM.MechTimer.Settings.wScale > 0.5 then
				KBM.MechTimer.Settings.wScale = KBM.MechTimer.Settings.wScale - 0.025
				if KBM.MechTimer.Settings.wScale < 0.5 then
					KBM.MechTimer.Settings.wScale = 0.5
				end
				KBM.MechTimer.Anchor:SetWidth(KBM.MechTimer.Settings.wScale * KBM.MechTimer.Settings.w)
			end
		end
		
		if KBM.MechTimer.Settings.ScaleHeight then
			if KBM.MechTimer.Settings.hScale > 0.5 then
				KBM.MechTimer.Settings.hScale = KBM.MechTimer.Settings.hScale - 0.025
				if KBM.MechTimer.Settings.hScale < 0.5 then
					KBM.MechTimer.Settings.hScale = 0.5
				end
				KBM.MechTimer.Anchor:SetHeight(KBM.MechTimer.Settings.hScale * KBM.MechTimer.Settings.h)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
					end
				end
			end
		end
		
		if KBM.MechTimer.Settings.TextScale then
			if KBM.MechTimer.Settings.tScale > 0.5 then
				KBM.MechTimer.Settings.tScale = KBM.MechTimer.Settings.tScale - 0.025
				if KBM.MechTimer.Settings.tScale < 0.5 then
					KBM.MechTimer.Settings.tScale = 0.5
				end
				KBM.MechTimer.Anchor.Text:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
						Timer.GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
					end
				end				
			end
		end
	end
	self:ApplySettings()
end

function KBM.MechTimer:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Timer_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", KBM.MechTimer.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", KBM.MechTimer.Anchor, "RIGHT")
		GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.Background:SetLayer(KBM.Layer.Timers)
		GUI.TimeBar = UI.CreateFrame("Frame", "Timer_Progress_Frame", GUI.Background)
		--KBM.LoadTexture(GUI.TimeBar, "KingMolinator", "Media/BarTexture2.png")
		GUI.TimeBar:SetWidth(KBM.MechTimer.Anchor:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.CastInfo = UI.CreateFrame("Text", "Timer_Text_Frame", GUI.Background)
		GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.CastInfo:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT")
		GUI.CastInfo:SetLayer(3)
		GUI.CastInfo:SetFontColor(1,1,1)
		GUI.CastInfo:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.Shadow:SetPoint("CENTER", GUI.CastInfo, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.MechTimer.Settings.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
	end
	return GUI
end

function KBM.MechTimer:Add(Name, Duration, Repeat)
	local Timer = {}
	Timer.Active = false
	Timer.Alerts = {}
	Timer.Timers = {}
	Timer.Triggers = {}
	Timer.TimeStart = nil
	Timer.Removing = false
	Timer.Starting = false
	if not Duration then
		Timer.Time = 2
		Timer.Dynamic = true
	else
		Timer.Time = Duration
		Timer.Dynamic = false
	end
	Timer.Delay = iStart
	Timer.Enabled = true
	Timer.Linked = nil
	Timer.Repeat = Repeat
	Timer.Name = Name
	Timer.Phase = 0
	Timer.PhaseMax = 0
	Timer.Type = "timer"
	Timer.Waiting = false
	Timer.WaitNext = false
	Timer.Priority = 0
	Timer.Custom = false
	Timer.Color = KBM.MechTimer.Settings.Color
	Timer.HasMenu = true
	if type(Name) ~= "string" then
		error("Expecting String for Name, got "..type(Name))
	end
	
	function self:AddRemove(Object, Force)
		if not Object.Removing then
			if Object.Active then
				Object.Removing = true
				Object.ForceStop = Force or false
				table.insert(self.RemoveTimers, Object)
				self.RemoveCount = self.RemoveCount + 1
			end
		end
	end
	
	function self:AddStart(Object, Duration)
		if not Object.Starting then
			if Object.Enabled then
				self.Queued = false
				Object.Starting = true
				if Object.Dynamic then
					Object.Time = Duration
				end
				self.StartCount = self.StartCount + 1
				table.insert(self.StartTimers, Object)
				self:AddRemove(Object)
			end
		end
	end
	
	function Timer:Wait(Priority)
		self.WaitNext = true
		self.Priority = tonumber(Priority) or -1
	end
	
	function Timer:Start(CurrentTime, DebugInfo)	
		if self.Enabled then
			if self.Phase > 0 then
				if KBM.CurrentMod then
					if self.Phase < KBM.CurrentMod.Phase then
						return
					end
				end
			end
			if self.Active then
				KBM.MechTimer:AddStart(self)
				return
			end
			local Anchor = KBM.MechTimer.Anchor
			self.ForceStop = false
			self.GUI = KBM.MechTimer:Pull()
			self.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
			self.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
			self.GUI.Shadow:SetFontSize(self.GUI.CastInfo:GetFontSize())
			self.TimeStart = CurrentTime
			self.Remaining = self.Time
			self.GUI.CastInfo:SetText(string.format(" %0.01f : ", self.Remaining)..self.Name)
			
			if KBM.MechTimer.Settings.Shadow then
				self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
				self.GUI.Shadow:SetVisible(true)
			else
				self.GUI.Shadow:SetVisible(false)
			end
			
			if KBM.MechTimer.Settings.Texture then
				self.GUI.Texture:SetVisible(true)
			else
				self.GUI.Texture:SetVisible(false)
			end
			
			if self.Delay then
				self.Time = Delay
			end
			
			if self.Settings then
				if self.Settings.Custom then
					self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
				else
					self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
				end
			else
				self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[KBM.MechTimer.Settings.Color].Red, KBM.Colors.List[KBM.MechTimer.Settings.Color].Green, KBM.Colors.List[KBM.MechTimer.Settings.Color].Blue, 0.33)
			end
			
			if #KBM.MechTimer.ActiveTimers > 0 then
				for i, cTimer in ipairs(KBM.MechTimer.ActiveTimers) do
					if self.Remaining < cTimer.Remaining then
						self.Active = true
						if i == 1 then
							self.GUI.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
							cTimer.GUI.Background:SetPoint("TOPLEFT", self.GUI.Background, "BOTTOMLEFT", 0, 1)
						else
							self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
							cTimer.GUI.Background:SetPoint("TOPLEFT", self.GUI.Background, "BOTTOMLEFT", 0, 1)
						end
						table.insert(KBM.MechTimer.ActiveTimers, i, self)
						break
					end
				end
				if not self.Active then
					self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.LastTimer.GUI.Background, "BOTTOMLEFT", 0, 1)
					table.insert(KBM.MechTimer.ActiveTimers, self)
					KBM.MechTimer.LastTimer = self
					self.Active = true
				end
			else
				self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
				table.insert(KBM.MechTimer.ActiveTimers, self)
				self.Active = true
				KBM.MechTimer.LastTimer = self
				if KBM.MechTimer.Settings.Visible then
					KBM.MechTimer.Anchor.Text:SetVisible(false)
				end
			end
			self.GUI.Background:SetVisible(true)
			self.Starting = false
		end		
	end
	
	function Timer:Queue(Duration)
		if self.Enabled then
			KBM.MechTimer:AddStart(self, Duration)
		end
	end
	
	function Timer:Stop()
		if self.Active then
			if not self.Deleting then
				self.Deleting = true
				for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
					if Timer == self then
						if #KBM.MechTimer.ActiveTimers == 1 then
							KBM.MechTimer.LastTimer = nil
							if KBM.MechTimer.Settings.Visible then
								KBM.MechTimer.Anchor.Text:SetVisible(true)
							end
						elseif i == 1 then
							KBM.MechTimer.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
						elseif i == #KBM.MechTimer.ActiveTimers then
							KBM.MechTimer.LastTimer = KBM.MechTimer.ActiveTimers[i-1]
						else
							KBM.MechTimer.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
						end
						table.remove(KBM.MechTimer.ActiveTimers, i)
						break
					end
				end
				self.GUI.Background:SetVisible(false)
				self.GUI.Shadow:SetText("")
				table.insert(KBM.MechTimer.Store, self.GUI)
				self.Active = false
				self.Remaining = 0
				self.TimeStart = 0
				self.Waiting = false
				for i, AlertObj in pairs(self.Alerts) do
					self.Alerts[i].Triggered = false
				end
				for i, TimerObj in pairs(self.Timers) do
					self.Timers[i].Triggered = false
				end
				self.GUI = nil
				self.Removing = false
				self.Deleting = false
				if KBM.Encounter then
					if not self.ForceStop then
						if self.Repeat then
							KBM.MechTimer:AddStart(self)
						end
						if self.TimerAfter then
							for i, TimerObj in ipairs(self.TimerAfter) do
								if TimerObj.Phase >= KBM.CurrentMod.Phase or TimerObj.Phase == 0 then
									KBM.MechTimer:AddStart(TimerObj)
								end
							end
						end
						if self.AlertAfter then
							KBM.Alert:Start(self.AlertAfter, Inspect.Time.Real())
						end
					end
				end
			end
		end
	end
	
	function Timer:AddAlert(AlertObj, Time)
		if type(AlertObj) == "table" then
			if AlertObj.Type ~= "alert" then
				error("Expecting AlertObj got "..tostring(AlertObj.Type))
			else
				if Time == 0 then
					self.AlertAfter = AlertObj
				else
					self.Alerts[Time] = {}
					self.Alerts[Time].Triggered = false
					self.Alerts[Time].AlertObj = AlertObj
				end
			end
		else
			error("Expecting AlertObj got "..type(AlertObj))
		end
	end
	
	function Timer:AddTimer(TimerObj, Time)
		if type(TimerObj) == "table" then
			if TimerObj.Type ~= "timer" then
				error("Expecting TimerObj got "..tostring(TimerObj.Type))
			else
				if Time == 0 then
					if not self.TimerAfter then
						self.TimerAfter = {}
					end
					table.insert(self.TimerAfter, TimerObj)
				else
					if not self.Timers[Time] then
						self.Timers[Time] = {
							Triggered = false,
							Timers = {},
						}
					end
					table.insert(self.Timers[Time].Timers, TimerObj)
				end
			end
		else
			error("Expecting TimerObj got "..type(TimerObj))
		end
	end
	
	function Timer:AddTrigger(TriggerObj, Time)
		if not self.Triggers[Time] then
			self.Triggers[Time] = {}
		end
		self.Triggers[Time].Triggered = false
		self.Triggers[Time].TriggerObj = TriggerObj
	end
	
	function Timer:SetPhase(Phase)
		self.Phase = Phase
	end
	
	function Timer:Update(CurrentTime)
		local text = ""
		if self.Active then
			if self.Waiting then
				self.Remaining = math.floor(self.Time - (CurrentTime - self.TimeStart))
				if self.Remaining ~= self.lastRemaining then
					self.GUI.CastInfo:SetText(" "..self.Remaining.." : "..self.Name)
					self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
					self.lastRemaining = self.Remaining
				end
			else
				self.Remaining = self.Time - (CurrentTime - self.TimeStart)
				if self.Remaining < 10 then
					text = string.format(" %0.01f : ", self.Remaining)..self.Name
				elseif self.Remaining >= 60 then
					text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Name
				else
					text = " "..math.floor(self.Remaining).." : "..self.Name
				end
				if text ~= self.GUI.CastInfo:GetText() then
					self.GUI.CastInfo:SetText(text)
					self.GUI.Shadow:SetText(text)
				end
				newWidth = math.floor(self.GUI.Background:GetWidth() * (self.Remaining/self.Time))
				if self.GUI.TimeBar:GetWidth() ~= newWidth then
					self.GUI.TimeBar:SetWidth(self.GUI.Background:GetWidth() * (self.Remaining/self.Time))
				end
				if self.Remaining <= 0 then
					self.Remaining = 0
					if not self.WaitNext then
						KBM.MechTimer:AddRemove(self)
					else
						self.Waiting = true
						self.GUI.TimeBar:SetWidth(self.GUI.Background:GetWidth())
						self.GUI.CastInfo:SetText(math.floor(self.Remaining).." : "..self.Name)
						self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
					end
				end
				if KBM.Encounter then
					TriggerTime = math.ceil(self.Remaining)
					if self.Timers[TriggerTime] then
						if not self.Timers[TriggerTime].Triggered then
							for i, TimerObj in pairs(self.Timers[TriggerTime].Timers) do
								KBM.MechTimer:AddStart(TimerObj)
							end
							self.Timers[TriggerTime].Triggered = true
						end
					end
					if self.Alerts[TriggerTime] then
						if not self.Alerts[TriggerTime].Triggered then
							KBM.Alert:Start(self.Alerts[TriggerTime].AlertObj, CurrentTime)
							self.Alerts[TriggerTime].Triggered = true
						end
					end
				end
			end
		end
	end
	
	function Timer:NoMenu()
		self.HasMenu = false
		self.Enabled = true
	end
	
	function Timer:SetLink(Timer)
		if type(Timer) == "table" then
			if Timer.Type ~= "timer" then
				error("Supplied Object is not a Timer, got: "..tostring(Timer.Type))
			else
				self.Link = Timer
				self:NoMenu()
				for SettingID, Value in pairs(self.Settings) do
					if SettingID ~= "ID" then
						self.Link.Settings[SettingID] = Value
					end
				end
				if not Timer.Linked then
					Timer.Linked = {}
				end
				table.insert(Timer.Linked, self)
			end
		else
			error("Expecting at least a table got: "..type(Timer))
		end
	end
	
	return Timer
	
end

function KBM.Trigger:Init()
	self.Queue = {}
	self.Queue.Locked = false
	self.Queue.Removing = false
	self.Queue.List = {}
	self.List = {}
	self.Notify = {}
	self.Say = {}
	self.Damage = {}
	self.Cast = {}
	self.CastID = {}
	self.PersonalCast = {}
	self.PersonalCastID = {}
	self.Percent = {}
	self.Combat = {}
	self.Start = {}
	self.Death = {}
	self.Buff = {}
	self.PlayerBuff = {}
	self.PlayerDebuff = {}
	self.PlayerIDBuff = {}
	self.BuffRemove = {}
	self.PlayerBuffRemove = {}
	self.PlayerIDBuffRemove = {}
	self.Time = {}
	self.Channel = {}
	self.ChannelID = {}
	self.PersonalChannel = {}
	self.PersonalChannelID = {}
	self.Interrupt = {}
	self.InterruptID = {}
	self.PersonalInterrupt = {}
	self.PersonalInterruptID = {}
	self.NpcDamage = {}
	self.EncStart = {}
	self.CustomBuffRemove = {}
	self.Seq = {}
	self.Max = {
		Timers = {},
		Spies = {},
	}
	self.High = {
		Timers = 0,
		Spies = 0,
	}

	function self.Queue:Add(TriggerObj, Caster, Target, Duration)	
		if KBM.Encounter then
			if TriggerObj.Queued then
				TriggerObj.Target[Target] = true
				return
			elseif self.Removing then
				return
			end
			TriggerObj.Queued = true
			table.insert(self.List, TriggerObj)
			TriggerObj.Caster = Caster
			if Target then
				TriggerObj.Target = {[Target] = true}
			else
				TriggerObj.Target = {}
			end
			TriggerObj.Duration = Duration
			self.Queued = true
		end		
	end
	
	function self.Queue:Activate()	
		if self.Queued then
			if KBM.Encounter then
				if self.Removing then
					return
				end
				for i, TriggerObj in ipairs(self.List) do
					TriggerObj:Activate(TriggerObj.Caster, TriggerObj.Target, TriggerObj.Duration)
					TriggerObj.Queued = false
				end
				self.List = {}
				self.Queued = false
			end
		end		
	end
	
	function self.Queue:Remove()		
		self.Removing = true
		self.List = {}
		self.Removing = false
		self.Queued = false		
	end
	
	function self:Create(Trigger, Type, Unit, Hook, NonEncounter)	
		local TriggerObj = {}
		TriggerObj.Timers = {}
		TriggerObj.Alerts = {}
		TriggerObj.Spies = {}
		TriggerObj.Stop = {}
		TriggerObj.Hook = Hook
		TriggerObj.Unit = Unit
		TriggerObj.Type = Type
		TriggerObj.Caster = nil
		TriggerObj.Target = {}
		TriggerObj.Queued = false
		TriggerObj.Phase = nil
		TriggerObj.Trigger = Trigger
		TriggerObj.LastTrigger = 0
		TriggerObj.Enabled = true
		TriggerObj.Extended = NonEncounter
		TriggerObj.Seq = {
			Alerts = {},
			TotalAlerts = 0,
			CurrentAlert = 1,
			Timers = {},
			TotalTimers = 0,
			CurrentTimer = 1,
			Stored = false,
		}
		
		function TriggerObj:AddTimer(TimerObj)
			if not TimerObj then
				error("Timer object does not exist!")
			end
			if type(TimerObj) ~= "table" then
				error("TimerObj: Expecting Table, got "..tostring(type(TimerObj)))
			elseif TimerObj.Type ~= "timer" then
				error("TimerObj: Expecting timer, got "..tostring(TimerObj.Type))
			end
			table.insert(self.Timers, TimerObj)
			if not KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = 1
			else
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = KBM.Trigger.Max.Timers[self.Unit.Mod.ID] + 1
			end
			if KBM.Trigger.High.Timers < KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.High.Timers = KBM.Trigger.Max.Timers[self.Unit.Mod.ID]
			end
		end
		
		function TriggerObj:AddTimerSeq(TimerObj, Player)
			if not TimerObj then
				error("Timer object does not exist!")
			end
			if type(TimerObj) ~= "table" then
				error("TimerObj: Expecting Table, got "..tostring(type(TimerObj)))
			elseif TimerObj.Type ~= "timer" then
				error("TimerObj: Expecting timer, got "..tostring(TimerObj.Type))
			end
			table.insert(self.Seq.Timers, TimerObj)
			self.Seq.TotalTimers = self.Seq.TotalTimers + 1
			if not KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = 1
			else
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = KBM.Trigger.Max.Timers[self.Unit.Mod.ID] + 1
			end
			if KBM.Trigger.High.Timers < KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.High.Timers = KBM.Trigger.Max.Timers[self.Unit.Mod.ID]
			end
			if not KBM.Trigger.Seq[self.Unit.Mod.ID] then
				KBM.Trigger.Seq[self.Unit.Mod.ID] = {}
			end
			if not self.Seq.Stored then
				table.insert(KBM.Trigger.Seq[self.Unit.Mod.ID], self)
				self.Seq.Stored = true
			end
		end
		
		function TriggerObj:AddSpy(SpyObj)
			if not SpyObj then
				error("Mechanic Spy object does not exist!")
			end
			if type(SpyObj) ~= "table" then
				error("SpyObj: Expecting Table, got "..tostring(type(SpyObj)))
			elseif SpyObj.Type ~= "spy" then
				error("SpyObj: Expecting Mechanic Spy, go "..tostring(SpyObj.Type))
			end
			table.insert(self.Spies, SpyObj)
		end
		
		function TriggerObj:AddAlert(AlertObj, Player)
			if not AlertObj then
				error("Alert Object does not exist!")
			end
			if type(AlertObj) ~= "table" then
				error("AlertObj: Expecting Table, got "..tostring(type(AlertObj)))
			elseif AlertObj.Type ~= "alert" then
				error("AlertObj: Expecting alert, got "..tostring(AlertObj.Type))
			end
			AlertObj.Player = Player
			table.insert(self.Alerts, AlertObj)
		end
		
		function TriggerObj:AddAlertSeq(AlertObj, Player)
			if not AlertObj then
				error("Alert Object does not exist!")
			end
			if type(AlertObj) ~= "table" then
				error("AlertObj: Expecting Table, got "..tostring(type(AlertObj)))
			elseif AlertObj.Type ~= "alert" then
				error("AlertObj: Expecting alert, got "..tostring(AlertObj.Type))
			end
			AlertObj.Player = Player
			table.insert(self.Seq.Alerts, AlertObj)
			self.Seq.TotalAlerts = self.Seq.TotalAlerts + 1
			if not KBM.Trigger.Seq[self.Unit.Mod.ID] then
				KBM.Trigger.Seq[self.Unit.Mod.ID] = {}
			end
			if not self.Seq.Stored then
				table.insert(KBM.Trigger.Seq[self.Unit.Mod.ID], self)
				self.Seq.Stored = true
			end
		end
		
		function TriggerObj:AddPhase(PhaseObj)
			if not PhaseObj then
				error("Phase Object does not exist!")
			end
			self.Phase = PhaseObj 
		end
		
		function TriggerObj:AddStart(Mod)
			self.ModStart = Mod
		end
		
		function TriggerObj:SetVictory()
			self.Victory = true
		end
		
		function TriggerObj:ResetSeq()
			self.Seq.CurrentTimer = 1
			self.Seq.CurrentAlert = 1
		end
		
		function TriggerObj:ResetAlertSeq()
			self.Seq.CurrentAlert = 1
		end
		
		function TriggerObj:ResetTimerSeq()
			self.Seq.CurrentTimer = 1
		end
		
		function TriggerObj:AddStop(Object, Player)
			if type(Object) ~= "table" then
				error("Expecting at least table: Got "..tostring(type(Object)))
			elseif Object.Type ~= "timer" and Object.Type ~= "alert" and Object.Type ~= "spy" then
				error("Expecting at least timer, alert or spy: Got "..tostring(Object.Type))
			end
			table.insert(self.Stop, Object)
		end
		
		function TriggerObj:Activate(Caster, Target, Data)
			local Triggered = false
			local current = Inspect.Time.Real()
			if self.Victory == true then
				KBM:Victory()
				return
			end
			if self.Type == "damage" then
				for i, Timer in ipairs(self.Timers) do
					if Timer.Active then
						if current - self.LastTrigger > KBM.Idle.Trigger.Duration then
							Timer:Queue(Data)
							Triggered = true
						end
					else
						Timer:Queue(Data)
						Triggered = true
					end
				end
				if self.Seq.TotalTimers > 0 then
					local Timer = self.Seq.Timers[self.Seq.CurrentTimer]
					if Timer.Active then
						if current - self.LastTrigger > KBM.Idle.Trigger.Duration then
							Timer:Queue(Data)
							Triggered = true
							self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
							if self.Seq.CurrentTimer > self.Seq.TotalTimers then
								self.Seq.CurrentTimer = 1
							end
						end
					else
						Timer:Queue(Data)
						Triggered = true
						self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
						if self.Seq.CurrentTimer > self.Seq.TotalTimers then
							self.Seq.CurrentTimer = 1
						end
					end
				end
			else
				for i, Timer in ipairs(self.Timers) do
					Timer:Queue(Data)
					Triggered = true
				end
				if self.Seq.TotalTimers > 0 then
					local Timer = self.Seq.Timers[self.Seq.CurrentTimer]
					if Timer.Active then
						if current - self.LastTrigger > KBM.Idle.Trigger.Duration then
							Timer:Queue(Data)
							Triggered = true
							self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
							if self.Seq.CurrentTimer > self.Seq.TotalTimers then
								self.Seq.CurrentTimer = 1
							end
						end
					else
						Timer:Queue(Data)
						Triggered = true
						self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
						if self.Seq.CurrentTimer > self.Seq.TotalTimers then
							self.Seq.CurrentTimer = 1
						end
					end
				end
			end
			for i, SpyObj in ipairs(self.Spies) do
				if SpyObj.Source then
					if self.Caster then
						if LibSUnit.Lookup.UID[self.Caster] then
							SpyObj:Start(LibSUnit.Lookup.UID[self.Caster].Name, Data)
						end
					end
				else
					for UID, bool in pairs(self.Target) do
						if LibSUnit.Lookup.UID[UID] then
							SpyObj:Start(LibSUnit.Lookup.UID[UID].Name, Data)
						end
					end
				end
			end
			
			for i, AlertObj in ipairs(self.Alerts) do
				if AlertObj.Player then
					if self.Target[LibSUnit.Player.UnitID] then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
						Triggered = true
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					Triggered = true
				end
			end
			
			if self.Seq.TotalAlerts > 0 then
				local AlertObj = self.Seq.Alerts[self.Seq.CurrentAlert]
				if AlertObj.Player then
					if self.Target[LibSUnit.Player.UnitID] then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
						Triggered = true
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					Triggered = true
				end
				self.Seq.CurrentAlert = self.Seq.CurrentAlert + 1
				if self.Seq.CurrentAlert > self.Seq.TotalAlerts then
					self.Seq.CurrentAlert = 1
				end
			end
			
			for i, Obj in ipairs(self.Stop) do
				if Obj.Type == "timer" then
					KBM.MechTimer:AddRemove(Obj)
					Triggered = true
				elseif Obj.Type == "alert" then
					KBM.Alert:Stop(Obj)
					Triggered = true
				elseif Obj.Type == "spy" then
					if self.Type == "death" then
						Obj:Stop()
					else
						if self.Source then
							if LibSUnit.Lookup.UID[self.Caster] then
								Obj:Stop(LibSUnit.Lookup.UID[self.Caster].Name)
							end
						else
							for UID, bool in pairs(self.Target) do
								if LibSUnit.Lookup.UID[UID] then
									Obj:Stop(LibSUnit.Lookup.UID[UID].Name)
								end
							end
						end
					end
				end
			end
			
			if self.Extended == "CustomBuffRemove" then
				if self.Phase then
					self.Phase(Data, Target)
					Triggered = true
				end
			else
				if KBM.Encounter then
					if self.Phase then
						self.Phase(self.Type)
						Triggered = true
					end
				end
			end
			
			if Triggered then
				self.LastTrigger = current
				self.Target = {}
			end
		end
		
		if not NonEncounter then
			if Type == "notify" then
				TriggerObj.Phrase = Trigger
				if not self.Notify[Unit.Mod.ID] then
					self.Notify[Unit.Mod.ID] = {}
				end
				table.insert(self.Notify[Unit.Mod.ID], TriggerObj)
			elseif Type == "say" then
				TriggerObj.Phrase = Trigger
				if not self.Say[Unit.Mod.ID] then
					self.Say[Unit.Mod.ID] = {}
				end
				table.insert(self.Say[Unit.Mod.ID], TriggerObj)
			elseif Type == "npcDamage" then
				if not self.NpcDamage[Unit.Mod.ID] then
					self.NpcDamage[Unit.Mod.ID] = {}
				end
				self.NpcDamage[Unit.Mod.ID][Unit.Name] = TriggerObj
			elseif Type == "damage" then
				self.Damage[Trigger] = TriggerObj
			elseif Type == "cast" then
				if not self.Cast[Unit.Mod.ID] then
					self.Cast[Unit.Mod.ID] = {}
				end
				if not self.Cast[Unit.Mod.ID][Unit.Name] then
					self.Cast[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Cast[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "castID" then
				if not self.CastID[Unit.Mod.ID] then
					self.CastID[Unit.Mod.ID] = {}
				end
				if not self.CastID[Unit.Mod.ID][Unit.Name] then
					self.CastID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.CastID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalCast" then
				if not self.PersonalCast[Unit.Mod.ID] then
					self.PersonalCast[Unit.Mod.ID] = {}
				end
				if not self.PersonalCast[Unit.Mod.ID][Unit.Name] then
					self.PersonalCast[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalCast[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalCastID" then
				if not self.PersonalCastID[Unit.Mod.ID] then
					self.PersonalCastID[Unit.Mod.ID] = {}
				end
				if not self.PersonalCastID[Unit.Mod.ID][Unit.Name] then
					self.PersonalCastID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalCastID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "channel" then
				if not self.Channel[Unit.Mod.ID] then
					self.Channel[Unit.Mod.ID] = {}
				end
				if not self.Channel[Unit.Mod.ID][Unit.Name] then
					self.Channel[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Channel[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "channelID" then
				if not self.ChannelID[Unit.Mod.ID] then
					self.ChannelID[Unit.Mod.ID] = {}
				end
				if not self.ChannelID[Unit.Mod.ID][Unit.Name] then
					self.ChannelID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.ChannelID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalChannel" then
				if not self.PersonalChannel[Unit.Mod.ID] then
					self.PersonalChannel[Unit.Mod.ID] = {}
				end
				if not self.PersonalChannel[Unit.Mod.ID][Unit.Name] then
					self.PersonalChannel[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalChannel[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalChannelID" then
				if not self.PersonalChannelID[Unit.Mod.ID] then
					self.PersonalChannelID[Unit.Mod.ID] = {}
				end
				if not self.PersonalChannelID[Unit.Mod.ID][Unit.Name] then
					self.PersonalChannelID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalChannelID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj			
			elseif Type == "interrupt" then
				if not self.Interrupt[Unit.Mod.ID] then
					self.Interrupt[Unit.Mod.ID] = {}
				end
				if not self.Interrupt[Unit.Mod.ID][Unit.Name] then
					self.Interrupt[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Interrupt[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "interruptID" then
				if not self.InterruptID[Unit.Mod.ID] then
					self.InterruptID[Unit.Mod.ID] = {}
				end
				if not self.InterruptID[Unit.Mod.ID][Unit.Name] then
					self.InterruptID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Interrupt[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalInterrupt" then
				if not self.PersonalInterrupt[Unit.Mod.ID] then
					self.PersonalInterrupt[Unit.Mod.ID] = {}
				end
				if not self.PersonalInterrupt[Unit.Mod.ID][Unit.Name] then
					self.PersonalInterrupt[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalInterrupt[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalInterruptID" then
				if not self.PersonalInterruptID[Unit.Mod.ID] then
					self.PersonalInterruptID[Unit.Mod.ID] = {}
				end
				if not self.PersonalInterruptID[Unit.Mod.ID][Unit.Name] then
					self.PersonalInterruptID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalInterruptID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "percent" then
				if not self.Percent[Unit.Mod.ID] then
					self.Percent[Unit.Mod.ID] = {}
				end
				if not self.Percent[Unit.Mod.ID][Unit.Name] then
					self.Percent[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Percent[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "combat" then
				self.Combat[Trigger] = TriggerObj
			elseif Type == "start" then
				if not self.Start[Unit.Mod.ID] then
					self.Start[Unit.Mod.ID] = {}
				end
				table.insert(self.Start[Unit.Mod.ID], TriggerObj)
			elseif Type == "death" then
				if not self.Death[Unit.Mod.ID] then
					self.Death[Unit.Mod.ID] = {}
				end
				self.Death[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "buff" then
				if not self.Buff[Unit.Mod.ID] then
					self.Buff[Unit.Mod.ID] = {}
				end
				if not self.Buff[Unit.Mod.ID][Trigger] then
					self.Buff[Unit.Mod.ID][Trigger] = {}
				end
				self.Buff[Unit.Mod.ID][Trigger][Unit.Name] = TriggerObj
			elseif Type == "buffRemove" then
				if not self.BuffRemove[Unit.Mod.ID] then
					self.BuffRemove[Unit.Mod.ID] = {}
				end
				if not self.BuffRemove[Unit.Mod.ID][Trigger] then
					self.BuffRemove[Unit.Mod.ID][Trigger] = {}
				end
				self.BuffRemove[Unit.Mod.ID][Trigger][Unit.Name] = TriggerObj
			elseif Type == "playerBuff" or Type == "playerDebuff" then
				if not self.PlayerBuff[Unit.Mod.ID] then
					self.PlayerBuff[Unit.Mod.ID] = {}
				end
				self.PlayerBuff[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "playerBuffRemove" then
				if not self.PlayerBuffRemove[Unit.Mod.ID] then
					self.PlayerBuffRemove[Unit.Mod.ID] = {}
				end
				self.PlayerBuffRemove[Unit.Mod.ID][Trigger] = TriggerObj
			-- elseif Type == "playerDebuff" then
				-- if not self.PlayerDebuff[Unit.Mod.ID] then
					-- self.PlayerDebuff[Unit.Mod.ID] = {}
				-- end
				-- self.PlayerDebuff[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "playerIDBuff" then
				if not self.PlayerIDBuff[Unit.Mod.ID] then
					self.PlayerIDBuff[Unit.Mod.ID] = {}
				end
				self.PlayerIDBuff[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "playerIDBuffRemove" then
				if not self.PlayerIDBuffRemove[Unit.Mod.ID] then
					self.PlayerIDBuffRemove[Unit.Mod.ID] = {}
				end
				self.PlayerIDBuffRemove[Unit.Mod.ID][Trigger] = TriggerObj			
			elseif Type == "time" then
				if not self.Time[Unit.Mod.ID] then
					self.Time[Unit.Mod.ID] = {}
				end
				self.Time[Unit.Mod.ID][Trigger] = TriggerObj
			else
				error("Unknown trigger type: "..tostring(Type))
			end
		else
			if not self[NonEncounter][Type] then
				self[NonEncounter][Type] = {}
			end
			if NonEncounter == "EncStart" then
				self[NonEncounter][Type][Trigger] = Unit.Mod
			elseif NonEncounter == "CustomBuffRemove" then
				self[NonEncounter][Type][Trigger] = TriggerObj
				KBM.Buffs.WatchID[Trigger] = true
			end
		end
		
		table.insert(self.List, TriggerObj)
		return TriggerObj		
	end
	
	function self:Unload()
		self.Notify = {}
		self.Say = {}
		self.Damage = {}
		self.Cast = {}
		self.Percent = {}
		self.Combat = {}
		self.Start = {}
		self.Death = {}
		self.Buff = {}		
	end
end

local function KBM_Options()
	if KBM.Menu.Active then
		KBM.Menu:Close()
	else
		KBM.Menu:Open()
	end	
end

function KBM.Button:Init()
	KBM.Button.Texture = UI.CreateFrame("Texture", "Button Texture", KBM.Context)
	KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button.png")
	KBM.Button.Texture:SetWidth(KBM.Constant.Button.s)
	KBM.Button.Texture:SetHeight(KBM.Button.Texture:GetWidth())
	KBM.Button.Highlight = UI.CreateFrame("Texture", "Button Texture Highlight", KBM.Context)
	KBM.LoadTexture(KBM.Button.Highlight, "KingMolinator", "Media/New_Options_Button_Over.png")
	KBM.Button.Highlight:SetPoint("TOPLEFT", KBM.Button.Texture, "TOPLEFT")
	KBM.Button.Highlight:SetPoint("BOTTOMRIGHT", KBM.Button.Texture, "BOTTOMRIGHT")
	KBM.Button.Highlight:SetVisible(false)
	
	function self:ApplySettings()
		self.Texture:ClearPoint("CENTER")
		self.Texture:ClearPoint("TOPLEFT")
		if not KBM.Options.Button.x then
			self.Texture:SetPoint("CENTER", UIParent, "CENTER")
		else
			self.Texture:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Button.x, KBM.Options.Button.y)
		end
		self.Texture:SetLayer(5)
		self.Highlight:SetLayer(6)
		self.Texture:SetVisible(KBM.Options.Button.Visible)
	end
	
	function self:UpdateMove(uType)
		if uType == "end" then
			KBM.Options.Button.x = self.Texture:GetLeft()
			KBM.Options.Button.y = self.Texture:GetTop()
		end	
	end
	function self:MouseInHandler()
		KBM.Button.Highlight:SetVisible(true)
	end
	function self:MouseOutHandler()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button.png")
		KBM.Button.Highlight:SetVisible(false)
	end
	function self:LeftDownHandler()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button_Down.png")
		KBM.Button.Highlight:SetVisible(false)
	end
	function self:LeftUpHandler()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button.png")
		KBM.Button.Highlight:SetVisible(true)
	end
	function self:LeftClickHandler()
		KBM_Options()
	end

	function self:SetUnlocked(bool)
		if bool then
			self.Drag:EventAttach(Event.UI.Input.Mouse.Right.Down, self.Drag.FrameEvents.LeftDownHandler, "KBM Main Button Right Down")
			self.Drag:EventAttach(Event.UI.Input.Mouse.Right.Up, self.Drag.FrameEvents.LeftUpHandler, "KBM Main Button Right Up")
		else
			self.Drag:EventDetach(Event.UI.Input.Mouse.Right.Down, self.Drag.FrameEvents.LeftDownHandler)
			self.Drag:EventDetach(Event.UI.Input.Mouse.Right.Up, self.Drag.FrameEvents.LeftUpHandler)		
		end
	end
	
	self.Drag = KBM.AttachDragFrame(self.Texture, function (uType) self:UpdateMove(uType) end, "Button Drag", 6)
	self.Drag:EventDetach(Event.UI.Input.Mouse.Left.Down, self.Drag.FrameEvents.LeftDownHandler)
	self.Drag:EventDetach(Event.UI.Input.Mouse.Left.Up, self.Drag.FrameEvents.LeftUpHandler)
	self.Drag:EventAttach(Event.UI.Input.Mouse.Cursor.In, self.MouseInHandler, "KBM Main Button Mouse In")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Cursor.Out, self.MouseOutHandler, "KBM Main Button Mouse Out")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Down, self.LeftDownHandler, "KBM Main Button Left Down")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Up, self.LeftUpHandler, "KBM Main Button Left Up")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Click, self.LeftClickHandler, "KBM Main Button Left Click")
	self.Drag:SetMouseMasking("limited")
	
	if KBM.Options.Button.Unlocked then
		self:SetUnlocked(true)
	end
		
	self:ApplySettings()
	
end

function KBM.Chat:Init()
	self.Enabled = true
end

function KBM.Chat:Create(Text)
	local ChatObj = {}
	ChatObj.Text = Text
	ChatObj.Enabled = true
	ChatObj.Color = "yellow"
	ChatObj.HasMenu = true
	ChatObj.Custom = false
	ChatObj.Html = false
	function self:Display(ChatObj)
		if ChatObj.Enabled then
			Command.Console.Display("general", false, tostring(ChatObj.Text), ChatObj.Html)
		end
	end
	return ChatObj
end

function KBM.Chat.Out(Text, Html, prefix)
	prefix = prefix or false
	Html = Html or false
	Command.Console.Display("general", prefix, Text, Html)
end

function KBM.MechSpy:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Spy_Frame", KBM.Context)
		GUI.Background:SetHeight(self.Anchor:GetHeight())
		GUI.Background:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.TimeBar = UI.CreateFrame("Frame", "Spy_Progress_Frame", GUI.Background)
		GUI.TimeBar:SetWidth(self.Anchor:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Spy_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(self.Anchor.Text:GetFontSize())
		GUI.Shadow:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Text = UI.CreateFrame("Text", "Spy_Text_Frame", GUI.Shadow)
		GUI.Text:SetFontSize(self.Anchor.Text:GetFontSize())
		GUI.Text:SetPoint("TOPLEFT", GUI.Shadow, "TOPLEFT", -1, -1)
		GUI.Text:SetLayer(3)
		GUI.Text:SetFontColor(1,1,1)
		GUI.Text:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Spy_Skin", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.Constant.MechSpy.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
		function GUI:SetText(Text)
			self.Text:SetText(Text)
			self.Shadow:SetText(Text)
		end
	end
	return GUI
end

function KBM.MechSpy:PullHeader()
	local GUI = {}
	if #self.HeaderStore > 0 then
		GUI = table.remove(self.HeaderStore)
	else
		GUI.Background = UI.CreateFrame("Frame", "Spy_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Background:SetHeight(self.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.Background:SetLayer(6)
		GUI.Cradle = UI.CreateFrame("Frame", "Spy_Cradle", GUI.Background)
		GUI.Cradle:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Cradle:SetPoint("RIGHT", GUI.Background, "RIGHT")
		GUI.Cradle:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.Texture = UI.CreateFrame("Texture", "MechSpy_Header_Texture", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/MSpy_Texture.png")
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(1)
		GUI.Shadow = UI.CreateFrame("Text", "Mechanic_Spy_Header_Shadow", GUI.Background)
		GUI.Shadow:SetText("")
		GUI.Shadow:SetPoint("CENTERRIGHT", GUI.Background, "CENTERRIGHT", -1, 1)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetLayer(2)
		GUI.Text = UI.CreateFrame("Text", "Mechanic_Spy_Header_Text", GUI.Shadow)
		GUI.Text:SetText("")
		GUI.Text:SetPoint("TOPRIGHT", GUI.Shadow, "TOPRIGHT", -1, -1)
		GUI.Text:SetLayer(3)
		function GUI:SetText(Text)
			self.Text:SetText(Text)
			self.Shadow:SetText(Text)
		end
		function GUI:SetColor(R, G, B, A)
			GUI.Texture:SetBackgroundColor(R, G, B, A)		
		end
	end
	return GUI
end

function KBM.MechSpy:ApplySettings()
	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(math.floor(KBM.Constant.MechSpy.w * self.Settings.wScale))
	self.Anchor:SetHeight(math.floor(KBM.Constant.MechSpy.h * self.Settings.hScale))
	self.Anchor.Text:SetFontSize(math.floor(KBM.Constant.MechSpy.TextSize * self.Settings.tScale))
	self.Anchor.Shadow:SetFontSize(self.Anchor.Text:GetFontSize())
	if KBM.Menu.Active then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Visible)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
end

function KBM.MechSpy:Init()
	self.List = {
		Mod = {},
		Active = {},
	}
	self.Active = false
	self.Last = nil
	self.StopTimers = {}
	self.Store = {}
	self.HeaderStore = {}
	self.Settings = KBM.Options.MechSpy
	self.Anchor = UI.CreateFrame("Frame", "MechSpy_Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Texture = UI.CreateFrame("Texture", "MechSpy_Anchor_Texture", self.Anchor)
	KBM.LoadTexture(self.Texture, "KingMolinator", "Media/MSpy_Texture.png")
	self.Texture:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
	self.Texture:SetPoint("BOTTOMRIGHT", self.Anchor, "BOTTOMRIGHT")
	self.Texture:SetLayer(1)
	self.Texture:SetBackgroundColor(1,0,0,0.33)
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.MechSpy.Settings.x = self:GetLeft()
			KBM.MechSpy.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Shadow = UI.CreateFrame("Text", "Mechanic_Spy_Anchor_Shadow", self.Anchor)
	self.Anchor.Shadow:SetText(KBM.Language.Anchors.MechSpy[KBM.Lang])
	self.Anchor.Shadow:SetPoint("CENTERRIGHT", self.Anchor, "CENTERRIGHT", -1, 1)
	self.Anchor.Shadow:SetFontColor(0,0,0)
	self.Anchor.Shadow:SetLayer(2)
	self.Anchor.Text = UI.CreateFrame("Text", "Mechanic_Spy_Anchor_Text", self.Anchor.Shadow)
	self.Anchor.Text:SetText(KBM.Language.Anchors.MechSpy[KBM.Lang])
	self.Anchor.Text:SetPoint("TOPRIGHT", self.Anchor.Shadow, "TOPRIGHT", -1, -1)
	self.Anchor.Text:SetLayer(3)
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.MechSpy.Settings.ScaleWidth then
			if KBM.MechSpy.Settings.wScale < 1.5 then
				KBM.MechSpy.Settings.wScale = KBM.MechSpy.Settings.wScale + 0.025
				if KBM.MechSpy.Settings.wScale > 1.5 then
					KBM.MechSpy.Settings.wScale = 1.5
				end
				KBM.MechSpy.Anchor:SetWidth(math.floor(KBM.MechSpy.Settings.wScale * KBM.Constant.TankSwap.w))
			end
		end
		
		if KBM.MechSpy.Settings.ScaleHeight then
			if KBM.MechSpy.Settings.hScale < 1.5 then
				KBM.MechSpy.Settings.hScale = KBM.MechSpy.Settings.hScale + 0.025
				if KBM.MechSpy.Settings.hScale > 1.5 then
					KBM.MechSpy.Settings.hScale = 1.5
				end
				KBM.MechSpy.Anchor:SetHeight(math.floor(KBM.MechSpy.Settings.hScale * KBM.Constant.MechSpy.h))
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
							end
						end
					end
				end
			end
		end
		
		if KBM.MechSpy.Settings.ScaleText then
			if KBM.MechSpy.Settings.tScale < 1.5 then
				KBM.MechSpy.Settings.tScale = KBM.MechSpy.Settings.tScale + 0.025
				if KBM.MechSpy.Settings.tScale > 1.5 then
					KBM.MechSpy.Settings.tScale = 1.5
				end
				KBM.MechSpy.Anchor.Text:SetFontSize(math.floor(KBM.Constant.MechSpy.TextSize * KBM.MechSpy.Settings.tScale))
				KBM.MechSpy.Anchor.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						Mechanic.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
								Timer.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
							end
						end
					end
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if KBM.MechSpy.Settings.ScaleWidth then
			if KBM.MechSpy.Settings.wScale > 0.5 then
				KBM.MechSpy.Settings.wScale = KBM.MechSpy.Settings.wScale - 0.025
				if KBM.MechSpy.Settings.wScale < 0.5 then
					KBM.MechSpy.Settings.wScale = 0.5
				end
				KBM.MechSpy.Anchor:SetWidth(math.floor(KBM.MechSpy.Settings.wScale * KBM.Constant.MechSpy.w))
			end
		end
		
		if KBM.MechSpy.Settings.ScaleHeight then
			if KBM.MechSpy.Settings.hScale > 0.5 then
				KBM.MechSpy.Settings.hScale = KBM.MechSpy.Settings.hScale - 0.025
				if KBM.MechSpy.Settings.hScale < 0.5 then
					KBM.MechSpy.Settings.hScale = 0.5
				end
				KBM.MechSpy.Anchor:SetHeight(math.floor(KBM.MechSpy.Settings.hScale * KBM.Constant.MechSpy.h))
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
							end
						end
					end
				end
			end
		end
		
		if KBM.MechSpy.Settings.ScaleText then
			if KBM.MechSpy.Settings.tScale > 0.5 then
				KBM.MechSpy.Settings.tScale = KBM.MechSpy.Settings.tScale - 0.025
				if KBM.MechSpy.Settings.tScale < 0.5 then
					KBM.MechSpy.Settings.tScale = 0.5
				end
				KBM.MechSpy.Anchor.Text:SetFontSize(math.floor(KBM.MechSpy.Settings.tScale * KBM.Constant.MechSpy.TextSize))
				KBM.MechSpy.Anchor.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						Mechanic.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
								Timer.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
							end
						end
					end
				end
			end
		end
	end
	self:ApplySettings()
	
	function self:Begin()
		if self.Settings.Enabled then
			self.Active = true
			for Name, BossObj in pairs(KBM.CurrentMod.Bosses) do
				if BossObj.MechRef then
					for ID, SpyObj in pairs(BossObj.MechRef) do
						SpyObj:Begin()
					end
				end
			end
		end
	end
	
	function self:Update(CurrentTime)
		if self.Active then
			for i, SpyObj in ipairs(self.List.Active) do
				for Name, TimerObj in pairs(SpyObj.Timers) do
					TimerObj:Update(CurrentTime)
				end
				for i, TimerObj in ipairs(SpyObj.StopTimers) do
					TimerObj:Stop()
				end
				SpyObj.StopTimers = {}
			end
		end
	end
	
	function self:End()
		self.Active = false
		for i, SpyObj in ipairs(self.List.Active) do
			SpyObj.StopTimers = {}
			SpyObj:End()
		end
		self.List.Active = {}
	end	
	
end

function KBM.MechSpy:Add(Name, Duration, Type, BossObj)

	local Mechanic = {}
	Mechanic.Active = false
	Mechanic.Visible = false
	Mechanic.Timers = {}
	Mechanic.StopTimers = {}
	Mechanic.Names = {}
	Mechanic.Removing = false
	Mechanic.Boss = BossObj
	Mechanic.Starting = false
	Mechanic.RemoveCount = 0
	Mechanic.StartCount = 0
	if not Duration then
		Mechanic.Time = 2
		Mechanic.Dynamic = true
		Mechanic.Duration = 2
	else
		Mechanic.Time = Duration
		Mechanic.Dynamic = false
		Mechanic.Duration = Duration
		if Duration == -1 then
			Mechanic.Static = true
		end
	end
	Mechanic.Enabled = true
	Mechanic.Name = Name
	Mechanic.Phase = 0
	Mechanic.PhaseMax = 0
	Mechanic.Type = "spy"
	Mechanic.Source = false
	Mechanic.Custom = false
	Mechanic.HasMenu = true
	Mechanic.Color = KBM.MechSpy.Settings.Color
	if type(Name) ~= "string" then
		error("Expecting String for Name, got "..type(Name))
	end
	
	function Mechanic:Show()
		if not self.Visible then
			if not KBM.MechSpy.FirstHeader then
				KBM.MechSpy.FirstHeader = self
				KBM.MechSpy.LastHeader = self
				self.HeaderBefore = nil
				self.HeaderAfter = nil
				self.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
			else
				self.HeaderBefore = KBM.MechSpy.LastHeader
				self.HeaderBefore.HeaderAfter = self
				self.HeaderAfter = nil
				KBM.MechSpy.LastHeader = self
				self.GUI.Background:SetPoint("TOP", self.HeaderBefore.GUI.Cradle, "BOTTOM")
			end
			self.Visible = true
		end
		self.GUI.Background:SetVisible(true)
	end
	
	function Mechanic:SetSource()
		self.Source = true
	end
	
	function Mechanic:Hide()
		self.GUI.Background:SetVisible(false)
		if self.Visible then
			if KBM.MechSpy.FirstHeader == self then
				KBM.MechSpy.FirstHeader = self.HeaderAfter
				if self.HeaderAfter then
					self.HeaderAfter.HeaderBefore = nil
					self.HeaderAfter.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
				end
			elseif KBM.MechSpy.LastHeader == self then
				KBM.MechSpy.LastHeader = self.HeaderBefore
				if self.HeaderBefore then
					self.HeaderBefore.HeaderAfter = nil
				end
			else
				self.HeaderBefore.HeaderAfter = self.HeaderAfter
				self.HeaderAfter.HeaderBefore = self.HeaderBefore
				self.HeaderAfter.GUI.Background:SetPoint("TOP", self.HeaderBefore.GUI.Cradle, "BOTTOM")
			end
			self.HeaderBefore = nil
			self.HeaderAfter = nil
			self.GUI.Cradle:SetPoint("BOTTOM", self.GUI.Background, "BOTTOM")
			self.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
			self.Visible = false
		end
	end
	
	function Mechanic:Begin()
		if KBM.MechSpy.Settings.Enabled then
			self.Active = true
			self.Visible = false
			self.GUI = KBM.MechSpy:PullHeader()
			if self.Settings then
				if self.Settings.Custom then
					self.GUI:SetColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
				else
					self.GUI:SetColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
				end
			else
				self.GUI:SetColor(KBM.Colors.List[KBM.MechSpy.Settings.Color].Red, KBM.Colors.List[KBM.MechSpy.Settings.Color].Green, KBM.Colors.List[KBM.MechSpy.Settings.Color].Blue, 0.33)
			end
			self.GUI:SetText(self.Name)
			table.insert(KBM.MechSpy.List.Active, self)
			if KBM.MechSpy.Settings.Show then
				self:Show()
			else
				self:Hide()
			end
		end
	end
	
	function Mechanic:End()
		self.Active = false
		for Name, Timer in pairs(self.Names) do
			Timer:Stop()
		end
		self.Timers = {}
		self:Hide()
		table.insert(KBM.MechSpy.HeaderStore, self.GUI)
		self.GUI = nil
	end
	
	function Mechanic:SpyAfter(SpyObj)
		if not self.SpyAfterList then
			self.SpyAfterList = {}
		end
		table.insert(self.SpyAfterList, SpyObj)
	end
	
	function Mechanic:Stop(Name)
		if Name then
			if self.Names[Name] then
				if KBM.Debug then
					print("Mechanic Spy stopping: "..Name)
				end
				self.Names[Name]:Stop()
			end
		else
			for Name, Timer in pairs(self.Names) do
				Timer:Stop()
			end
		end
	end
		
	function Mechanic:Start(Name, Duration)
		if KBM.Debug then
			print("Mechanic Spy Called")
		end
		if KBM.Encounter then
			if KBM.MechSpy.Settings.Enabled then
				if self.Enabled == true and type(Name) == "string" then
					if KBM.Debug then
						print("Mechanic Spy launching Timer: "..Name)
					end
					if self.Names[Name] then
						self.Names[Name]:Stop()
					end
					local CurrentTime = Inspect.Time.Real()
					local Anchor = self.GUI.Background
					if not self.Visible then
						self:Show()
					end
					Timer = {}
					Timer.Name = Name
					Timer.GUI = KBM.MechSpy:Pull()
					Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
					Timer.TimeStart = CurrentTime
					if self.Static then
						Duration = 0
						Timer.Time = 0
						Timer.Static = true
						Timer.GUI.TimeBar:SetWidth(math.ceil(Timer.GUI.Background:GetWidth()))
					else
						Timer.Static = false
						if not self.Dynamic then
							Duration = self.Duration
							Timer.Time = self.Time
						else
							if Duration == nil or Duration < 1 then
								Duration = self.Duration
							end
							Timer.Time = Duration
						end
					end
					Timer.Remaining = Duration
					Timer.GUI:SetText(string.format(" %0.01f : ", Timer.Remaining)..Timer.Name)
								
					if self.Settings then
						if self.Settings.Custom then
							Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
						else
							Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
						end
					else
						Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[KBM.MechSpy.Settings.Color].Red, KBM.Colors.List[KBM.MechSpy.Settings.Color].Green, KBM.Colors.List[KBM.MechSpy.Settings.Color].Blue, 0.33)
					end
					
					if #self.Timers > 0 then
						for i, cTimer in ipairs(self.Timers) do
							if Timer.Remaining < cTimer.Remaining then
								Timer.Active = true
								if i == 1 then
									Timer.GUI.Background:SetPoint("TOP", self.GUI.Background, "BOTTOM", nil, 1)
									cTimer.GUI.Background:SetPoint("TOP", Timer.GUI.Background, "BOTTOM", nil, 1)
									self.FirstTimer = Timer
								else
									Timer.GUI.Background:SetPoint("TOP", self.Timers[i-1].GUI.Background, "BOTTOM", nil, 1)
									cTimer.GUI.Background:SetPoint("TOP", Timer.GUI.Background, "BOTTOM", nil, 1)
								end
								table.insert(self.Timers, i, Timer)
								break
							end
						end
						if not Timer.Active then
							Timer.GUI.Background:SetPoint("TOP", self.LastTimer.GUI.Background, "BOTTOM", nil, 1)
							table.insert(self.Timers, Timer)
							self.LastTimer = Timer
							Timer.Active = true
						end
					else
						Timer.GUI.Background:SetPoint("TOP", self.GUI.Background, "BOTTOM", nil, 1)
						table.insert(self.Timers, Timer)
						Timer.Active = true
						self.LastTimer = Timer
						self.FirstTimer = Timer
					end
					self.Names[Name] = Timer
					Timer.GUI.Background:SetVisible(true)
					Timer.Starting = false
					Timer.Parent = self
					self.GUI.Cradle:SetPoint("BOTTOM", self.LastTimer.GUI.Background, "BOTTOM")
					function Timer:Stop()
						if not self.Deleting then
							if self.Active then
								self.Active = false
								self.Deleting = true
								self.GUI.Background:SetVisible(false)
								for i, Timer in ipairs(self.Parent.Timers) do
									if Timer == self then
										if #self.Parent.Timers == 1 then
											self.Parent.LastTimer = nil
											self.Parent.GUI.Cradle:SetPoint("BOTTOM", self.Parent.GUI.Background, "BOTTOM")
											if not KBM.MechSpy.Settings.Show then
												self.Parent:Hide()
											end
										elseif i == 1 then
											self.Parent.Timers[i+1].GUI.Background:SetPoint("TOP", self.Parent.GUI.Background, "BOTTOM", nil, 1)
										elseif i == #self.Parent.Timers then
											self.Parent.LastTimer = self.Parent.Timers[i-1]
											self.Parent.GUI.Cradle:SetPoint("BOTTOM", self.Parent.LastTimer.GUI.Background, "BOTTOM")
										else
											self.Parent.Timers[i+1].GUI.Background:SetPoint("TOP", self.Parent.Timers[i-1].GUI.Background, "BOTTOM", nil, 1)
										end
										table.remove(self.Parent.Timers, i)
										break
									end
								end
								table.insert(KBM.MechSpy.Store, self.GUI)
								self.Remaining = 0
								self.TimeStart = 0
								self.GUI = nil
								self.Removing = false
								self.Deleting = false
								self.Parent.Names[self.Name] = nil
								if KBM.Encounter then
									if self.Parent.SpyAfterList then
										for i, SpyObj in ipairs(self.Parent.SpyAfterList) do
											SpyObj:Start(self.Name)
										end
									end
								end
							end
						end
					end
					function Timer:Update(CurrentTime)
						local text = ""
						if self.Active then
							if self.Waiting then
							
							else
								if self.Static == false then
									self.Remaining = self.Time - (CurrentTime - self.TimeStart)
								else
									self.Remaining = CurrentTime - self.TimeStart
								end
								if self.Remaining < 10 then
									text = string.format(" %0.01f : ", self.Remaining)..self.Name
								elseif self.Remaining >= 60 then
									text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Name
								else
									text = " "..math.floor(self.Remaining).." : "..self.Name
								end
								self.GUI:SetText(text)
								if self.Static == false then
									self.GUI.TimeBar:SetWidth(math.ceil(self.GUI.Background:GetWidth() * (self.Remaining/self.Time)))
									if self.Remaining <= 0 then
										self.Remaining = 0
										table.insert(self.Parent.StopTimers, self)
									end
								end
							end
						end
					end
					Timer:Update(Inspect.Time.Real())
				end
			end
		end		
	end
	
	function Mechanic:Queue(Duration)
		if KBM.MechSpy.Settings.Enabled then
			if self.Enabled then
				self:AddStart(self, Duration)
			end
		end
	end
	
	function Mechanic:NoMenu()
		self.Enabled = true
		self.NoMenu = true
		self.HasMenu = false
	end
	
	function Mechanic:SetLink(Spy)
		if type(Spy) == "table" then
			if Spy.Type ~= "spy" then
				error("Supplied Object is not a Mechanic Spy, got: "..tostring(Spy.Type))
			else
				self.Link = Spy
				self:NoMenu()
				for SettingID, Value in pairs(self.Settings) do
					if SettingID ~= "ID" then
						self.Link.Settings[SettingID] = Value
					end
				end
				if not Spy.Linked then
					Spy.Linked = {}
				end
				table.insert(Spy.Linked, self)
			end
		else
			error("Expecting at least a table got: "..type(Spy))
		end		
	end
			
	function Mechanic:SetPhase(Phase)
		self.Phase = Phase
	end
	
	if not self.List[BossObj.Mod] then
		self.List[BossObj.Mod] = {}
	end
	table.insert(self.List[BossObj.Mod], Mechanic)
	
	return Mechanic
end

function KBM.PhaseMonitor:PullObjective()
	local GUI  = {}
	if #self.ObjectiveStore > 0 then
		GUI = table.remove(self.ObjectiveStore)
	else
		GUI.Frame = UI.CreateFrame("Frame", "Objective_Base", KBM.Context)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
		GUI.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Progress = UI.CreateFrame("Texture", "Percentage_Progress", GUI.Frame)
		GUI.Progress:SetPoint("TOPRIGHT", GUI.Frame, "TOPRIGHT")
		GUI.Progress:SetPoint("BOTTOM", GUI.Frame, "BOTTOM")
		KBM.LoadTexture(GUI.Progress, "KingMolinator", "Media/BarTexture.png")
		GUI.Progress:SetWidth(GUI.Frame:GetWidth())
		GUI.Progress:SetBackgroundColor(0, 0.5, 0, 0.33)
		GUI.Progress:SetVisible(false)
		GUI.Progress:SetLayer(1)
		GUI.Shadow = UI.CreateFrame("Text", "Objective_Shadow", GUI.Frame)
		GUI.Shadow:SetFontColor(0,0,0,1)
		GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Shadow:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT", 1, 1)
		GUI.Shadow:SetLayer(2)
		GUI.Text = UI.CreateFrame("Text", "Objective_Text", GUI.Frame)
		GUI.Text:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
		GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Text:SetLayer(3)
		GUI.ObShadow = UI.CreateFrame("Text", "Objectives_Shadow", GUI.Frame)
		GUI.ObShadow:SetFontColor(0,0,0,1)
		GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.ObShadow:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT", 1, 1)
		GUI.ObShadow:SetLayer(4)
		GUI.Objective = UI.CreateFrame("Text", "Objective_Tracker", GUI.Frame)
		GUI.Objective:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT")
		GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Objective:SetLayer(5)
		GUI.Frame:SetVisible(self.Settings.Enabled)
		function GUI:SetName(Text)
			self.Shadow:SetText(Text)
			self.Text:SetText(Text)
		end
		function GUI:SetObjective(Text)
			self.ObShadow:SetText(Text)
			self.Objective:SetText(Text)
		end
	end
	return GUI
end

function KBM.PhaseMonitor:Init()

	self.Settings = KBM.Options.PhaseMon
	if self.Settings.Type ~= "PhaseMon" then
		print("Error: Incorrect Settings for Phase Monintor")
	end
	self.Anchor = UI.CreateFrame("Frame", "Phase_Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor.Shadow = UI.CreateFrame("Text", "Phase_Anchor_Shadow", self.Anchor)
	self.Anchor.Shadow:SetFontColor(0,0,0,1)
	self.Anchor.Shadow:SetText(KBM.Language.Anchors.Phases[KBM.Lang])
	self.Anchor.Shadow:SetPoint("CENTER", self.Anchor, "CENTER", 1, 1)
	self.Anchor.Shadow:SetLayer(1)
	self.Anchor.Text = UI.CreateFrame("Text", "Phase_Anchor_Text", self.Anchor)
	self.Anchor.Text:SetText(KBM.Language.Anchors.Phases[KBM.Lang])
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Text:SetLayer(2)

	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.PhaseMonitor.Settings.x = self:GetLeft()
			KBM.PhaseMonitor.Settings.y = self:GetTop()
		end
	end
		
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Phase Anchor Drag", 2)

	self.Frame = UI.CreateFrame("Texture", "Phase Monitor", KBM.Context)
	self.Frame:SetLayer(5)
	KBM.LoadTexture(self.Frame, "KingMolinator", "Media/BarTexture.png")
	self.Frame:SetBackgroundColor(0,0,0.9,0.33)
	self.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
	self.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
	self.Frame:SetPoint("TOP", self.Anchor, "TOP")
	self.Frame:SetPoint("BOTTOM", self.Anchor, "CENTERY")
	self.Frame.Shadow = UI.CreateFrame("Text", "Phase_Monitor_Shadow", self.Frame)
	self.Frame.Shadow:SetText("Phase: 1")
	self.Frame.Shadow:SetFontColor(0,0,0,1)
	self.Frame.Shadow:SetPoint("CENTER", self.Frame, "CENTER", 1,1)
	self.Frame.Shadow:SetLayer(1)
	self.Frame.Text = UI.CreateFrame("Text", "Phase_Monitor_Text", self.Frame)
	self.Frame.Text:SetText("Phase: 1")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Frame.Text:SetLayer(2)
	
	self.Frame:SetVisible(false)
	
	self.Objectives = {}
	self.ObjectiveStore = {}
	self.Phase = {}
	self.Phase.Object = nil
	self.Active = false
	
	self.Objectives.Lists = {}
	self.Objectives.Lists.Meta = {}
	self.Objectives.Lists.Death = {}
	self.Objectives.Lists.Percent = {}
	self.Objectives.Lists.Time = {}
	self.Objectives.Lists.All = {}
	self.Objectives.Lists.LastObjective = nil
	self.Objectives.Lists.Count = 0
	
	self.ActiveObjects = LibSata:Create()
	
	function self:ApplySettings()
	
		if self.Settings.Type ~= "PhaseMon" then
			error("Error (Apply Settings): Incorrect Settings for Phase Monitor")
		end
	
		self.Anchor:ClearAll()
		if not self.Settings.x then
			self.Anchor:SetPoint("CENTERTOP", UIParent, 0.65, 0)
		else
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.Anchor:SetWidth(self.Settings.w * self.Settings.wScale)
		self.Anchor:SetHeight(self.Settings.h * self.Settings.hScale)
		self.Anchor.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Anchor.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if self.Settings.Enabled and KBM.Menu.Active then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor:SetBackgroundColor(0,0,0,0.33)
			self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
		else
			self.Anchor:SetVisible(false)
		end
		if #self.ObjectiveStore > 0 then
			for _, GUI in ipairs(self.ObjectiveStore) do
				GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end
		if self.Objectives.Lists.Count > 0 then
			for _, Object in ipairs(self.Objectives.Lists.All) do
				Object.GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end	
	end
	
	function self.Objectives.Lists:Add(Object)	
		if self.Count > 0 then
			Object.Previous = self.LastObjective
		end
		self.Count = self.Count + 1
		self.LastObjective = Object
		self.All[self.Count] = Object
		if Object.Previous then
			-- Appended to current List
			Object.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
			Object.Previous.Next = Object
			Object.Next = nil
		else
			-- First in the list
			Object.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
			Object.Previous = nil
			Object.Next = nil
		end
		Object.Index = self.Count
	end
	
	function self.Objectives.Lists:Remove(Object)
		if not Object then
			if KBM.Debug then
				print("Error: Unknown Object")
			end
			return
		end
		if self.Count == 1 then
			Object.GUI.Progress:SetVisible(false)
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			self[Object.Type][Object.Name] = nil
			if Object.UnitID then
				self[Object.Type][Object.UnitID] = nil
			end
			self[Object.Type] = {}
			self.All = {}
			Object = nil
			self.Count = 0
		else
			Object.GUI.Progress:SetVisible(false)
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			if Object.Next then
				if Object.Previous then
					-- Next Object is now after this objects previous in the list.
					Object.Previous.Next = Object.Next
					Object.Next.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
				else
					-- Next Object is now First in the list
					Object.Next.Previous = nil
					Object.Next.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
				end
			else
				-- This object was the last object in the list, and now the previous object is.
				Object.Previous.Next = nil
				self.LastObjective = Object.Previous
			end
			if Object.Type == "Percent" then
				if self[Object.Type][Object.Name] then
					self[Object.Type][Object.Name][tostring(Object)] = nil
					if not next(self[Object.Type][Object.Name]) then
						self[Object.Type][Object.Name] = nil
					end
				else
					if self[Object.Type][tostring(Object)] then
						self[Object.Type][tostring(Object)] = nil
					elseif self[Object.Type][Object.UnitID] then
						self[Object.Type][Object.UnitID] = nil
					end
				end
			else
				self[Object.Type][Object.Name] = nil
			end
			table.remove(self.All, Object.Index)
			-- Re-Index list
			for Index, Object in ipairs(self.All) do
				Object.Index = Index
			end
			self.Count = self.Count - 1
		end		
	end
	
	function self:SetPhase(Phase)
		self.Phase = Phase
		self.Frame.Shadow:SetText("Phase: "..Phase)
		self.Frame.Text:SetText("Phase: "..Phase)
	end
	
	function self.Phase:Create(Phase)
		local PhaseObj = {}
		PhaseObj.StartTime = 0
		PhaseObj.Phase = Phase
		PhaseObj.DefaultPhase = Phase
		PhaseObj.Objectives = {}
		PhaseObj.LastObjective = KBM.PhaseMonitor.Frame
		PhaseObj.Type = "PhaseMon"
		
		function PhaseObj:Update(Time)
			Time = math.floor(Time)
		end
		
		function PhaseObj:SetPhase(Phase)
			self.Phase = Phase
			KBM.PhaseMonitor:SetPhase(Phase)
		end
		
		function PhaseObj.Objectives:AddMeta(Name, Target, Total)		
			local MetaObj = {}
			MetaObj.Count = Total
			MetaObj.Target = Target
			MetaObj.Name = Name
			MetaObj.GUI = KBM.PhaseMonitor:PullObjective()
			MetaObj.GUI:SetName(Name)
			MetaObj.GUI:SetObjective(MetaObj.Count.."/"..MetaObj.Target)
			MetaObj.GUI.Progress:SetVisible(false)
			MetaObj.Type = "Meta"
			
			function MetaObj:Update(Total)
				if self.Target >= Total then
					self.Count = Total
					self.GUI:SetObjective(self.Count.."/"..self.Target)
				end
			end
			function MetaObj:Remove()
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Meta[Name] = MetaObj
			KBM.PhaseMonitor.Objectives.Lists:Add(MetaObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				MetaObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				MetaObj.GUI.Frame:SetVisible(false)
			end
			return MetaObj
		end
		
		function PhaseObj.Objectives:AddDeath(Name, Total, Type)		
			local DeathObj = {}
			DeathObj.Count = 0
			DeathObj.Total = Total
			DeathObj.Name = Name
			DeathObj.uType = Type
			DeathObj.Boss = BossObj
			DeathObj.GUI = KBM.PhaseMonitor:PullObjective()
			DeathObj.GUI:SetName(Name)
			DeathObj.GUI:SetObjective(DeathObj.Count.."/"..DeathObj.Total)
			DeathObj.GUI.Progress:SetVisible(false)
			DeathObj.Type = "Death"
			
			function DeathObj:Kill(UnitObj)
				if self.Count < Total then
					if self.uType == nil then
						self.Count = self.Count + 1
						self.GUI:SetObjective(self.Count.."/"..self.Total)
					elseif UnitObj.Details then
						if self.uType == UnitObj.Type then
							self.Count = self.Count + 1
							self.GUI:SetObjective(self.Count.."/"..self.Total)
						end
					end
				end
			end
			
			function DeathObj:Remove()
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Death[Name] = DeathObj
			KBM.PhaseMonitor.Objectives.Lists:Add(DeathObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				DeathObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				DeathObj.GUI.Frame:SetVisible(false)
			end
			return DeathObj
		end
		
		function PhaseObj.Objectives:AddPercent(Object, Target, Current)
			local PercentObj = {}
			PercentObj.Target = Target
			PercentObj.PercentRaw = Current * 0.01
			PercentObj.PercentFlat = math.ceil(Current)
			PercentObj.Percent = PercentObj.PercentFlat
			if type(Object) == "string" then
				-- Backwards Compatibility, soon to be removed
				PercentObj.Name = Object
				if KBM.CurrentMod then
					if KBM.CurrentMod.Bosses[PercentObj.Name] then
						PercentObj.BossObj = KBM.CurrentMod.Bosses[PercentObj.Name]
						PercentObj.UnitObj = PercentObj.BossObj.UnitObj
						PercentObj.UnitID = PercentObj.BossObj.UnitID
						if PercentObj.UnitObj then
							PercentObj.PercentRaw = PercentObj.UnitObj.PercentRaw
							PercentObj.Percent = PercentObj.UnitObj.Percent
							PercentObj.PercentFlat = PercentObj.UnitObj.PercentFlat
						end
					end
				end
			else
				PercentObj.Name = Object.Name
				PercentObj.BossObj = Object
				PercentObj.UnitObj = Object.UnitObj
				PercentObj.UnitID = Object.UnitID
				Object.PhaseObj = PercentObj
				if PercentObj.UnitObj then
					PercentObj.PercentRaw = Object.UnitObj.PercentRaw
					PercentObj.Percent = Object.UnitObj.Percent
					PercentObj.PercentFlat = Object.UnitObj.PercentFlat
				end
			end
			PercentObj.Dead = false
			PercentObj.GUI = KBM.PhaseMonitor:PullObjective()
			PercentObj.GUI.Progress:SetWidth(PercentObj.GUI.Frame:GetWidth() * PercentObj.PercentRaw)
			PercentObj.GUI.Progress:SetVisible(true)
			if PercentObj.BossObj then
				if PercentObj.BossObj.DisplayName then
					PercentObj.GUI:SetName(PercentObj.BossObj.DisplayName)
				else
					PercentObj.GUI:SetName(PercentObj.Name)
				end
			else
				PercentObj.GUI:SetName(PercentObj.Name)
			end
			if Target == 0 then
				PercentObj.GUI:SetObjective(PercentObj.PercentFlat.."%")
			else
				PercentObj.GUI:SetObjective(PercentObj.PercentFlat.."%/"..PercentObj.Target.."%")
			end	
			PercentObj.Type = "Percent"
			
			function PercentObj:Update()
				if self.Dead then
					return
				end
				if self.UnitObj then
					self.PercentRaw = self.UnitObj.PercentRaw
					self.Percent = self.UnitObj.Percent
					self.PercentFlat = self.UnitObj.PercentFlat
				end
				if self.PercentFlat == 0 then
					self.GUI:SetObjective(KBM.Language.Options.Dead[KBM.Lang])
					self.GUI.Progress:SetVisible(false)
					self.Dead = true
				else
					if self.PercentFlat >= self.Target then
						if self.Target == 0 then
							if self.PercentFlat <= 3 then
								self.GUI:SetObjective(tostring(self.Percent).."%")
							else
								self.GUI:SetObjective(self.PercentFlat.."%")
							end
						else
							self.GUI:SetObjective(self.PercentFlat.."%/"..self.Target.."%")
						end
						self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * self.PercentRaw)
					end
				end
			end
			
			function PercentObj:Remove()
				if self.BossObj then
					self.BossObj.PhaseObj = nil
				end
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			function PercentObj:UpdateID(UnitID)
				if self.UnitID then
					KBM.PhaseMonitor.Objectives.Lists.Percent[self.UnitID] = nil
				else
					if KBM.PhaseMonitor.Objectives.Lists.Percent[tostring(self.BossObj)] then
						KBM.PhaseMonitor.Objectives.Lists.Percent[tostring(self.BossObj)] = nil
					end
				end
				
				self.UnitID = UnitID
				if self.UnitID then
					self.UnitObj = LibSUnit.Lookup.UID[UnitID]
					KBM.PhaseMonitor.Objectives.Lists.Percent[self.UnitID] = self
				end
			end
			
			if PercentObj.UnitID then
				KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.UnitID] = PercentObj
			elseif not PercentObj.BossObj then
				if not KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.Name] then
					KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.Name] = {}
				end
				table.insert(KBM.PhaseMonitor.Objectives.Lists.Percent[PercentObj.Name], PercentObj)
			else
				KBM.PhaseMonitor.Objectives.Lists.Percent[tostring(PercentObj.BossObj)] = PhaseObj
			end
			KBM.PhaseMonitor.Objectives.Lists:Add(PercentObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				PercentObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				PercentObj.GUI.Frame:SetVisible(false)
			end
			return PercentObj
		end
		
		function PhaseObj.Objectives:AddTime(Time)
		end
		
		function PhaseObj.Objectives:Remove(Index)		
			if type(Index) == "number" then
				KBM.PhaseMonitor.Objectives.Lists:Remove(KBM.PhaseMonitor.Objectives.Lists.All[Index])
			else
				for _, Object in ipairs(KBM.PhaseMonitor.Objectives.Lists.All) do
					Object.GUI.Frame:SetVisible(false)
					table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
				end
				for ListName, List in pairs(KBM.PhaseMonitor.Objectives.Lists) do
					if type(List) == "table" then
						if ListName == "Percent" then
							for ID, PercentObj in pairs(List) do
								if PercentObj.BossObj then
									PercentObj.BossObj.PhaseObj = nil
								end
							end
						end
						KBM.PhaseMonitor.Objectives.Lists[ListName] = {}
					end
				end
				KBM.PhaseMonitor.Objectives.Lists.Count = 0
			end			
		end
		
		function PhaseObj:Start(Time)
			self.StartTime = math.floor(Time)
			self.Phase = self.DefaultPhase
			if KBM.PhaseMonitor.Settings.Enabled then
				if KBM.PhaseMonitor.Settings.PhaseDisplay then
					KBM.PhaseMonitor.Frame:SetVisible(true)
				end
			end
			KBM.PhaseMonitor.Active = true
			self:SetPhase(self.Phase)
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				if KBM.PhaseMonitor.Settings.Enabled then
					KBM.PhaseMonitor.Anchor:SetVisible(false)
				else
					KBM.PhaseMonitor.Anchor.Shadow:SetVisible(false)
					KBM.PhaseMonitor.Anchor.Text:SetVisible(false)
					KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0)
				end
			end
			self.TableObj = KBM.PhaseMonitor.ActiveObjects:Add(self)
		end
		
		function PhaseObj:End(Time)
			self.Objectives:Remove()
			if self.TableObj then
				KBM.PhaseMonitor.ActiveObjects:Remove(self.TableObj)
				self.TableObj = nil
			end
			KBM.PhaseMonitor.Frame:SetVisible(false)
			KBM.PhaseMonitor.Active = false
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				KBM.PhaseMonitor.Anchor.Shadow:SetVisible(true)
				KBM.PhaseMonitor.Anchor.Text:SetVisible(true)
				KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0.33)
			else
				if KBM.PhaseMonitor.Settings.Visible then
					KBM.PhaseMonitor.Anchor:SetVisible(true)
				end
			end
		end
	
		self.Object = PhaseObj
		return PhaseObj
	end
	
	function self:Remove()
		for TableObj, PhaseObj in LibSata.EachIn(self.ActiveObjects) do
			PhaseObj:End()
		end
	end
	
	function self.Phase:Remove()	
	end
	
	function self.Anchor.Drag.Event:WheelForward()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale < 1.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale + 0.02
				if KBM.PhaseMonitor.Settings.wScale > 1.6 then
					KBM.PhaseMonitor.Settings.wScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale < 1.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale + 0.02
				if KBM.PhaseMonitor.Settings.hScale > 1.6 then
					KBM.PhaseMonitor.Settings.hScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale < 1.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale + 0.02
				if KBM.PhaseMonitor.Settings.tScale > 1.6 then
					KBM.PhaseMonitor.Settings.tScale = 1.6
				end
				Change = true
			end
		end
		
		if Change then
			KBM.PhaseMonitor:ApplySettings()
		end		
	end
	
	function self.Anchor.Drag.Event:WheelBack()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale > 0.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale - 0.02
				if KBM.PhaseMonitor.Settings.wScale < 0.6 then
					KBM.PhaseMonitor.Settings.wScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale > 0.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale - 0.02
				if KBM.PhaseMonitor.Settings.hScale < 0.6 then
					KBM.PhaseMonitor.Settings.hScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale > 0.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale - 0.02
				if KBM.PhaseMonitor.Settings.tScale < 0.6 then
					KBM.PhaseMonitor.Settings.tScale = 0.6
				end
				Change = true
			end
		end
		
		if Change then 
			KBM.PhaseMonitor:ApplySettings()
		end
	end
	self:ApplySettings()	
end

function KBM.EncTimer:Init()	
	self.TestMode = false
	self.Settings = KBM.Options.EncTimer
	self.Frame = UI.CreateFrame("Frame", "Encounter_Timer", KBM.Context)
	self.Frame:SetLayer(5)
	self.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Frame.Shadow = UI.CreateFrame("Text", "Time_Shadow", self.Frame)
	self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
	self.Frame.Shadow:SetPoint("CENTER", self.Frame, "CENTER", 1, 1)
	self.Frame.Shadow:SetLayer(1)
	self.Frame.Shadow:SetFontColor(0,0,0,1)
	self.Frame.Text = UI.CreateFrame("Text", "Encounter_Text", self.Frame)
	self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Frame.Text:SetLayer(2)
	self.Enrage = {}
	self.Enrage.Frame = UI.CreateFrame("Frame", "Enrage Timer", KBM.Context)
	self.Enrage.Frame:SetPoint("TOPLEFT", self.Frame, "BOTTOMLEFT")
	self.Enrage.Frame:SetPoint("RIGHT", self.Frame, "RIGHT")
	self.Enrage.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Enrage.Frame:SetLayer(5)
	self.Enrage.Shadow = UI.CreateFrame("Text", "Time_Shadow", self.Enrage.Frame)
	self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
	self.Enrage.Shadow:SetPoint("CENTER", self.Enrage.Frame, "CENTER", 1, 1)
	self.Enrage.Shadow:SetLayer(2)
	self.Enrage.Shadow:SetFontColor(0,0,0,1)
	self.Enrage.Text = UI.CreateFrame("Text", "Enrage Text", self.Enrage.Shadow)
	self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
	self.Enrage.Text:SetPoint("CENTER", self.Enrage.Frame, "CENTER")
	self.Enrage.Progress = UI.CreateFrame("Texture", "Enrage Progress", self.Enrage.Frame)
	KBM.LoadTexture(self.Enrage.Progress, "KingMolinator", "Media/BarTexture.png")
	self.Enrage.Progress:SetPoint("TOPLEFT", self.Enrage.Frame, "TOPLEFT")
	self.Enrage.Progress:SetPoint("BOTTOM", self.Enrage.Frame, "BOTTOM")
	self.Enrage.Progress:SetWidth(0)
	self.Enrage.Progress:SetBackgroundColor(0.9,0,0,0.33)
	self.Enrage.Progress:SetLayer(1)
	
	function self:ApplySettings()
		self.Frame:ClearAll()
		if not self.Settings.x then
			self.Frame:SetPoint("CENTERTOP", UIParent, "CENTERTOP")
		else
			self.Frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.Frame:SetWidth(self.Settings.w * self.Settings.wScale)
		self.Frame:SetHeight(self.Settings.h * self.Settings.hScale)
		self.Enrage.Frame:SetHeight(self.Frame:GetHeight())
		self.Frame.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Enrage.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Enrage.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if KBM.Menu.Active then
			self.Frame:SetVisible(self.Settings.Visible)
			self.Enrage.Frame:SetVisible(self.Settings.Visible)
			self.Frame.Drag:SetVisible(self.Settings.Unlocked)
		else
			if self.Active then
				self.Frame:SetVisible(self.Settings.Enabled)
				if KBM.CurrentMod.Enrage then
					self.Enrage.Frame:SetVisible(self.Settings.Enrage)
				else
					self.Enrage.Frame:SetVisible(false)
				end
				self.Frame.Drag:SetVisible(false)
			else
				self.Frame:SetVisible(false)
				self.Enrage.Frame:SetVisible(false)
				self.Frame.Drag:SetVisible(false)
			end
		end
	end
	
	function self:UpdateMove(uType)	
		if uType == "end" then
			self.Settings.x = self.Frame:GetLeft()
			self.Settings.y = self.Frame:GetTop()
		end		
	end
	
	function self:Update(current)	
		local EnrageString = ""
		if self.Settings.Duration then
			self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
			self.Frame.Text:SetText(self.Frame.Shadow:GetText())
		end
		
		if self.Settings.Enrage then
			if KBM.CurrentMod.Enrage then
				if self.Paused then
					EnrageString = KBM.ConvertTime(KBM.CurrentMod.Enrage)
				else
					if current < KBM.EnrageTime then
						EnrageString = KBM.ConvertTime(KBM.EnrageTime - current + 1)
						self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." "..EnrageString)
						self.Enrage.Text:SetText(self.Enrage.Shadow:GetText())
						self.Enrage.Progress:SetWidth(math.floor(self.Enrage.Frame:GetWidth()*((KBM.TimeElapsed - self.EnrageStart)/KBM.CurrentMod.Enrage)))
					else
						self.Enrage.Shadow:SetText(KBM.Language.Timers.Enraged[KBM.Lang])
						self.Enrage.Text:SetText(KBM.Language.Timers.Enraged[KBM.Lang])
						self.Enrage.Progress:SetWidth(self.Enrage.Frame:GetWidth())
					end
				end
			end
		end		
	end
	
	function self:Unpause()
		self.EnrageStart = KBM.TimeElapsed
		KBM.EnrageTime = Inspect.Time.Real() + KBM.CurrentMod.Enrage
		self.Paused = false
	end
	
	function self:Start(Time)
		self.IsEnraged = false
		self.EnrageStart = 0
		if self.Settings.Enabled then
			if self.Settings.Duration then
				self.Frame:SetVisible(true)
				self.Active = true
			end
			if self.Settings.Enrage then
				if KBM.CurrentMod.Enrage then
					if KBM.CurrentMod.EnragePaused then
						self.Paused = true
					end
					self.Enrage.Frame:SetVisible(true)
					self.Enrage.Progress:SetWidth(0)
					self.Enrage.Progress:SetVisible(true)
					self.Active = true
				end
			end
			if self.Active then
				self:Update(Time)
			end
		end		
	end
	
	function self:TestUpdate()	
	end
	
	function self:End()	
		self.Active = false
		self.IsEnraged = false
		self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
		self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
		self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		self.Enrage.Progress:SetVisible(false)
		self.Enrage.Progress:SetWidth(0)
	end
	
	function self:SetTest(bool)	
		if bool then
			self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
			self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
			self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
			self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		end
		self.Frame:SetVisible(bool)
		self.Enrange:SetVisible(bool)		
	end
	
	self.Frame.Drag = KBM.AttachDragFrame(self.Frame, function (uType) self:UpdateMove(uType) end, "Enc Timer Drag", 2)
	function self.Frame.Drag.Event:WheelForward()	
		if KBM.EncTimer.Settings.ScaleWidth then
			if KBM.EncTimer.Settings.wScale < 1.6 then
				KBM.EncTimer.Settings.wScale = KBM.EncTimer.Settings.wScale + 0.02
				if KBM.EncTimer.Settings.wScale > 1.6 then
					KBM.EncTimer.Settings.wScale = 1.6
				end
				KBM.EncTimer.Frame:SetWidth(KBM.EncTimer.Settings.wScale * KBM.EncTimer.Settings.w)
			end
		end
		
		if KBM.EncTimer.Settings.ScaleHeight then
			if KBM.EncTimer.Settings.hScale < 1.6 then
				KBM.EncTimer.Settings.hScale = KBM.EncTimer.Settings.hScale + 0.02
				if KBM.EncTimer.Settings.hScale > 1.6 then
					KBM.EncTimer.Settings.hScale = 1.6
				end
				KBM.EncTimer.Frame:SetHeight(KBM.EncTimer.Settings.hScale * KBM.EncTimer.Settings.h)
				KBM.EncTimer.Enrage.Frame:SetHeight(KBM.EncTimer.Frame:GetHeight())
			end
		end
		
		if KBM.EncTimer.Settings.TextScale then
			if KBM.EncTimer.Settings.tScale < 1.6 then
				KBM.EncTimer.Settings.tScale = KBM.EncTimer.Settings.tScale + 0.02
				if KBM.EncTimer.Settings.tScale > 1.6 then
					KBM.EncTimer.Settings.tScale = 1.6
				end
				KBM.EncTimer.Frame.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)	
				KBM.EncTimer.Enrage.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
			end
		end		
	end
	
	function self.Frame.Drag.Event:WheelBack()	
		if KBM.EncTimer.Settings.ScaleWidth then
			if KBM.EncTimer.Settings.wScale > 0.6 then
				KBM.EncTimer.Settings.wScale = KBM.EncTimer.Settings.wScale - 0.02
				if KBM.EncTimer.Settings.wScale < 0.6 then
					KBM.EncTimer.Settings.wScale = 0.6
				end
				KBM.EncTimer.Frame:SetWidth(KBM.EncTimer.Settings.wScale * KBM.EncTimer.Settings.w)
			end
		end
		
		if KBM.EncTimer.Settings.ScaleHeight then
			if KBM.EncTimer.Settings.hScale > 0.6 then
				KBM.EncTimer.Settings.hScale = KBM.EncTimer.Settings.hScale - 0.02
				if KBM.EncTimer.Settings.hScale < 0.6 then
					KBM.EncTimer.Settings.hScale = 0.6
				end
				KBM.EncTimer.Frame:SetHeight(KBM.EncTimer.Settings.hScale * KBM.EncTimer.Settings.h)
				KBM.EncTimer.Enrage.Frame:SetHeight(KBM.EncTimer.Frame:GetHeight())
			end
		end
		
		if KBM.EncTimer.Settings.TextScale then
			if KBM.EncTimer.Settings.tScale > 0.6 then
				KBM.EncTimer.Settings.tScale = KBM.EncTimer.Settings.tScale - 0.02
				if KBM.EncTimer.Settings.tScale < 0.6 then
					KBM.EncTimer.Settings.tScale = 0.6
				end
				KBM.EncTimer.Frame.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)	
				KBM.EncTimer.Enrage.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
			end
		end
	end
	self:ApplySettings()	
end

function KBM.CheckActiveBoss(UnitObj)
	local current = Inspect.Time.Real()
	local style = "new"
	local UnitID = UnitObj.UnitID
	local uDetails = UnitObj.Details
	if KBM.IgnoreList[UnitID] or KBM.BossID[UnitID] then
		return
	end
	if KBM.Options.Enabled then
		if (not KBM.Idle.Wait or (KBM.Idle.Wait == true and KBM.Idle.Until < current)) or KBM.Encounter then
			local BossObj = nil
			KBM.Idle.Wait = false
			--if not KBM.BossID[UnitID] then
				if UnitObj.Loaded  and UnitObj.Combat then
					local skipCache = false
					if UnitObj.Type then
						if KBM.Boss.TypeList[UnitObj.Type] then
							BossObj = KBM.Boss.TypeList[UnitObj.Type]
							if KBM.Boss.Chronicle[UnitObj.Type] then
								if not KBM.Encounter then
									KBM.EncounterMode = "Chronicle"
								end
							else
								if not KBM.Encounter then
									KBM.EncounterMode = BossObj.Mod.InstanceObj.Type
								end
							end
						end
					end
					if not BossObj then
						-- Check if Unit is currently in Template form.
						BossObj = KBM.Boss.Template[UnitObj.Name]
						if BossObj then
							if not KBM.Encounter then
								KBM.EncounterMode = "Template"
							end
						end
					else
						skipCache = true
					end
					local ModBossObj = nil
					if BossObj then
						if BossObj.Mod then
							local ModAttempt = nil
							if KBM.Encounter then
								if BossObj.Mod.ID == KBM.CurrentMod.ID then
									ModBossObj = KBM.CurrentMod:UnitHPCheck(uDetails, UnitID)
									ModAttempt = BossObj.Mod
								end
							else
								if not BossObj.Ignore then
									ModBossObj = BossObj.Mod:UnitHPCheck(uDetails, UnitID)
									ModAttempt = BossObj.Mod
								end
							end
							if ModBossObj then
								local hasUTID = false
								if skipCache == false then
									if UnitObj.Type then
										if type(BossObj.UTID) == "string" then
											if BossObj.UTID == UnitObj.Type then
												hasUTID = true
											end
										elseif type(BossObj.UTID) == "table" then
											for i, UTID in pairs(BossObj.UTID) do
												if UTID == UnitObj.Type then
													hasUTID = true
													break
												end
											end
										end
									end
								else
									hasUTID = true
								end
								if hasUTID == false then
									if UnitObj.Type then
										if not KBM.Options.UnitCache.List then
											KBM.Options.UnitCache.List = {}
										end
										if not KBM.Options.UnitCache.List[UnitObj.Name] then
											KBM.Options.UnitCache.List[UnitObj.Name] = {}
										end
										if not KBM.Options.UnitCache.List[UnitObj.Name][UnitObj.Type] then
											print("--------------------------------------")
											print("Template Unit/Encounter found.")
											print("Boss Name: "..tostring(UnitObj.Name).." added to Cache")
											local Zone = {
												id = "n/a",
												name = "unavailable",
												["type"] = "n/a",
											}
											if not UnitObj.Zone then
												if LibSUnit.Player.Zone then
													Zone = Inspect.Zone.Detail(LibSUnit.Player.Zone)
												end
											else
												Zone = Inspect.Zone.Detail(uDetails.zone)
											end
											KBM.Options.UnitCache.List[UnitObj.Name][UnitObj.Type] = {
												Location = tostring(KBM.Player.Location),
												Tier = tostring(UnitObj.Tier),
												Level = tostring(UnitObj.Level).." ("..type(UnitObj.Level)..")",
												XYZ = tostring(UnitObj.Position.X)..","..tostring(UnitObj.Position.Y)..","..tostring(UnitObj.Position.Z),
												Zone = Zone,
												Mod = BossObj.Mod.Descript,
												Time = "Start",
												System = tostring(os.date()),
											}
											if KBM.Encounter then
												KBM.Options.UnitCache.List[UnitObj.Name][UnitObj.Type].Time = KBM.ConvertTime(KBM.TimeElapsed)
											end
											KBM.Options.UnitTotal = KBM.Options.UnitTotal + 1
										end
									end
								end
								if (BossObj.Ignore ~= true and KBM.Encounter ~= true) or KBM.Encounter == true then
									if KBM.Debug then
										print("Boss found Checking: Tier = "..tostring(UnitObj.Tier).." "..tostring(UnitObj.Level).." ("..type(UnitObj.Level)..")")
										print("Players location: "..tostring(LibSUnit.Player.Location))
										print("Unit Type: "..tostring(UnitObj.Type))
										print("Unit Name: "..tostring(UnitObj.Name))
										print("Unit X: "..tostring(UnitObj.Position.X))
										print("Unit Y: "..tostring(UnitObj.Position.Y))
										print("Unit Z: "..tostring(UnitObj.Position.Z))
										print("------------------------------------")
									end
									-- if KBM.Debug then
										-- print("Boss matched checking encounter start")
									-- end
									if KBM.EncounterMode ~= "Chronicle" or (KBM.EncounterMode == "Chronicle" and BossObj.Mod.Settings.Chronicle) then
										KBM.BossID[UnitID] = {}
										KBM.BossID[UnitID].UnitObj = UnitObj
										KBM.BossID[UnitID].Monitor = true
										KBM.BossID[UnitID].Mod = BossObj.Mod
										KBM.BossID[UnitID].IdleSince = false
										KBM.BossID[UnitID].Boss = ModBossObj
										KBM.BossID[UnitID].PhaseObj = ModBossObj.PhaseObj
										ModBossObj.UnitObj = UnitObj
										if UnitObj.Health > 0 then
											if KBM.Debug then
												print("Boss is alive and in combat, activating.")
											end
											KBM.BossID[UnitID].Dead = false
											KBM.BossID[UnitID].Available = true
											if not KBM.Encounter then
												-- if KBM.Debug then
													-- print("New encounter, starting")
												-- end
												KBM.Encounter = true
												KBM.CurrentMod = KBM.BossID[UnitID].Mod
												local PercentOver = 99
												if KBM.EncounterMode == "Chronicle" then
													if KBM.CurrentMod.ChroniclePOver then
														PercentOver = KBM.CurrentMod.ChroniclePOver
													end
													print(KBM.Language.Encounter.Start[KBM.Lang].." "..KBM.CurrentMod.Descript.." (Chronicles)")
													if UnitObj.PercentFlat >= PercentOver then 
														KBM.CurrentMod.Settings.Records.Chronicle.Attempts = KBM.CurrentMod.Settings.Records.Chronicle.Attempts + 1
													end
												elseif KBM.EncounterMode == "Template" then
													print("Template Mode actived, no record tracking available.")
												else
													print(KBM.Language.Encounter.Start[KBM.Lang].." "..KBM.CurrentMod.Descript)
													if UnitObj.PercentFlat >= PercentOver then
														KBM.CurrentMod.Settings.Records.Attempts = KBM.CurrentMod.Settings.Records.Attempts + 1
													end
												end
												if UnitObj.PercentFlat < PercentOver then
													KBM.ValidTime = false
												else
													KBM.ValidTime = true
												end
												print(KBM.Language.Encounter.GLuck[KBM.Lang])
												KBM.TimeElapsed = 0
												KBM.StartTime = math.floor(current)
												KBM.CurrentMod.Phase = 1
												KBM.Phase = 1
												if KBM.CurrentMod.Settings.EncTimer then
													if KBM.CurrentMod.Settings.EncTimer.Override then
														KBM.EncTimer.Settings = KBM.CurrentMod.Settings.EncTimer
													else
														KBM.EncTimer.Settings = KBM.Options.EncTimer
													end
												else
													KBM.EncTimer.Settings = KBM.Options.EncTimer
												end
												if KBM.CurrentMod.Settings.PhaseMon then
													if KBM.CurrentMod.Settings.PhaseMon.Override then
														KBM.PhaseMonitor.Settings = KBM.CurrentMod.Settings.PhaseMon
													else
														KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
													end
												else
													KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
												end
												if KBM.CurrentMod.Settings.MechTimer then
													if KBM.CurrentMod.Settings.MechTimer.Override then
														KBM.MechTimer.Settings = KBM.CurrentMod.Settings.MechTimer
													else
														KBM.MechTimer.Settings = KBM.Options.MechTimer
													end
												else
													KBM.MechTimer.Setting = KBM.Options.MechTimer
												end
												if KBM.CurrentMod.Settings.Alerts then
													if KBM.CurrentMod.Settings.Alerts.Override then
														KBM.Alert.Settings = KBM.CurrentMod.Settings.Alerts
													else
														KBM.Alert.Settings = KBM.Options.Alerts
													end
												else
													KBM.Alert.Settings = KBM.Options.Alerts
												end
												if KBM.CurrentMod.Settings.MechSpy then
													if KBM.CurrentMod.Settings.MechSpy.Override then
														KBM.MechSpy.Settings = KBM.CurrentMod.Settings.MechSpy
													else
														KBM.MechSpy.Settings = KBM.Options.MechSpy
													end
												else
													KBM.MechSpy.Settings = KBM.Options.MechSpy
												end
												KBM.EncTimer:ApplySettings()
												KBM.PhaseMonitor:ApplySettings()
												KBM.MechTimer:ApplySettings()
												KBM.Alert:ApplySettings()
												KBM.MechSpy:ApplySettings()
												if KBM.CurrentMod.Enrage then
													KBM.EnrageTime = KBM.StartTime + KBM.CurrentMod.Enrage
												end
												KBM.EncTimer:Start(KBM.StartTime)
												KBM.MechSpy:Begin()
												KBM.Event.Encounter.Start({Type = "start", Mod = KBM.CurrentMod})
												KBM.PercentageMon:Start(KBM.CurrentMod.ID)
											else
												if KBM.PercentageMon.Active then
													if KBM.PercentageMon.Current then
														if UnitObj == KBM.PercentageMon.Current.BossL.UnitObj then
															KBM.PercentageMon:SetPercentL()
															KBM.PercentageMon:SetMarkL()
														elseif UnitObj == KBM.PercentageMon.Current.BossR.UnitObj then
															KBM.PercentageMon:SetPercentR()
															KBM.PercentageMon:SetMarkR()
														end
													end
												end
											end
											if ModBossObj.PhaseObj then
												KBM.BossID[UnitID].PhaseObj = ModBossObj.PhaseObj
												ModBossObj.PhaseObj:UpdateID(UnitID)
												ModBossObj.PhaseObj:Update()
											elseif KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name] then
												local PhaseObj = table.remove(KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name])
												if PhaseObj then
													KBM.BossID[UnitID].PhaseObj = PhaseObj
													PhaseObj.BossObj = ModBossObj
													PhaseObj.UnitObj = UnitObj
													PhaseObj:UpdateID(UnitID)
													PhaseObj:Update()
												end
											elseif KBM.PhaseMonitor.Objectives.Lists.Percent[UnitID] then
												KBM.BossID[UnitID].PhaseObj = KBM.PhaseMonitor.Objectives.Lists.Percent[UnitID]
												KBM.BossID[UnitID].PhaseObj.UnitObj = UnitObj
												KBM.BossID[UnitID].PhaseObj:Update()
											elseif KBM.BossID[UnitID].PhaseObj then
												KBM.BossID[UnitID].PhaseObj:UpdateID(UnitID)
												KBM.BossID[UnitID].PhaseObj:Update()
											end
										else
											KBM.BossID[UnitID].Dead = true
											KBM.BossID[UnitID].Available = true
										end
									end
								end
							elseif not KBM.Encounter then
								if ModAttempt then
									if ModAttempt.EncounterRunning then
										ModAttempt:Reset()
									else
										if KBM.PhaseMonitor.ActiveObjects._count > 0 then
											KBM.PhaseMonitor:Remove()
										end
									end
								end
							end
						end
					else
						-- if UnitObj.CurrentKey == "Avail" then
							-- if UnitObj.Type then
								-- if not KBM.Boss.TypeList[UnitObj.Type] then
									-- if UnitObj.Relation == "hostile" then
										-- if KBM.Debug then
											-- if not KBM.IgnoreList[UnitID] then
												-- -- print("New Unit Added to Ignore:")
												-- -- dump(uDetails)
												-- -- print("----------")
											-- end
										-- end
										-- --KBM.IgnoreList[UnitID] = true
									-- end
								-- end
							-- end
						-- end
					end
				end
			--else
				-- if uDetails then
					-- if uDetails.health == 0 then
						-- KBM.BossID[UnitID].Combat = false
						-- KBM.BossID[UnitID].available = true
						-- if not KBM.BossID[UnitID].dead then
							-- KBM.BossID[UnitID].dead = true
						-- end
					-- end
				-- end
			--end
		else
			-- if KBM.Debug then
				-- print("Encounter idle wait, skipping start.")
			-- end
			if KBM.Idle.Until < current then
				KBM.Idle.Wait = false
			end
		end
	end	
end

function KBM.CombatEnter(handle, uList)
	if KBM.Options.Enabled then
		for UnitID, UnitObj in pairs(uList) do
			if not UnitObj.Player then
				KBM.CheckActiveBoss(UnitObj)
			end
		end
	end	
end

function KBM.Damage(info)
	-- Damage done by a Non Raid Member to Anything.
	if KBM.Options.Enabled then
		if info.targetObj and info.sourceObj then
			local tarObj = info.targetObj
			local srcObj = info.sourceObj
			if KBM.Encounter then
				-- Damage done by a Boss Object to the Raid [DURING ENCOUNTER]
				local PlayerObj = LibSUnit.Raid.UID[tarObj.UnitID]
				if PlayerObj then
					local BossObj = KBM.BossID[srcObj.UnitID]
					if KBM.CurrentMod then
						if BossObj then
							if info.abilityName then
								if KBM.Trigger.Damage[info.abilityName] then
									TriggerObj = KBM.Trigger.Damage[info.abilityName]
									KBM.Trigger.Queue:Add(TriggerObj, srcObj.UnitID, PlayerObj.UnitID)
								end
							end
							-- Check for Npc Based Triggers (Usually Dynamic: Eg - Failsafe for P4 start Akylios)
							if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID] then
								if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name] then
									local TriggerObj = KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name]
									if TriggerObj.Enabled then
										KBM.Trigger.Queue:Add(TriggerObj, srcObj.UnitID, PlayerObj.UnitID)
									end
								end
							end
						else
							if not LibSUnit.Raid.UID[srcObj.UnitID] then
								if srcObj.Combat then
									if not srcObj.Dead then
										KBM.CheckActiveBoss(srcObj)
									end
								end
							end
						end
					end
				else
					-- Damage by the Raid to a Boss Object [DURING ENCOUNTER]
					local PlayerObj = LibSUnit.Raid.UID[srcObj.UnitID]
					if PlayerObj then
						local BossObj = KBM.BossID[tarObj.UnitID]
						if BossObj then
							if not BossObj.Dead then
								if KBM.CurrentMod then
									-- Check for Npc Based Triggers (Usually Dynamic: Eg - Failsafe for P4 start Akylios)
									if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID] then
										if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name] then
											local TriggerObj = KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name]
											if TriggerObj.Enabled then
												KBM.Trigger.Queue:Add(TriggerObj, srcObj.UnitID, tarObj.UnitID)
											end
										end
									end
								end
							end
						else
							if not LibSUnit.Raid.UID[tarObj.UnitID] then
								if tarObj.Combat then
									if not tarObj.Dead then
										KBM.CheckActiveBoss(tarObj)
									end
								end
							end
						end
					end
				end			
			else
				-- Encounter state is idle, check triggering methods.
				-- This is a fail-safe, and not usually used for Encounter starts.
				local PlayerObj = LibSUnit.Raid.UID[srcObj.UnitID]
				if PlayerObj then
					if not LibSUnit.Raid.UID[tarObj.UnitID] then
						if tarObj.Combat then
							if not tarObj.Dead then
								KBM.CheckActiveBoss(tarObj)
							end
						end
					end
				else
					PlayerObj = LibSUnit.Raid.UID[tarObj.UnitID]
					if PlayerObj then
						if not LibSUnit.Raid.UID[srcObj.UnitID] then
							if srcObj.Combat then
								if not srcObj.Dead then
									KBM.CheckActiveBoss(srcObj)
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM.Heal(info)
end

function KBM.CPU:Init()
	self.Constant = {
		Width = 150,
		Height = 20,
		Text = 12,
	}
	self.Callbacks = {}
	function self.Callbacks.Position(Type)
		if Type == "end" then
			KBM.Options.CPU.x = KBM.CPU.GUI.Header:GetLeft()
			KBM.Options.CPU.y = KBM.CPU.GUI.Header:GetTop()
		end
	end
	self.GUI = {}
	self.GUI.Header = UI.CreateFrame("Texture", "CPU_Monitor_Header", KBM.Context)
	self.GUI.Header:SetWidth(self.Constant.Width)
	self.GUI.Header:SetHeight(self.Constant.Height)
	KBM.LoadTexture(self.GUI.Header, "KingMolinator", "Media/BarTexture.png")
	self.GUI.Header:SetBackgroundColor(0, 0.35, 0, 0.75)
	if not KBM.Options.CPU.x then
		self.GUI.Header:SetPoint("CENTER", UIParent, "CENTER")
	else
		self.GUI.Header:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.CPU.x, KBM.Options.CPU.y)
	end
	self.GUI.HeadText = UI.CreateFrame("Text", "CPU_Monitor_HText", self.GUI.Header)
	self.GUI.HeadText:SetFontSize(self.Constant.Text)
	self.GUI.HeadText:SetText("KBM CPU Monitor")
	self.GUI.HeadText:SetPoint("CENTER", self.GUI.Header, "CENTER")
	self.GUI.DragFrame = KBM.AttachDragFrame(self.GUI.Header, self.Callbacks.Position, 5)
	self.GUI.Trackers = {}
	self.GUI.LastTracker = self.GUI.Header
	function self:CreateTrack(ID, Name, R, G, B)
		local TrackObj = {
			GUI = {},
			Current = "",
		}
		TrackObj.GUI.Frame = UI.CreateFrame("Frame", Name, self.GUI.Header)
		TrackObj.GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		TrackObj.GUI.Frame:SetPoint("TOPLEFT", self.GUI.LastTracker, "BOTTOMLEFT")
		TrackObj.GUI.Frame:SetPoint("RIGHT", self.GUI.LastTracker, "RIGHT")
		TrackObj.GUI.Frame:SetHeight(self.Constant.Height)
		TrackObj.GUI.Text = UI.CreateFrame("Text", Name.."_Text", TrackObj.GUI.Frame)
		TrackObj.GUI.Text:SetText(Name)
		TrackObj.GUI.Text:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Text:SetPoint("CENTERLEFT", TrackObj.GUI.Frame, "CENTERLEFT", 2, 0)
		TrackObj.GUI.Data = UI.CreateFrame("Text", Name.."_Data", TrackObj.GUI.Frame)
		TrackObj.GUI.Data:SetText("0")
		TrackObj.GUI.Data:SetFontColor(R, G, B)
		TrackObj.GUI.Data:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Data:SetPoint("CENTERRIGHT", TrackObj.GUI.Frame, "CENTERRIGHT", -2, 0)
		function TrackObj:UpdateDisplay(New)
			New = tonumber(New) or 0
			NewString = string.format("%0.1f%%", New)
			if NewString ~= self.Current then
				if New < 10 then
					self.GUI.Data:SetFontColor(0.2, 0.9, 0.2)
				elseif New < 30 then
					self.GUI.Data:SetFontColor(0.9, 0.5, 0.35)
				else
					self.GUI.Data:SetFontColor(0.9, 0.2, 0.2)
				end
				self.GUI.Data:SetText(NewString)
				self.Current = NewString
			end
		end
		self.GUI.Trackers[ID] = TrackObj
		self.GUI.LastTracker = TrackObj.GUI.Frame
	end
	self:CreateTrack("KingMolinator", "KBM", 0.9, 0.5, 0.35)
	self:CreateTrack("Rift", "Rift", 0.9, 0.5, 0.35)
	self:CreateTrack("SafesRaidManager", "SRM", 0.9, 0.5, 0.35)
	if KBM.PlugIn.List["KBMMarkIt"] then
		self:CreateTrack("KBMMarkIt", "KBM: Mark-It", 0.9, 0.5, 0.35)
	end
	if KBM.PlugIn.List["KBMAddWatch"] then
		self:CreateTrack("KBMAddWatch", "KBM: AddWatch", 0.9, 0.5, 0.35)
	end
	self:CreateTrack("KBMReadyCheck", "KBM:RC", 0.9, 0.5, 0.35)
	self:CreateTrack("NonKBM", "Other Addons", 0.9, 0.5, 0.35)
	function self:UpdateAll()
		local CPUTable = Inspect.Addon.Cpu()
		local Others = 0
		for AddonID, SubTable in pairs(CPUTable) do
			if self.GUI.Trackers[AddonID] then
				local Total = 0
				for ID, Data in pairs(SubTable) do
					if type(Data) == "number" then
						Total = Total + Data
					elseif type(Data) == "table" then
						for ID, SubData in pairs(Data) do
							if type(SubData) == "number" then
								Total = Total + SubData
							end
						end
					end
				end
				self.GUI.Trackers[AddonID]:UpdateDisplay(Total * 100)
			else
				for ID, Data in pairs(SubTable) do
					if type(Data) == "number" then
						Others = Others + Data
					end
				end
			end
		end
		self.GUI.Trackers["NonKBM"]:UpdateDisplay(Others * 100)
	end
end

function KBM.CPU:Toggle(Silent)
	if not Silent then
		if KBM.Options.CPU.Enabled then
			KBM.Options.CPU.Enabled = false
		else
			KBM.Options.CPU.Enabled = true
		end
	end
	if KBM.Options.CPU.Enabled then
		if not self.GUI then
			self:Init()
		end
		self.GUI.Header:SetVisible(true)
	else
		if self.GUI then
			self.GUI.Header:SetVisible(false)
		end
	end
end

function KBM.Unit.Percent(handle, UnitObj)
	if KBM.Encounter then
		local BossObj = KBM.BossID[UnitObj.UnitID]
		if BossObj then
			if UnitObj.PercentFlat ~= UnitObj.PercentFlatLast then
				if KBM.Trigger.Percent[KBM.CurrentMod.ID] then
					if KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name] then
						if UnitObj.PercentFlatLast - UnitObj.PercentFlat > 1 then
							for PCycle = UnitObj.PercentFlatLast, UnitObj.PercentFlat, -1 do
								if KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][PCycle] then
									TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][PCycle]
									KBM.Trigger.Queue:Add(TriggerObj, nil, UnitObj.UnitID)
								end
							end
						else
							if KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][UnitObj.PercentFlat] then
								TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][UnitObj.PercentFlat]
								KBM.Trigger.Queue:Add(TriggerObj, nil, UnitObj.UnitID)
							end
						end
					end
				end
			end
			if KBM.PhaseMonitor.Active then
				if KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.UnitID] then
					KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.UnitID]:Update()
				end
			end
			if KBM.PercentageMon.Active then
				if KBM.PercentageMon.Current then
					if KBM.PercentageMon.Current.BossL.UnitObj == UnitObj then
						KBM.PercentageMon:SetPercentL()
					elseif KBM.PercentageMon.Current.BossR.UnitObj == UnitObj then	
						KBM.PercentageMon:SetPercentR()
					end
				end
			end
		end
	end
end

function KBM.Unit.Available(handle, UnitObj)
	if KBM.Encounter then
		if UnitObj.Loaded then
			if not UnitObj.Player then
				if not KBM.BossID[UnitObj.UnitID] then
					KBM.CheckActiveBoss(UnitObj)
				else
					KBM.BossID[UnitObj.UnitID].Boss.UnitObj = UnitObj
				end
			end
		end
	end
end

function KBM.Unit.Removed(handle, Units)
	for UnitID, UnitObj in pairs(Units) do
		KBM.IgnoreList[UnitID] = nil
	end
end

function KBM.Unit.Mark(handle, Units)
	if KBM.PercentageMon.Active then
		if KBM.PercentageMon.Settings.Marks then
			if KBM.PercentageMon.Current then
				for UnitID, UnitObj in pairs(Units) do
					if KBM.PercentageMon.Current.BossL.UnitObj == UnitObj then
						KBM.PercentageMon:SetMarkL()
					elseif KBM.PercentageMon.Current.BossR.UnitObj == UnitObj then	
						KBM.PercentageMon:SetMarkR()
					end
				end
			end
		end
	end
end

function KBM.CreateEditFrame(parent, hook, layer)
	local df = UI.CreateFrame("Frame", parent:GetName().."_DragFrame", parent)	
	df:SetLayer(layer or 10)
	df:SetAllPoints(parent)
	df:SetVisible(false)
	df._hook = hook
	
	local EventFunc = {}
	function EventFunc:HandleMouseDown()
		local Mouse = Inspect.Mouse()
		
		self:SetBackgroundColor(0,0,0,0.5)
		self._offset = {
			x = (Mouse.x - (self:GetLeft() + (self:GetWidth() * 0.5))) or 0,
			y = (Mouse.y - (self:GetTop() + (self:GetHeight() * 0.5))) or 0,
		}
		if self._hook then
			self._hook("start")
		end
		
		self:EventAttach(Event.UI.Input.Mouse.Cursor.Move, EventFunc.HandleMouseMove, "KBM-EditFrame-MouseMoveHandler_"..parent:GetName())
		self._moving = true
	end
	
	function EventFunc:HandleMouseMove(handle, x, y)
		if self._moving then
			self:GetParent():SetPoint("CENTER", UIParent, "TOPLEFT", x - self._offset.x, y - self._offset.y)
		end
	end
	
	function EventFunc:HandleMouseUp()
		if self._moving then
			local Mouse = Inspect.Mouse()
			
			self:SetBackgroundColor(0,0,0,0)
			self:EventDetach(Event.UI.Input.Mouse.Cursor.Move, EventFunc.HandleMouseMove)
			local relX = (Mouse.x - self._offset.x) / UIParent:GetWidth()
			local relY = (Mouse.y - self._offset.y) / UIParent:GetHeight()
			self._offset = nil
			
			if self._hook then
				self._hook("end", relX, relY)
			end
			self:GetParent():SetPoint("CENTER", UIParent, relX, relY)
			self._moving = false
		end
	end
		
	-- function BarObj:unlockSize(bool)
		-- if bool then
			-- ui.editFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, EventFunc.HandleMouseWheelForward, "LibSCast-EditFrame-MouseWheelForwardHandler_"..ui.cradle:GetName())
			-- ui.editFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Back, EventFunc.HandleMouseWheelBack, "LibSCast-EditFrame-MouseWheelBackHandler_"..ui.cradle:GetName())
			-- ui.editFrame:EventAttach(Event.UI.Input.Mouse.Middle.Click, EventFunc.HandleMouseWheelClick, "LibSCast-EditFrame-MouseMiddleClickHandler_"..ui.cradle:GetName())
		-- else
			-- ui.editFrame:EventDetach(Event.UI.Input.Mouse.Wheel.Forward, EventFunc.HandleMouseWheelForward)
			-- ui.editFrame:EventDetach(Event.UI.Input.Mouse.Wheel.Back, EventFunc.HandleMouseWheelBack)
			-- ui.editFrame:EventDetach(Event.UI.Input.Mouse.Middle.Click, EventFunc.HandleMouseWheelClick)		
		-- end
	-- end
	
	df:EventAttach(Event.UI.Input.Mouse.Left.Down, EventFunc.HandleMouseDown, "KBM-EditFrame-MouseDownHandler_"..parent:GetName())
	df:EventAttach(Event.UI.Input.Mouse.Left.Up, EventFunc.HandleMouseUp, "KBM-EditFrame-MouseUpHandler_"..parent:GetName())
	df:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, EventFunc.HandleMouseUp, "KBM-EditFrame-MouseUpoutsideHandler_"..parent:GetName())
	
	return df
end

function KBM.AttachDragFrame(parent, hook, name, layer)
	if not name then name = "" end
	if not layer then layer = 0 end
	
	local Drag = {}
	Drag.Frame = UI.CreateFrame("Frame", "Drag Frame", parent)
	Drag.Frame:SetPoint("TOPLEFT", parent, "TOPLEFT")
	Drag.Frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
	Drag.Frame.parent = parent
	Drag.Frame.MouseDown = false
	Drag.Frame:SetLayer(layer)
	Drag.hook = hook
	Drag.Layer = parent:GetLayer()
	Drag.Parent = parent
	Drag.FrameEvents = {}
	Drag.Frame.FrameEvents = Drag.FrameEvents
	
	function Drag.FrameEvents:LeftDownHandler()
		self.MouseDown = true
		mouseData = Inspect.Mouse()
		self.MyStartX = self.parent:GetLeft()
		self.MyStartY = self.parent:GetTop()
		self.StartX = mouseData.x - self.MyStartX
		self.StartY = mouseData.y - self.MyStartY
		tempX = self.parent:GetLeft()
		tempY = self.parent:GetTop()
		tempW = self.parent:GetWidth()
		tempH =	self.parent:GetHeight()
		self.parent:ClearAll()
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", tempX, tempY)
		self.parent:SetWidth(tempW)
		self.parent:SetHeight(tempH)
		self:SetBackgroundColor(0,0,0,0.5)
		Drag.hook("start")
		Drag.Parent:SetLayer(KBM.Layer.DragActive)
	end
	
	function Drag.FrameEvents:MouseMoveHandler(handle, mouseX, mouseY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (mouseX - self.StartX), (mouseY - self.StartY))
		end
	end
	
	function Drag.FrameEvents:LeftUpHandler()
		if self.MouseDown then
			self.MouseDown = false
			self:SetBackgroundColor(0,0,0,0)
			Drag.hook("end")
			Drag.Parent:SetLayer(Drag.Layer)
		end
	end
	
	function Drag.Frame:Remove()	
		Drag.Frame:EventDettach(Event.UI.Input.Mouse.Left.Down, Drag.FrameEvents.LeftDownHandler)
		Drag.Frame:EventDettach(Event.UI.Input.Mouse.Cursor.Move, Drag.FrameEvents.MouseMoveHandler)
		Drag.Frame:EventDettach(Event.UI.Input.Mouse.Left.Up, Drag.FrameEvents.LeftUpHandler)
		Drag.hook = nil
		self:sRemove()
		self.Remove = nil		
	end
	
	Drag.Frame:EventAttach(Event.UI.Input.Mouse.Left.Down, Drag.FrameEvents.LeftDownHandler, "Drag Frame Left Down Handler: "..Drag.Parent:GetName())
	Drag.Frame:EventAttach(Event.UI.Input.Mouse.Cursor.Move, Drag.FrameEvents.MouseMoveHandler, "Drag Frame Mouse Move Handler: "..Drag.Parent:GetName())
	Drag.Frame:EventAttach(Event.UI.Input.Mouse.Left.Up, Drag.FrameEvents.LeftUpHandler, "Drag Frame Left Up Handler: "..Drag.Parent:GetName())
	return Drag.Frame
end

function KBM.TankSwap:Pull()
	local GUI = {}
	if #self.TankStore > 0 then
		GUI = table.remove(self.TankStore)
		GUI.TankAggro.Texture:SetVisible(false)
		for i = 1, 4 do
			GUI.DebuffFrame[i].Texture:SetVisible(false)
			KBM.LoadTexture(GUI.DebuffFrame[i].Texture, "Rift", self.DefaultTexture)
			GUI.DeCoolFrame[i]:SetVisible(false)
		end
	else
		GUI.Frame = UI.CreateFrame("Frame", "TankSwap_Frame", KBM.Context)
		GUI.Frame:SetLayer(1)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		GUI.TankAggro = UI.CreateFrame("Frame", "TankSwap_Aggro_Frame", GUI.Frame)
		GUI.TankAggro:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
		GUI.TankAggro:SetBackgroundColor(0,0,0,0)
		GUI.TankAggro.Texture = UI.CreateFrame("Texture", "TankSwap_Aggro_Texture", GUI.TankAggro)
		GUI.TankAggro.Texture:SetPoint("TOPLEFT", GUI.TankAggro, "TOPLEFT", 1, 1)
		GUI.TankAggro.Texture:SetPoint("BOTTOMRIGHT", GUI.TankAggro, "BOTTOMRIGHT", -1, -1)
		KBM.LoadTexture(GUI.TankAggro.Texture, "Rift", self.AggroTexture)
		GUI.TankAggro.Texture:SetAlpha(0.66)
		GUI.TankAggro.Texture:SetVisible(false)
		GUI.Dead = UI.CreateFrame("Texture", "TankSwap_Dead", GUI.TankAggro)
		KBM.LoadTexture(GUI.Dead, "KingMolinator", "Media/KBM_Death.png")
		GUI.Dead:SetLayer(1)
		GUI.Dead:SetPoint("TOPLEFT", GUI.TankAggro, "TOPLEFT", 1, 1)
		GUI.Dead:SetPoint("BOTTOMRIGHT", GUI.TankAggro, "BOTTOMRIGHT", -1, -1)
		GUI.Dead:SetAlpha(0.8)
		GUI.TankFrame = UI.CreateFrame("Frame", "TankSwap_Tank_Frame", GUI.Frame)
		GUI.TankFrame:SetPoint("TOPLEFT", GUI.TankAggro, "TOPRIGHT")
		GUI.TankFrame:SetPoint("BOTTOM", GUI.TankAggro, "BOTTOM")
		GUI.TankFrame:SetPoint("RIGHT", GUI.Frame, "RIGHT")
		GUI.TankHP = UI.CreateFrame("Texture", "TankSwap_Tank_HPFrame", GUI.TankFrame)
		KBM.LoadTexture(GUI.TankHP, "KingMolinator", "Media/BarTexture.png")
		GUI.TankHP:SetLayer(1)
		GUI.TankHP:SetBackgroundColor(0,0.8,0,0.33)
		GUI.TankHP:SetPoint("TOP", GUI.TankFrame, "TOP")
		GUI.TankHP:SetPoint("LEFT", GUI.TankFrame, "LEFT")
		GUI.TankHP:SetPoint("BOTTOM", GUI.TankFrame, "BOTTOM")
		GUI.TankShadow = UI.CreateFrame("Text", "TankSwap_Tank_Shadow", GUI.TankFrame)
		GUI.TankShadow:SetLayer(2)
		GUI.TankShadow:SetFontColor(0,0,0)
		GUI.TankText = UI.CreateFrame("Text", "TankSwap_Tank_Text", GUI.TankFrame)
		GUI.TankText:SetLayer(3)
		GUI.TankShadow:SetPoint("TOPLEFT", GUI.TankText, "TOPLEFT", 1, 1)
		GUI.TankText:SetPoint("CENTERLEFT", GUI.TankFrame, "CENTERLEFT", 2, 0)
		GUI.DebuffFrame = {}
		GUI.DeCoolFrame = {}
		GUI.DeCool = {}
		for i = 1, 4 do
			GUI.DebuffFrame[i] = UI.CreateFrame("Frame", "TankSwap_Debuff_Frame_"..i, GUI.Frame)
			GUI.DebuffFrame[i]:SetPoint("LEFT", GUI.Frame, "LEFT")
			if i > 2 then
				GUI.DebuffFrame[i]:SetPoint("TOP", GUI.DebuffFrame[1], "BOTTOM")
			else
				GUI.DebuffFrame[i]:SetPoint("TOP", GUI.TankHP, "BOTTOM")
			end
			GUI.DebuffFrame[i]:SetWidth(math.floor(GUI.Frame:GetHeight() * 0.5))
			GUI.DebuffFrame[i]:SetHeight(GUI.DebuffFrame[i]:GetWidth())
			GUI.DebuffFrame[i]:SetBackgroundColor(0,0,0,0)
			GUI.DebuffFrame[i]:SetLayer(1)
			GUI.DebuffFrame[i].Texture = UI.CreateFrame("Texture", "TankSwap_Debuff_Texture_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Texture:SetPoint("TOPLEFT", GUI.DebuffFrame[i], "TOPLEFT")
			GUI.DebuffFrame[i].Texture:SetPoint("BOTTOMRIGHT", GUI.DebuffFrame[i], "BOTTOMRIGHT")
			GUI.DebuffFrame[i].Texture:SetAlpha(0.33)
			KBM.LoadTexture(GUI.DebuffFrame[i].Texture, "Rift", self.DefaultTexture)
			GUI.DebuffFrame[i].Texture:SetVisible(false)
			GUI.DebuffFrame[i].Shadow = UI.CreateFrame("Text", "TankSwap_Debuff_Shadow_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DebuffFrame[i].Shadow:SetFontColor(0,0,0)
			GUI.DebuffFrame[i].Shadow:SetLayer(2)
			GUI.DebuffFrame[i].Text = UI.CreateFrame("Text", "TankSwap_Debuff_Text_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DebuffFrame[i].Text:SetLayer(3)
			GUI.DebuffFrame[i].Shadow:SetPoint("TOPLEFT", GUI.DebuffFrame[i].Text, "TOPLEFT", 1, 1)
			GUI.DebuffFrame[i].Text:SetPoint("CENTER", GUI.DebuffFrame[i], "CENTER")
			GUI.DeCoolFrame[i] = UI.CreateFrame("Texture", "TankSwap_CDFrame", GUI.Frame)
			GUI.DeCoolFrame[i]:SetPoint("TOPLEFT", GUI.DebuffFrame[i], "TOPRIGHT")
			GUI.DeCoolFrame[i]:SetPoint("BOTTOM", GUI.DebuffFrame[i], "BOTTOM")
			GUI.DeCoolFrame[i]:SetPoint("RIGHT", GUI.Frame, "RIGHT")
			GUI.DeCoolFrame[i]:SetBackgroundColor(0,0,0,0.33)
			GUI.DeCool[i] = UI.CreateFrame("Texture", "TankSwap_CD_Progress_"..i, GUI.DeCoolFrame[i])
			KBM.LoadTexture(GUI.DeCool[i], "KingMolinator", "Media/BarTexture.png")
			GUI.DeCool[i]:SetPoint("TOPLEFT", GUI.DeCoolFrame[i], "TOPLEFT")
			GUI.DeCool[i]:SetPoint("BOTTOM", GUI.DeCoolFrame[i], "BOTTOM")
			GUI.DeCool[i]:SetWidth(0)
			GUI.DeCool[i]:SetBackgroundColor(0.5,0,8,0.33)
			GUI.DeCool[i].Shadow = UI.CreateFrame("Text", "TankSwap_CD_Shadow_"..i, GUI.DeCoolFrame[i])
			GUI.DeCool[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DeCool[i].Shadow:SetFontColor(0,0,0)
			GUI.DeCool[i].Shadow:SetLayer(2)
			GUI.DeCool[i].Text = UI.CreateFrame("Text", "TankSwap_CD_Text_"..i, GUI.DeCoolFrame[i])
			GUI.DeCool[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DeCool[i].Shadow:SetPoint("TOPLEFT", GUI.DeCool[i].Text, "TOPLEFT", 1, 1)
			GUI.DeCool[i].Text:SetPoint("CENTER", GUI.DeCoolFrame[i], "CENTER")
			GUI.DeCool[i].Text:SetLayer(3)
		end
		function GUI:SetTank(Text)
			self.TankShadow:SetText(Text)
			self.TankText:SetText(Text)
		end
		function GUI:SetDeCool(Text, iBuff)
			self.DeCool[iBuff].Shadow:SetText(Text)
			self.DeCool[iBuff].Text:SetText(Text)
		end
		function GUI:SetStack(Text, iBuff)
			self.DebuffFrame[iBuff].Shadow:SetText(Text)
			self.DebuffFrame[iBuff].Text:SetText(Text)
		end
		function GUI:SetDeath(bool)
			if bool then
				self.TankText:SetAlpha(0.5)
				for i = 1, 4 do
					self.DebuffFrame[i].Shadow:SetVisible(false)
					self.DebuffFrame[i].Text:SetVisible(false)
					self.DebuffFrame[i].Texture:SetVisible(false)
					self.DeCoolFrame[i]:SetVisible(false)
				end
				self.Dead:SetVisible(true)
				self.TankAggro.Texture:SetVisible(false)
				self.TankHP:SetVisible(false)
			else
				self.TankText:SetAlpha(1)
				self.Dead:SetVisible(false)
				self.TankHP:SetVisible(true)
				for i = 1, 4 do
					self.DebuffFrame[i].Shadow:SetVisible(true)
					self.DebuffFrame[i].Text:SetVisible(true)
					self.DeCoolFrame[i]:SetVisible(false)
				end
			end			
		end
	end
	self:ApplySettings(GUI)
	return GUI
end

function KBM.TankSwap:Init()
	self.Tanks = {}
	self.TankCount = 0
	self.DefaultTexture = "Data/\\UI\\ability_icons\\generic_ability_001.dds"
	self.AggroTexture = "Data/\\UI\\ability_icons\\weaponsmith1a.dds"
	self.Active = false
	self.DebuffID = {}
	self.Debuffs = 0
	self.DebuffName = {}
	self.DebuffList = {}
	self.Boss = {}
	self.LastTank = nil
	self.Test = false
	self.TankStore = {}
	self.Settings = KBM.Options.TankSwap
	self.Enabled = self.Settings.Enabled
	self.Anchor = UI.CreateFrame("Frame", "Tank-Swap_Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Constant.TankSwap.w * self.Settings.wScale)
	self.Anchor:SetHeight(KBM.Constant.TankSwap.h * self.Settings.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor:SetLayer(5)
	
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("CENTER", UIParent, "CENTER")
	end
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.TankSwap.Settings.x = self:GetLeft()
			KBM.TankSwap.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "TankSwap info", self.Anchor)
	self.Anchor.Text:SetText(KBM.Language.Anchors.TankSwap[KBM.Lang])
	self.Anchor.Text:SetFontSize(KBM.Constant.TankSwap.TextSize * self.Settings.tScale)
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "TS Anchor Drag", 2)
	
	function self.Anchor.Drag:WheelForwardHandler()
		if KBM.TankSwap.Settings.ScaleWidth then
			if KBM.TankSwap.Settings.wScale < 1.5 then
				KBM.TankSwap.Settings.wScale = KBM.TankSwap.Settings.wScale + 0.025
				if KBM.TankSwap.Settings.wScale > 1.5 then
					KBM.TankSwap.Settings.wScale = 1.5
				end
				KBM.TankSwap.Anchor:SetWidth(math.floor(KBM.TankSwap.Settings.wScale * KBM.Constant.TankSwap.w))
				if KBM.TankSwap.Settings.hScale >= KBM.TankSwap.Settings.wScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.wScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
		
		if KBM.TankSwap.Settings.ScaleHeight then
			if KBM.TankSwap.Settings.hScale < 1.5 then
				KBM.TankSwap.Settings.hScale = KBM.TankSwap.Settings.hScale + 0.025
				if KBM.TankSwap.Settings.hScale > 1.5 then
					KBM.TankSwap.Settings.hScale = 1.5
				end
				KBM.TankSwap.Anchor:SetHeight(math.floor(KBM.TankSwap.Settings.hScale * KBM.Constant.TankSwap.h))
				if KBM.TankSwap.Settings.wScale >= KBM.TankSwap.Settings.hScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.hScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
	end

	function self.Anchor.Drag:WheelBackHandler()
		if KBM.TankSwap.Settings.ScaleWidth then
			if KBM.TankSwap.Settings.wScale > 0.5 then
				KBM.TankSwap.Settings.wScale = KBM.TankSwap.Settings.wScale - 0.025
				if KBM.TankSwap.Settings.wScale < 0.5 then
					KBM.TankSwap.Settings.wScale = 0.5
				end
				KBM.TankSwap.Anchor:SetWidth(math.floor(KBM.TankSwap.Settings.wScale * KBM.Constant.TankSwap.w))
				if KBM.TankSwap.Settings.hScale >= KBM.TankSwap.Settings.wScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.wScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
		
		if KBM.TankSwap.Settings.ScaleHeight then
			if KBM.TankSwap.Settings.hScale > 0.5 then
				KBM.TankSwap.Settings.hScale = KBM.TankSwap.Settings.hScale - 0.025
				if KBM.TankSwap.Settings.hScale < 0.5 then
					KBM.TankSwap.Settings.hScale = 0.5
				end
				KBM.TankSwap.Anchor:SetHeight(math.floor(KBM.TankSwap.Settings.hScale * KBM.Constant.TankSwap.h))
				if KBM.TankSwap.Settings.wScale >= KBM.TankSwap.Settings.hScale then
					KBM.TankSwap.Settings.tScale = KBM.TankSwap.Settings.hScale
				end
				KBM.TankSwap.Anchor.Text:SetFontSize(math.floor(KBM.Constant.TankSwap.TextSize * KBM.TankSwap.Settings.tScale))
			end
		end
	end
		
	self.Anchor.Drag:EventAttach(Event.UI.Input.Mouse.Wheel.Back, self.Anchor.Drag.WheelBackHandler, "wheelback")
	self.Anchor.Drag:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, self.Anchor.Drag.WheelForwardHandler, "wheelforward")
	
	if KBM.Menu.Active then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
	
	function self:ApplySettings(GUI)
		GUI.Frame:SetHeight(math.ceil(KBM.Constant.TankSwap.h * KBM.Options.TankSwap.hScale))
		GUI.TankAggro:SetHeight(math.floor(GUI.Frame:GetHeight() * 0.5))
		GUI.TankAggro:SetWidth(GUI.TankAggro:GetHeight())
		GUI.TankHP:SetWidth(GUI.TankFrame:GetWidth())		
		GUI.TankShadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
		GUI.TankText:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
		for i = 1, 4 do
			GUI.DebuffFrame[i]:SetWidth(math.floor(GUI.Frame:GetHeight() * 0.5))
			GUI.DebuffFrame[i]:SetHeight(GUI.DebuffFrame[i]:GetWidth())
			GUI.DebuffFrame[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DebuffFrame[i].Shadow:SetFontColor(0,0,0)
			GUI.DebuffFrame[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DeCool[i].Shadow:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
			GUI.DeCool[i].Text:SetFontSize(KBM.Constant.TankSwap.TextSize * KBM.Options.TankSwap.tScale)
		end
	end
			
	function self:Add(UnitID, Test)		
		if self.Test and not Test then
			self:Remove()
			self.Anchor:SetVisible(false)
		end
		if Test then
			self.Debuffs = 4
		end
		local TankObj = {}
		TankObj.UnitID = UnitID
		TankObj.DebuffList = {}
		TankObj.DebuffName = {}
		TankObj.Test = Test
		TankObj.TargetCount = 0
		for i = 1, self.Debuffs do
			TankObj.DebuffList[i] = {
				ID = nil,
				Stacks = 0,
				Remaining = 0,
			}
			if not Test then
				TankObj.DebuffName[self.DebuffList[i].Name] = TankObj.DebuffList[i]
			end
		end
		self.Active = true
		TankObj.Dead = false
		
		if Test then
			TankObj.Name = Test
			TankObj.UnitID = Test
			self.Test = true
			TankObj.Dead = false
		else
			TankObj.Unit = LibSUnit.Lookup.UID[UnitID]
			if TankObj.Unit then
				TankObj.Name = TankObj.Unit.Name or "<Unknown>"
				if TankObj.Unit.Dead and TankObj.Unit.Health then
					if TankObj.Unit.Health > 0 then
						TankObj.Dead = false
					else
						TankObj.Dead = true
					end
				else
					TankObj.Dead = true
				end
			end
		end
		
		TankObj.GUI = KBM.TankSwap:Pull()
		TankObj.GUI:SetTank(TankObj.Name)
		
		if self.TankCount == 0 then
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
			TankObj.GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		else
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.LastTank.GUI.Frame, "BOTTOMLEFT", 0, 2)
			TankObj.GUI.Frame:SetPoint("RIGHT", self.LastTank.GUI.Frame, "RIGHT")
		end
		
		self.LastTank = TankObj
		self.Tanks[TankObj.UnitID] = TankObj
		self.TankCount = self.TankCount + 1
		
		function TankObj:BuffUpdate(DebuffID, DebuffName)
			self.DebuffName[DebuffName].ID = DebuffID
		end
		
		function TankObj:Death()
			self.Dead = true
			self.GUI:SetDeath(true)
		end
		
		function TankObj:UpdateHP()
			if self.Unit.Health then
				if self.Unit.Health > 0 then
					if self.Dead then
						self.GUI:SetDeath(false)
						self.Dead = false
					end
					self.GUI.TankHP:SetWidth(math.ceil(self.GUI.TankFrame:GetWidth() * self.Unit.PercentRaw))
				elseif not self.Dead then
					self:Death()
				end
			elseif not self.Dead then
				self:Death()
			end
		end
		
		TankObj.GUI:SetDeath(TankObj.Dead)
		if self.Debuffs > 2 then
			TankObj.GUI.Frame:SetHeight(TankObj.GUI.DeCoolFrame[1]:GetHeight() * 3)
		else
			TankObj.GUI.Frame:SetHeight(TankObj.GUI.DeCoolFrame[1]:GetHeight() * 2)
		end
		if self.Test then
			for i = 1, 4 do
				local Visible = true
				if i > self.Debuffs then
					Visible = false
				end
				TankObj.GUI:SetStack("2", i)
				TankObj.GUI:SetDeCool("99.9", i)
				TankObj.GUI.DeCoolFrame[i]:SetVisible(Visible)
				TankObj.GUI.DeCool[i]:SetWidth(TankObj.GUI.DeCoolFrame[i]:GetWidth())
				TankObj.GUI.DebuffFrame[i].Texture:SetVisible(Visible)
			end
			TankObj.GUI.TankHP:SetWidth(TankObj.GUI.TankFrame:GetWidth())
			if self.Debuffs > 1 then
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
				TankObj.GUI.DebuffFrame[2]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
				TankObj.GUI.DeCool[1]:SetWidth(TankObj.GUI.DeCoolFrame[1]:GetWidth())
				TankObj.GUI.DeCool[2]:SetWidth(TankObj.GUI.DeCoolFrame[2]:GetWidth())
				if self.Debuffs > 3 then
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
					TankObj.GUI.DebuffFrame[4]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
					TankObj.GUI.DeCool[3]:SetWidth(TankObj.GUI.DeCoolFrame[3]:GetWidth())
					TankObj.GUI.DeCool[4]:SetWidth(TankObj.GUI.DeCoolFrame[4]:GetWidth())
				else
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
				end
			else
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
			end
		else
			for i = 1, 4 do
				TankObj.GUI:SetStack("", i)
				TankObj.GUI:SetDeCool("", i)
				TankObj.GUI.DeCoolFrame[i]:SetVisible(false)
				TankObj.GUI.DeCool[i]:SetWidth(TankObj.GUI.DeCoolFrame[i]:GetWidth())
				TankObj.GUI.DebuffFrame[i].Texture:SetVisible(false)				
			end
			if self.Debuffs > 1 then
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
				TankObj.GUI.DebuffFrame[2]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
				if self.Debuffs > 3 then
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
					TankObj.GUI.DebuffFrame[4]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
				else
					TankObj.GUI.DeCoolFrame[3]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
				end
			else
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
			end
		end
		TankObj.GUI.Frame:SetVisible(true)
		return TankObj		
	end
	
	function self:AddBoss(UnitID)
		if self.Active then
			if self.Boss then
				self.Boss[UnitID] = false
			end
		end
	end
	
	function self:Start(DebuffName, BossID, Debuffs)
		if not BossID then 
			return
		end
		if self.Settings.Enabled then
			if (LibSUnit.Player.Role == "tank" and self.Settings.Tank == true) or self.Settings.Tank == false then
				if self.Active then
					self:Remove()
				end
				self.Active = true
				local Spec = ""
				local UnitID = ""
				local uDetails = nil
				self.Boss = {
					[BossID] = false,
				}
				self.CurrentTarget = nil
				self.CurrentIcon = nil
				self.DebuffList = {}
				self.DebuffName = {}
				if type(DebuffName) == "table" then
					for i, DebuffName in ipairs(DebuffName) do
						self:AddDebuff(DebuffName, i)
					end
				else
					self:AddDebuff(DebuffName, 1)
				end
				self.Debuffs = Debuffs or 1
				if LibSUnit.Raid.Grouped then
					local _specList = LibSUnit.Lookup.SpecList
					for i = 1, 20 do
						if LibSUnit.Raid.Lookup[_specList[i]] then
							UnitObj = LibSUnit.Raid.Lookup[_specList[i]].Unit
							if UnitObj then
								if UnitObj.UnitID then
									if UnitObj.Role == "tank" then
										self:Add(UnitObj.UnitID)
									end
								end
							end
						end
					end
					-- for UnitID, UnitObj in pairs(LibSUnit.Raid.UID) do
						-- if UnitID then
							-- if UnitObj.Role == "tank" then
								-- self:Add(UnitID)
							-- end
						-- end
					-- end
				end
			end
			local EventData = {
				DebuffList = self.DebuffName,
				Enabled = KBM.Options.TankSwap.Enabled,
			}
			KBM.Event.System.TankSwap.Start(EventData)
		end
	end
	
	function self:AddDebuff(DebuffName, Index)
		self.DebuffList[Index] = {
			Name = DebuffName,
			Index = Index,
		}
		self.DebuffName[DebuffName] = self.DebuffList[Index]
	end
		
	function self:Update()	
		local uDetails = ""
		for UnitID, TankObj in pairs(self.Tanks) do
			for i = 1, self.Debuffs do
				if TankObj.DebuffList[i].ID then
					local DebuffObj = TankObj.DebuffList[i]
					local bDetails = Inspect.Buff.Detail(UnitID, TankObj.DebuffList[i].ID)
					if bDetails then
						if bDetails.stack then
							DebuffObj.Stacks = bDetails.stack
						else
							DebuffObj.Stacks = 1
						end
						DebuffObj.Remaining = (bDetails.remaining or 0.0)
						DebuffObj.Duration = (bDetails.duration or 1.0)
						if bDetails.icon then
							DebuffObj.Icon = bDetails.icon
						else
							DebuffObj.Icon = self.DefaultTexture
						end
						if DebuffObj.Remaining > 9.94 then
							TankObj.GUI:SetDeCool(KBM.ConvertTime(DebuffObj.Remaining), i)
							TankObj.GUI.DeCool[i]:SetWidth(math.ceil(TankObj.GUI.DeCoolFrame[i]:GetWidth() * (DebuffObj.Remaining/DebuffObj.Duration)))
						elseif DebuffObj.Remaining > 0 then
							TankObj.GUI:SetDeCool(string.format("%0.01f", DebuffObj.Remaining), i)
							TankObj.GUI.DeCool[i]:SetWidth(math.ceil(TankObj.GUI.DeCoolFrame[i]:GetWidth() * (DebuffObj.Remaining/DebuffObj.Duration)))
						else
							TankObj.GUI:SetDeCool("-", i)
							TankObj.GUI.DeCool[i]:SetWidth(0)
						end
						TankObj.GUI:SetStack(tostring(DebuffObj.Stacks), i)
						KBM.LoadTexture(TankObj.GUI.DebuffFrame[i].Texture, "Rift", DebuffObj.Icon)
						TankObj.GUI.DebuffFrame[i].Texture:SetVisible(true)
						TankObj.GUI.DeCoolFrame[i]:SetVisible(true)
					else
						TankObj.GUI.DeCoolFrame[i]:SetVisible(false)
						TankObj.GUI.DeCool[i]:SetWidth(0)
						TankObj.GUI:SetDeCool("", i)
						TankObj.GUI:SetStack("", i)
						TankObj.GUI.DebuffFrame[i].Texture:SetVisible(false)
						TankObj.DebuffList[i].ID = nil
					end
				end
			end
			TankObj:UpdateHP()
			for UnitID, CurrentTarget in pairs(self.Boss) do
				local BossObj = LibSUnit.Lookup.UID[UnitID]
				if BossObj then
					if BossObj.Target then
						if self.Tanks[BossObj.Target] then
							if self.Tanks[BossObj.Target] ~= CurrentTarget then
								if CurrentTarget then
									CurrentTarget.TargetCount = CurrentTarget.TargetCount - 1
									if CurrentTarget.TargetCount == 0 then
										CurrentTarget.GUI.TankAggro.Texture:SetVisible(false)
									end
								end
								self.Boss[UnitID] = self.Tanks[BossObj.Target]
								self.Boss[UnitID].GUI.TankAggro.Texture:SetVisible(true)
								self.Boss[UnitID].TargetCount = self.Boss[UnitID].TargetCount + 1
							end
						end
					end
				end
			end
		end	
	end
	
	function self:Remove()
		for UnitID, TankObj in pairs(self.Tanks) do
			table.insert(self.TankStore, TankObj.GUI)
			TankObj.GUI.Frame:SetVisible(false)
			TankObj.GUI = nil
		end
		self.Active = false
		self.DebuffName = {}
		self.DebuffID = {}
		self.Tanks = {}
		self.LastTank = nil
		self.TankCount = 0
		self.Boss = {}
		if not self.Test then
			KBM.Event.System.TankSwap.End()
		end
		self.Test = false
	end	
end

function KBM.Alert:Init()
	function self:ApplySettings()
		self.Anchor:ClearAll()
		self.Text:SetFontSize(KBM.Constant.Alerts.TextSize * self.Settings.tScale)
		self.Shadow:SetFontSize(self.Text:GetFontSize())
		if self.Settings.x then
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		else
			self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
			self.Anchor:SetPoint("CENTERY", UIParent, nil, 0.25)
		end	
		self.Notify = self.Settings.Notify
		self.Flash = self.Settings.Flash
		self.Enabled = self.Settings.Enabled
		self.AlertControl.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
		self.AlertControl.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
		self.AlertControl.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
		self.AlertControl.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		if KBM.Menu.Active then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor.Drag:SetVisible(self.Settings.Visible)
			if self.Settings.Vertical then
				self.Left.red:SetVisible(self.Settings.Visible)
				self.Right.red:SetVisible(self.Settings.Visible)
			else
				self.Left.red:SetVisible(false)
				self.Right.red:SetVisible(false)
			end
			if self.Settings.Horizontal then
				self.Top.red:SetVisible(self.Settings.Visible)
				self.Bottom.red:SetVisible(self.Settings.Visible)
			else
				self.Top.red:SetVisible(false)
				self.Bottom.red:SetVisible(false)
			end
			if self.Settings.Visible then
				if self.Settings.Vertical then
					self.AlertControl.Left:SetVisible(self.Settings.FlashUnlocked)
					self.AlertControl.Right:SetVisible(self.Settings.FlashUnlocked)
				end
				if self.Settings.Horizontal then
					self.AlertControl.Top:SetVisible(self.Settings.FlashUnlocked)
					self.AlertControl.Bottom:SetVisible(self.Settings.FlashUnlocked)
				end
			end
		else
			self.Anchor:SetVisible(false)
			self.Anchor.Drag:SetVisible(false)
			self.Left.red:SetVisible(false)
			self.Right.red:SetVisible(false)
			self.Top.red:SetVisible(false)
			self.Bottom.red:SetVisible(false)
			self.AlertControl.Left:SetVisible(false)
			self.AlertControl.Right:SetVisible(false)
			self.AlertControl.Top:SetVisible(false)
			self.AlertControl.Bottom:SetVisible(false)
		end
	end

	self.List = {}
	self.Settings = KBM.Options.Alerts
	self.Anchor = UI.CreateFrame("Frame", "Alert Text Anchor", KBM.Context)
	self.Anchor:SetBackgroundColor(0,0,0,0)
	self.Anchor:SetLayer(KBM.Layer.DragInactive)
	self.Shadow = UI.CreateFrame("Text", "Alert Text Outline", self.Anchor)
	self.Shadow:SetFontColor(0,0,0)
	self.Shadow:SetLayer(1)
	self.Text = UI.CreateFrame("Text", "Alert Text", self.Anchor)
	self.Shadow:SetPoint("CENTER", self.Text, "CENTER", 2, 2)
	self.Text:SetText(KBM.Language.Anchors.AlertText[KBM.Lang])
	self.Shadow:SetText(self.Text:GetText())
	self.Shadow:SetFontSize(self.Text:GetFontSize())
	self.Text:SetFontColor(1,1,1)
	self.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Text:SetLayer(2)
	self.Anchor:SetVisible(self.Settings.Visible)
	self.ColorList = {"red", "blue", "cyan", "yellow", "orange", "purple", "dark_green", "pink", "dark_grey"}
	self.Left = {}
	self.Right = {}
	self.Top = {}
	self.Bottom = {}
	self.Count = 0
	self.AlertControl = {}
	self.AlertControl.Left = UI.CreateFrame("Frame", "Left_Alert_Controller", KBM.Context)
	self.AlertControl.Left:SetVisible(false)
	self.AlertControl.Left:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Left:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	self.AlertControl.Left:SetPoint("BOTTOM", UIParent, "BOTTOM")
	self.AlertControl.Right = UI.CreateFrame("Frame", "Right_Alert_Controller", KBM.Context)
	self.AlertControl.Right:SetVisible(false)
	self.AlertControl.Right:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Right:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
	self.AlertControl.Right:SetPoint("BOTTOM", UIParent, "BOTTOM")
	self.AlertControl.Top = UI.CreateFrame("Frame", "Top_Alert_Controller", KBM.Context)
	self.AlertControl.Top:SetVisible(false)
	self.AlertControl.Top:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Top:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	self.AlertControl.Top:SetPoint("RIGHT", UIParent, "RIGHT")
	self.AlertControl.Bottom = UI.CreateFrame("Frame", "Bottom_Alert_Controller", KBM.Context)
	self.AlertControl.Bottom:SetVisible(false)
	self.AlertControl.Bottom:SetLayer(KBM.Layer.DragInactive)
	self.AlertControl.Bottom:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
	self.AlertControl.Bottom:SetPoint("RIGHT", UIParent, "RIGHT")
	
	for _t, Color in ipairs(self.ColorList) do
		self.Left[Color] = UI.CreateFrame("Texture", "Left_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Left[Color], "KingMolinator", "Media/Alert_Left_"..Color..".png")
		self.Left[Color]:SetPoint("TOPLEFT", self.AlertControl.Left, "TOPLEFT")
		self.Left[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Left, "BOTTOMRIGHT")
		self.Left[Color]:SetVisible(false)
		self.Left[Color]:SetLayer(KBM.Layer.Alerts)
		self.Right[Color] = UI.CreateFrame("Texture", "Right_Alert"..Color, KBM.Context)
		KBM.LoadTexture(self.Right[Color], "KingMolinator", "Media/Alert_Right_"..Color..".png")
		self.Right[Color]:SetPoint("TOPLEFT", self.AlertControl.Right, "TOPLEFT")
		self.Right[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Right, "BOTTOMRIGHT")
		self.Right[Color]:SetVisible(false)
		self.Right[Color]:SetLayer(KBM.Layer.Alerts)
		self.Top[Color] = UI.CreateFrame("Texture", "Top_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Top[Color], "KingMolinator", "Media/Alert_Top_"..Color..".png")
		self.Top[Color]:SetPoint("TOPLEFT", self.AlertControl.Top, "TOPLEFT")
		self.Top[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Top, "BOTTOMRIGHT")
		self.Top[Color]:SetVisible(false)
		self.Top[Color]:SetLayer(KBM.Layer.Alerts)
		self.Bottom[Color] = UI.CreateFrame("Texture", "Bottom_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Bottom[Color], "KingMolinator", "Media/Alert_Bottom_"..Color..".png")
		self.Bottom[Color]:SetPoint("TOPLEFT", self.AlertControl.Bottom, "TOPLEFT")
		self.Bottom[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Bottom, "BOTTOMRIGHT")
		self.Bottom[Color]:SetVisible(false)
		self.Bottom[Color]:SetLayer(KBM.Layer.Alerts)
	end
	
	self.AlertControl.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
	self.AlertControl.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
	self.AlertControl.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
	self.AlertControl.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
	
	function self.AlertControl:WheelBack()
		if KBM.Alert.Settings.fScale < 1.5 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale + 0.05
			if KBM.Alert.Settings.fScale > 1.5 then
				KBM.Alert.Settings.fScale = 1.5
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
			self.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
			self.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		end
	end
	
	function self.AlertControl:WheelForward()
		if KBM.Alert.Settings.fScale > 0.15 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale - 0.05
			if KBM.Alert.Settings.fScale < 0.15 then
				KBM.Alert.Settings.fScale = 0.15
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
			self.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
			self.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		end	
	end
	
	function self.AlertControl.Left.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Left.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Right.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Right.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Top.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Top.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Bottom.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Bottom.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	self.Current = nil
	self.StopTime = 0
	self.Remaining = 0
	self.Alpha = 1
	self.Queue = {}
	self.Speed = 0.025
	self.Direction = -self.Speed
	self.Color = "red"
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Alert.Settings.x = self:GetLeft()
			KBM.Alert.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Alert Anchor Drag", 2)
	self.Anchor.Drag:ClearAll()
	self.Anchor.Drag:SetPoint("TOPRIGHT", self.Text, "TOPRIGHT")
	self.Anchor.Drag:SetPoint("BOTTOMLEFT", self.Text, "BOTTOMLEFT")
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.Alert.Settings.ScaleText then
			if KBM.Alert.Settings.tScale < 2 then
				KBM.Alert.Settings.tScale = KBM.Alert.Settings.tScale + 0.02
				if KBM.Alert.Settings.tScale > 2 then
					KBM.Alert.Settings.tScale = 2
				end
				KBM.Alert.Shadow:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)
				KBM.Alert.Text:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)	
			end
		end		
	end
	
	function self.Anchor.Drag.Event:WheelBack()	
		if KBM.Alert.Settings.ScaleText then
			if KBM.Alert.Settings.tScale > 0.8 then
				KBM.Alert.Settings.tScale = KBM.Alert.Settings.tScale - 0.02
				if KBM.Alert.Settings.tScale < 0.8 then
					KBM.Alert.Settings.tScale = 0.8
				end
				KBM.Alert.Shadow:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)
				KBM.Alert.Text:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)	
			end
		end
	end
	
	function self:Create(Text, Duration, Flash, Countdown, Color)
		local AlertObj = {}
		AlertObj.DefDuration = Duration
		AlertObj.Duration = Duration
		AlertObj.Flash = Flash
		if not Color then
			AlertObj.Color = self.Color
		else
			AlertObj.Color = Color
		end
		AlertObj.Text = Text
		AlertObj.Countdown = Countdown
		AlertObj.Enabled = true
		AlertObj.Linked = nil
		AlertObj.AlertAfter = nil
		AlertObj.isImportant = false
		AlertObj.HasMenu = true
		AlertObj.Type = "alert"
		if type(Text) ~= "string" then
			error("Expecting String for Text, got: "..type(Text))
		end
		if not self.Left[AlertObj.Color] then
			error("Alert:Create() Invalid color supplied:- "..AlertObj.Color)
		end
		
		function AlertObj:AlertEnd(endAlertObj)
			if type(endAlertObj) == "table" then
				if endAlertObj.Type == "alert" then
					self.AlertAfter = endAlertObj
				else
					error("KBM.Alert:AlertEnd - Expecting Alert Object: Got "..tostring(endAlertObj.Type))
				end
			else
				error("KBM.Alert:AlertEnd - Expecting at least table: Got "..tostring(type(endAlertObj)))
			end
		end
		
		function AlertObj:TimerEnd(endTimerObj)
			if type(endTimerObj) == "table" then
				if endTimerObj.Type == "timer" then
					self.TimerAfter = endTimerObj
				else
					error("KBM.Alert:TimerEnd - Expecting Timer Object: Got "..tostring(endTimerObj.Type))
				end
			else
				error("KBM.Alert:TimerEnd - Expecting at least table: Got "..tostring(type(endTimerObj)))
			end
		end

		function AlertObj:Important()
			self.isImportant = true
		end
		
		function AlertObj:NoMenu()
			self.HasMenu = false
			self.Enabled = true
		end

		function AlertObj:SetLink(Alert)
			if type(Alert) == "table" then
				if Alert.Type ~= "alert" then
					error("Supplied Object is not an Alert, got: "..tostring(Alert.Type))
				else
					self.Link = Alert
					self:NoMenu()
					for SettingID, Value in pairs(self.Settings) do
						if SettingID ~= "ID" then
							self.Link.Settings[SettingID] = Value
						end
					end
					if not Alert.Linked then
						Alert.Linked = {}
					end
					table.insert(Alert.Linked, self)
				end
			else
				error("Expecting at least a table got: "..type(Alert))
			end		
		end
		
		self.Count = self.Count + 1
		table.insert(self.List, AlertObj)
		return AlertObj		
	end
	
	function self:Start(AlertObj, CurrentTime, Duration)
		local CurrentTime = Inspect.Time.Real()
		if self.Settings.Enabled then
			if AlertObj.Enabled then
				if self.Starting and not AlertObj.isImportant then
					if KBM.Debug then
						print("Alert starting overlap: Aborting")
					end
					return
				end
				if self.Active then
					if self.Current.Active then
						if not AlertObj.isImportant then
							if self.Current.isImportant then
								if not self.Current.Stopping then
									return
								end
							end
						end
						self.Starting = true
						self:Stop()
					end
				end
				self.Starting = true
				AlertObj.Active = true
				self.Duration = AlertObj.Duration
				if Duration then
					if not AlertObj.DefDuration then
						self.Duration = Duration
					end
				else
					if not AlertObj.DefDuration then
						self.Duration = 2
					else
						self.Duration = AlertObj.DefDuration
					end
				end
				self.Current = AlertObj
				AlertObj.Duration = self.Duration
				self.Alpha = 1.0
				if self.Settings.Flash then
					if not AlertObj.Settings then
						self.Color = AlertObj.Color
						AlertObj.Settings = KBM.Defaults.AlertObj()
					else
						if AlertObj.Settings.Custom then
							self.Color = AlertObj.Settings.Color
						else
							self.Color = AlertObj.Color
						end
					end
					if AlertObj.Settings.Border then
						if self.Settings.Vertical then
							self.Left[self.Color]:SetAlpha(1.0)
							self.Left[self.Color]:SetVisible(true)
							self.Right[self.Color]:SetAlpha(1.0)
							self.Right[self.Color]:SetVisible(true)
						end
						if self.Settings.Horizontal then
							self.Top[self.Color]:SetAlpha(1.0)
							self.Top[self.Color]:SetVisible(true)
							self.Bottom[self.Color]:SetAlpha(1.0)
							self.Bottom[self.Color]:SetVisible(true)						
						end
						self.Direction = false
						self.FadeStart = CurrentTime
					end
				end
				if self.Settings.Notify then
					if AlertObj.Text then
						if AlertObj.Settings.Notify then
							self.Shadow:SetText(AlertObj.Text)
							self.Text:SetText(AlertObj.Text)
							self.Anchor:SetVisible(true)
							self.Anchor:SetAlpha(1.0)
						end
					end
				end
				if self.Duration then
					self.StopTime = CurrentTime + AlertObj.Duration
					self.Remaining = self.StopTime - CurrentTime
				else
					self.StopTime = 0
				end
				self.Active = true
				self.Starting = false
				self:Update(CurrentTime)
			end
		end
	end
	
	function self:Stop(SpecObj)
		if (self.Current and not SpecObj) or (self.Current and SpecObj == self.Current) then
			if self.Current.Active then
				self.Current.Stopping = true
				self.Left[self.Color]:SetVisible(false)
				self.Right[self.Color]:SetVisible(false)
				self.Top[self.Color]:SetVisible(false)
				self.Bottom[self.Color]:SetVisible(false)
				self.Anchor:SetVisible(false)
				self.Shadow:SetText(" Alert Anchor ")
				self.Text:SetText(" Alert Anchor ")
				self.StopTime = 0
				self.Current.Active = false
				self.Current.Stopping = false
				self.Active = false
				if self.Current.AlertAfter and not self.Starting then
					if KBM.Encounter then
						KBM.Alert:Start(self.Current.AlertAfter, Inspect.Time.Real())
					end
				end
				if self.Current.TimerAfter then
					if KBM.Encounter then
						if not self.Current.TAStarted then
							KBM.MechTimer:AddStart(self.Current.TimerAfter)
							self.Current.TAStart = false
						end
					end
				end
			end
		end
	end	
	
	function self:Update(CurrentTime)
		local CurrentTime = Inspect.Time.Real()
		if self.Current.Stopping then
			if self.Alpha == 0 then
				self:Stop()
			else
				local TimeDiff = CurrentTime - self.FadeStart
				self.Alpha = 1.0 - (TimeDiff * 1.25)
				if self.Alpha < 0 then
					self.Alpha = 0.0
				end
				if self.Settings.Flash then
					if self.Current.Settings.Border then
						if self.Settings.Vertical then
							self.Left[self.Color]:SetAlpha(self.Alpha)
							self.Right[self.Color]:SetAlpha(self.Alpha)
						end
						if self.Settings.Horizontal then
							self.Top[self.Color]:SetAlpha(self.Alpha)
							self.Bottom[self.Color]:SetAlpha(self.Alpha)
						end
					end
				end
				if self.Settings.Notify then
					if self.Current.Settings.Notify then
						self.Anchor:SetAlpha(self.Alpha)
					end
				end
			end
		else
			if self.Settings.Flash then
				if self.Current.Flash then
					if self.Current.Settings.Border then
						local TimeDiff = CurrentTime - self.FadeStart
						if self.Direction then
							if TimeDiff > 0.5 then
								self.Alpha = 1.0
								self.Direction = false
								self.FadeStart = CurrentTime
							else
								self.Alpha = TimeDiff * 2
							end
						else
							if TimeDiff > 0.5 then
								self.Alpha = 0.0
								self.Direction = true
								self.FadeStart = CurrentTime
							else
								self.Alpha = 1.0 - (TimeDiff * 2)
							end
						end
						if self.Settings.Vertical then
							self.Left[self.Color]:SetAlpha(self.Alpha)
							self.Right[self.Color]:SetAlpha(self.Alpha)
						end
						if self.Settings.Horizontal then
							self.Top[self.Color]:SetAlpha(self.Alpha)
							self.Bottom[self.Color]:SetAlpha(self.Alpha)
						end
					end
				end
			end
			if self.Current.Countdown then
				if self.Remaining then
					self.Remaining = self.StopTime - CurrentTime
					if self.Current.Settings.Notify then
						if self.Remaining <= 0 then
							self.Remaining = 0
							self.Shadow:SetText(self.Current.Text)
							self.Text:SetText(self.Current.Text)
						else
							CDText = string.format("%0.1f - "..self.Current.Text, self.Remaining)
							self.Shadow:SetText(CDText)
							self.Text:SetText(CDText)
						end
					end
				end
			end
			if self.StopTime then
				if self.StopTime <= CurrentTime then
					self.Direction = false
					self.FadeStart = (CurrentTime - (1.0 - self.Alpha))
					self.Current.Stopping = true
					if self.Current.AlertAfter and not self.Starting then
						self:Stop()
					elseif self.Current.TimerAfter then
						if KBM.Encounter then
							KBM.MechTimer:AddStart(self.Current.TimerAfter)
							self.Current.TAStarted = true
						end
					end
				end
			end
		end
	end
	self:ApplySettings()	
end

local function KBM_Reset(Forced)
	if KBM.Encounter then
		if Forced == true then
			KBM.Event.Encounter.End({Type = "reset", Mod = KBM.CurrentMod})
			KBM.IgnoreList = {}
		else
			KBM.Idle.Wait = true
			KBM.Idle.Until = Inspect.Time.Real() + KBM.Idle.Duration
		end
		KBM.Idle.Combat.Wait = false
		KBM.Encounter = false
		if KBM.CurrentMod then
			if KBM.Trigger.Seq[KBM.CurrentMod.ID] then
				for i, Trigger in ipairs(KBM.Trigger.Seq[KBM.CurrentMod.ID]) do
					Trigger:ResetSeq()
				end
			end
			KBM.CurrentMod:Reset()
			KBM.CurrentMod = nil
			KBM.CurrentBoss = ""
			KBM_CurrentBossName = ""
		end
		KBM.TimeElapsed = 0
		KBM.TimeStart = 0
		KBM.EnrageTime = 0
		KBM.EnrageTimer = 0
		if KBM.EncTimer.Active then
			KBM.EncTimer:End()
		end
		if KBM.TankSwap.Active then
			KBM.TankSwap:Remove()
		end
		if KBM.Alert.Current then
			KBM.Alert:Stop()
		end
		KBM.MechSpy:End()	
		if #KBM.MechTimer.ActiveTimers > 0 then
			for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
				KBM.MechTimer:AddRemove(Timer)
			end
			if #KBM.MechTimer.RemoveTimers > 0 then
				for i, Timer in ipairs(KBM.MechTimer.RemoveTimers) do
					Timer:Stop()
				end
			end
			KBM.MechTimer.RemoveTimers = {}
			KBM.MechTimer.ActiveTimers = {}
			KBM.MechTimer.StartTimers = {}
		end
		KBM.Trigger.Queue:Remove()
		KBM.EncTimer.Settings = KBM.Options.EncTimer
		KBM.EncTimer:ApplySettings()
		KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
		KBM.PhaseMonitor:ApplySettings()
		KBM.MechTimer.Settings = KBM.Options.MechTimer
		KBM.MechTimer:ApplySettings()
		KBM.MechSpy.Settings = KBM.Options.MechSpy
		KBM.MechSpy:ApplySettings()
		KBM.Alert.Settings = KBM.Options.Alerts
		KBM.Alert:ApplySettings()
		KBM.Buffs.Active = {}
		KBM.PercentageMon:End()
		for UnitID, BossObj in pairs(KBM.BossID) do
			if BossObj.Boss then
				BossObj.Boss.UnitObj = nil
				if Forced == "victory" then
					KBM.IgnoreList[UnitID] = true
				end
			end
		end
		KBM.BossID = {}
	else
		print("No encounter to reset.")
		KBM.IgnoreList = {}
	end
end

function KBM.ConvertTime(Time)
	Time = math.floor(Time)
	local TimeString = "00"
	local TimeSeconds = 0
	local TimeMinutes = 0
	local TimeHours = 0
	if Time > 59 then
		TimeMinutes = math.floor(Time / 60)
		TimeSeconds = Time - (TimeMinutes * 60)
		if TimeMinutes > 59 then
			TimeHours = math.floor(TimeMinutes / 60)
			TimeMinutes = TimeMinutes - (TimeHours * 60)
			TimeString = string.format("%d:%02d:%02d", TimeHours, TimeMinutes, TimeSeconds)
		else
			TimeString = string.format("%02d:%02d", TimeMinutes, TimeSeconds)
		end
	else
		TimeString = string.format("%02d", Time)
	end
	return TimeString
end

function KBM.Raid.CombatEnter(handle)

	if KBM.Debug then
		print("Raid has entered combat: Number in combat = "..LibSUnit.Raid.CombatTotal)
	end
	if KBM.Idle.Combat.Wait then
		KBM.Idle.Combat.Wait = false
	end
	
end

function KBM.WipeIt(Force)

	KBM.Idle.Combat.Wait = false
	if KBM.Encounter then
		KBM.TimeElapsed = KBM.Idle.Combat.StoreTime
		if Force then
			print("Encounter ended. Wiped.")
		else
			print(KBM.Language.Encounter.Wipe[KBM.Lang])
		end
		print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
		if KBM.EncounterMode == "Chronicle" then
			KBM.CurrentMod.Settings.Records.Chronicle.Wipes = KBM.CurrentMod.Settings.Records.Chronicle.Wipes + 1
		elseif KBM.EncounterMode ~= "Template" then
			KBM.CurrentMod.Settings.Records.Wipes = KBM.CurrentMod.Settings.Records.Wipes + 1
		end
		KBM.Event.Encounter.End({Type = "wipe", Mod = KBM.CurrentMod})
		KBM_Reset()
	end
	
end

function KBM.Raid.CombatLeave(handle)

	if KBM.Debug then
		print("Raid has left combat")
	end
	if KBM.Options.Enabled then
		if KBM.Encounter then
			if KBM.Debug then
				print("Possible Wipe, waiting raid out of combat")
			end
			KBM.Idle.Combat.Wait = true
			if KBM.CurrentMod.TimeoutOverride then
				KBM.Idle.Combat.Until = Inspect.Time.Real() + KBM.CurrentMod.Timeout
			else
				KBM.Idle.Combat.Until = Inspect.Time.Real() + KBM.Idle.Combat.Duration
			end
			KBM.Idle.Combat.StoreTime = KBM.TimeElapsed
		end
	end
	
end

KBM.ClearBuffers = 0

function KBM:Timer(handle)

	local current = Inspect.Time.Real()
	local diff = (current - self.HeldTime)
	local udiff = (current - self.UpdateTime)

	if not KBM.Updating then
		KBM.Updating = true
		
		if KBM.Options.Enabled then			
			if diff >= 1 then				
				if KBM.Options.CPU.Enabled then
					KBM.CPU:UpdateAll()
				end
				KBM.ResMaster:Update()
				self.HeldTime = current								
			end
			
			if KBM.Encounter then
				if KBM.CurrentMod then
					KBM.CurrentMod:Timer(current, diff)
					KBM.PercentageMon:Update(current, diff)
				end
				if diff >= 1 then
					self.LastElapsed = self.TimeElapsed
					self.TimeElapsed = math.floor(current - self.StartTime)
					if KBM.CurrentMod.Enrage then
						self.EnrageTimer = self.EnrageTime - math.floor(current)
					end
					if self.Options.EncTimer.Enabled then
						self.EncTimer:Update(current)
					end
					self.HeldTime = current - (diff - math.floor(diff))
					self.UpdateTime = current
					if self.Trigger.Time[KBM.CurrentMod.ID] then
						for TimeCheck = (self.LastElapsed + 1), self.TimeElapsed do
							if self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck] then
								self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck]:Activate(current)
							end
						end
					end
				end
				for ID, PlugIn in pairs(self.PlugIn.List) do
					PlugIn:Timer(current)
				end	
				-- for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
					-- local Trigger = true
					-- for ID, CastBarObj in pairs(CastCheck.List) do
						-- CastBarObj:Update(Trigger)
						-- Trigger = false
					-- end
				-- end
				if udiff >= 0.075 then
					for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
						Timer:Update(current)
					end
					KBM.MechSpy:Update(current)
					self.UpdateTime = current
					if not KBM.TankSwap.Test then
						if KBM.TankSwap.Active then
							KBM.TankSwap:Update()
						end
					end
				end
				self.Trigger.Queue:Activate()
				if self.MechTimer.RemoveCount > 0 then
					for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
						Timer:Stop()
					end
					self.MechTimer.RemoveTimers = {}
					self.MechTimer.RemoveCount = 0
				end
				if self.MechTimer.StartCount > 0 then
					for i, Timer in ipairs(self.MechTimer.StartTimers) do
						Timer:Start(current)
					end
					self.MechTimer.StartTimers = {}
					self.MechTimer.StartCount = 0
				end
				if self.Alert.Active then
					self.Alert:Update(current)
				end
				if KBM.Idle.Combat.Wait then
					if KBM.Idle.Combat.Until < current then
						KBM.WipeIt()
					end
				end	
			else
				for ID, PlugIn in pairs(self.PlugIn.List) do
					PlugIn:Timer(current)
				end
				
				-- for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
					-- local Trigger = true
					-- for ID, CastBarObj in pairs(CastCheck.List) do
						-- CastBarObj:Update(Trigger)
						-- Trigger = false
					-- end
				-- end
			end
		end
		
		KBM.Updating = false
	end	
end

function KBM:AuxTimer(handle)
end

local function KBM_CastBar(units)
	-- for UnitID, Status in pairs(units) do
		-- if KBM.CastBar.ActiveCastBars[UnitID] then
			-- local Trigger = true
			-- for ID, CastBarObj in pairs(KBM.CastBar.ActiveCastBars[UnitID].List) do
				-- CastBarObj:Update(Trigger)
				-- Trigger = false
			-- end
		-- end
	-- end
end

local function KM_ToggleEnabled(result)
	
end

function KBM.Victory()
	print(KBM.Language.Encounter.Victory[KBM.Lang])
	if KBM.EncounterMode == "Chronicle" then
		if KBM.ValidTime then
			if KBM.CurrentMod.Settings.Records.Chronicle.Best == 0 or KBM.TimeElapsed < KBM.CurrentMod.Settings.Records.Chronicle.Best then
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
				if KBM.CurrentMod.Settings.Records.Chronicle.Best ~= 0 then
					print(KBM.Language.Records.Previous[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Chronicle.Best))
					print(KBM.Language.Records.BeatChrRecord[KBM.Lang])
				else
					print(KBM.Language.Records.NewChrRecord[KBM.Lang])
				end
				KBM.CurrentMod.Settings.Records.Chronicle.Best = KBM.TimeElapsed
				KBM.CurrentMod.Settings.Records.Chronicle.Date = tostring(os.date())
				KBM.CurrentMod.Settings.Records.Chronicle.Kills = KBM.CurrentMod.Settings.Records.Chronicle.Kills + 1
			else
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))								
				print(KBM.Language.Records.Current[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Chronicle.Best))
				KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
			end
		else
			print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
			print(KBM.Language.Records.Invalid[KBM.Lang])
			KBM.CurrentMod.Settings.Records.Chronicle.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
		end
	elseif KBM.EncounterMode == "Template" then
		print("Template Mode activated. Recording cancelled.")
	else
		if KBM.ValidTime then
			if KBM.CurrentMod.Settings.Records.Best == 0 or (KBM.TimeElapsed < KBM.CurrentMod.Settings.Records.Best) then
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
				if KBM.CurrentMod.Settings.Records.Best ~= 0 then
					print(KBM.Language.Records.Previous[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Best))
					print(KBM.Language.Records.BeatRecord[KBM.Lang])
				else
					print(KBM.Language.Records.NewRecord[KBM.Lang])
				end
				KBM.CurrentMod.Settings.Records.Best = KBM.TimeElapsed
				KBM.CurrentMod.Settings.Records.Date = tostring(os.date())
				KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
			else
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
				print(KBM.Language.Records.Current[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Best))
				KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
			end
		else
			print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
			print(KBM.Language.Records.Invalid[KBM.Lang])
			KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
		end
	end
	KBM.Event.Encounter.End({Type = "victory", KBM.CurrentMod})
	KBM_Reset("victory")
end

function KBM.Unit.Death(handle, info)	
	if KBM.Options.Enabled then	
		if KBM.Encounter then
			local UnitObj = info.targetObj
			if UnitObj then
				if LibSUnit.Raid.UID[UnitObj.UnitID] then
					if KBM.TankSwap.Active then
						if KBM.TankSwap.Tanks[UnitObj.UnitID] then
							KBM.TankSwap.Tanks[UnitObj.UnitID]:Death()
						end
					end
					if LibSUnit.Raid.Wiped then
						if KBM.Debug then
							print("All dead, definite wipe (Experimental)")
							KBM.Idle.Combat.StoreTime = KBM.TimeElapsed
							KBM.WipeIt(true)
						end
					end
				else
					if KBM.CurrentMod then
						if KBM.CurrentMod.ID then
							if KBM.Trigger.Death[KBM.CurrentMod.ID] then
								local TriggerObj = KBM.Trigger.Death[KBM.CurrentMod.ID][UnitObj.Name]
								if TriggerObj then
									KBM.Trigger.Queue:Add(TriggerObj, nil, UnitObj.UnitID)
								end
							end
						end
					end
					if KBM.BossID[UnitObj.UnitID] then
						KBM.BossID[UnitObj.UnitID].Dead = true
						if KBM.PhaseMonitor.Active then
							if KBM.PhaseMonitor.Objectives.Lists.Death[UnitObj.Name] then
								KBM.PhaseMonitor.Objectives.Lists.Death[UnitObj.Name]:Kill(UnitObj)
							end
						end
						if KBM.CurrentMod:Death(UnitObj.UnitID) then
							KBM:Victory()
						end
					end
				end
			end
		end
	end	
end

local function KBM_Help()
	print(KBM.Language.Command.Title[KBM.Lang])
	print(KBM.Language.Command.On[KBM.Lang])
	print(KBM.Language.Command.Off[KBM.Lang])
	print(KBM.Language.Command.Reset[KBM.Lang])
	print(KBM.Language.Command.Version[KBM.Lang])
	print(KBM.Language.Command.Options[KBM.Lang])
	print(KBM.Language.Command.Help[KBM.Lang])
end

function KBM.Notify(handle, data)
	if KBM.Debug then
		print("Notify Capture;")
		dump(data)
	end

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if data.message then
				if KBM.CurrentMod then
					if KBM.Trigger.Notify[KBM.CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Notify[KBM.CurrentMod.ID]) do
							local sStart, sEnd, Target
							sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
							if sStart then
								local unitID = nil
								if Target then
									if LibSUnit.Lookup.Name[Target] then
										for UnitID, UnitObj in pairs (LibSUnit.Lookup.Name[Target]) do
											if UnitObj.Player then
												unitID = UnitID
												break
											end
										end
									end
								else
									unitID = "uNone"
								end
								KBM.Trigger.Queue:Add(TriggerObj, TriggerObj.Unit.Name, unitID)
								break
							end
						end
					end
				end
			end
		end
	end	
end

function KBM.NPCChat(handle, data)
	if KBM.Debug then
		print("Chat Capture;")
		dump(data)
	end

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if data.fromName then
				if KBM.CurrentMod then
					if KBM.Trigger.Say[KBM.CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Say[KBM.CurrentMod.ID]) do
							if TriggerObj.Unit.Name == data.fromName then
								local sStart, sEnd, Target
								sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
								if sStart then
									if not Target then
										Target = "NotifyObject"
									end
									KBM.Trigger.Queue:Add(TriggerObj, data.fromName, Target)
									break
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM:BuffAdd(handle, Units)
	-- Used to manage Triggers and soon Tank-Swap managing.
	-- local TimeStore = Inspect.Time.Real()
	
	if KBM.Options.Enabled then
		if KBM.Encounter then
			for unitID, BuffTable in pairs(Units) do
				for BuffID, bDetails in pairs(BuffTable) do
					if bDetails then
						if KBM.Trigger.Buff[KBM.CurrentMod.ID] then
							if KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name] then
								local uDetails = LibSUnit.Lookup.UID[unitID]
								if uDetails then
									local TriggerObj = KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name][uDetails.Name]
									if TriggerObj then
										if TriggerObj.Unit.UnitID == unitID then
											KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
										end
									end
								end
							end
						end
						-- if KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID] ~= nil and bDetails.debuff == true then
							-- if KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID][bDetails.name] then
								-- local TriggerObj = KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID][bDetails.name]
								-- if LibSUnit.Raid.UID[unitID] ~= nil or unitID == LibSUnit.Player.UnitID then
									-- if KBM.Debug then
										-- print("Debuff Trigger matched: "..bDetails.name)
										-- if LibSUnit.Raid.Grouped then
											-- print("LibSUnit Match: "..tostring(LibSUnit.Raid.UID[unitID]))
										-- end
										-- print("Player Match: "..LibSUnit.Player.UnitID.." - "..unitID)
										-- print("---------------")
										-- dump(bDetails)
									-- end
									-- KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								-- end
							-- end
						-- end
						if KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID][bDetails.type] then
								local TriggerObj = KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID][bDetails.type]
								if LibSUnit.Raid.UID[unitID] ~= nil or unitID == LibSUnit.Player.UnitID then
									if KBM.Debug then
										print("Debuff Trigger matched: "..bDetails.name)
										if LibSUnit.Raid.Grouped then
											print("LibSUnit Match: "..tostring(LibSUnit.Raid.UID[unitID]))
										end
										print("Player Match: "..LibSUnit.Player.UnitID.." - "..unitID)
										print("---------------")
										dump(bDetails)
									end
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name] then
								local TriggerObj = KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name]
								if LibSUnit.Raid.UID[unitID] ~= nil or unitID == LibSUnit.Player.UnitID then
									if KBM.Debug then
										print("Buff Trigger matched: "..bDetails.name)
										if LibSUnit.Raid.Grouped then
											print("LibSUnit Match: "..tostring(LibSUnit.Raid.UID[unitID]))
										end
										print("Player Match: "..LibSUnit.Player.UnitID.." - "..unitID)
										print("---------------")
										dump(bDetails)
									end
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if unitID == LibSUnit.Player.UnitID then
							if KBM.Buffs.WatchID[bDetails.LibSBuffType] then
								if KBM.Trigger.CustomBuffRemove["playerBuffID"] then
									if KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType] then
										local Trigger = KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType]
										Trigger:Activate(unitID, bDetails.caster, BuffID)
									end
								end
							end
						end
						if KBM.TankSwap.Active then
							if KBM.TankSwap.Tanks[unitID] then
								if KBM.TankSwap.DebuffName[bDetails.name] then
									KBM.TankSwap.Tanks[unitID]:BuffUpdate(BuffID, bDetails.name)
								elseif KBM.TankSwap.DebuffName[bDetails.LibSBuffType] then
									KBM.TankSwap.Tanks[unitID]:BuffUpdate(BuffID, bDetails.LibSBuffType)
								end
							end
						end
					end
				end
			end
		else
			for unitID, BuffTable in pairs(Units) do
				for BuffID, bDetails in pairs(BuffTable) do
					if bDetails then
						if KBM.Trigger.EncStart["playerBuff"] then
							if KBM.Trigger.EncStart["playerBuff"][bDetails.name] then
								local TriggerMod = KBM.Trigger.EncStart["playerBuff"][bDetails.name]
								if TriggerMod.Dummy then
									KBM.CheckActiveBoss(TriggerMod.Dummy.Details, "Dummy")
								end
							end
						end
						if unitID == KBM.Player.UnitID then
							if KBM.Buffs.WatchID[bDetails.LibSBuffType] then
								if KBM.Trigger.CustomBuffRemove["playerBuffID"] then
									if KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType] then
										local Trigger = KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType]
										Trigger:Activate(unitID, bDetails.caster, BuffID)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM:BuffRemove(handle, Units)
	if KBM.Options.Enabled then
		if KBM.Encounter then
			for unitID, BuffTable in pairs(Units) do
				for BuffID, bDetails in pairs(BuffTable) do
					if bDetails then
						if KBM.Trigger.BuffRemove[KBM.CurrentMod.ID] then
							if KBM.Trigger.BuffRemove[KBM.CurrentMod.ID][bDetails.name] then
								local uDetails = LibSUnit.Lookup.UID[unitID]
								if uDetails then
									local TriggerObj = KBM.Trigger.BuffRemove[KBM.CurrentMod.ID][bDetails.name][uDetails.Name]
									if TriggerObj then
										if TriggerObj.Unit.UnitID == unitID then
											KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
										end
									end
								end
							end
						end
						if KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name] then
								local TriggerObj = KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name]
								if LibSUnit.Raid.UID[unitID] or unitID == LibSUnit.Player.UnitID then
									KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
								end
							end
						end
						if KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID][bDetails.type] then
								local TriggerObj = KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID][bDetails.type]
								if LibSUnit.Raid.UID[unitID] or unitID == LibSUnit.Player.UnitID then
									KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM.SlashInspectBuffs(handle, Name)
	local UnitID = ""
	if Name == "" then
		Name = KBM.Player.Name
		UnitID = KBM.Player.UnitID
	elseif Name == "%t" then
		local tDetails = Inspect.Unit.Detail("player.target")
		if tDetails then
			if tDetails.id then
				Name = tDetails.name
				UnitID = tDetails.id 
			end
		else
			Name = KBM.Player.Name
			UnitID = KBM.Player.UnitID
		end
	else
		if LibSUnit.Lookup.Name[Name] then
			for lUnitID, Object in pairs(LibSUnit.Lookup.Name[Name]) do
				UnitID = lUnitID
			end
		end
	end
	if UnitID ~= "" then
		print("----------------")
		print("Inspecting Buffs for: "..tostring(Name))
		if UnitID then
			if LibSBuff.Cache[UnitID] then
				for buffID, bDetails in pairs(LibSBuff.Cache[UnitID].BuffID or {}) do
					if bDetails then
						if type(bDetails) == "table" then
							print(tostring(bDetails.name).." : "..tostring(bDetails.LibSBuffType))
						end
					end
				end
				print("----------------")
			end
		end
	else
		print("No Buff data available for: "..tostring(Name))
	end
end

function KBM.FormatPrecision(Val)
	if Val < 0.000001 or Val == nil then
		return "Too Low"
	else
		return string.format("%0.6fs", Val)
	end
end

function KBM.VersionReqCheckb(name, failed, message)
	if not failed then
		print("Version request sent successfully for "..name.."!")
	else
		print("Version request failed for: "..tostring(name))
	end
end

function KBM.VersionReqCheck(name, failed, message)
	if not failed then
		print("Version request sent successfully for "..name.."!")
	else
		Command.Message.Broadcast("tell", name, "KBMVerReq", "V", function (failed, message) KBM.VersionReqCheckb(name, failed, message) end)
	end
end

local function KBM_Version(name)
	if string.find(name, "%t") then
		local nameLU = Inspect.Unit.Lookup("player.target")
		if nameLU then
			nameLU_Details = Inspect.Unit.Detail(nameLU)
			if nameLU_Details then
				name = nameLU_Details.name
			end
		else
			name = ""
		end
	end
	if type(name) == "string" and name ~= "" then
		Command.Message.Send(name, "KBMVerReq", "V", function (failed, message) KBM.VersionReqCheck(name, failed, message) end)
	else
		print(KBM.Language.Version.Title[KBM.Lang])
		if KBM.IsAlpha then
			print("King Boss Mods v"..AddonData.toc.Version.." Alpha")
		else
			print("King Boss Mods v"..AddonData.toc.Version)
		end
	end
end

function KBM.StateSwitch(bool)
	KBM.Options.Enabled = bool
	if KBM.Options.Enabled then
		print("King Boss Mods is now Enabled.")
	else
		print("King Boss Mods is now Disabled.")
		if KBM.Encounter then
			print("Stopping running Encounter.")
			KBM_Reset()
		end
	end
end

function KBM.ApplySettings()
	KBM.TankSwap.Enabled = KBM.Options.TankSwap.Enabled
end

local function KBM_Debug()
	if KBM.Debug then
		print("Debugging disabled")
		KBM.Debug = false
		KBM.Options.Debug = false
	else
		print("Debugging enabled")
		KBM.Debug = true
		KBM.Options.Debug = true
	end
end

function KBM.SecureEnter()
end

function KBM.SecureLeave()
	if not LibSUnit.Raid.Grouped then
		KBM.Raid.CombatLeave()
	end
end

function KBM.RaidRes(data)
	if KBM.Debug then
		print("Raid Ressurect")
		dump(data)
		print("Total Dead: "..tostring(LibSUnit.Raid.DeadTotal).."/"..tostring(LibSUnit.Raid.Members))
		print("--------------")
	end
end

-- Define KBM Custom Event System
-- System Related
KBM.Event.System.Start, KBM.Event.System.Start.EventTable = Utility.Event.Create("KingMolinator", "System.Start")
-- Unit Related
KBM.Event.Unit.Cast.Start, KBM.Event.Unit.Cast.Start.EventTable = Utility.Event.Create("KingMolinator", "Unit.Cast.Start")
KBM.Event.Unit.Cast.End, KBM.Event.Unit.Cast.End.EventTable = Utility.Event.Create("KingMolinator", "Unit.Cast.End")
KBM.Event.System.TankSwap.Start, KBM.Event.System.TankSwap.Start.EventTable = Utility.Event.Create("KingMolinator", "System.TankSwap.Start")
KBM.Event.System.TankSwap.End, KBM.Event.System.TankSwap.End.EventTable = Utility.Event.Create("KingMolinator", "System.TankSwap.End")
-- Encounter Related
KBM.Event.Encounter.Start, KBM.Event.Encounter.Start.EventTable = Utility.Event.Create("KingMolinator", "Encounter.Start")
KBM.Event.Encounter.End, KBM.Event.Encounter.End.EventTable = Utility.Event.Create("KingMolinator", "Encounter.End")

function KBM.InitVars()
	KBM.Button:Init()
	KBM.TankSwap:Init()
	KBM.Alert:Init()
	KBM.MechTimer:Init()
	KBM.Castbar:Init()
	KBM.EncTimer:Init()
	KBM.PhaseMonitor:Init()
	KBM.Trigger:Init()
	KBM.MechSpy:Init()
	KBM.SheepProtection:Init()
end

KBM.SetDefault = {}
function KBM.SetDefault.menu()
	KBM.Menu.Window:SetPoint("TOPLEFT", UIParent, 0.25, 0.2)
	KBM.Options.Frame.RelX = false
	KBM.Options.Frame.RelY = false
end

function KBM.SetDefault.button()
	KBM.Options.Button = KBM.Defaults.Button()
	KBM.Button:ApplySettings()
end

function KBM.SetDefault.rcbutton()
	KBM.Ready.Button:Defaults()
end

function KBM.SetDefault.playercastbar()
	local tempCastObj = KBM.Castbar:DefaultSelf()
	local Castbar = KBM.Castbar.Player.Self
	Castbar.Settings.relX = tempCastObj.relX
	Castbar.Settings.relY = tempCastObj.relY
	if Castbar.Settings.pinned then
		Castbar.Settings.pinned = false
		Castbar.CastObj:Unpin()
		Castbar.CastObj:Unlocked(Castbar.Settings.visible)
		Castbar.Settings.unlocked = Castbar.Settings.visible
		UI.Native.Castbar:EventDetach(Event.UI.Layout.Size, KBM.Castbar.HandlePinScale, "KBMCastbar-Mimic-PinScale-Handler")
	end
	Castbar.CastObj:UpdateSettings()
end

function KBM.SetDefault.targetcastbar()
	local tempCastObj = KBM.Castbar:DefaultTarget()
	local Castbar = KBM.Castbar.Player.Target
	Castbar.Settings.relX = tempCastObj.relX
	Castbar.Settings.relY = tempCastObj.relY
	Castbar.CastObj:UpdateSettings()
end

function KBM.SetDefault.focuscastbar()
	local tempCastObj = KBM.Castbar:DefaultFocus()
	local Castbar = KBM.Castbar.Player.Focus
	Castbar.Settings.relX = tempCastObj.relX
	Castbar.Settings.relY = tempCastObj.relY
	Castbar.CastObj:UpdateSettings()
end

function KBM.SetDefault.bosscastbar()
	local tempCastObj = KBM.Castbar:DefaultGlobal()
	KBM.Options.Castbar.Global.relX = tempCastObj.relX
	KBM.Options.Castbar.Global.relY = tempCastObj.relY
	KBM.Castbar.Anchor.cradle:SetPoint("CENTER", UIParent, KBM.Options.Castbar.Global.relX, KBM.Options.Castbar.Global.relY)
end

function KBM.SetDefault.castbars()
	KBM.SetDefault.playercastbar()
	KBM.SetDefault.targetcastbar()
	KBM.SetDefault.focuscastbar()
	KBM.SetDefault.bosscastbar()
end

function KBM.SlashDefault(handle, Args)
	-- Will eventually have different options that will link to default buttons in UI
	-- For now it'll reset the Options Menu Button to its default settings. (Central, Visible and Unlocked)
	Args = string.lower(Args or "")
	if Args == "all" then
		for ID, _function in pairs(KBM.SetDefault) do
			_function()
		end
	elseif KBM.SetDefault[Args] then
		KBM.SetDefault[Args]()
	else 
		print("Bellow are a list of commands for: /kbmdefault")
		print("All\t\t: Will reset all of the below.")
		print("Button\t: Resets KBM's Mini-map button.")
		print("RCButton\t: Resets Ready Check's mini-map button.")
		print("Menu\t: Resets KBM's Menu Option window.")
		print("PlayerCastbar\t: Resets the Player's Castbar position.")
		print("TargetCastbar\t: Resets the Player's Target Castbar position.")
		print("FocusCastbar\t: Resets the Player's Focus Castbar position.")
		print("BossCastbar\t: Resets the Global Boss Castbar position.")
		print("Castbars\t: Resets all Global and Player castbar positions.")
		print("For exmaple: /kbmdefault button")
	end
end

function KBM.SlashUnitCache(handle, arg)
	if type(arg) == "string" then
		arg = string.upper(arg)
	end
	if arg == "CLEAR" then
		print("Unit Cache has been cleared. /reloadui to save changes.")
		KBM.Options.UnitCache.List = {}
		KBM.Options.UnitTotal = 0
	elseif arg == "TOTAL" then
		print("You have found "..KBM.Options.UnitTotal.." missing UTIDs")
	elseif KBM.Options.UnitTotal > 0 then
		print("You have found "..KBM.Options.UnitTotal.." missing UTIDs")
		print("----------------")
		for UnitName, TypeList in pairs(KBM.Options.UnitCache.List) do
			print("Matches for: "..UnitName)
			for TypeID, Details in pairs(TypeList) do
				print("----------------")
				print("UTID: "..tostring(TypeID))
				for ID, Value in pairs(Details) do
					if ID ~= "Zone" then
						print(tostring(ID).." : "..tostring(Value))
					else
						if type(Value) == "table" then
							print("Zone ID: "..tostring(Value.id))
							print("Zone Name: "..tostring(Value.name))
							print("Zone Type: "..tostring(Value.type))
						else
							print("Zone: Malformed Data")
						end
					end
				end
			end
			print("----------------")
		end
	else
		print("You have not found any missing UTIDs")
	end
end

function KBM.SlashZone()
	zDetails = Inspect.Zone.Detail(LibSUnit.Player.Zone)
	print(zDetails.name)
	print(zDetails.id)
end

function KBM.AllocateBoss(Mod, BossObj, UTID, tableIndex)
	local iType = Mod.InstanceObj.Type
	if UTID ~= "none" then
		if string.len(UTID) == 17 then
			KBM.Boss[iType][UTID] = BossObj
			KBM.Boss.TypeList[UTID] = BossObj
			if KBM.Options.UnitCache.List[BossObj.Name] then
				if KBM.Options.UnitCache.List[BossObj.Name][BossObj.UTID] then
					KBM.Options.UnitCache.List[BossObj.Name][BossObj.UTID] = nil
					KBM.Options.UnitTotal = KBM.Options.UnitTotal - 1
					if not next(KBM.Options.UnitCache.List[BossObj.Name]) then
						KBM.Options.UnitCache.List[BossObj.Name] = nil
					end
				end
			end
			if KBM.Options.UnitCache[iType][Mod.Instance] then
				if KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] then
					if tableIndex then
						if tableIndex == KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] then
							KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] = nil
						end
					else
						KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] = nil
					end
				end
				if not next(KBM.Options.UnitCache[iType][Mod.Instance]) then
					KBM.Options.UnitCache[iType][Mod.Instance] = nil
				end
			end
			--print("Raid Boss: "..BossObj.Name.." initizialized successfully: "..BossObj.RaidID)
		else
			print("WARNING: "..BossObj.Name.." ID Length not correct, required Length 17")
			print("Instance: "..BossObj.Mod.Instance)
			print("ID: "..BossObj.UTID)
			print("Instance Type: "..iType)
		end
	else
		if not KBM.Options.UnitCache[iType][Mod.Instance] then
			KBM.Options.UnitCache[iType][Mod.Instance] = {}
		end
		if not KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] then
			KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] = tableIndex or true
		end
		KBM.Boss.Template[BossObj.Name] = BossObj
	end
end

-- Settings Menu
local function BuildMenuSettings()
	local Menu = {}
	Menu.Callbacks = {}
	
	-- Settings
	function Menu.Main(Header)
		Menu.Callbacks.Main = {}
		local self = Menu.Callbacks.Main
		local Item = Header:CreateItem(KBM.Language.Options.Settings[KBM.Lang], "Main")
		local MenuItem

		function self:Character(bool)
			KBM.Options.Character = bool
			if bool then
				KBM_GlobalOptions = KBM.Options
				KBM.Options = chKBM_GlobalOptions
			else
				chKBM_GlobalOptions = KBM.Options
				KBM.Options = KBM_GlobalOptions
			end
			KBM.Options.Character = bool
			for _, Mod in ipairs(KBM.ModList) do
				if Mod.SwapSettings then
					Mod:SwapSettings(bool)
				end
			end
			KBM.Ready:SwapSettings(bool)
		end

		function self:Enabled(bool)
			KBM.StateSwitch(bool)
		end

		function self:Visible(bool)
			KBM.Options.Button.Visible = bool
			KBM.Button.Texture:SetVisible(bool)
		end

		function self:Unlocked(bool)
			KBM.Options.Button.Unlocked = bool
			KBM.Button:SetUnlocked(bool)
		end
		
		function self:Protect(bool)
			KBM.Options.Sheep.Protect = bool
			if bool then
				if KBM.Buffs.Active[KBM.Player.UnitID] then
					for SheepID, bool in pairs(KBM.SheepProtection.SheepList) do
						if KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[SheepID] then
							KBM.SheepProtection.Remove(KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[SheepID].id, KBM.Buffs.Active[KBM.Player.UnitID].Buff_Types[SheepID].caster)
						end
					end
				end
			end
		end

		Item.UI.CreateHeader(KBM.Language.Options.Character[KBM.Lang], KBM.Options, "Character", self)
		if KBM.IsAlpha then
			MenuItem = Item.UI.CreateHeader(KBM.Language.Options.ModEnabled[KBM.Lang].." Alpha", KBM.Options, "Enabled", self)
		else
			MenuItem = Item.UI.CreateHeader(KBM.Language.Options.ModEnabled[KBM.Lang], KBM.Options, "Enabled", self)
		end
		MenuItem:CreateCheck(KBM.Language.Options.Sheep[KBM.Lang], KBM.Options.Sheep, "Protect", self)
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.Button[KBM.Lang], KBM.Options.Button, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.LockButton[KBM.Lang], KBM.Options.Button, "Unlocked", self)
		
		Item:Select()
	end

	-- Timers
	function Menu.Timers(Header)	
		Menu.Callbacks.Timers = {}
		Menu.Callbacks.MechTimers = {}
		local self = Menu.Callbacks.Timers
		local Item = Header:CreateItem(KBM.Language.Menu.Timers[KBM.Lang], "Timers")
		local MenuItem
		
		-- Encounter Timer Callbacks.
		function self:Enabled(bool)
			KBM.Options.EncTimer.Enabled = bool
		end
		function self:Visible(bool)
			KBM.Options.EncTimer.Visible = bool
			KBM.EncTimer.Frame:SetVisible(bool)
			KBM.EncTimer.Enrage.Frame:SetVisible(bool)
			KBM.Options.EncTimer.Unlocked = bool
			KBM.EncTimer.Frame.Drag:SetVisible(bool)
		end
		function self:Duration(bool)
			KBM.Options.EncTimer.Duration = bool
		end
		function self:Enrage(bool)
			KBM.Options.EncTimer.Enrage = bool
		end
		function self:ScaleHeight(bool, Check)
			KBM.Options.EncTimer.ScaleHeight = bool
		end
		function self:ScaleWidth(bool, Check)
			KBM.Options.EncTimer.ScaleWidth = bool
		end
		function self:TextScale(bool, Check)
			KBM.Options.EncTimer.TextScale = bool
		end
		
		-- Encounter Timer Options
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.EncTimers[KBM.Lang], KBM.Options.EncTimer, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.Timer[KBM.Lang], KBM.Options.EncTimer, "Duration", self)
		MenuItem:CreateCheck(KBM.Language.Options.Enrage[KBM.Lang], KBM.Options.EncTimer, "Enrage", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowTimer[KBM.Lang], KBM.Options.EncTimer, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.EncTimer, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.EncTimer, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.EncTimer, "TextScale", self)
		
		self = Menu.Callbacks.MechTimers
		-- Timer Callbacks
		function self:Enabled(bool)
			KBM.Options.MechTimer.Enabled = bool
		end
		function self:Shadow(bool)
			KBM.Options.MechTimer.Shadow = bool
		end
		function self:Texture(bool)
			KBM.Options.MechTimer.Texture = bool
		end
		function self:Visible(bool)
			KBM.Options.MechTimer.Visible = bool
			KBM.MechTimer.Anchor:SetVisible(bool)
			KBM.Options.MechTimer.Unlocked = bool
			KBM.MechTimer.Anchor.Drag:SetVisible(bool)
			if #KBM.MechTimer.ActiveTimers > 0 then
				KBM.MechTimer.Anchor.Text:SetVisible(false)
			else
				if bool then
					KBM.MechTimer.Anchor.Text:SetVisible(true)
				end
			end
		end
		function self:ScaleHeight(bool, Check)
			KBM.Options.MechTimer.ScaleHeight = bool
		end
		function self:ScaleWidth(bool, Check)
			KBM.Options.MechTimer.ScaleWidth = bool
		end
		function self:TextScale(bool, Check)
			KBM.Options.MechTimer.TextScale = bool
		end
		
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.MechanicTimers[KBM.Lang], KBM.Options.MechTimer, "Enabled", self)
		-- MechTimers.GUI.Check:SetEnabled(false)
		-- KBM.Options.MechTimer.Enabled = true
		MenuItem:CreateCheck(KBM.Language.Options.Texture[KBM.Lang], KBM.Options.MechTimer, "Texture", self)
		MenuItem:CreateCheck(KBM.Language.Options.Shadow[KBM.Lang], KBM.Options.MechTimer, "Shadow", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.MechTimer, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.MechTimer, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.MechTimer, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.MechTimer, "TextScale", self)
	end

	-- Phases
	function Menu.Phases(Header)		
		Menu.Callbacks.Phases = {}
		local self = Menu.Callbacks.Phases
		local Item = Header:CreateItem(KBM.Language.Options.PhaseMonitor[KBM.Lang], "Phases")
		local MenuItem
		
		-- Phase Monitor Callbacks.
		function self:Enabled(bool)
			KBM.Options.PhaseMon.Enabled = bool
			if KBM.Options.PhaseMon.Visible then
				if bool then
					KBM.PhaseMonitor.Anchor:SetVisible(true)
				else
					KBM.PhaseMonitor.Anchor:SetVisible(false)
				end
			end
		end
		function self:Visible(bool)
			KBM.Options.PhaseMon.Visible = bool
			KBM.PhaseMonitor.Anchor:SetVisible(bool)
			KBM.Options.PhaseMon.Unlocked = bool
			KBM.PhaseMonitor.Anchor.Drag:SetVisible(bool)
		end
		function self:PhaseDisplay(bool)
			KBM.Options.PhaseMon.PhaseDisplay = bool
		end
		function self:Objectives(bool)
			KBM.Options.PhaseMon.Objectives = bool
		end
		function self:ScaleWidth(bool)
			KBM.Options.PhaseMon.ScaleWidth = bool
		end
		function self:ScaleHeight(bool)
			KBM.Options.PhaseMon.ScaleHeight = bool
		end
		function self:TextScale(bool)
			KBM.Options.PhaseMon.TextScale = bool
		end
				
		-- Timer Options
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.PhaseEnabled[KBM.Lang], KBM.Options.PhaseMon, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.Phases[KBM.Lang], KBM.Options.PhaseMon, "PhaseDisplay", self)
		MenuItem:CreateCheck(KBM.Language.Options.Objectives[KBM.Lang], KBM.Options.PhaseMon, "Objectives", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.PhaseMon, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.PhaseMon, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.PhaseMon, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.PhaseMon, "TextScale", self)
	end

	-- Castbars
	function Menu.CastBars(Header)
		Menu.Callbacks.CastBar = {}
		local self = Menu.Callbacks.CastBar
		local Item = Header:CreateItem(KBM.Language.Options.Castbar[KBM.Lang], "CastBars")
		local MenuItem
		self.texture = {}

		-- Castbar Callbacks
		function self:enabled(bool)
			KBM.Options.Castbar.Global.enabled = bool
			KBM.Castbar.Global.CastObj:Enable(bool)
			for UnitID, Castbar in pairs(KBM.Castbar.ActiveCastbars) do
				Castbar.CastObj:Enable(bool)
				if bool then
					Castbar.CastObj:SetVisible(KBM.Options.Castbar.Global.visible)
				else
					Castbar.CastObj:SetVisible(false)
				end
			end
			KBM.Castbar.Anchor:SetVisible(bool)
			if bool then
				KBM.Castbar.Global.CastObj:SetVisible(KBM.Options.Castbar.Global.visible)
			else
				KBM.Castbar.Global.CastObj:SetVisible(false)
			end
		end
		
		function self.texture:enabled(bool)
			KBM.Options.Castbar.Global.texture.foreground.enabled = bool
			KBM.Castbar.Global.CastObj:SetTexture("foreground", bool)
			for UnitID, Castbar in pairs(KBM.Castbar.ActiveCastbars) do
				Castbar.CastObj:SetTexture("foreground", bool)
			end
		end
		
		-- function self:Shadow(bool)
			-- KBM.Options.CastBar.Shadow = bool
			-- if KBM.CastBar.Anchor.GUI then
				-- KBM.CastBar.Anchor.GUI.Shadow:SetVisible(bool)
			-- end
		-- end
		
		function self:visible(bool)
			KBM.Options.Castbar.Global.visible = bool
			KBM.Options.Castbar.Global.unlocked = bool
			KBM.Castbar.Anchor:SetVisible(bool)
			KBM.Castbar.Global.CastObj:SetVisible(bool)
		end
		
		function self:widthUnlocked(bool)
			KBM.Options.Castbar.Global.scale.widthUnlocked = bool
		end
		
		function self:heightUnlocked(bool)
			KBM.Options.Castbar.Global.scale.heightUnlocked = bool
		end
		
		-- function self:TextScale(bool)
			-- KBM.Options.CastBar.TextScale = bool
		-- end
		
		function self:riftBar(bool)
			if bool then
				KBM.Options.Castbar.Global.pack = "Rift"
			else
				KBM.Options.Castbar.Global.pack = "Simple"
			end
			KBM.Options.Castbar.Global.riftBar = bool
			KBM.Castbar.Global.CastObj:SetPack(KBM.Options.Castbar.Global.pack)
			for UnitID, Castbar in pairs(KBM.Castbar.ActiveCastbars) do
				Castbar.CastObj:SetPack(KBM.Options.Castbar.Global.pack)
			end
		end

		-- CastBar Options. 
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.CastbarEnabled[KBM.Lang], KBM.Options.Castbar.Global, "enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], KBM.Options.Castbar.Global, "riftBar", self)
		MenuItem:CreateCheck(KBM.Language.Options.Texture[KBM.Lang], KBM.Options.Castbar.Global.texture.foreground, "enabled", self.texture)
		--MenuItem:CreateCheck(KBM.Language.Options.Shadow[KBM.Lang], KBM.Options.CastBar, "shadow", self)
		local SubMenu = MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.Castbar.Global, "visible", self)
		SubMenu:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.Castbar.Global.scale, "widthUnlocked", self)
		SubMenu:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.Castbar.Global.scale, "heightUnlocked", self)
		--MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.CastBar, "TextScale", self)
		
		-- Player Castbar Callbacks
		for _, Castbar in ipairs(KBM.Castbar.MenuOrder) do
			local self = {}
			self.texture = {}
			
			function self:enabled(bool)
				Castbar.Settings.enabled = bool
				Castbar.CastObj:Enable(bool)
				if bool then
					Castbar.CastObj:SetVisible(Castbar.Settings.visible)
					Castbar.CastObj:Unlocked(Castbar.Settings.unlocked)
				else
					Castbar.CastObj:SetVisible(false)
					Castbar.CastObj:Unlocked(false)
				end
			end
			
			function self:riftBar(bool)
				if bool then
					Castbar.Settings.pack = "Rift"
				else
					Castbar.Settings.pack = "Simple"
				end
				Castbar.Settings.riftBar = bool
				Castbar.CastObj:SetPack(Castbar.Settings.pack)
				if not Castbar.Settings.pinned then
					Castbar.CastObj:Unlocked(Castbar.Settings.unlocked)
				end
			end
			
			function self:pinned(bool)
				Castbar.Settings.pinned = bool
				if bool then
					Castbar.Settings.unlocked = false
					Castbar.CastObj:Unlocked(false)
					Castbar.CastObj:Pin(KBM.Castbar.PlayerPin)
					UI.Native.Castbar:EventAttach(Event.UI.Layout.Size, KBM.Castbar.HandlePinScale, "KBMCastbar-Mimic-PinScale-Handler")
				else
					Castbar.CastObj:Unpin()
					Castbar.CastObj:Unlocked(Castbar.Settings.visible)
					Castbar.Settings.unlocked = Castbar.Settings.visible
					UI.Native.Castbar:EventDetach(Event.UI.Layout.Size, KBM.Castbar.HandlePinScale, "KBMCastbar-Mimic-PinScale-Handler")
				end
			end
			
			function self.texture:enabled(bool)
				Castbar.Settings.texture.foreground.enabled = bool
				Castbar.CastObj:SetTexture("foreground", bool)
			end
			
			-- function self:Shadow(bool)
				-- KBM.Player.CastBar.Settings.CastBar.Shadow = bool
				-- KBM.Player.CastBar.CastObj:ApplySettings()
			-- end
			
			function self:visible(bool)
				Castbar.Settings.visible = bool
				Castbar.CastObj:SetVisible(bool)
				if not Castbar.Settings.pinned then
					Castbar.Settings.unlocked = bool
					Castbar.CastObj:Unlocked(bool)
				end
			end
			
			function self:widthUnlocked(bool)
				Castbar.Settings.scale.widthUnlocked = bool
			end
			
			function self:heightUnlocked(bool)
				Castbar.Settings.scale.heightUnlocked = bool
				Castbar.Settings.scale.textUnlocked = bool
			end
			-- function self:TextScale(bool)
				-- KBM.Player.CastBar.Settings.CastBar.TextScale = bool
			-- end
				
			MenuItem = Item.UI.CreateHeader(Castbar.MenuName, Castbar.Settings, "enabled", self)
			MenuItem:CreateCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], Castbar.Settings, "riftBar", self)
			if Castbar.ID == "KBM_Player_Bar" then
				MenuItem:CreateCheck(KBM.Language.CastBar.Mimic[KBM.Lang], Castbar.Settings, "pinned", self)
			end
			MenuItem:CreateCheck(KBM.Language.Options.Texture[KBM.Lang], Castbar.Settings.texture.foreground, "enabled", self.texture)
			--MenuItem:CreateCheck(KBM.Language.Options.Shadow[KBM.Lang], KBM.Options.Player.CastBar, "Shadow", self)
			local SubMenu = MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], Castbar.Settings, "visible", self)
			SubMenu:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], Castbar.Settings.scale, "widthUnlocked", self)
			SubMenu:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], Castbar.Settings.scale, "heightUnlocked", self)
			--SubMenu:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], Castbar.Settings.scale, "textUnlocked", self)
		end
	end

	function Menu.Alerts(Header)
		Menu.Callbacks.Alerts = {}
		local self = Menu.Callbacks.Alerts
		local Item = Header:CreateItem(KBM.Language.Options.Alert[KBM.Lang], "Alerts")
		local MenuItem

		function self:Enabled(bool)
			KBM.Options.Alerts.Enabled = bool
		end
		function self:Visible(bool)
			KBM.Options.Alerts.Visible = bool
			if bool then
				KBM.Alert.Anchor:SetAlpha(1)
				KBM.Alert.Left.red:SetAlpha(1)
				KBM.Alert.Right.red:SetAlpha(1)
				KBM.Alert.Top.red:SetAlpha(1)
				KBM.Alert.Bottom.red:SetAlpha(1)
			end
			KBM.Alert:ApplySettings()
		end
		function self:ScaleText(bool)
			KBM.Options.Alerts.ScaleText = bool
		end
		function self:FlashUnlocked(bool)
			KBM.Options.Alerts.FlashUnlocked = bool
			-- if KBM.Options.Alerts.Visible then
				-- KBM.Alert.AlertControl.Left:SetVisible(bool)
				-- KBM.Alert.AlertControl.Right:SetVisible(bool)
				-- KBM.Alert.AlertControl.Top:SetVisible(bool)
				-- KBM.Alert.AlertControl.Bottom:SetVisible(bool)
			-- end
			KBM.Alert:ApplySettings()
		end
		function self:Flash(bool)
			KBM.Options.Alerts.Flash = bool
		end
		function self:Vertical(bool)
			KBM.Options.Alerts.Vertical = bool
			KBM.Alert:ApplySettings()
		end
		function self:Horizontal(bool)
			KBM.Options.Alerts.Horizontal = bool
			KBM.Alert:ApplySettings()
		end
		function self:Notify(bool)
			KBM.Options.Alerts.Notify = bool
		end

		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], KBM.Options.Alerts, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.AlertText[KBM.Lang], KBM.Options.Alerts, "Notify", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.Alerts, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.Alerts, "ScaleText", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockFlash[KBM.Lang], KBM.Options.Alerts, "FlashUnlocked", self)
		MenuItem = MenuItem:CreateHeader(KBM.Language.Options.AlertFlash[KBM.Lang], KBM.Options.Alerts, "Flash", self)
		MenuItem:CreateCheck(KBM.Language.Options.AlertVert[KBM.Lang], KBM.Options.Alerts, "Vertical", self)
		MenuItem:CreateCheck(KBM.Language.Options.AlertHorz[KBM.Lang], KBM.Options.Alerts, "Horizontal", self)
	end

	-- Mechanic Spy
	function Menu.MechSpy(Header)
		Menu.Callbacks.MechSpy = {}
		local self = Menu.Callbacks.MechSpy
		local Item = Header:CreateItem(KBM.Language.MechSpy.Name[KBM.Lang], "MechSpy")
		local MenuItem	
		
		function self:Enabled(bool)
			KBM.Options.MechSpy.Enabled = bool
			KBM.MechSpy:ApplySettings()
		end
		function self:Show(bool)
			KBM.Options.MechSpy.Show = bool
			KBM.MechSpy:ApplySettings()
		end
		function self:Visible(bool)
			KBM.Options.MechSpy.Visible = bool
			KBM.MechSpy:ApplySettings()		
		end
		function self:ScaleWidth(bool)
			KBM.Options.MechSpy.ScaleWidth = bool
		end
		function self:ScaleHeight(bool)
			KBM.Options.MechSpy.ScaleHeight = bool
		end
		function self:ScaleText(bool)
			KBM.Options.MechSpy.ScaleText = bool
		end
				
		MenuItem = Item.UI.CreateHeader(KBM.Language.MechSpy.Enabled[KBM.Lang], KBM.Options.MechSpy, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.MechSpy.Show[KBM.Lang], KBM.Options.MechSpy, "Show", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.MechSpy, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.MechSpy, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.MechSpy, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.MechSpy, "ScaleText", self)
	end

	local Header = KBM.Menu.Page:CreateHeader(KBM.Language.Menu.Global[KBM.Lang], "GLOP", "Main", "Main")
	Menu.Main(Header)
	Menu.Timers(Header)
	Menu.Phases(Header)
	Menu.CastBars(Header)
	Menu.Alerts(Header)
	Menu.MechSpy(Header)
end

local function BuildMenuModules()
	local Menu = {}
	Menu.Callbacks = {}

	-- Tank Swap
	function Menu.TankSwap(Header)
		Menu.Callbacks.TankSwap = {}
		local self = Menu.Callbacks.TankSwap
		local Item = Header:CreateItem(KBM.Language.TankSwap.Title[KBM.Lang], "TankSwap")
		local MenuItem, CheckItem
		
		-- Tank-Swap Close link.
		function self:Close()
			if KBM.Menu.Active then
				if KBM.TankSwap.Active then
					if KBM.TankSwap.Test then
						KBM.TankSwap:Remove()
						KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
					end
				end
			else
				if KBM.TankSwap.Active then
					if KBM.TankSwap.Test then
						CheckItem.UI.Check:SetChecked(false)
					end
				end
			end
		end
		
		function self:Enabled(bool)
			KBM.Options.TankSwap.Enabled = bool
			KBM.TankSwap.Enabled = bool
		end
		
		function self:Visible(bool)
			KBM.Options.TankSwap.Visible = bool
			if not KBM.TankSwap.Active then
				KBM.TankSwap.Anchor:SetVisible(bool)
			end
		end
		
		function self:Unlocked(bool)
			KBM.Options.TankSwap.Unlocked = bool
			KBM.TankSwap.Anchor.Drag:SetVisible(bool)
		end
		
		function self:ScaleWidth(bool)
			KBM.Options.TankSwap.ScaleWidth = bool
		end
			
		function self:ScaleHeight(bool)
			KBM.Options.TankSwap.ScaleHeight = bool
		end
				
		function self:Tank(bool)
			KBM.Options.TankSwap.Tank = bool
		end
		
		function self:Test(bool)
			if bool then
				KBM.TankSwap:Add("Dummy", "Tank A")
				KBM.TankSwap:Add("Dummy", "Tank B")
				KBM.TankSwap:Add("Dummy", "Tank C")
				KBM.TankSwap.Anchor:SetVisible(false)
			else
				KBM.TankSwap:Remove()
				KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
			end
		end
		
		-- Tank-Swap Options. 
		MenuItem = Item.UI.CreateHeader(KBM.Language.TankSwap.Enabled[KBM.Lang], KBM.Options.TankSwap, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.TankSwap, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.TankSwap.Tank[KBM.Lang], KBM.Options.TankSwap, "Tank", self)
		CheckItem = MenuItem:CreateCheck(KBM.Language.TankSwap.Test[KBM.Lang], nil, "Test", self)
		MenuItem = MenuItem:CreateHeader(KBM.Language.Options.LockAnchor[KBM.Lang], KBM.Options.TankSwap, "Unlocked", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.TankSwap, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.TankSwap, "ScaleHeight", self)
		
		Item:SetCloseLink(self.Close)
	end

	-- Percentage Monitor
	function Menu.PerMon(Header)
		Menu.Callbacks.PerMon = {}
		local self = Menu.Callbacks.PerMon
		local Item = Header:CreateItem(KBM.Language.PerMon.Title[KBM.Lang], "PerMon")
		local MenuItem
		
		function self:Enabled(bool)
			KBM.PercentageMon.Settings.Enabled = bool
			KBM.PercentageMon.GUI.Cradle:SetVisible(bool)
		end
		function self:Unlocked(bool)
			KBM.PercentageMon.Settings.Unlocked = bool
			if bool then
				KBM.PercentageMon:SetEvents()
			else
				KBM.PercentageMon:ClearEvents()
			end
		end
		function self:Scalable(bool)
			KBM.PercentageMon.Settings.Scalable = bool
			if bool then
				KBM.PercentageMon:UnlockScale()
			else
				KBM.PercentageMon:LockScale()
			end
		end
		function self:Names(bool)
			KBM.PercentageMon.Settings.Names = bool
			KBM.PercentageMon:SetNames()
		end
		function self:Marks(bool)
			KBM.PercentageMon.Settings.Marks = bool
			KBM.PercentageMon:SetMarkL()
			KBM.PercentageMon:SetMarkR()
		end
		function self:Percent(bool)
			KBM.PercentageMon.Settings.Percent = bool
			KBM.PercentageMon:SetPercentL()
			KBM.PercentageMon:SetPercentR()
		end
		
		MenuItem = Item.UI.CreateHeader(KBM.Language.PerMon.Enable[KBM.Lang], KBM.PercentageMon.Settings, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Unlock[KBM.Lang], KBM.PercentageMon.Settings, "Unlocked", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Scale[KBM.Lang], KBM.PercentageMon.Settings, "Scalable", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Name[KBM.Lang], KBM.PercentageMon.Settings, "Names", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Mark[KBM.Lang], KBM.PercentageMon.Settings, "Marks", self)
		MenuItem:CreateCheck(KBM.Language.PerMon.Percent[KBM.Lang], KBM.PercentageMon.Settings, "Percent", self)
	end	

	-- Ready Check
	function Menu.ReadyCheck(Header)
		Menu.Callbacks.ReadyCheck = {}
		Menu.Callbacks.ReadyButton = {}
		local self = Menu.Callbacks.ReadyCheck
		local Item = Header:CreateItem(KBM.Language.ReadyCheck.Name[KBM.Lang], "ReadyCheck")
		local MenuItem
	
		function self:Enabled(bool)
			KBM.Ready.Enabled = bool
			KBM.Ready.Enable(bool)
			KBM.Ready.Button:ApplySettings()
		end
		function self:Combat(bool)
			KBM.Ready.Settings.Combat = bool
			KBM.Ready.UpdateSMode()
		end
		function self:Solo(bool)
			KBM.Ready.Settings.Solo = bool
			KBM.Ready.UpdateSMode()
		end
		function self:Unlocked(bool)
			KBM.Ready.Settings.Unlocked = bool
			KBM.Ready.SetLock()
		end
		function self:Hidden(bool)
			KBM.Ready.Settings.Hidden = bool
			KBM.Ready.UpdateSMode()
		end
		function self:Scale(bool)
			KBM.Ready.Settings.Scale = bool
			KBM.Ready.GUI:SetScaling(bool)
		end
			
		MenuItem = Item.UI.CreateHeader(KBM.Language.Options.Enabled[KBM.Lang], KBM.Ready.Settings, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Unlock[KBM.Lang], KBM.Ready.Settings, "Unlocked", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Size[KBM.Lang], KBM.Ready.Settings, "Scale", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Hidden[KBM.Lang], KBM.Ready.Settings, "Hidden", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Combat[KBM.Lang], KBM.Ready.Settings, "Combat", self)
		MenuItem:CreateCheck(KBM.Language.ReadyCheck.Solo[KBM.Lang], KBM.Ready.Settings, "Solo", self)
		
		-- Button Settings
		self = Menu.Callbacks.ReadyButton
		function self:Visible(bool)
			KBM.Ready.Settings.Button.Visible = bool
			KBM.Ready.Button:ApplySettings()
		end
		function self:Unlocked(bool)
			KBM.Ready.Settings.Button.Unlocked = bool
			KBM.Ready.Button:SetUnlocked(bool)
		end
		
		MenuItem = MenuItem:CreateHeader(KBM.Language.Options.Button[KBM.Lang], KBM.Ready.Settings.Button, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.LockButton[KBM.Lang], KBM.Ready.Settings.Button, "Unlocked", self)
	end

	-- Res Master
	function Menu.ResMaster(Header)
		Menu.Callbacks.ResMaster = {}
		local self = Menu.Callbacks.ResMaster
		local Item = Header:CreateItem(KBM.Language.ResMaster.Name[KBM.Lang], "ResMaster")
		local MenuItem
		
		function self:Enabled(bool)
			KBM.Options.ResMaster.Enabled = bool
			if bool then
				KBM.PlayerControl:GatherAbilities(true)
				KBM.PlayerControl:GatherRaidInfo()
			else
				KBM.ResMaster.Rezes:Clear()
			end
		end
		function self:Visible(bool)
			KBM.Options.ResMaster.Visible = bool
			KBM.Options.ResMaster.Unlocked = bool
			KBM.ResMaster.GUI:ApplySettings()
		end
		function self:ScaleWidth(bool)
			KBM.Options.ResMaster.ScaleWidth = bool
		end
		function self:ScaleHeight(bool)
			KBM.Options.ResMaster.ScaleHeight = bool
		end
		function self:ScaleText(bool)
			KBM.Options.ResMaster.ScaleText = bool
		end
		function self:Cascade(bool)
			KBM.Options.ResMaster.Cascade = bool
			KBM.ResMaster:ReOrder()
		end
		
		MenuItem = Item.UI.CreateHeader(KBM.Language.ResMaster.Enabled[KBM.Lang], KBM.Options.ResMaster, "Enabled", self)
		MenuItem:CreateCheck(KBM.Language.ResMaster.Cascade[KBM.Lang], KBM.Options.ResMaster, "Cascade", self)
		MenuItem:CreateCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], KBM.Options.ResMaster, "Visible", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], KBM.Options.ResMaster, "ScaleWidth", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], KBM.Options.ResMaster, "ScaleHeight", self)
		MenuItem:CreateCheck(KBM.Language.Options.UnlockText[KBM.Lang], KBM.Options.ResMaster, "ScaleText", self)
	end
	
	local Header = KBM.Menu.Page:CreateHeader(KBM.Language.Menu.Mods[KBM.Lang], "MODS", "Main", "Main")
	Menu.TankSwap(Header)
	Menu.PerMon(Header)
	Menu.ReadyCheck(Header)
	Menu.ResMaster(Header)	
end

function KBM.InitMenus()	
	-- New Style Menu
	BuildMenuSettings()
	BuildMenuModules()

	-- Reset References for missing UTIDs
	-- These are compiled fresh each run.
	KBM.Options.UnitCache.Raid = {}
	KBM.Options.UnitCache.Sliver = {}
	KBM.Options.UnitCache.Master = {}
	KBM.Options.UnitCache.Expert = {}
	KBM.Options.UnitCache.Normal = {}
	
	-- Compile Boss Menus
	for _, Mod in ipairs(KBM.ModList) do
		Mod:AddBosses(KBM.Boss.Name)
		if Mod.InstanceObj then
			if not KBM.Boss[Mod.InstanceObj.Type] then
				print("WARNING: Encounter "..Mod.InstanceObj.Name.." has an incorrect Type value of "..tostring(Mod.InstanceObj.Type))
			end
			Mod.UTID = {}
			for BossName, BossObj in pairs(Mod.Bosses) do
				if BossObj.UTID then
					if type(BossObj.UTID) == "table" then
						for i, UTID in pairs(BossObj.UTID) do
							KBM.AllocateBoss(Mod, BossObj, UTID, i)
							Mod.UTID[UTID] = BossObj
						end
					elseif type(BossObj.UTID) == "string" then
						KBM.AllocateBoss(Mod, BossObj, BossObj.UTID)
						Mod.UTID[BossObj.UTID] = BossObj
					else
						print("Error: UTID for "..BossObj.Name.." is an incorrect type (string/table)")
						error("Type is: "..type(UTID))
					end
				elseif BossObj.RaidID then
					print("WARNING: Old style RaidID field used for: "..BossObj.Name)
					print("in Encounter: "..Mod.InstanceObj.Name)
				elseif BossObj.SliverID then
					print("WARNING: Old style SliverID field used for: "..BossObj.Name)
					print("in Encounter: "..Mod.InstanceObj.Name)					
				else
					if Mod.InstanceObj.Type == "Normal" or Mod.InstanceObj.Type == "Expert" or Mod.InstanceObj.Type == "Master" then
						print(string.format("WARNING: Old style %sID field used for: "..BossObj.Name, Mod.InstanceObj.Type))
						print("in Encounter: "..Mod.InstanceObj.Name)					
					else
						print("Instance: "..BossObj.Mod.Instance)
						error("Missing RaidID or SliverID for "..BossObj.Name)
					end
				end
				if BossObj.ChronicleID then
					KBM.Boss.Chronicle[BossObj.ChronicleID] = BossObj
					KBM.Boss.TypeList[BossObj.ChronicleID] = BossObj
					Mod.UTID[BossObj.ChronicleID] = BossObj
				end
				if KBM.SubBoss[BossObj.Name] then
					print("WARNING: Boss "..BossObj.Name.." assigning old style KBM.SubBoss table entry")
					print("Instance: "..Mod.InstanceObj.Name.." ("..Mod.InstanceObj.Type..")")				
					print("Encounter: "..Mod.Descript)
				end
			end
			Mod.InstanceObj.MenuObj:CreateEncounter(Mod)
		elseif not Mod.IsInstance then
			error(tostring(Mod.ID).." is missing required field: InstanceObj")
		else
			-- Instance Header
			KBM.Menu.Instance:Create(Mod)
		end
		Mod:Start()
	end	
end

local function KBM_Start()
	local MinVer = {
		["KBMAddWatch"] = {
			High = 0,
			Mid = 2,
			Low = 9,
			Rev = 74,
		},
		["KBMMarkIt"] = {
			High = 0,
			Mid = 2,
			Low = 0,
			Rev = 43,
		},
	}

	if KBM.PlugIn.Count > 0 then
		for ID, PlugIn in pairs(KBM.PlugIn.List) do
			if type(PlugIn.Version) == "table" then
				if PlugIn.Version.Check then
					local Comp = true
					local VerString = "0.0.0.0"
					if MinVer[ID] then
						Comp = PlugIn.Version:Check(MinVer[ID].Rev)
						VerString = string.format("%d.%d.%d.%d", MinVer[ID].High, MinVer[ID].Mid, MinVer[ID].Low, MinVer[ID].Rev)
					end
					if Comp then
						if PlugIn.Start then
							PlugIn:Start()
						end
					else
						KBM.Chat.Out(string.format(KBM.Language.Chat.PlugVer[KBM.Lang], ID, VerString), true)
					end
				else
					KBM.Chat.Out(string.format(KBM.Language.Chat.PlugInc[KBM.Lang], ID), true)
				end
			else
				KBM.Chat.Out(string.format(KBM.Language.Chat.PlugInc[KBM.Lang], ID), true)
			end
		end
	end		
end

KBM.SheepProtection = {}
function KBM.SheepProtection:Init()
	self.SheepList = {
		["B2C7F2ABFDAD20E1D"] = "Shambler",
		["B69270855B9A593AC"] = "Sheep",
	}
	function self.Remove(BuffID, CasterID)
		if KBM.Options.Sheep.Protect then
			local Name
			if CasterID then
				if LibSUnit.Lookup.UID[CasterID] then
					Name = LibSUnit.Lookup.UID[CasterID].Name
				end
			end
			if Name then
				print("Auto removing Polymorph effects cast by "..Name.."!")
			else
				print("Auto removing Polymorph effects!")
			end
			Command.Buff.Cancel(BuffID)
		end
	end
	for ID, bool in pairs(self.SheepList) do
		local Trigger = KBM.Trigger:Create(ID, "playerBuffID", nil, nil, "CustomBuffRemove")
		Trigger:AddPhase(self.Remove)
	end
end

function KBM.InitEvents()
	-- Addon API Events
	-- Chat
	Command.Event.Attach(Event.Chat.Notify, KBM.Notify, "Notify Event")
	Command.Event.Attach(Event.Chat.Npc, KBM.NPCChat, "NPC Chat")
	-- Units
	-- System
	Command.Event.Attach(Event.System.Update.Begin, function () KBM:Timer() end, "System Update Begin")
	--Command.Event.Attach(Event.System.Update.End, function () KBM:AuxTimer() end, "System Update End")
	Command.Event.Attach(Event.System.Secure.Enter, KBM.SecureEnter, "Secure Enter")
	Command.Event.Attach(Event.System.Secure.Leave, KBM.SecureLeave, "Secure Leave")
	
	-- Safe's Buff Library Events
	Command.Event.Attach(Event.SafesBuffLib.Buff.Add, function (...) KBM:BuffAdd(...) end, "Buff Monitor (Add)")
	Command.Event.Attach(Event.SafesBuffLib.Buff.Change, function (...) KBM:BuffAdd(...) end, "Buff Monitor (Change)")
	Command.Event.Attach(Event.SafesBuffLib.Buff.Remove, function (...) KBM:BuffRemove(...) end, "Buff Monitor (Remove)")
	
	-- Safe's Unit Library Events
	Command.Event.Attach(Event.SafesUnitLib.Unit.New.Full, KBM.Unit.Available, "Unit Available")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Full, KBM.Unit.Available, "Unit Available")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Removed, KBM.Unit.Removed, "Unit Removed")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Combat, KBM.CombatEnter, "Unit Combat Enter")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Combat.Enter, KBM.Raid.CombatEnter, "Raid Combat Enter")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Combat.Leave, KBM.Raid.CombatLeave, "Raid Combat Leave")
	--Command.Event.Attach(Event.SafesUnitLib.Raid.Wipe, 
	Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Percent, KBM.Unit.Percent, "Unit Percent Change")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Mark, KBM.Unit.Mark, "Unit Mark Change")
	Command.Event.Attach(Event.SafesUnitLib.Combat.Damage, KBM.Damage, "Unit Damage")
	Command.Event.Attach(Event.SafesUnitLib.Combat.Heal, KBM.Heal, "Unit Heal")
	Command.Event.Attach(Event.SafesUnitLib.Combat.Death, KBM.Unit.Death, "Unit Death")
	
	-- Slash Commands
	Command.Event.Attach(Command.Slash.Register("kbmreset"), function(handle) KBM_Reset(true) end, "KBM Reset")
	Command.Event.Attach(Command.Slash.Register("kbmhelp"), KBM_Help, "KBM Help")
	Command.Event.Attach(Command.Slash.Register("kbmversion"), function(handle, ...) KBM_Version(...) end, "KBM Version Info")
	Command.Event.Attach(Command.Slash.Register("kbmoptions"), KBM_Options, "KBM Open Options")
	Command.Event.Attach(Command.Slash.Register("kbmdebug"), KBM_Debug, "KBM Debug on/off")
	Command.Event.Attach(Command.Slash.Register("kbmlocale"), KBMLM.FindMissing, "KBM Locale Finder")
	Command.Event.Attach(Command.Slash.Register("kbmcpu"), function() KBM.CPU:Toggle() end, "KBM CPU Monitor")
	Command.Event.Attach(Command.Slash.Register("kbmbuffs"), KBM.SlashInspectBuffs, "Slash Command for Buff Listing")
	Command.Event.Attach(Command.Slash.Register("kbmon"), function(handle) KBM.StateSwitch(true) end, "KBM On")
	Command.Event.Attach(Command.Slash.Register("kbmoff"), function(handle) KBM.StateSwitch(false) end, "KBM Off")
	Command.Event.Attach(Command.Slash.Register("kbmdefault"), KBM.SlashDefault, "Default settings handler")
	Command.Event.Attach(Command.Slash.Register("kbmunitcache"), KBM.SlashUnitCache, "Unit Data mining output")
	Command.Event.Attach(Command.Slash.Register("kbmzone"), KBM.SlashZone, "KBM Zone Info")
end

function KBM.WaitReady()
	KBM.Player.UnitObj = LibSUnit.Player
	KBM.Player.ID = "KBM_Player"
	KBM.Player.Name = LibSUnit.Player.Name
	KBM.Player.UnitID = LibSUnit.Player.UnitID
	KBM_Start()
	KBM.InitEvents()
	KBM.Event.System.Start(self)
	
	KBM.Castbar:LoadPlayerBars()
end

KBM.PlugIn = {}
KBM.PlugIn.List = {}
KBM.PlugIn.Count = 0
function KBM.PlugIn.Register(PlugIn)
	if PlugIn then
		if KBM.PlugIn.List[PlugIn.ID] then
			print("<Plug-In ID Conflict> The Plug-In ID: "..PlugIn.ID.." already exists.")
			print("Plug-In will not be registered.")
		else
			KBM.PlugIn.List[PlugIn.ID] = PlugIn
			KBM.PlugIn.Count = KBM.PlugIn.Count + 1
			if KBM.CPU.CreateTrack then
				if KBM.PlugIn.List["KBMMarkIt"] then
					if PlugIn.ID == "KBMMarkIt" then
						KBM.CPU:CreateTrack("KBMMarkIt", "KBM: Mark-It", 0.9, 0.5, 0.35)
					end
				end
				if KBM.PlugIn.List["KBMAddWatch"] then
					if PlugIn.ID == "KBMAddWatch" then
						KBM.CPU:CreateTrack("KBMAddWatch", "KBM: AddWatch", 0.9, 0.5, 0.35)
					end
				end
			end
		end
	else
		print("Attempted Plug-In load failed. Incorrect parameters <PlugIn>")
		print("Expecting Plug-In Table Object.")
	end
end

function KBM.RegisterMod(ModID, Mod)
	if KBM.BossMod[ModID] then
		error("<Mod ID Conflict> The Mod ID: "..ModID.." already exists.") 
	else
		KBM.BossMod[ModID] = Mod
		table.insert(KBM.ModList, Mod)
	end
end

function KBM.InitKBM(handle, ModID)	
	if ModID == "KBMReadyCheck" then
		KBM.ApplySettings()
		local TempGUIList = {}
		for Cached = 1, KBM.Trigger.High.Timers do
			local TempGUI = KBM.MechTimer:Pull()
			TempGUI.Background:SetVisible(false)
			table.insert(TempGUIList, TempGUI)
		end
		for n, GUIObj in ipairs(TempGUIList) do
			table.insert(KBM.MechTimer.Store, GUIObj)
		end
		KBM.CPU:Toggle(true)
		
		KBM.ResMaster:Start()
		KBM.Player.Rezes = {
			List = {},
			Resume = {},
			Count = 0,
		}
		KBM.PlayerControl:Start()	
		for i, File in pairs(KBM.Marks.File) do
			KBM.Marks.Icon[i] = UI.CreateFrame("Texture", File, KBM.Context)
			KBM.Marks.Icon[i]:SetTexture("Rift", File)
			KBM.Marks.Icon[i]:SetVisible(false)
		end
		
		-- Finalize Menu's
		KBM.InitMenus()
			
		-- Start
		if KBM.IsAlpha then
			print(KBM.Language.Welcome.Welcome[KBM.Lang]..AddonData.toc.Version.." Alpha")
		else
			print(KBM.Language.Welcome.Welcome[KBM.Lang]..AddonData.toc.Version)
		end
		print(KBM.Language.Welcome.Commands[KBM.Lang])
		print(KBM.Language.Welcome.Options[KBM.Lang])
	else
		if Inspect.Buff.Detail ~= IBDReserved then
			print(tostring(ModID).." changed internal command: Restoring Inspect.Buff.Detail")
			Inspect.Buff.Detail = IBDReserved
		end
	end
end

Command.Event.Attach(Event.Addon.SavedVariables.Load.Begin, KBM_DefineVars, "KBM_Main_Load_Begin")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, KBM_LoadVars, "KBM_Main_Load_End")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, KBM_SaveVars, "KBM_Main_Save_Begin")
Command.Event.Attach(Event.Addon.Load.End, KBM.InitKBM, "KBM Begin Init Sequence")
Command.Event.Attach(Event.SafesUnitLib.System.Start, KBM.WaitReady, "KBM Sync Wait")

local AddonDetails = Inspect.Addon.Detail("KBMTextureHandler")
KBM.LoadTexture = AddonDetails.data.LoadTexture
