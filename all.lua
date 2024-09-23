require "frengine.assets.assetLib"
require "frengine.assets.sprite"
require "frengine.constants"
require "frengine.gameObject"
require "frengine.input"
require "frengine.room"
require "frengine.timer"
require "frengine.utils"
require "frengine.vector"

require "frengine.third_party.flux"

local frengine = {}

function frengine.init()
   love.math.random(os.time())
   love.window.setMode(384, 216)
   love.graphics.setDefaultFilter("nearest", "nearest")
   AssetLib:load()
end

return frengine