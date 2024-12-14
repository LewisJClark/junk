local vector = require("junk.types.vector")

local UP = 0
local DOWN = 1
local PRESSED = 2
local RELEASED = 3

local inputManager = {
   instances = {}
}
inputManager.__index = inputManager

function inputManager:new()
   local im = setmetatable({
      mouse_pos = vector:new(0, 0),
      actions = {},
      bindings={}
   }, inputManager)
   table.insert(self.instances, im)
   return im
end

function inputManager:addAction(name, ...)
   local args = {...}
   self.actions[name] = { frames=0, state=UP }
   for _,input in ipairs(args) do
      self.bindings[input] = name
   end
end

function inputManager:_updateBindingState(binding, state)
   if self.bindings[binding] then
      self.actions[self.bindings[binding]].frames = 1
      self.actions[self.bindings[binding]].state = state
   end
end

function love.keypressed(key, scancode, isRepeat) inputManager.instances[1]:_updateBindingState("key:"..key, PRESSED) end
function love.keyreleased(key, scancode, isRepeat) inputManager.instances[1]:_updateBindingState("key:"..key, RELEASED) end
function love.gamepadpressed(joystick, button) inputManager.instances[1]:_updateBindingState("pad:"..button, PRESSED) end
function love.gamepadreleased(joystick, button) inputManager.instances[1]:_updateBindingState("pad:"..button, RELEASED) end

function inputManager:update()
   self.mouse_pos.x, self.mouse_pos.y = love.mouse.getPosition()
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

function inputManager:isUp(actionName) return self.actions[actionName].state == UP end
function inputManager:isDown(actionName) return self.actions[actionName].state == DOWN end
function inputManager:isPressed(actionName) return self.actions[actionName].state == PRESSED end
function inputManager:isReleased(actionName) return self.actions[actionName].state == RELEASED end

return inputManager