local toc, data = ...
local id = toc.identifier

wyk.vars.Gadgets = nil
wyk.vars.kAlert = nil

wyk.vars.loadedCalling = nil

wyk.vars.RarityColors = {
	sellable =		{ r = 0.34375, g = 0.34375, b = 0.34375 },
	common =		{ r =    0.98, g =    0.98, b =    0.98 },
	uncommon =		{ r =     0.0, g =   0.797, b =     0.0 },
	rare =			{ r =   0.148, g =   0.496, b =   0.977 },
	epic =			{ r =   0.676, g =   0.281, b =    0.98 },
	quest =			{ r =     1.0, g =     1.0, b =     0.0 },
	relic =			{ r =     1.0, g =     0.5, b =     0.0 },
	transcendent =	{ r =     1.0, g =     0.0, b =     0.0 },
}

wyk.vars.Images = {
	sizes = {
		equip = 46,
		classicon = 48,
		border = 64,
	},
	other = {
		cross = { src = id, file = "resource/btnCross.png" },
		closeBtn = { src = id, file = "resource/closeBtn.png" },
		closeBtnIN = { src = id, file = "resource/closeBtn_in.png" },
		unignoreBtn = { src = id, file = "resource/unignoreBtn.png" },
		unignoreBtnIN = { src = id, file = "resource/unignoreBtn_in.png" },
		gadgetsBtn = { src = id, file = "resource/btnGadgets_in.png" },
		lock = { src = id, file = "resource/lock_silver.png" },
	},
	borders = {
		dark = { src = id, file = "resource/buttonDark.png" },
		gray = { src = id, file = "resource/buttonGray.png" },
		air = { src = id, file = "resource/buttonAir.png" },
		death = { src = id, file = "resource/buttonDeath.png" },
		earth = { src = id, file = "resource/buttonEarth.png" },
		fire = { src = id, file = "resource/buttonFire.png" },
		life = { src = id, file = "resource/buttonLife.png" },
		water = { src = id, file = "resource/buttonWater.png" },
		default = { src = "Rift", file = "icon_border.dds" },
		disabled = { src = "Rift", file = "icon_border_disabled.dds" },
		epic = { src = "Rift", file = "icon_border_epic.dds" },
		quest = { src = "Rift", file = "icon_border_quest.dds" },
		rare = { src = "Rift", file = "icon_border_rare.dds" },
		relic = { src = "Rift", file = "icon_border_relic.dds" },
		uncommon = { src = "Rift", file = "icon_border_uncommon.dds" },
	},
	slots = {
		--Changed it to images with randomized names, lets see how many times this breaks on patches!
		belt = { src = "Rift", file = "CharacterSheet_I1FF.dds" },
		chest = { src = "Rift", file = "CharacterSheet_I1F9.dds" },
		cape = { src = "Rift", file = "CharacterSheet_I243.dds" },
		feet = { src = "Rift", file = "CharacterSheet_I205.dds" },
		focus = { src = "Rift", file = "CharacterSheet_I21F.dds" },
		gloves = { src = "Rift", file = "CharacterSheet_I1FC.dds" },
		handmain = { src = "Rift", file = "CharacterSheet_I209.dds" },
		handoff = { src = "Rift", file = "CharacterSheet_I20C.dds" },
		helmet = { src = "Rift", file = "CharacterSheet_I1F3.dds" },
		legs = { src = "Rift", file = "CharacterSheet_I202.dds" },
		neck = { src = "Rift", file = "CharacterSheet_I212.dds" },
		ranged = { src = "Rift", file = "CharacterSheet_I20F.dds" },
		ring1 = { src = "Rift", file = "CharacterSheet_I218.dds" },
		ring2 = { src = "Rift", file = "CharacterSheet_I218.dds" },
		seal = { src = "Rift", file = "CharacterSheet_I21F.dds" },
		shoulders = { src = "Rift", file = "CharacterSheet_I1F7.dds" },
		synergy = { src = "Rift", file = "CharacterSheet_I21B.dds" },
		trinket = { src = "Rift", file = "CharacterSheet_I215.dds" },
	},
	classes = {
		cleric = {
			warden = { src = "Rift", file = "soul_warden.dds" },
			druid = { src = "Rift", file = "soul_druid.dds" },
			inquisitor = { src = "Rift", file = "soul_inquisitor.dds" },
			cabalist = { src = "Rift", file = "soul_cablist.dds" },
			purifier = { src = "Rift", file = "soul_purifier.dds" },
			justicar = { src = "Rift", file = "soul_justicar.dds" },
			shaman = { src = "Rift", file = "soul_shaman.dds" },
			sentinel = { src = "Rift", file = "soul_sentinel.dds" },
			defiler = { src = "Rift", file = "soul_defiler.dds" },
			oracle = { src = "Rift", file = "soul_oracle.dds" },
			templar = { src = id, file = "resource/cleric99.png" },
		},
		mage = {
			archon = { src = "Rift", file = "soul_archon.dds" },
			dominator = { src = "Rift", file = "soul_dominator.dds" },
			chloromancer = { src = "Rift", file = "soul_chloromancer.dds" },
			elementalist = { src = "Rift", file = "soul_elementalist.dds" },
			warlock = { src = "Rift", file = "soul_warlock.dds" },
			necromancer = { src = "Rift", file = "soul_necromancer.dds" },
			pyromancer = { src = "Rift", file = "soul_pyromancer.dds" },
			stormcaller = { src = "Rift", file = "soul_stormcaller.dds" },
			harbinger = { src = "Rift", file = "soul_harbinger.dds" },
			arbiter = { src = "Rift", file = "soul_arbiter.dds" },
			archmage = { src = id, file = "resource/mage99.png" },
		},
		rogue = {
			assassin = { src = "Rift", file = "soul_assassin.dds" },
			bard = { src = "Rift", file = "soul_bard.dds" },
			bladedancer = { src = "Rift", file = "soul_bladedancer.dds" },
			nightblade = { src = "Rift", file = "soul_nightblade.dds" },
			riftstalker = { src = "Rift", file = "soul_riftstalker.dds" },
			saboteur = { src = "Rift", file = "soul_saboteur.dds" },
			marksman = { src = "Rift", file = "soul_marksman.dds" },
			ranger = { src = "Rift", file = "soul_ranger.dds" },
			tactician = { src = "Rift", file = "soul_tactician.dds" },
			physician = { src = "Rift", file = "soul_physician.dds" },
			infiltrator = { src = id, file = "resource/rogue99.png" },
		},
		warrior = {
			beastmaster = { src = "Rift", file = "soul_beastmaster.dds" },
			champion = { src = "Rift", file = "soul_champion.dds" },
			warlord = { src = "Rift", file = "soul_warlord.dds" },
			paladin = { src = "Rift", file = "soul_paladin.dds" },
			paragon = { src = "Rift", file = "soul_paragon.dds" },
			reaver = { src = "Rift", file = "soul_reaver.dds" },
			riftblade = { src = "Rift", file = "soul_riftblade.dds" },
			voidknight = { src = "Rift", file = "soul_voidknight.dds" },
			tempest = { src = "Rift", file = "soul_tempest.dds" },
			liberator = { src = "Rift", file = "soul_liberator.dds" },
			vindicator = { src = id, file = "resource/warrior99.png" },
		},
	}
}

