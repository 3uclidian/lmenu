
local Menu = require("lmenu.Menu")
local ANSI = require("lmenu.ANSI")
local draw = require("lmenu.draw")
local prompt = require("lmenu.prompt")
local getchar = require("lgetchar").getChar

local charprompt = Menu.new(prompt)
charprompt.default = 1
charprompt.options = {'y','n'}

function charprompt:add(char, callback, ...)
	if not rawget(self, "options") then -- prevent overwriting parent options
		self.options = {}
	end
	if type(char) == "string" then
		char = string.byte(char)
	end
	table.insert(self.options, {
		content = char,
		callback = callback or function()
			return char
		end,
		callbackArgs = {...}
	})
	return self
end

function charprompt:setDefault(n)
	self.default = n
	return self
end

local function writeChar(options, upper)
	local char = options.content
	if upper then
		draw.char(string.char(char):upper())
	else
		draw.char(string.char(char))
	end
end

function charprompt:draw(n)
	if self.question then
		draw.question(self.question)
	end
	if n then
		draw.space()
		draw.char(string.char(n.content))
	else
		draw.qmark("?")
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
			if v.content == c then
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
	return c.callback(table.unpack(c.callbackArgs))
end

return charprompt
