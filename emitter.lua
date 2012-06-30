local Object = require('./object')

local Emitter = Object:extend()

-- Register an event listener
function Emitter:on(name, callback)
  -- Lazy create event types table.
  if not self.handlers then
    self.handlers = {}
  end
  local handlers = self.handlers
  
  -- Lazy create table for callbacks.
  if not handlers[name] then
    handlers[name] = {}
  end
  
  -- Store the callback as a key
  handlers[name][callback] = true
end

-- Remove an event listener
function Emitter:off(name, callback)
  -- Get the list of callbacks.
  local list = self.handlers and self.handlers[name]
  if not list then return end

  -- Delete the key by setting to nil.
  list[callback] = nil
end

-- Emit a named event.
function Emitter:emit(name, ...)
  -- Get the list of callbacks.
  local list = self.handlers and self.handlers[name]
  if not list then return end
  
  -- Call each one with the args.
  for callback in pairs(list) do
    callback(...)
  end
end

local a = Emitter:new()
a:on("foo", print)
a:emit("foo", 1, 2, 3)
  
