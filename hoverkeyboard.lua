local Button = require('button')

local HoverKeyboard = {}
function HoverKeyboard:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o:_createButtons()
  return o
end
function HoverKeyboard:_createButtons()
  self.buttons = {}
  local rows = {
    {'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'},
    {'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'},
    {'Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/'},
  }
  for j, row in ipairs(rows) do
    for i, l in ipairs(row) do
      table.insert(self.buttons, Button:new{
        position = lovr.math.newVec3(-1.0 + i * 0.2, 1.8 - j*0.2, -2.0),
        size = lovr.math.newVec3(0.2, 0.2, 0.1),
        onPressed = function() 
          lovr.event.push("keypressed", l, -1, false)
          lovr.event.push("keyreleased", l, -1)
        end,
        label = l
      })
    end
  end
end
function HoverKeyboard:draw()
  for i, b in ipairs(self.buttons) do
    b:draw()
  end
end

return HoverKeyboard