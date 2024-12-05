local class = require("junk.third_party.middleclass")

local uiRoot = class("uiRoot")

function uiRoot:initialize()
   self.id = "root"
   self.path = ""
   self.global_x = 0
   self.global_y = 0
   self.children = {}
   self.focused_node = nil
end

function uiRoot:update(dt)
   for i,child in ipairs(self.children) do
      child.global_x = self.global_x + child.x
      child.global_y = self.global_y + child.y
      child:update(dt)
   end
   if self.focused_node then self.focused_node:handleInput() end
end

function uiRoot:draw()
   for i,child in ipairs(self.children) do
      child:draw()
   end
end

function uiRoot:addChild(node)
   table.insert(self.children, node)
   node.parent = self
   node.path = self.path.."/"..node.id
end

function uiRoot:removeChild(node)
   for i,child in ipairs(self.children) do
      if child.id == node.id then
         child.parent = nil
         table.remove(self.children, i)
      end
   end
end

function uiRoot:getChild(id)
   for i,child in ipairs(self.children) do
      if child.id == id then return child end
   end
   return nil
end

function uiRoot:getNodeAtPath(path)
   local ids = SplitStr(path, "/")
   if #ids == 0 then return nil end
   local current_node = self
   for i,id in ipairs(ids) do
      if current_node == nil then return nil end
      if id == ".." then current_node = current_node.parent
      else current_node = current_node:getChild(id) end
   end
   return current_node
end

return uiRoot