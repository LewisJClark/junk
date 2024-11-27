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

require "frengine.third_party.flux"

Frengine = {
   Class = require "frengine.third_party.middleclass"
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
   Flux:update(dt)
end