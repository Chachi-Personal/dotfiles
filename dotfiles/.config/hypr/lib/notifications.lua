local M = {}

M.notify = function(opts)
	local cmd = string.format(
		"notify-send '%s' '%s' -t %d",
		opts.title or "Notification",
		opts.message or "",
		opts.timeout or 5000
	)
	hl.exec_cmd(cmd)
end

return M
