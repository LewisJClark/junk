require "frengine.vector"

GameObject = {}
GameObject.__index = GameObject

function GameObject:inherit(config)
   local o = {
      name = "Default",
      room = nil,
      enabled = true,
      position = Vector:new(0, 0),
      colliderWidth = 1,
      colliderHeight = 1,
      colliderOffsetX = 0,
      colliderOffsetY = 0,
      colliderGroups = {}
   }
   for k,v in pairs(config) do o[k] = v end
   return setmetatable(o, GameObject)
end

-- Collider -------------------------------------------------------------------------------------------------------------------
function GameObject:setCollider(config)
   self.colliderWidth = config.width or 1
   self.colliderHeight = config.height or 1
   self.colliderOffsetX = config.offsetX or 0
   self.colliderOffsetY = config.offsetY or 0
   return self
end

function GameObject:getColliderSides()
   local left = self.position.x + self.colliderOffsetX
   local right = self.position.x + self.colliderOffsetX + self.colliderWidth
   local top = self.position.y + self.colliderOffsetY
   local bottom = self.position.y + self.colliderOffsetY + self.colliderHeight
   return left, right, top, bottom
end

function GameObject:collidesWith(other)
   if not self.enabled or not other.enabled then return false end
   local l1, r1, t1, b1 = self:getColliderSides()
   local l2, r2, t2, b2 = other:getColliderSides()
   return l1 < r2 and r1 > l2 and t1 < b2 and b1 > t2
end

function GameObject:drawCollider(r, g, b, a)
   love.graphics.setColor(r or 1, g or 0, b or 0, a or 1)
   love.graphics.rectangle("line", math.floor(self.position.x + self.colliderOffsetX) + 0.5, math.floor(self.position.y + self.colliderOffsetY) + 0.5, self.colliderWidth, self.colliderHeight)
end