require "frengine.assets.assetLib"
require "frengine.assets.sprite"

require "frengine.vector"
require "frengine.input"
require "frengine.timer"

require "frengine.gameObject"
require "frengine.room"

require "frengine.third_party.flux"

local frengine = {}

function frengine.init()
   love.math.random(os.time())
   love.window.setMode(384, 216)
   love.graphics.setDefaultFilter("nearest", "nearest")
   AssetLib:load()
end

return frengine