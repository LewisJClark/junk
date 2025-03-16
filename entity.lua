local nextEntityId = 1

local entity = Class("entity")

---@param room junk.room The room table the entity belongs to.
---@param layer junk.roomLayer The roomLayer table that the entity is on.
---@param x number The entity's x position in the room.
---@param y number The entity's y position in the room.
---@param config table A table with entity specific config in.
function entity:initialize(room, layer, x, y, config)
   self.id = nextEntityId
   nextEntityId = nextEntityId + 1
   self.x = x
   self.y = y
   self.room = room
   self.room_layer = layer
   self.signals = Signal:new()
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