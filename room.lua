local bump = require("junk.third_party.bump")
local class = require("junk.third_party.middleclass")
local roomLayer = require("junk.roomLayer")

--[[
   A room is a level or screen in a game. I copied this terminology
   from GameMaker because I liked how it sounded. All screens/levels
   in the game should inherit from this.
]]

local room = class("room")

function room:initialize(name)
   self.name = "room"
   self.entities = {}
   self.entity_groups = {}
   self.named_entities = {}
   self.world = bump.newWorld(60)
   self.layers = {}
   self.layer_lookup = {}
end

function room:createLayer(name)
   if self.layer_lookup[name] ~= nil then
      error("Room layer '"..name.." already exists")
   end
   local layer = roomLayer:new(name)
   table.insert(self.layers, layer)
   self.layer_lookup[name] = layer
   return layer
end

function room:createLayers(...)
   local args = {...}
   for i=1,#args do
      self:createLayer(args[i])
   end
end

function room:createEntity(kind, layer, x, y, config, name)
   local target_layer = self.layer_lookup[layer]
   if target_layer == nil then return end
   local e
   if type(kind) == "string" then
      e = _G[kind]:new(self, target_layer, x, y, config)
   else
      e = kind:new(self, target_layer, x, y, config)
   end
   target_layer:addEntity(e)
   if name then self.named_entities[name] = e end

   e:ready()
   return e
end

function room:destroyEntity(entity)
   entity.room_layer:removeEntity(entity)
   entity:destroyed()
end

function room:addNamedEntity(entity, name)
   self.named_entities[name] = entity
end

function room:removeNamedEntity(name)
   self.named_entities[name] = nil
end

function room:getNamedEntity(name)
   return self.named_entities[name]
end

function room:addEntityToGroup(entity, group)
   if self.entity_groups[group] == nil then
      self.entity_groups[group] = {}
   end
   table.insert(self.entity_groups[group], entity)
end

function room:removeEntityFromGroup(entity, group)
   if self.entity_groups[group] == nil then return end
   local group = self.entity_groups[group]
   for i=#group,1,-1 do
      if group[i] == entity then table.remove(group, i) end
   end
end

function room:addCollider(collider)
   self.world:add(collider, collider.x, collider.y, collider.w, collider.h)
   collider.world = self.world
end

function room:removeCollider(collider)
   self.world:remove(collider)
   collider.world = nil
end

function room:enter()
   -- Called when the room is entered.
end

function room:update(dt)
   for i=1,#self.layers do
      self.layers[i]:update(dt)
   end
end

function room:draw()
   for i=1,#self.layers do
      self.layers[i]:draw()
   end
end

function room:leave()
   -- Called when the room is left.
end

function room:positionMeeting(x, y, filter)
   local colliders = self.world:queryPoint(x, y, filter)
   return colliders
end

function room:positionMeetingGroup(x, y, group)
   local colliders = self.world:queryPoint(x, y, function(item) 
      return item:isInGroup(group)
   end)
   return colliders
end

return room
