--[[
   A Room is a level or screen in a game. I copied this terminology
   from GameMaker because I liked how it sounded. All screens/levels
   in the game should inherit from this.
]]

Room = Class("Room")

function Room:initialize(name)
   self.name = "Room"
   self.entities = {}
   self.entity_groups = {}
   self.named_entities = {}
   self.world = Bump.newWorld(60)
   self.layers = {}
   self.layer_lookup = {}
end

function Room:createLayer(name)
   if self.layer_lookup[name] ~= nil then
      error("Room layer '"..name.." already exists")
   end
   local layer = RoomLayer:new(name)
   table.insert(self.layers, layer)
   self.layer_lookup[name] = layer
   return layer
end

function Room:createLayers(...)
   local args = {...}
   for i=1,#args do
      self:createLayer(args[i])
   end
end

function Room:createEntity(kind, layer, x, y, config, name)
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

function Room:destroyEntity(entity)
   entity.room_layer:removeEntity(entity)
   entity:destroyed()
end

function Room:addNamedEntity(entity, name)
   self.named_entities[name] = entity
end

function Room:removeNamedEntity(name)
   self.named_entities[name] = nil
end

function Room:getNamedEntity(name)
   return self.named_entities[name]
end

function Room:addEntityToGroup(entity, group)
   if self.entity_groups[group] == nil then
      self.entity_groups[group] = {}
   end
   table.insert(self.entity_groups[group], entity)
end

function Room:removeEntityFromGroup(entity, group)
   if self.entity_groups[group] == nil then return end
   local group = self.entity_groups[group]
   for i=#group,1,-1 do
      if group[i] == entity then table.remove(group, i) end
   end
end

function Room:addCollider(collider)
   self.world:add(collider, collider.x, collider.y, collider.w, collider.h)
   collider.world = self.world
end

function Room:removeCollider(collider)
   self.world:remove(collider)
   collider.world = nil
end

function Room:enter()
   -- Called when the Room is entered.
end

function Room:update(dt)
   for i=1,#self.layers do
      self.layers[i]:update(dt)
   end
end

function Room:draw()
   for i=1,#self.layers do
      self.layers[i]:draw()
   end
end

function Room:leave()
   -- Called when the Room is left.
end

function Room:positionMeeting(x, y, filter)
   local colliders = self.world:queryPoint(x, y, filter)
   return colliders
end

function Room:positionMeetingGroup(x, y, group)
   local colliders = self.world:queryPoint(x, y, function(item) 
      return item:isInGroup(group)
   end)
   return colliders
end