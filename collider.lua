Collider = {}
Collider.__index = Collider

function Collider:new(owner, x, y, width, height, offset_x, offset_y)
   local c = {
      owner = owner,
      offset_x = offset_x or 0,
      offset_y = offset_y or 0,
      x = x + self.offset_x,
      y = y + self.offset_y,
      w = width,
      h = height,
      groups = {},
      filter = function() return false end,
      world = nil, -- Set when the Collider is added to a room.
   }
   return setmetatable(c, Collider)
end

function Collider:addToGroup(group)
   self.groups[group] = true
   return self
end

function Collider:removeFromGroup(group)
   self.groups[group] = false
   return self
end

function Collider:isInGroup(group)
   return self.groups[group]
end

function Collider:setFilter(filter)
   self.filter = filter
   return self
end

function Collider:moveTo(x, y)
   if self.world == nil then return end
   self.x = x + self.offset_x
   self.y = y + self.offset_y
   self.world:update(self, x + self.offset_x, y + self.offset_y)
end

function Collider:tryMoveTo(x, y)
   local final_x, final_y, collisions = self.world:move(self, x + self.offset_x, y + self.offset_y, self.filter)
   self.x = final_x
   self.y = final_y
   return final_x - self.offset_x, final_y - self.offset_y, collisions
end

function Collider:placeMeeting(x, y)
   local final_x = x and x + self.offset_x or self.x
   local final_y = y and y + self.offset_y or self.y
   local _, _, collisions, _ = self.world:check(self, final_x, final_y, self.filter)
   return collisions
end

function Collider:draw()
   love.graphics.setColor(1, 0, 0, 1)
   love.graphics.rectangle("line", math.floor(self.x) + 0.5, math.floor(self.y) + 0.5, self.w-1, self.h-1)
   love.graphics.setColor(1, 1, 1, 1)
end
