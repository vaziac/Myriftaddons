local toc, data = ...
local id = toc.identifier

function wyk.frame.HR(width, color, context)
    local hr = wyk.frame.CreateFrame(wyk.UniqueName("wyk_frame_HR"), context, {
		h = 1,
		w = width, 
		bg = color,
		layer = 1, 
	}, true)
    return hr
end