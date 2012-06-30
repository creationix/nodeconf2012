local Object = require('./object')

-- Create a class using Object
local Rect = Object:extend()
function Rect:initialize(w, h)
  self.w = w
  self.h = h
end
function Rect:getArea()
  return self.w * self.h
end

-- Create an instance it.
local rect = Rect:new(4, 5)
print(rect:getArea())
