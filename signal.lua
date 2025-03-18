Signal = {}
Signal.__index = Signal

function Signal:new()
   return setmetatable({}, Signal)
end

function Signal:addSignals(...)
   local args = {...}
   for _,name in ipairs(args) do
      self[name] = {}
   end
end

function Signal:emit(name, args)
   if self[name] == nil then return end
   for _,listener in pairs(self[name]) do
      listener(args)
   end
end

function Signal:addListener(name, listener)
   if self[name] == nil then self[name] = {} end
   self[name][listener] = listener
end

function Signal:removeListener(name, listener)
   if self[name] == nil then return end
   self[name][listener] = nil
end