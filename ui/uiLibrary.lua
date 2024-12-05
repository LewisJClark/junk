local uiLibrary = {
   node = require("junk.ui.uiNode"),
   panel = require("junk.ui.uiPanel"),
   button = require("junk.ui.uiButton"),
   sprite_button = require("junk.ui.uiSpriteButton")
}

local function createNode(config)
   local node = uiLibrary[config.type]:new(config.id, config)
   if config.children then
      for _,child_config in ipairs(config.children) do
         node:addChild(createNode(child_config))
      end
   end
   return node
end

function uiLibrary:extend(nodes)
   for name,node_type in nodes do
      self[name] = node_type
   end
end

function uiLibrary:loadLayout(path)
   local root = require(path)
   if root.extensions then
      -- Add any custom UI components to the library.
      for name,path in pairs(root.extensions) do
         self[name] = require(path)
      end
   end
   local loaded_layout = createNode(root)
   loaded_layout:ready()
   return loaded_layout
end

return uiLibrary