wyk.vars.ParsableSlots = {
	"seqp",
	"si01",
	"si02",
	"si03",
	"si04",
	"si05",
	"si06",
	"si07",
	"sw01",
	"sw02",
	"sw03",
	"sw04",
	"sw05",
}

wyk.vars.eqpSlots = {
	ring1 = "seqp.rn1",
	ring2 = "seqp.rn2",
	belt = "seqp.blt",
	neck = "seqp.nck",
	helmet = "seqp.hlm",
	trinket = "seqp.tkt",
	chest = "seqp.chs",
	cape = "seqp.cpe",
	focus = "seqp.fcs",
	handoff = "seqp.hof",
	legs = "seqp.lgs",
	shoulders = "seqp.shl",
	synergy = "seqp.syn",
	ranged = "seqp.rng",
	feet = "seqp.fet",
	handmain = "seqp.hmn",
	gloves = "seqp.glv",
	seal = "seqp.sel",
}


wyk.vars.slotsByCategory = {
	["head"] = wyk.func.DeriveSlot("helmet");
	["shoulders"] = wyk.func.DeriveSlot("shoulders");
	["cape"] = wyk.func.DeriveSlot("cape");
	["chest"] = wyk.func.DeriveSlot("chest");
	["hands"] = wyk.func.DeriveSlot("gloves");
	["waist"] = wyk.func.DeriveSlot("belt");
	["legs"] = wyk.func.DeriveSlot("legs");
	["feet"] = wyk.func.DeriveSlot("feet");
	["neck"] = wyk.func.DeriveSlot("neck");
	["trinket"] = wyk.func.DeriveSlot("trinket");
	["ring"] = wyk.func.DeriveSlot("ring1");
	["offring"] = wyk.func.DeriveSlot("ring2");
	["crystal"] = wyk.func.DeriveSlot("synergy");
	["seal"] = wyk.func.DeriveSlot("seal");
	["planar"] = wyk.func.DeriveSlot("focus");
	["onehand"] = wyk.func.DeriveSlot("handmain");
	["twohand"] = wyk.func.DeriveSlot("handmain");
	["offonehand"] = wyk.func.DeriveSlot("handoff");
	["totem"] = wyk.func.DeriveSlot("handoff");
	["shield"] = wyk.func.DeriveSlot("handoff");
	["ranged"] = wyk.func.DeriveSlot("ranged");
	["planar"] = wyk.func.DeriveSlot("focus");
}

