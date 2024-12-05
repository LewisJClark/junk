local class = require("junk.third_party.middleclass")

--[[
   A room is a level or screen in a game. I copied this terminology
   from GameMaker because I liked how it sounded. All screens/levels
   in the game should inherit from this.
]]

local room = class("room")

function room:initialize(name)
   self.name = "room"
end

function room:enter() end

function room:update(dt) end

function room:draw() end

function room:leave() end

return room
