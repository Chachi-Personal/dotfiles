local M = {}

local fullscreen_window = function(action)
	if action == "set" then
		hl.dsp.layout("colresize 1")
	elseif action == "unset" then
		hl.dsp.layout("colresize 0.5")
	end
end

M.fullscreen_workspace = function(mode)
	mode = mode == nil and "fullscreen" or mode
	local current_workspace = hl.get_active_workspace()
	local current_window = hl.get_active_window()
	if current_workspace == nil then
		return
	end
	local wins = hl.get_workspace_windows(current_workspace)
	local workspace_state = M.workspaces[current_workspace.id].state
	if workspace_state == mode then
		for _, win in ipairs(wins) do
			hl.dispatch(hl.dsp.window.fullscreen({ mode = mode, action = "unset", window = win }))
		end
		M.workspaces[current_workspace.id].state = "normal"
	end
	if workspace_state == nil or workspace_state == "normal" then
		for _, win in ipairs(wins) do
			hl.dispatch(hl.dsp.window.fullscreen({ mode = mode, action = "set", window = win }))
		end
		M.workspaces[current_workspace.id].state = mode
	end
	hl.dispatch(hl.dsp.focus({ window = current_window }))
end

M.setup = function()
	M.workspaces = {}
	for i = 1, 10, 1 do
		M.workspaces[i] = {
			state = "normal", -- normal | maximized | fullscreen?
		}
	end
	hl.on("window.open", function()
		local current_workspace_id = hl.get_active_workspace().id
		local workspace_state = M.workspaces[current_workspace_id].state
		local active_window = hl.get_active_window()
		if active_window.floating then
			return
		end
		if workspace_state == "normal" or workspace_state == nil then
			hl.dsp.window.fullscreen({ action = "unset", window = active_window })
			return
		end
		hl.dispatch(hl.dsp.window.fullscreen({ mode = workspace_state, action = "set", window = active_window }))
	end)
end

return M