wyk.vars.eqpSlotDisplaynames = {
	ring1 = "Ring",
	ring2 = "Ring",
	belt = "Belt",
	neck = "Neck",
	helmet = "Helmet",
	trinket = "Trinket",
	chest = "Chest",
	cape = "Cape",
	focus = "Planar Focus",
	handoff = "Off-Hand",
	legs = "Legs",
	shoulders = "Shoulders",
	synergy = "Synergy Crysal",
	ranged = "Ranged Weapon",
	feet = "Feet",
	handmain = "Main-Hand",
	gloves = "Gloves",
	seal = "Seal",
}

wyk.vars.eqpStats = {
	armor = { stat = "armor", delimiter = ": ", post = "", display = "Armor" },
	block = { stat = "block", delimiter = " +", post = "", display = "Block" },
	critAttack = { stat = "critAttack", delimiter = " +", post = "", display = "Physical Crit" },
	critSpell = { stat = "critSpell", delimiter = " +", post = "", display = "Spell Crit" },
	dexterity = { stat = "dexterity", delimiter = " +", post = "", display = "Dexterity" },
	dodge = { stat = "dodge", delimiter = " +", post = "", display = "Dodge" },
	endurance = { stat = "endurance", delimiter = " +", post = "", display = "Endurance" },
	energyMax = { stat = "energyMax", delimiter = " +", post = "", display = "energyMax" },
	energyRegen = { stat = "energyRegen", delimiter = " +", post = "", display = "energyRegen" },
	focus = { stat = "focus", delimiter = " +", post = "", display = "Focus" },
	hit = { stat = "hit", delimiter = " +", post = "", display = "Hit" },
	intelligence = { stat = "intelligence", delimiter = " +", post = "", display = "Intelligence" },
	manaMax = { stat = "manaMax", delimiter = " +", post = "", display = "manaMax" },
	manaRegen = { stat = "manaRegen", delimiter = " +", post = "", display = "manaRegen" },
	movement = { stat = "movement", delimiter = " ", post = "%", display = "Movement Rate" },
	parry = { stat = "parry", delimiter = " +", post = "", display = "Parry" },
	powerAttack = { stat = "powerAttack", delimiter = " +", post = "", display = "Attack Power" },
	powerMax = { stat = "powerMax", delimiter = " +", post = "", display = "powerMax" },
	powerRegen = { stat = "powerRegen", delimiter = " +", post = "", display = "powerRegen" },
	powerSpell = { stat = "powerSpell", delimiter = " +", post = "", display = "Spell Power" },
	resistAll = { stat = "resistAll", delimiter = " +", post = "", display = "Resist All" },
	resistAir = { stat = "resistAir", delimiter = " +", post = "", display = "Air" },
	resistDeath = { stat = "resistDeath", delimiter = " +", post = "", display = "Death" },
	resistEarth = { stat = "resistEarth", delimiter = " +", post = "", display = "Earth" },
	resistFire = { stat = "resistFire", delimiter = " +", post = "", display = "Fire" },
	resistLife = { stat = "resistLife", delimiter = " +", post = "", display = "Life" },
	resistWater = { stat = "resistWater", delimiter = " +", post = "", display = "Water" },
	stealth = { stat = "stealth", delimiter = " +", post = "", display = "Stealth" },
	stealthDetect = { stat = "stealthDetect", delimiter = " +", post = "", display = "Stealth Detection" },
	strength = { stat = "strength", delimiter = " +", post = "", display = "Strength" },
	wisdom = { stat = "wisdom", delimiter = " +", post = "", display = "Wisdom" },
	xp = { stat = "xp", delimiter = " ", post = "%", display = "Experience Bonus" },
	valor = { stat = "valor", delimiter = " +", post = "", display = "Valor" },
	vengeance = { stat = "vengeance", delimiter = " +", post = "", display = "Vengeance" },
	deflect = { stat = "deflect", delimiter = " +", post = "", display = "Deflect" },
}

