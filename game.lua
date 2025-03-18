--[[ 
   This represents the current state of the Game, at least as Junk sees it.
   Modules can require this module in order to modify the overall Game state by
   changing rooms, changing window sizes etc.
]]
Game = {
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
   
   window_title = "Game",
   window_width = 384,
   window_height = 216,
   current_font = nil,

   rooms = {},                          -- List of rooms available in the game.
   entities = {},                       -- List of entities available in the game.
   current_room = nil,
   signals = {},

   time_scale = 1,
   scaled_delta = 0,
   delta_tween = Tweener:new(),
   scaled_tween = Tweener:new()
}

function Game:init(width, height, title)
   self.base_width = width
   self.base_height = height
   self.window_title = title
   self.window_width = width
   self.window_height = height

   love.math.random(os.time())
   love.window.setMode(width, height)
   love.window.setTitle(title)
   love.graphics.setDefaultFilter("nearest", "nearest")
   love.graphics.setLineStyle("rough")

   self.canvas = love.graphics.newCanvas(self.base_width, self.base_height)
   table.insert(self.canvas_stack, self.canvas)
   table.insert(self.shader_stack, love.graphics.getShader())

   -- Setup some default input bindings.
   Input:addAction("ui_up", "key:up")
   Input:addAction("ui_down", "key:down")
   Input:addAction("ui_left", "key:left")
   Input:addAction("ui_right", "key:right")
   Input:addAction("ui_confirm", "key:return")
   Input:addAction("ui_cancel", "key:escape")
   Input:addAction("left_mouse", "mouse:1")
   Input:addAction("right_mouse", "mouse:2")

   Assets:load()
end

function Game:update(dt)
   self.scaled_delta = dt * self.time_scale
   self.delta_tween:update(dt)
   self.scaled_tween:update(self.scaled_delta)
   Input:update(dt)
   if self.current_room then self.current_room:update(self.scaled_delta) end
end

-- Window ---------------------------------------------------------------------------------------------------------------------------------------------------

function Game:setWindowBorderless(borderless)
   love.window.setMode(self.window_width, self.window_height, {borderless=borderless})
end

-- Rendering ------------------------------------------------------------------------------------------------------------------------------------------------

function Game:setRenderScale(scale)
   self.render_scale = scale
   self.window_width = self.base_width * scale
   self.window_height = self.base_height * scale
   Input.render_scale = scale
   love.window.setMode(self.window_width, self.window_height)
end

function Game:registerColour(name, r, g, b, a)
   self.colours[name] = Utils.normalizeColour({ r, g, b, a})
end

function Game:getColourCopy(name)
   if self.colours[name] ~= nil then
      local col = self.colours[name]
      return { col[1], col[2], col[3], col[4] }
   end
end

function Game:drawColliders()
   if not self.current_room then return end
   local colliders = self.current_room.world:getItems()
   for i=1,#colliders do
      colliders[i]:draw()
   end
end

function Game:pushCanvas(canvas)
   table.insert(self.canvas_stack, canvas)
   love.graphics.setCanvas(canvas)
end

function Game:popCanvas()
   table.remove(self.canvas_stack, #self.canvas_stack)
   love.graphics.setCanvas(self.canvas_stack[#self.canvas_stack])
end

function Game:pushShader(shader)
   table.insert(self.shader_stack, shader)
   love.graphics.setShader(shader)
end

function Game:popShader()
   table.remove(self.shader_stack, #self.shader_stack)
   love.graphics.setShader(self.shader_stack[#self.shader_stack])
end

-- Room management ------------------------------------------------------------------------------------------------------------------------------------------

function Game:gotoRoom(name, config)
   if _G[name] ~= nil then
      if self.current_room then self.current_room:leave() end
      self.current_room = _G[name]:new(config)
      self.current_room:enter()
   end
end