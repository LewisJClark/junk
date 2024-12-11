local assetManager = require("junk.assets.assetManager")
local inputManager = require("junk.inputManager")
local tweener = require("junk.tweener")
local utils = require("junk.utils")
local uiRoot = require("junk.ui.uiRoot")

--[[ 
   This represents the current state of the game, at least as Junk sees it.
   Modules can require this module in order to modify the overall game state by
   changing rooms, changing window sizes etc. It's via this module that the game's
   asset, input and ui managers are accessed too.
]]
local game = {
   base_width = 384,
   base_height = 216,
   render_scale = 1,
   colours = {
      white={ 1, 1, 1, 1 },
      black={ 0, 0, 0, 1 },
   },

   window_title = "game",
   window_width = 384,
   window_height = 216,

   canvas = nil, 

   assets = assetManager:new(),         -- Asset manager for the game.
   input = inputManager:new(),          -- Input manager for the game.
   ui = uiRoot:new(),                   -- The root UI node of the game.
   rooms = {},                          -- List of rooms available in the game.
   entities = {},                       -- List of entities available in the game.
   current_room = nil,                  -- The current room of the game.

   time_scale = 1,
   scaled_delta = 0,
   delta_tween = tweener:new(),
   scaled_tween = tweener:new()
}

function game:init(width, height, title)
   self.base_width = width
   self.base_height = height
   self.window_title = title
   self.window_width = width
   self.window_height = height

   love.math.random(os.time())
   love.window.setMode(width, height)
   love.window.setTitle(title)
   love.graphics.setDefaultFilter("nearest", "nearest")

   self.canvas = love.graphics.newCanvas(self.base_width, self.base_height)

   self.input:addAction("ui_up", "up")
   self.input:addAction("ui_down", "down")
   self.input:addAction("ui_left", "left")
   self.input:addAction("ui_right", "right")
   self.input:addAction("ui_confirm", "a")
   self.input:addAction("ui_cancel", "escape")

   self.assets:load()
end

function game:update(dt)
   self.scaled_delta = dt * self.time_scale
   self.delta_tween:update(dt)
   self.scaled_tween:update(self.scaled_delta)
   self.input:update(dt)
   self.current_room:update(self.scaled_delta)
   self.ui:update(dt)
end

-- Rendering ------------------------------------------------------------------------------------------------------------------------------------------------

function game:setRenderScale(scale)
   self.render_scale = scale
   self.window_width = self.base_width * scale
   self.window_height = self.base_height * scale
   love.window.setMode(self.window_width, self.window_height)
end

function game:registerColour(name, r, g, b, a)
   self.colours[name] = utils.normalizeColour({ r, g, b, a})
end

function game:getColourCopy(name)
   if self.colours[name] ~= nil then
      local col = self.colours[name]
      return { col[1], col[2], col[3], col[4] }
   end
end

-- Room management ------------------------------------------------------------------------------------------------------------------------------------------

function game:registerRoom(name, room)
   self.rooms[name] = room
end

function game:gotoRoom(name)
   if self.rooms[name] ~= nil then
      if self.current_room then self.current_room:leave() end
      self.current_room = self.rooms[name]:new()
      self.current_room:enter()
   end
end

-- Entity management ----------------------------------------------------------------------------------------------------------------------------------------

function game:registerEntity(name, entity)
   self.entities[name] = entity
end

return game
