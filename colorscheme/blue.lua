
local rgb = require("lmenu.ANSI").fg

local b = rgb(150,150,255)
return setmetatable({
	title = rgb(100,150,255),
	option = rgb(100,100,255),
	selected = rgb(90,80,230),
	checkbox = rgb(200,200,255),
	char = rgb(100,100,255),
	selector = rgb(200,200,255),
	default = rgb(100,100,200),
	paren = rgb(80,80,150),
	sep = rgb(100,100,200),
}, {
	__index = function()
		return b
	end
})
