local class = require("junk.third_party.middleclass")
local utils = require("junk.utils")
local game = require("junk.game")

local uiNode = class("uiNode")

function uiNode:initialize(id, config)
   self.id = id
   self.path = config.path or ""
   self.x = config.x or 0
   self.y = config.y or 0
   self.global_x = config.global_x or 0
   self.global_y = config.global_y or 0
   self.width = config.width or 12
   self.height = config.height or 12
   self.visible = config.visible or true
   self.enabled = config.enabled or true
   self.children = {}
   self.parent = nil
   self.start_with_focus = config.start_with_focus or false
   self.has_focus = false

   self.node_up = config.node_up or nil
   self.node_down = config.node_down or nil
   self.node_left = config.node_left or nil
   self.node_right = config.node_right or nil
end

function uiNode:ready()
   if self.node_up then self.node_up = self:getNodeAtPath(self.node_up) end
   if self.node_down then self.node_down = self:getNodeAtPath(self.node_down) end
   if self.node_left then self.node_left = self:getNodeAtPath(self.node_left) end
   if self.node_right then self.node_right = self:getNodeAtPath(self.node_right) end
   for _,child in ipairs(self.children) do
      child:ready()
   end
end

function uiNode:update(dt)
   self.has_focus = game.ui.focused_node == self
   for i,child in ipairs(self.children) do
      child.global_x = self.global_x + child.x
      child.global_y = self.global_y + child.y
      child:update(dt)
   end
end

function uiNode:handleInput()
   if game.input:isPressed("ui_up") and self.node_up then game.ui.focused_node = self.node_up end
   if game.input:isPressed("ui_down") and self.node_down then game.ui.focused_node = self.node_down end
   if game.input:isPressed("ui_left") and self.node_left then game.ui.focused_node = self.node_left end
   if game.input:isPressed("ui_right") and self.node_right then game.ui.focused_node = self.node_right end
   -- Other functionality implemented in child classes.
end

function uiNode:draw()
   if not self.visible then return end
   for i,child in ipairs(self.children) do
      child:draw()
   end
end

function uiNode:addChild(node)
   table.insert(self.children, node)
   node.parent = self
   node.path = self.path.."/"..node.id
end

function uiNode:removeChild(node)
   for i,child in ipairs(self.children) do
      if child.id == node.id then
         child.parent = nil
         table.remove(self.children, i)
      end
   end
end

function uiNode:getChild(id)
   for i,child in ipairs(self.children) do
      if child.id == id then return child end
   end
   return nil
end

function uiNode:getNodeAtPath(path)
   local ids = utils.splitStr(path, "/")
   if #ids == 0 then return nil end
   local current_node = self
   for i,id in ipairs(ids) do
      if current_node == nil then return nil end
      if id == ".." then current_node = current_node.parent
      else current_node = current_node:getChild(id) end
   end
   return current_node
end

function uiNode:getChildToFocus()
   if self.start_with_focus then return self end
   for i,child in ipairs(self.children) do
      local found_node = child:getChildToFocus()
      if found_node ~= nil then return found_node end
   end
   return nil
end

function uiNode:show()
   self.visible = true
   game.ui.focused_node = self:getChildToFocus()
end

return uiNode