local Object = {}
Object.meta = {__index = Object}

-- Creates a new instance and initializes it.
function Object:new(...)
  local obj = setmetatable({}, self.meta)
  if obj.initialize then
    obj:initialize(...)
  end
  return obj
end

-- Creates a new sub-class
function Object:extend()
  local sub = setmetatable({}, self.meta)
  sub.meta = {__index = sub}
  return sub
end

return Object