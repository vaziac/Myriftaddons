﻿-- King Boss Mods Texture Handler
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMTextureHandler")
local PI = AddonData.data

PI.Store = {}
PI.Queue = {
	Count = 0,
	List = {},
}

function PI.LoadTexture(Texture, Location, File, Force)
	if Force then
		Texture:SetTexture(Location, File)
	else
		if not PI.Store[tostring(Texture)] then
			--print("Pushing unqueued Texture: "..Location.." - "..File)
			PI.Queue:Push(Texture, Location, File)
		else
			--print("Updating queued Texture: "..Location.." - "..File)
			PI.Store[tostring(Texture)].File = File
			PI.Store[tostring(Texture)].Location = Location
		end
	end
end

function PI.Queue:Push(Texture, Location, File)
	if self.Count == 0 then
		local Entry = {
			Texture = Texture,
			Location = Location,
			File = File,
		}
		self.First = Entry
		self.Last = Entry
		PI.Store[tostring(Texture)] = Entry
		--print("New queue created")
	else
		local Entry = {
			Texture = Texture,
			Location = Location,
			File = File,
			Before = self.Last,
		}
		self.Last = Entry
		Entry.Before.After = Entry
		PI.Store[tostring(Texture)] = Entry
		--print("Adding to queue")
	end
	self.Count = self.Count + 1
end

function PI.Queue:Pop(Entry)
	--print("Removing: "..Entry.Location.." - "..Entry.File)
	if self.Count == 1 then
		self.First = nil
		self.Last = nil
		--print("Queue cleared")
	else
		self.First = Entry.After
		Entry.After.Before = nil
		--print("Queue count: "..self.Count)
	end
	PI.Store[tostring(Entry.Texture)] = nil
	self.Count = self.Count - 1
end

function PI.CycleLoad()
	if PI.Queue.Count > 0 then
		--print("Items in Queue: loading")
		local TimeStart = Inspect.Time.Real()
		local Count = 0
		repeat
			if PI.Queue.First.Texture.SetTexture then
				PI.Queue.First.Texture:SetTexture(PI.Queue.First.Location, PI.Queue.First.File)
			end
			PI.Queue:Pop(PI.Queue.First)
			Count = Count + 1
			local Duration = Inspect.Time.Real() - TimeStart
			local Average = Duration / Count
			if (Average * (Count + 1)) > 0.04 then
				break
			end
		until Inspect.System.Watchdog() < 0.05 or PI.Queue.Count == 0
	end
end

Command.Event.Attach(Event.System.Update.Begin, PI.CycleLoad, "KBMTH: Stage 1 Load Cycle")
Command.Event.Attach(Event.System.Update.End, PI.CycleLoad, "KBMTH: Stage 2 Load Cycle")