local HoverKeyboard = {
  caps= false,
  canBeGrabbed= true
}
setmetatable(HoverKeyboard, {__index=letters.Node})
local HoverKeyboard_mt = {
  __index = HoverKeyboard
}

local s = 0.08
local rows = {
  {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'},
  {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'},
  {'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'},
  {'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '?'},
  {'!', '@', ':', ';', '-', '/', '&', '=', '(', ')'},
  {'escape', 'lshift', 'space', 'backspace', 'return'}
}
local specialKeysRowIndex = 6

function HoverKeyboard:new(o)
  o = o or {}
  o.size = lovr.math.newVec3(#rows[1] * s, s * #rows, 0.1)
  o = letters.Node.new(self, o)
  setmetatable(o, HoverKeyboard_mt)
  o.transform
    :translate(-0.0, 0.7, -1.0)
    :rotate(-3.14/4, 1, 0, 0)
  o:_createButtons()
  return o
end

function HoverKeyboard:_createButtons()

  
  for rowIndex, row in ipairs(rows) do
    for keyIndex, key in ipairs(row) do
      local size = lovr.math.newVec3((rowIndex == specialKeysRowIndex) and s*1.8 or s, s, 0.05)
      self:addChild(letters.Button:new{
        size = size,
        transform = lovr.math.newMat4():translate(
            -self.size.x/2 + keyIndex * size.x,
            self.size.y/2 - rowIndex*size.y,
            self.size.z/2
        ),
        
        onPressed = function(button)
          if key == "lshift" then
            self.caps=button.selected
          end
          lovr.event.push("keypressed", key, -1, false)
          if rowIndex < specialKeysRowIndex then
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


return HoverKeyboard
