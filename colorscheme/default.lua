
local ANSI = require("lmenu.ANSI")
local c = ANSI.color
local b = ANSI.color.bright

local cs = setmetatable({
	title = b.cyan,

	option = c.white,
	selected = ANSI.bold .. b.white,
	checkbox = b.green,
	char = b.white,

	selector = b.green,

	default = b.black,
	paren = b.black,
	sep = b.black,

	positive = b.green,
	negative = b.red,
}, {
	__index = function()
		return ANSI.color.white
	end
})

return cs
