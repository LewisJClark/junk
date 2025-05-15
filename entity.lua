local nextEntityId = 1

Entity = {}
Entity.__index = Entity

---@param room junk.room The room table the Entity belongs to.
---@param layer junk.roomLayer The roomLayer table that the Entity is on.
---@param x number The Entity's x position in the room.
---@param y number The Entity's y position in the room.
---@param config table A table with Entity specific config in.
function Entity:new(room, layer, x, y, config)
   local e = {
      id = nextEntityId,
      x = x,
      y = y,
      room = room,
      room_layer = layer,
      signals = {}
   }
   nextEntityId = nextEntityId + 1
   return setmetatable(e, Entity)
end

--@param dt number The delta time value to use.
function Entity:update(dt)
end

function Entity:draw()
end

-- Called when the entity has been added to a room.
function Entity:ready() end

-- Called when the Entity has been removed from a room.
function Entity:destroyed() end

-- Add signals to an entity.
---@param ... string One or multiple signal names.
function Entity:addSignals(...)
   local args = {...}
   for _,name in ipairs(args) do
      self.signals[name] = {}
   end
end

-- Emits the signal with the given name, invoking all listeners.
---@param name string The name of the signal to emit.
---@param args table Any arguments to pass to listeners.
function Entity:emitSignal(name, args)
   local listeners = self.signals[name]
   if listeners == nil then return end
   for _,listener in pairs(listeners) do
      listener(args)
   end
end

-- Adds a listener to a given signal.
---@param name string The name of the signal to add the listener to.
---@param listener function The listener to add.
function Entity:addSignalListener(name, listener)
   if self.signals[name] == nil then self.signals[name] = {} end
   self.signals[name][listener] = listener
end

-- Remove a listener from a signal.
---@param name string The name of the signal to remove the listener from.
---@param listener function The listener to remove.
function Entity:removeSignalListener(name, listener)
   local signal = self.signals[name]
   if signal == nil then return end
   signal[listener] = nil
end

function Entity:extend(extend_with)
   for k,v in pairs(extend_with) do
      self[k] = v
   end
end