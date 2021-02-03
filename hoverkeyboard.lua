local HoverKeyboard = {
  caps=false,
}
function HoverKeyboard:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o:_createButtons()
  o.transform = lovr.math.newMat4()
    :translate(-1.0, 1.2, -2.0)
    :rotate(-3.14/4, 1, 0, 0)
  return o
end
function HoverKeyboard:remove()
  for i, b in ipairs(self.buttons) do
    b:remove()
  end
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
        position = lovr.math.newVec3(0 + keyIndex * size.x, 0 - rowIndex*size.y, 0),
        
        onPressed = function(button)
          if key == "lshift" then
            self.caps=button.selected
          end
          lovr.event.push("keypressed", key, -1, false)
          if rowIndex < 4 then
            local character = key
            if self.caps then
              character = string.upper(key)
            end
            lovr.event.push("textinput", character, -1)
          end
        end,
        onReleased = function(button)
          if key == "lshift" then
            self.caps=button.selected
          end
          lovr.event.push("keyreleased", key, -1)
        end,
        label = key,
        isToggle = key == "lshift"
      })
    end
  end
end

function HoverKeyboard:update()
  for i, b in ipairs(self.buttons) do
    local pos = b.position
    local collider = b.collider
    local m = lovr.math.mat4():mul(self.transform):translate(pos)
    local x, y, z, sx, sy, sz, a, ax, ay, az = m:unpack()
    collider:setPose(x, y, z, a, ax, ay, az)
  end
end

function HoverKeyboard:draw()
  lovr.graphics.push()
  lovr.graphics.transform(self.transform)
  for i, b in ipairs(self.buttons) do
    b:draw()
  end
  lovr.graphics.pop()
end

return HoverKeyboard
