local M = {}

M.set = {}

function M.register(name)
	M.set[name] = true
end

function M.contains(name)
	return M.set[name] == true
end

return M
