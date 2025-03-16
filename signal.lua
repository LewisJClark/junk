local signal = {}
signal.__index = signal

function signal:new()
   return setmetatable({}, signal)
end

function signal:addSignals(...)
   local args = {...}
   for _,name in ipairs(args) do
      self[name] = {}
   end
end

function signal:emit(name, args)
   if self[name] == nil then return end
   for _,listener in ipairs(self[name]) do
      listener(args)
   end
end

function signal:addListener(name, listener)
   if self[name] == nil then self[name] = {} end
   self[name][listener] = listener
end

function signal:removeListener(name, listener)
   if self[name] == nil then return end
   self[name][listener] = nil
end

return signal