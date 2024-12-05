local vector = require("junk.types.vector")

local UP = 0
local DOWN = 1
local PRESSED = 2
local RELEASED = 3

local inputManager = {}
inputManager.__index = inputManager

function inputManager:new()
   return setmetatable({
      mouse_pos = vector:new(0, 0),
      actions = {}
   }, inputManager)
end

function inputManager:addAction(name, key, mbutton)
   self.actions[name] = {
      state=UP,
      lastState=UP,
      lastInputType="key",
      key=key,
      mbutton=mbutton
   }
end

function inputManager:update()
   self.mouse_pos.x, self.mouse_pos.y = love.mouse.getPosition()
   for _,action in pairs(self.actions) do
      action.lastState = action.state
      local newState = UP
      -- Check keyboard inputs.
      if action.key ~= nil and love.keyboard.isDown(action.key) then
         if action.lastState == UP then newState = PRESSED
         else newState = DOWN end
         action.lastInputType = "key"
      elseif action.lastInputType == "key" then
         if action.lastState == DOWN then newState = RELEASED end
      end
      -- Check mouse inputs.
      if action.mbutton ~= nil and love.mouse.isDown(action.mbutton) then
         if action.lastState == UP then newState = PRESSED
         else newState = DOWN end
         action.lastInputType = "mbutton"
      elseif action.lastInputType == "mbutton" then
         if action.lastState == DOWN then newState = RELEASED end
      end
      action.state = newState
   end
end

function inputManager:isUp(actionName) return self.actions[actionName].state == UP end
function inputManager:isDown(actionName) return self.actions[actionName].state == DOWN end
function inputManager:isPressed(actionName) return self.actions[actionName].state == PRESSED end
function inputManager:isReleased(actionName) return self.actions[actionName].state == RELEASED end

return inputManager