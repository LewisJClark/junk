local vector = require("junk.types.vector")
local class = require("junk.third_party.middleclass")

local nextEntityId = 1

local entity = class("entity")

function entity:initialize(x, y, room)
   self.id = nextEntityId
   nextEntityId = nextEntityId + 1
   self.position = vector:new(x, y)
   self.room = room
end

return entity