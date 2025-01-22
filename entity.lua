local class = require("junk.third_party.middleclass")

local nextEntityId = 1

local entity = class("entity")

function entity:initialize(room, layer, x, y, config)
   self.id = nextEntityId
   nextEntityId = nextEntityId + 1
   self.x = x
   self.y = y
   self.room = room
   self.room_layer = layer
   self.signals = {}
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

function entity:setSignals(...)
   local args = {...}
   for _,name in ipairs(args) do
      self.signals[name] = {}
   end
end

function entity:emitSignal(name, params)
   if not self.signals[name] then
      error("Entity does not have a signal called '"..name.."'")
   end
   for _,listener in ipairs(self.signals[name]) do
      listener(params)
   end
end

function entity:addSignalListener(signal, listener)
   if not self.signals[signal] then
      error("Entity does not have a signal called '"..signal.."'")
   end
   table.insert(self.signals[signal], listener)
end

function entity:removeSignalListener(signal, listener)
   if not self.signals[signal] then return end
   for i,l in ipairs(self.signals[signal]) do
      if l == listener then 
         table.remove(self.signals[signal], i)
         return
      end
   end
end

return entity