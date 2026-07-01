local M = {}

M.workspaces = {}
for i = 1, 10, 1 do
	M.workspaces[i] = {
		state = "normal", -- normal | maximized | fullscreen?
	}
end

M.maximize = function(workspace)
	if workspace == nil then
		workspace = hl.get_active_workspace().id
	end

	-- TODO:
	-- If the workspace is in normal state, then maximize all windows and switch to maximized state
	if M.workspaces[workspace].state == "normal" then
		M.workspaces[workspace].state = "maximized"
		for win in hl.get_windows() do
			hl.dispatch(hl.dsp.layout("colresize 1"))
		end
	-- If the workspace is in maximzed state, then restore all widths of windows and switch to normal state
	elseif M.workspaces[workspace].state == "maximized" then
		M.workspaces[workspace].state = "normal"
	end
end
