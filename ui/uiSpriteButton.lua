local game = require("junk.game")
local utils = require("junk.utils")
local uiButton = require("junk.ui.uiButton")
local class = require("junk.third_party.middleclass")
local timer = require("junk.timer")

local uiSpriteButton = class("uiSpriteButton", uiButton)

function uiSpriteButton:initialize(id, config)
   uiButton.initialize(self, id, config)
   self.sprite = config.sprite and game.assets:createSprite(config.sprite) or nil
   self.focused_sprite = config.sprite and game.assets:createSprite(config.focused_sprite) or nil
   self.pressed_sprite = config.sprite and game.assets:createSprite(config.pressed_sprite) or nil
end

function uiSpriteButton:draw()
   local colour = self.colour
   local sprite = self.sprite
   if self.has_focus then 
      colour = self.focused_colour
      sprite = self.focused_sprite
   end
   if self.pressed then
      colour = self.pressed_colour
      sprite = self.pressed_sprite
   end
   love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)
   love.graphics.rectangle("fill", self.global_x, self.global_y, self.width, self.height)
   love.graphics.setColor(1, 1, 1, 1)
   sprite:draw(self.global_x, self.global_y)
end

return uiSpriteButton