local vector = require("junk.types.vector")
local utils = require("junk.utils")

local UP = 0
local DOWN = 1
local PRESSED = 2
local RELEASED = 3

local inputManager = {
   render_scale = 1,
   instances = {},
   stick_bindings = {
      leftx = { "pad:lstick_left", "pad:lstick_right" },
      lefty = { "pad:lstick_up", "pad:lstick_down" },
      rightx = { "pad:rstick_left", "pad:rstick_right" },
      righty = { "pad:rstick_up", "pad:rstick_down" },
   }
}
inputManager.__index = inputManager

function inputManager:new()
   local im = setmetatable({
      mouse_pos = vector:new(0, 0),
      leftx = 0,
      lefty = 0,
      rightx = 0,
      righty = 0,
      actions = {},
      bindings={}
   }, inputManager)
   table.insert(self.instances, im)
   return im
end

function inputManager:addAction(name, ...)
   local args = {...}
   self.actions[name] = { frames=0, state=UP, strength=0 }
   for _,input in ipairs(args) do
      self.bindings[input] = name
   end
end

function inputManager:_updateBindingState(binding, state, strength)
   if self.bindings[binding] then
      local action = self.actions[self.bindings[binding]]
      if action.state ~= state then
         action.state = state
         action.frames = 1
      end
      action.strength = strength
   end
end

function inputManager:_updateBindingStrength(binding, strength)
   if self.bindings[binding] then
      self.actions[self.bindings[binding]].strength = strength
   end
end

function inputManager:_getAxisState(value)
   if math.abs(value) < 0.2 then return 0 end
   if value < 0 then return -1 end
   return 1
end

function inputManager:_axisStateChanged(axis, new_state)
   return self[axis] ~= new_state
end

function love.keypressed(key, scancode, isRepeat) inputManager.instances[1]:_updateBindingState("key:"..key, PRESSED, 1) end
function love.keyreleased(key, scancode, isRepeat) inputManager.instances[1]:_updateBindingState("key:"..key, RELEASED, 0) end
function love.mousepressed(x, y, button) inputManager.instances[1]:_updateBindingState("mouse:"..button, PRESSED, 1) end
function love.mousereleased(x, y, button) inputManager.instances[1]:_updateBindingState("mouse:"..button, RELEASED, 1) end
function love.gamepadpressed(joystick, button) inputManager.instances[1]:_updateBindingState("pad:"..button, PRESSED, 1) end
function love.gamepadreleased(joystick, button) inputManager.instances[1]:_updateBindingState("pad:"..button, RELEASED, 0) end
function love.gamepadaxis(joystick, axis, value)
   local im = inputManager.instances[1]
   local binding_negative = inputManager.stick_bindings[axis][1]
   local binding_positive = inputManager.stick_bindings[axis][2]
   local stick_state = im:_getAxisState(value)
   local abs_value = math.abs(value)
   if not im:_axisStateChanged(axis, stick_state) then
      im:_updateBindingStrength(binding_positive, value > 0 and abs_value or 0)
      im:_updateBindingStrength(binding_negative, value < 0 and abs_value or 0)
   end
   local last_state = im[axis]
   if stick_state == 1 then 
      im:_updateBindingState(binding_positive, PRESSED, abs_value)
      im:_updateBindingState(binding_negative, last_state == -1 and RELEASED or UP, 0)
   elseif stick_state == -1 then
      im:_updateBindingState(binding_positive, last_state == 1 and RELEASED or UP, 0)
      im:_updateBindingState(binding_negative, PRESSED, abs_value)
   else
      im:_updateBindingState(binding_positive, last_state == 1 and RELEASED or UP, 0)
      im:_updateBindingState(binding_negative, last_state == -1 and RELEASED or UP, 0)
   end
   im[axis] = stick_state
end

function inputManager:update()
   self.mouse_pos.x, self.mouse_pos.y = love.mouse.getPosition()
   self.mouse_pos.x = math.floor(self.mouse_pos.x / self.render_scale)
   self.mouse_pos.y = math.floor(self.mouse_pos.y / self.render_scale)
   for _,action in pairs(self.actions) do
      if action.state == PRESSED and action.frames > 1 then
         action.state = DOWN 
         action.frames = 1
      elseif action.state == RELEASED and action.frames > 1 then
         action.state = UP
         action.frames = 1
      end
      action.frames = action.frames + 1
   end
end

function inputManager:isUp(actionName) return self.actions[actionName].state == UP or self.actions[actionName].state == RELEASED end
function inputManager:isDown(actionName) return self.actions[actionName].state == DOWN or self.actions[actionName].state == PRESSED end
function inputManager:isPressed(actionName) return self.actions[actionName].state == PRESSED end
function inputManager:isReleased(actionName) return self.actions[actionName].state == RELEASED end
function inputManager:getAxis(negative, positive)
   return self.actions[positive].strength - self.actions[negative].strength
end
function inputManager:getVector(negative_x, positive_x, negative_y, positive_y)
   return vector:new(
      self.actions[positive_x].strength - self.actions[negative_x].strength,
      self.actions[positive_y].strength - self.actions[negative_y].strength
   )
end

return inputManager