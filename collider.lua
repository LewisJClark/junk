local class = require("junk.third_party.middleclass")

local collider = class("collider")

function collider:initialize(owner, x, y, width, height, offset_x, offset_y)
   self.owner = owner
   self.offset_x = offset_x or 0
   self.offset_y = offset_y or 0
   self.x = x + self.offset_x
   self.y = y + self.offset_y
   self.w = width
   self.h = height
   self.groups = {}
   self.filter = function() return false end
   self.world = nil -- Set when the collider is added to a room.
end

function collider:addToGroup(group)
   self.groups[group] = true
   return self
end

function collider:removeFromGroup(group)
   self.groups[group] = false
   return self
end

function collider:isInGroup(group)
   return self.groups[group]
end

function collider:setFilter(filter)
   self.filter = filter
end

function collider:moveTo(x, y)
   if self.world == nil then return end
   self.x = x + self.offset_x
   self.y = y + self.offset_y
   self.world:update(self, x + self.offset_x, y + self.offset_y)
end

function collider:tryMoveTo(x, y)
   local final_x, final_y, collisions = self.world:move(self, x + self.offset_x, y + self.offset_y, self.filter)
   self.x = final_x
   self.y = final_y
   return final_x - self.offset_x, final_y - self.offset_y, collisions
end

function collider:placeMeeting(x, y)
   local final_x = x and x + self.offset_x or self.x
   local final_y = y and y + self.offset_y or self.y
   local _, _, collisions, _ = self.world:check(self, final_x, final_y, self.filter)
   return collisions
end

function collider:draw()
   love.graphics.setColor(1, 0, 0, 1)
   love.graphics.rectangle("line", math.floor(self.x) + 0.5, math.floor(self.y) + 0.5, self.w, self.h)
   love.graphics.setColor(1, 1, 1, 1)
end

return collider