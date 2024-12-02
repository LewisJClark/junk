require "frengine.vector"
local class = require "frengine.third_party.middleclass"

local nextEntityId = 1

Entity = class("Entity")

function Entity:initialize(x, y, room)
   self.id = nextEntityId
   nextEntityId = nextEntityId + 1
   self.position = Vector:new(x, y)
   self.room = room
end
