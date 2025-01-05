local vector = require("junk.types.vector")
local class = require("junk.third_party.middleclass")

local nextEntityId = 1

local entity = class("entity")

function entity:initialize(room, layer, x, y, config)
   self.id = nextEntityId
   nextEntityId = nextEntityId + 1
   self.position = vector:new(x, y)
   self.room = room
   self.room_layer = layer
end

function entity:update(dt)
end

function entity:draw()
end

function entity:ready()
   -- Called when the entity has been added to a room.
end

function entity:destroyed()
   -- Called when the entity has been removed from a room.
end

return entity