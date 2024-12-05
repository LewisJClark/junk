local uiNode = require("junk.ui.uiNode")
local class = require("junk.third_party.middleclass")

local uiPanel = class("uiPanel", uiNode)

function uiPanel:initialize(id, config)
   uiNode.initialize(self, id, config)
   self.colour = config.colour or { r=1, g=1, b=1, a=1 }
end

function uiPanel:update(dt)
   
end

return uiPanel