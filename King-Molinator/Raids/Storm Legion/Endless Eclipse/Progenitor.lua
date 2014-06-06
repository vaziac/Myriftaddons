﻿-- Progenitor Saetos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEEPR_Settings = nil
chKBMSLRDEEPR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local PRO = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Progenitor.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "RProgenitor",
	Object = "PRO",
	Enrage = (7 * 60) + 30,
	DeathCount = 0,
}

KBM.RegisterMod(PRO.ID, PRO)

-- Main Unit Dictionary
PRO.Lang.Unit = {}
PRO.Lang.Unit.Progenitor = KBM.Language:Add("Progenitor Saetos")
PRO.Lang.Unit.Progenitor:SetGerman("Erzeuger Saetos")
PRO.Lang.Unit.Progenitor:SetFrench("Progéniteur Saetos")
PRO.Lang.Unit.ProgenitorShort = KBM.Language:Add("Saetos")
PRO.Lang.Unit.ProgenitorShort:SetGerman("Saetos")
PRO.Lang.Unit.ProgenitorShort:SetFrench("Saetos")
PRO.Lang.Unit.Ebassi = KBM.Language:Add("Ebassi")
PRO.Lang.Unit.Ebassi:SetGerman()
PRO.Lang.Unit.Ebassi:SetFrench("Ebassi")
PRO.Lang.Unit.Arebus = KBM.Language:Add("Arebus")
PRO.Lang.Unit.Arebus:SetGerman() 
PRO.Lang.Unit.Arebus:SetFrench("Arebus") 
PRO.Lang.Unit.Rhu = KBM.Language:Add("Rhu'Megar")
PRO.Lang.Unit.Rhu:SetGerman()
PRO.Lang.Unit.Rhu:SetFrench("Rhu'Megar")
PRO.Lang.Unit.Juntun = KBM.Language:Add("Juntun")
PRO.Lang.Unit.Juntun:SetGerman()
PRO.Lang.Unit.Juntun:SetFrench("Juntun")

-- Ability Dictionary
PRO.Lang.Ability = {}
PRO.Lang.Ability.Ebon = KBM.Language:Add("Ebon Eruption")
PRO.Lang.Ability.Ebon:SetFrench("Éruption d'ébène")
PRO.Lang.Ability.Ebon:SetGerman("Schwärzeausbruch")
PRO.Lang.Ability.Redesign = KBM.Language:Add("Twisted Redesign")
PRO.Lang.Ability.Redesign:SetFrench("Refonte tordue")
PRO.Lang.Ability.Redesign:SetGerman("Verdrehte Umwandlung")
PRO.Lang.Ability.Entropic = KBM.Language:Add("Entropic Abyss")
PRO.Lang.Ability.Entropic:SetFrench("Abysses entropiques")
PRO.Lang.Ability.Entropic:SetGerman("Entropischer Abgrund")

-- Buff Dictionary
PRO.Lang.Buff = {}
PRO.Lang.Buff.Barrier = KBM.Language:Add("Ebon Barrier")
PRO.Lang.Buff.Barrier:SetFrench("Barrière d'ébène")
PRO.Lang.Buff.Barrier:SetGerman("Schwärzebarriere")
PRO.Lang.Buff.Hand = KBM.Language:Add("Hand of the Master")
PRO.Lang.Buff.Hand:SetFrench("Main du Maître")
PRO.Lang.Buff.Hand:SetGerman("Hand des Meisters")

-- Debuff Dictionary
PRO.Lang.Debuff = {}
PRO.Lang.Debuff.Soul = KBM.Language:Add("Soul Rupture")
PRO.Lang.Debuff.Soul:SetGerman("Seelenbruch")

-- Description Dictionary
PRO.Lang.Main = {}

PRO.Descript = PRO.Lang.Unit.Progenitor[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
PRO.Progenitor = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Progenitor[KBM.Lang],
	NameShort = PRO.Lang.Unit.ProgenitorShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD291C6A48356A9E",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Redesign = KBM.Defaults.AlertObj.Create("orange"),
			Soul = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Ebon = KBM.Defaults.MechObj.Create("cyan"),
			Soul = KBM.Defaults.MechObj.Create("purple"),
			Entropic = KBM.Defaults.MechObj.Create("blue"),
		},
	}
}

