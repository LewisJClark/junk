local utils = require("junk.utils")
local uiNode = require("junk.ui.uiNode")
local class = require("junk.third_party.middleclass")

local uiPanel = class("uiPanel", uiNode)

function uiPanel:initialize(id, config)
   uiNode.initialize(self, id, config)
   self.colour = config.colour and utils.normalizeColour(config.colour) or { r=1, g=1, b=1, a=1 }
end

function uiPanel:update(dt)
   uiNode.update(self, dt)
end

function uiPanel:draw()
   love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
   love.graphics.rectangle("fill", self.global_x, self.global_y, self.width, self.height)
   love.graphics.setColor(1, 1, 1, 1)
end

return uiPanel