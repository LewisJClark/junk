local bump = require("junk.third_party.bump")
local class = require("junk.third_party.middleclass")
local game = require("junk.game")

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
end

function room:createEntity(type, x, y, config, name)
   if game.entities[type] == nil then return end
   local e = game.entities[type]:new(self, x, y, config)
   table.insert(self.entities, e)
   e:ready()
   return e
end

function room:destroyEntity(entity)
   for i=#self.entities,1,-1 do
      if self.entities[i] == entity then 
         self.entities[i]:remove()
         table.remove(self.entities, i)
      end
   end
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
   for i=#self.entities,1,-1 do
      self.entities[i]:update(dt)
   end
end

function room:draw()
   for i=#self.entities,1,-1 do
      self.entities[i]:draw()
   end
end

function room:leave()
   -- Called when the room is left.
end

return room
