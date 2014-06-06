local toc, data = ...
local id = toc.identifier

function wyk.frame.BlockDrop(obj)
    --obj.Event.LeftDown = function() obj.LeftMouseDown = true; end
	obj:EventAttach(Event.UI.Input.Mouse.Left.Down, function(self, h)
		obj.LeftMouseDown = true;
	end, "Event.UI.Input.Mouse.Left.Down")

    --obj.Event.LeftUp = function()
    --    if not obj.LeftMouseDown then
    --        local cursor, held = Inspect.Cursor()
    --        if (cursor and cursor == "item") then
    --            pcall(Command.Item.Standard.Drop, held)
    --        end
    --    end
    --   obj.LeftMouseDown = false
    --end
	obj:EventAttach(Event.UI.Input.Mouse.Left.Up, function(self, h)
        if not obj.LeftMouseDown then
            local cursor, held = Inspect.Cursor()
            if (cursor and cursor == "item") then
                pcall(Command.Item.Standard.Drop, held)
            end
        end
        obj.LeftMouseDown = false
	end, "Event.UI.Input.Mouse.Left.Up")
end
