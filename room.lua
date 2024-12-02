Class = require "frengine.third_party.middleclass"

--[[
   A room is a level or screen in a game. I copied this terminology
   from GameMaker because I liked how it sounded. All screens/levels
   in the game should inherit from this.
]]

Room = Class("Room")

function Room:initialize(name)
   self.name = "Room"
end

function Room:enter() end

function Room:update(dt) end

function Room:draw() end

function Room:leave() end