wyk.vars.wpnStats = {
	damageDelay = { stat = "damageDelay", delimiter = nil, post = nil, display = nil },
	damageMax = { stat = "damageMax", delimiter = nil, post = nil, display = nil },
	damageMin = { stat = "damageMin", delimiter = nil, post = nil, display = nil },
	damageType = { stat = "damageType", delimiter = nil, post = nil, display = nil },
}

wyk.vars.displayStats = {
	detail1 = { stat = "dps", addbr = true },
	detail2 = { stat = "armor", addbr = false },
	detail3 = { stat = "strength", addbr = false },
	detail4 = { stat = "intelligence", addbr = false },
	detail5 = { stat = "wisdom", addbr = false },
	detail6 = { stat = "dexterity", addbr = false },
	detail7 = { stat = "endurance", addbr = false },
	detail8 = { stat = "block", addbr = false },
	detail9 = { stat = "deflect", addbr = false },
	detail10 = { stat = "dodge", addbr = false },
	detail11 = { stat = "parry", addbr = false },
	detail12 = { stat = "powerAttack", addbr = false },
	detail13 = { stat = "powerSpell", addbr = false },
	detail14 = { stat = "critAttack", addbr = false },
	detail15 = { stat = "critSpell", addbr = false },
	detail16 = { stat = "focus", addbr = false },
	detail17 = { stat = "hit", addbr = false },
	detail18 = { stat = "valor", addbr = false },
	detail19 = { stat = "vengeance", addbr = false },
	detail20 = { stat = "resistAll", addbr = false },
	detail21 = { stat = "resistLife", addbr = false },
	detail22 = { stat = "resistDeath", addbr = false },
	detail23 = { stat = "resistFire", addbr = false },
	detail24 = { stat = "resistWater", addbr = false },
	detail25 = { stat = "resistEarth", addbr = false },
	detail26 = { stat = "resistAir", addbr = false },
	detail27 = { stat = "stealth", addbr = false },
	detail28 = { stat = "stealthDetect", addbr = false },
	detail29 = { stat = "energyMax", addbr = false },
	detail30 = { stat = "energyRegen", addbr = false },
	detail31 = { stat = "manaMax", addbr = false },
	detail32 = { stat = "manaRegen", addbr = false },
	detail33 = { stat = "powerMax", addbr = false },
	detail34 = { stat = "powerRegen", addbr = false },
	detail35 = { stat = "movement", addbr = false },
	detail36 = { stat = "xp", addbr = false },
}

wyk.vars.displayStatCount = 35
wyk.vars.usrCallingIcons = nil
wyk.vars.usrCallingIconCount = 0

wyk.vars.Icons = {}
wyk.vars.IconCount = 0




