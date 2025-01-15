local assetManager = require("junk.assets.assetManager")
local inputManager = require("junk.inputManager")
local tweener = require("junk.tweener")
local utils = require("junk.utils")
local uiManager = require("junk.ui.uiManager")

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
   canvas = nil,
   canvas_stack = {},
   shader_stack = {},

   colours = {
      transparent={ 0, 0, 0, 0 },
      white={ 1, 1, 1, 1 },
      black={ 0, 0, 0, 1 },
   },
   
   window_title = "game",
   window_width = 384,
   window_height = 216,
   current_font = nil,

   assets = assetManager,
   input = inputManager:new(),
   ui = uiManager:new(),               
   rooms = {},                          -- List of rooms available in the game.
   entities = {},                       -- List of entities available in the game.
   current_room = nil,
   signals = {},

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
   table.insert(self.canvas_stack, self.canvas)
   table.insert(self.shader_stack, love.graphics.getShader())

   self.input:addAction("ui_up", "key:up")
   self.input:addAction("ui_down", "key:down")
   self.input:addAction("ui_left", "key:left")
   self.input:addAction("ui_right", "key:right")
   self.input:addAction("ui_confirm", "key:return")
   self.input:addAction("ui_cancel", "key:escape")
   self.input:addAction("left_mouse", "mouse:1")
   self.input:addAction("right_mouse", "mouse:2")

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

-- Window ---------------------------------------------------------------------------------------------------------------------------------------------------

function game:setWindowBorderless(borderless)
   love.window.setMode(self.window_width, self.window_height, {borderless=borderless})
end

-- Rendering ------------------------------------------------------------------------------------------------------------------------------------------------

function game:setRenderScale(scale)
   self.render_scale = scale
   self.window_width = self.base_width * scale
   self.window_height = self.base_height * scale
   self.input.render_scale = scale
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

function game:drawColliders()
   if not self.current_room then return end
   local colliders = self.current_room.world:getItems()
   for i=1,#colliders do
      colliders[i]:draw()
   end
end

function game:pushCanvas(canvas)
   table.insert(self.canvas_stack, canvas)
   love.graphics.setCanvas(canvas)
end

function game:popCanvas()
   table.remove(self.canvas_stack, #self.canvas_stack)
   love.graphics.setCanvas(self.canvas_stack[#self.canvas_stack])
end

function game:pushShader(shader)
   table.insert(self.shader_stack, shader)
   love.graphics.setShader(shader)
end

function game:popShader()
   table.remove(self.shader_stack, #self.shader_stack)
   love.graphics.setShader(self.shader_stack[#self.shader_stack])
end

-- Room management ------------------------------------------------------------------------------------------------------------------------------------------

function game:gotoRoom(name)
   if _G[name] ~= nil then
      if self.current_room then self.current_room:leave() end
      self.current_room = _G[name]:new()
      self.current_room:enter()
   end
end

-- Signals --------------------------------------------------------------------------------------------------------------------------------------------------

function game:addSignalListener(name, listener)
   if not self.signals[name] then self.signals[name] = {} end
   table.insert(self.signals[name], listener)
end

function game:emitSignal(name, params)
   local listeners = self.signals[name]
   if not listeners or #listeners < 1 then return end
   for _,listener in ipairs(self.signals[name]) do
      listener(params)
   end
end

return game
