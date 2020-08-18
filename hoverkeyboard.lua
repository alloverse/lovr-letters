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
    {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'},
    {'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'},
    {'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/'},
    {'escape', 'lshift', 'space', 'backspace', 'return'}
  }
  for rowIndex, row in ipairs(rows) do
    for keyIndex, key in ipairs(row) do
      local size = lovr.math.newVec3((rowIndex == 4) and 0.36 or 0.2, 0.2, 0.1)
      table.insert(self.buttons, HoverKeyboard.letters.Button:new{
        size = size,
        position = lovr.math.newVec3(-1.0 + keyIndex * size.x, 2.0 - rowIndex*size.y, -2.0),
        
        onPressed = function() 
          lovr.event.push("keypressed", key, -1, false)
        end,
        onReleased = function() 
          lovr.event.push("keyreleased", key, -1)
        end,
        label = key,
        isToggle = key == "lshift"
      })
    end
  end
end
function HoverKeyboard:update()

end
function HoverKeyboard:draw()
  for i, b in ipairs(self.buttons) do
    b:draw()
  end
end

return HoverKeyboard