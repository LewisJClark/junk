local class = require("junk.third_party.middleclass")

local uiManager = class("uiManager")

function uiManager:initialize()
   self.elements = {}
end

function uiManager:update(dt)
   for _,element in ipairs(self.elements) do
      element:update(dt)
   end
end

function uiManager:draw()
   for _,element in ipairs(self.elements) do
      element:draw()
   end
end

function uiManager:addElement(element)
   table.insert(self.elements, element)
end

function uiManager:removeElement(element)
   for i,e in ipairs(self.elements) do
      if e.id == element.id then
         table.remove(self.elements, i)
      end
   end
end

return uiManager