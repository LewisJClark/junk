require "frengine.assets.assetLib"
require "frengine.assets.sprite"
require "frengine.assets.tilemap"
require "frengine.constants"
require "frengine.gameObject"
require "frengine.input"
require "frengine.room"
require "frengine.timer"
require "frengine.utils"
require "frengine.vector"

require "frengine.third_party.flux"

local frengine = {}

function frengine.init(width, height, title)
   love.math.random(os.time())
   love.window.setMode(width, height)
   love.window.setTitle(title)
   love.graphics.setDefaultFilter("nearest", "nearest")
   AssetLib:load()
end

function frengine.update(dt)
   Input:update()
   Flux:update(dt)
end

return frengine