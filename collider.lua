local class = require("junk.third_party.middleclass")

local collider = class("collider")

function collider:initialize(owner, x, y, width, height)
   self.owner = owner
   self.x = x
   self.y = y
   self.w = width
   self.h = height
   self.groups = {}
end

function collider:addToGroup(group)
   self.groups[group] = true
end

function collider:removeFromGroup(group)
   self.groups[group] = false
end