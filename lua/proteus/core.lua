-- POST http://127.0.0.1:6969/update
--
-- ```json
-- {
--   "details": "Optional string",
--   "state": "Optional string",
--   "large_image_key": "Optional string",
--   "large_image_text": "Optional string",
--   "small_image_key": "Optional string",
--   "small_image_text": "Optional string",
--   "sticky": false
-- }
-- ```
--
-- ## Examples
--
-- **Normal update:**
-- ```bash
-- curl -X POST http://127.0.0.1:6969/update \
--   -H "Content-Type: application/json" \
--   -d '{"details": "Working on code", "state": "main.rs"}'
-- ```
--
-- **Sticky session (e.g., timer/focus mode):**
-- ```bash
-- curl -X POST http://127.0.0.1:6969/update \
--   -H "Content-Type: application/json" \
--   -d '{"details": "Focus Session", "state": "25:00", "sticky": true}'
-- ```
--
-- **Clear plugin data:**
-- ```bash
-- curl -X POST http://127.0.0.1:6969/update \
--   -H "Content-Type: application/json" \
--   -d '{}'
-- ```

local curl = require("plenary.curl")
local M = {}

function M.stopRPC()
	vim.notify("Proteus RPC stopped", vim.log.levels.INFO)
end

function M.updateRPC()
	-- vim.notify("Updated RPC", vim.log.levels.INFO)
	local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")

	local res = curl.post("http://127.0.0.1:6969/update", {
		body = vim.fn.json_encode({
			details = project,
			state = file,
		}),
		headers = {
			["Content-Type"] = "application/json",
		},
	})

	-- print("Status: ", res.status)
	-- print("Body: ", res.body)
end

function M.clearRPC()
	-- vim.notify("Cleared RPC", vim.log.levels.INFO)

	local res = curl.post("http://127.0.0.1:6969/update", {
		body = vim.fn.json_encode({}),
		headers = {
			["Content-Type"] = "application/json",
		},
	})

	-- print("Status: ", res.status)
	-- print("Body: ", res.body)
end
return M
