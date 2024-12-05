local uiLibrary = {
   node = require("junk.ui.uiNode"),
   panel = require("junk.ui.uiPanel"),
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

function uiLibrary:loadLayout(path)
   local root = require(path)
   return createNode(root)
end

return uiLibrary