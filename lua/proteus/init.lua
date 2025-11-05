--[[
This file should contain 
- public APIs: functions, setup, config
- module exports: return a table with functions
- optional setup logic: user config, defaults
--]]

local core = require("proteus.core")
local M = {}
M.stopRPC = core.stopRPC
M.updateRPC = core.updateRPC
M.clearRPC = core.clearRPC
M.enable = true

M.setup = function(opts)
	-- print("Options: ", opts)
	opts = opts or {}
	-- vim.notify("Initializing setup for proteus", vim.log.levels.INFO)
	M.config = vim.tbl_deep_extend("force", {
		test1 = true,
		test2 = "default",
	}, opts)

	vim.api.nvim_create_user_command("ProteusToggle", function()
		if M.enable == true then
			M.clearRPC()
		end
		M.enable = not M.enable
		vim.notify("stopping proteus", vim.log.levels.INFO)
	end, {})

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function()
			if M.enable == true then
				local curr_buf = vim.bo[vim.api.nvim_get_current_buf()]
				if curr_buf.buftype == "" then -- this avoid buffers that are not actual files you edit
					M.updateRPC()
					vim.notify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), vim.log.levels.INFO)
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd("ExitPre", {
		pattern = "*",
		callback = function()
			M.stopRPC()
		end,
	})
end

-- here you put the functions that are like a "public API"
return M
