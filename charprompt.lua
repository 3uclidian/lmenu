
local Menu = require("lmenu.Menu")
local ANSI = require("lmenu.ANSI")
local draw = require("lmenu.draw")
local prompt = require("lmenu.prompt")
local getchar = require("lgetchar").getChar

local charprompt = Menu.new(prompt)
charprompt.default = 1
charprompt.options = {
	{content = 'y', altContent = "Yes",
	callback = function() return true end},
	{content = 'n', altContent = "No",
	callback = function() return false end},
}


local function getContent(option)
	return option.content or option[1] or option
end

local function getAltContent(option)
	return option.altContent or option[2]
end

function charprompt:setDefault(n)
	self.default = n
	return self
end

local function writeChar(option, upper)
	local char = getContent(option)
	draw.char(upper and char:upper() or char)
end

function charprompt:draw(c)
	if self.title then
		draw.title(self.title)
	end
	if c then
		draw.extra(":")
		draw.space()
		draw.char(getAltContent(c) or getContent(c))
	else
		draw.extra("?")
		draw.space()
		draw.paren('[')
		for i, v in ipairs(self.options) do
			writeChar(v, i == self.default)
			draw.sep(i < #self.options and "/" or "")
		end
		draw.paren(']')
	end
end

function charprompt:resetCursor()
	ANSI.cursor.column(1)
	ANSI.clrln()
end

function charprompt.metamethods:__call()
	self:draw()
	local running = true
	local c
	while running do
		c = getchar()
		for i, v in ipairs(self.options) do
			if string.byte(getContent(v)) == c then
				c = v
				running = false
			end
		end
		if c == 10 then -- enter for default
			c = self.options[self.default]
			running = false
		end
	end
	self:resetCursor()
	self:draw(c)
	draw.nl()
	if c.callback then
		if c.callbackArgs then
			return c.callback(table.unpack(c.callbackArgs))
		end
		return c.callback()
	end
	return getContent(c)
end

return charprompt