PRO.Ebassi = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Ebassi[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFB8F268E16C8A192",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

PRO.Arebus = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Arebus[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFC1DFC775231ADB4",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

PRO.Rhu = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Rhu[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFB51152D35742133",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

PRO.Juntun = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Juntun[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFC8E06386D2DCB01",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

function PRO:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Progenitor.Name] = self.Progenitor,
		[self.Ebassi.Name] = self.Ebassi,
		[self.Arebus.Name] = self.Arebus,
		[self.Rhu.Name] = self.Rhu,
		[self.Juntun.Name] = self.Juntun,
	}

	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end
end

function PRO:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Progenitor = {
			CastBar = self.Progenitor.Settings.CastBar,
			AlertsRef = self.Progenitor.Settings.AlertsRef,
			MechRef = self.Progenitor.Settings.MechRef,
		},
		Juntun = {
			CastBar = self.Juntun.Settings.CastBar,
			TimersRef = self.Juntun.Settings.TimersRef,
			AlertsRef = self.Juntun.Settings.AlertsRef,
		},
		Ebassi = {
			CastBar = self.Ebassi.Settings.CastBar,
			TimersRef = self.Ebassi.Settings.TimersRef,
			AlertsRef = self.Ebassi.Settings.AlertsRef,
		},
		Arebus = {
			CastBar = self.Arebus.Settings.CastBar,
			TimersRef = self.Arebus.Settings.TimersRef,
			AlertsRef = self.Arebus.Settings.AlertsRef,
		},
		Rhu = {
			CastBar = self.Rhu.Settings.CastBar,
			TimersRef = self.Rhu.Settings.TimersRef,
			AlertsRef = self.Rhu.Settings.AlertsRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMSLRDEEPR_Settings = self.Settings
	chKBMSLRDEEPR_Settings = self.Settings
	
end

function PRO:SwapSettings(bool)

	if bool then
		KBMSLRDEEPR_Settings = self.Settings
		self.Settings = chKBMSLRDEEPR_Settings
	else
		chKBMSLRDEEPR_Settings = self.Settings
		self.Settings = KBMSLRDEEPR_Settings
	end

end

function PRO:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEEPR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEEPR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEEPR_Settings = self.Settings
	else
		KBMSLRDEEPR_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function PRO:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEEPR_Settings = self.Settings
	else
		KBMSLRDEEPR_Settings = self.Settings
	end	
end

function PRO:Castbar(units)
end

function PRO:RemoveUnits(UnitID)
	if self.Progenitor.UnitID == UnitID then
		self.Progenitor.Available = false
		return true
	end
	return false
end

function PRO:PhaseTwo(RightBossObj)
	self.Phase = 2
	self.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	KBM.PercentageMon:SetBossRight(RightBossObj)
	KBM.PercentageMon:Start(self.ID, true)
end

function PRO:UpdatePhaseMon()
	local RightBossObj
	self.PhaseObj.Objectives:Remove()
	for BossName, BossObj in pairs(self.Bosses) do
		if not BossObj.Dead then
			self.PhaseObj.Objectives:AddPercent(BossObj, 0, 100)
			if BossObj ~= self.Progenitor then
				RightBossObj = BossObj
			end
		end
	end
	if self.DeathCount == 3 then
		self:PhaseTwo(RightBossObj)
	end
end

function PRO:Death(UnitID)
	if self.Progenitor.UnitID == UnitID then
		self.Progenitor.Dead = true
		return true
	else
		if self.Phase == 1 then
			if self.Juntun.UnitID == UnitID then
				if not self.Juntun.Dead then
					self.Juntun.Dead = true
					self.DeathCount = self.DeathCount + 1
					self:UpdatePhaseMon()
				end
			end
			if self.Ebassi.UnitID == UnitID then
				if not self.Ebassi.Dead then
					self.Ebassi.Dead = true
					self.DeathCount = self.DeathCount + 1
					self:UpdatePhaseMon()
				end
			end
			if self.Arebus.UnitID == UnitID then
				if not self.Arebus.Dead then
					self.Arebus.Dead = true
					self.DeathCount = self.DeathCount + 1
					self:UpdatePhaseMon()
				end
			end
			if self.Rhu.UnitID == UnitID then
				if not self.Rhu.Dead then
					self.Rhu.Dead = true
					self.DeathCount = self.DeathCount + 1
					self:UpdatePhaseMon()
				end
			end
		end
	end
	return false
end

function PRO:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Progenitor, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Juntun, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Ebassi, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Arebus, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Rhu, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					BossObj.CastBar:Remove()
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function PRO:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		BossObj.CastBar:Remove()
	end
	self.Phase = 1
	self.DeathCount = 0
	self.PhaseObj:End(Inspect.Time.Real())
end

function PRO:Timer()	
end

function PRO:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Progenitor, self.Enabled)
end

function PRO:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Progenitor)
	
	-- Create Alerts
	self.Progenitor.AlertsRef.Redesign = KBM.Alert:Create(self.Lang.Ability.Redesign[KBM.Lang], nil, true, true, "orange")
	self.Progenitor.AlertsRef.Redesign:Important()
	self.Progenitor.AlertsRef.Soul = KBM.Alert:Create(self.Lang.Debuff.Soul[KBM.Lang], nil, false, true, "purple")
	self.Progenitor.AlertsRef.Soul:Important()
	KBM.Defaults.AlertObj.Assign(self.Progenitor)
	
	-- Create Spies
	--self.Progenitor.MechRef.Barrier = KBM.MechSpy:Add(self.Lang.Buff.Barrier[KBM.Lang], nil, "buff", self.Progenitor)
	self.Progenitor.MechRef.Ebon = KBM.MechSpy:Add(self.Lang.Ability.Ebon[KBM.Lang], nil, "channel", self.Progenitor)
	self.Progenitor.MechRef.Ebon:SetSource()
	self.Progenitor.MechRef.Soul = KBM.MechSpy:Add(self.Lang.Debuff.Soul[KBM.Lang], nil, "playerDebuff", self.Progenitor)
	self.Progenitor.MechRef.Entropic = KBM.MechSpy:Add(self.Lang.Ability.Entropic[KBM.Lang], 5, "cast", self.Progenitor)
	KBM.Defaults.MechObj.Assign(self.Progenitor)
	
	-- Assign Alerts and Timers to Triggers
	self.Progenitor.Triggers.Redesign = KBM.Trigger:Create(self.Lang.Ability.Redesign[KBM.Lang], "cast", self.Progenitor)
	self.Progenitor.Triggers.Redesign:AddAlert(self.Progenitor.AlertsRef.Redesign)
	self.Progenitor.Triggers.Soul = KBM.Trigger:Create(self.Lang.Debuff.Soul[KBM.Lang], "playerBuff", self.Progenitor)
	self.Progenitor.Triggers.Soul:AddAlert(self.Progenitor.AlertsRef.Soul, true)
	self.Progenitor.Triggers.Soul:AddSpy(self.Progenitor.MechRef.Soul)
	-- self.Progenitor.Triggers.Barrier = KBM.Trigger:Create(self.Lang.Buff.Barrier[KBM.Lang], "buff", self.Progenitor)
	-- self.Progenitor.Triggers.Barrier:AddSpy(self.Progenitor.MechRef.Barrier)

	self.Progenitor.CastBar = KBM.Castbar:Add(self, self.Progenitor)

	-- Setup the 4 mini bosses identically

	for k, BossObj in ipairs({[1] = self.Juntun, [2] = self.Ebassi, [3] = self.Arebus, [4] = self.Rhu, }) do
		BossObj.TimersRef.Ebon = KBM.MechTimer:Add(BossObj.Name.." "..self.Lang.Ability.Ebon[KBM.Lang], 23, false)
		KBM.Defaults.TimerObj.Assign(BossObj)
		BossObj.AlertsRef.Ebon = KBM.Alert:Create(BossObj.Name.." "..self.Lang.Ability.Ebon[KBM.Lang], nil, true, true, "red")
		KBM.Defaults.AlertObj.Assign(BossObj)
		BossObj.Triggers.Ebon = KBM.Trigger:Create(self.Lang.Ability.Ebon[KBM.Lang], "channel", BossObj)
		BossObj.Triggers.Ebon:AddTimer(BossObj.TimersRef.Ebon)
		BossObj.Triggers.Ebon:AddAlert(BossObj.AlertsRef.Ebon)
		BossObj.Triggers.Ebon:AddSpy(self.Progenitor.MechRef.Ebon)
		BossObj.Triggers.EbonInt = KBM.Trigger:Create(self.Lang.Ability.Ebon[KBM.Lang], "interrupt", BossObj)
		BossObj.Triggers.EbonInt:AddStop(BossObj.AlertsRef.Ebon)
		BossObj.Triggers.EbonInt:AddStop(self.Progenitor.MechRef.Ebon)
		BossObj.Triggers.Entropic = KBM.Trigger:Create(self.Lang.Ability.Entropic[KBM.Lang], "cast", BossObj)
		BossObj.Triggers.Entropic:AddSpy(self.Progenitor.MechRef.Entropic)
		BossObj.CastBar = KBM.Castbar:Add(self, BossObj)
		-- BossObj.Triggers.Barrier = KBM.Trigger:Create(self.Lang.Buff.Barrier[KBM.Lang], "buff", BossObj)
		-- BossObj.Triggers.Barrier:AddSpy(self.Progenitor.MechRef.Barrier)
	end
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self.PercentageMon = KBM.PercentageMon:Create(self.Progenitor, self.Juntun, 5, true)
	
end