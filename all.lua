require "frengine.assets.assetLib"
require "frengine.assets.sprite"
require "frengine.assets.tilemap"
require "frengine.constants"
require "frengine.entity"
require "frengine.gameObject"
require "frengine.input"
require "frengine.particleEmitter"
require "frengine.room"
require "frengine.timer"
require "frengine.utils"
require "frengine.vector"
require "frengine.tweener"

require "frengine.third_party.flux"

Frengine = {
   Class = require "frengine.third_party.middleclass",
   time_scale = 1,
   delta_tween = Tweener:new(),
   scaled_tween = Tweener:new()
}

function Frengine:init(width, height, title)
   love.math.random(os.time())
   love.window.setMode(width, height)
   love.window.setTitle(title)
   love.graphics.setDefaultFilter("nearest", "nearest")
   AssetLib:load()
end

function Frengine:update(dt)
   Input:update()
   self.delta_tween:update(dt)
   self.scaled_tween:update(dt * self.time_scale)
   Flux:update(dt)
end