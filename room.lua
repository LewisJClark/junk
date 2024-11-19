require "frengine.vector"
require "frengine.gameObject"

Room = {}
Room.__index = Room

function Room:inherit(config)
   local r = {
      objects = {},
      colliderGroups = {},
      toRemove = {},
      toAdd = {}
   }
   for k,v in pairs(config) do r[k] = v end
   return setmetatable(r, Room)
end

-- Object Management ---------------------------------------------------------------------------------

function Room:createObject(type, config)
   config.room = self
   local object = _G[type]:new(config)
   self:queueAddObject(object)
   return object
end

function Room:addObject(object)
   object.room = self
   object.enabled = true
   self.objects[#self.objects + 1] = object
   print("Adding: ", object.name)
end

function Room:removeObject(object)
   for i=1, #self.objects do
      if self.objects[i] == object then
         table.remove(self.objects, i)
         return
      end
   end
   for k,_ in pairs(object.colliderGroups) do
      self:removeFromColliderGroup(object, k)
   end
end

function Room:queueAddObject(object)
   object.enabled = false
   table.insert(self.toAdd, object)
end

function Room:queueRemoveObject(object)
   object.enabled = false
   table.insert(self.toRemove, object)
end


-- Collision Management ---------------------------------------------------------------------------------

function Room:addToColliderGroup(object, group)
   if self.colliderGroups[group] == nil then self.colliderGroups[group] = {} end
   local count = #self.colliderGroups[group] + 1
   self.colliderGroups[group][count] = object
   object.colliderGroups[group] = true
end

function Room:removeFromColliderGroup(object, group)
   if self.colliderGroups[group] == nil then return end
   for i=1, #self.colliderGroups[group] do
      if self.colliderGroups[group][i] == object then
         table.remove(self.colliderGroups[group], i)
         return
      end
   end
   object.colliderGroups[group] = nil
end

function Room:placeMeeting(object, x, y, group)
   if self.colliderGroups[group] == nil then return false end
   local oldX, oldY = object.position.x, object.position.y
   object.position.x, object.position.y = x, y
   for i=1, #self.colliderGroups[group] do
      if object:collidesWith(self.colliderGroups[group][i]) then
         object.position.x, object.position.y = oldX, oldY
         return true
      end
   end
   object.position.x, object.position.y = oldX, oldY
   return false
end

function Room:getCollisionsAt(object, x, y, group)
   local result = {}
   if self.colliderGroups[group] == nil then return result end
   local oldX, oldY = object.position.x, object.position.y
   object.position.x, object.position.y = x, y
   for i=1, #self.colliderGroups[group] do
      if object:collidesWith(self.colliderGroups[group][i]) then
         table.insert(result, self.colliderGroups[group][i])
      end
   end
   object.position.x, object.position.y = oldX, oldY
   return result
end

