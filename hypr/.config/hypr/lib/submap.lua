local M = {}

M.create = function(key, name, callback)
	hl.bind(key, hl.dsp.submap(name))
	hl.define_submap(name, function()
		callback()
		hl.bind("escape", hl.dsp.submap("reset"))
	end)
end

return M
