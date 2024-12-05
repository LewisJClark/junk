local game = require("junk.game")
local utils = require("junk.utils")
local uiNode = require("junk.ui.uiNode")
local class = require("junk.third_party.middleclass")
local timer = require("junk.timer")

local uiButton = class("uiButton", uiNode)

function uiButton:initialize(id, config)
   uiNode.initialize(self, id, config)
   self.pressed = false
   self.colour = config.colour and utils.normalizeColour(config.colour) or { r=1, g=1, b=1, a=1 }
   self.text = config.text or ""
   self.focused_colour = config.focused_colour and utils.normalizeColour(config.focused_colour) or { r=1, g=1, b=1, a=1 }
   self.pressed_colour = config.pressed_colour and utils.normalizeColour(config.pressed_colour) or { r=1, g=1, b=1, a=1 }
   self.pressed_timer = nil
   self.on_press = config.on_press or function() end
end

function uiButton:update(dt)
   uiNode.update(self, dt)
   if self.pressed_timer then self.pressed_timer:update(dt) end
end

function uiButton:handleInput()
   uiNode.handleInput(self)
   if game.input:isPressed("ui_confirm") then self:press() end
end

function uiButton:press()
   self.pressed = true
   self.on_press()
   self.pressed_timer = timer:once(0.1, function()
      self.pressed = false
   end)
end

function uiButton:draw()
   local colour = self.colour
   if self.has_focus then colour = self.focused_colour end
   if self.pressed then colour = self.pressed_colour end
   love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)
   love.graphics.rectangle("fill", self.global_x, self.global_y, self.width, self.height)
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.print(self.text, self.global_x, self.global_y)
end

return uiButton