local HoverKeyboard = {
  caps=false,
}
setmetatable(HoverKeyboard, {__index=letters.Node})
local HoverKeyboard_mt = {
  __index = HoverKeyboard
}

function HoverKeyboard:new(o)
  o = o or {}
  o.size = lovr.math.newVec3(2, 1, 0.1)
  o = letters.Node.new(self, o)
  setmetatable(o, HoverKeyboard_mt)
  o.transform
    :translate(-0.0, 1.0, -2.0)
    :rotate(-3.14/4, 1, 0, 0)
  o:_createButtons()
  
  return o
end

function HoverKeyboard:_createButtons()
  local rows = {
    {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'},
    {'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'},
    {'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/'},
    {'escape', 'lshift', 'space', 'backspace', 'return'}
  }
  for rowIndex, row in ipairs(rows) do
    for keyIndex, key in ipairs(row) do
      local size = lovr.math.newVec3((rowIndex == 4) and 0.36 or 0.2, 0.2, 0.1)
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

function HoverKeyboard:grab(by)
  self.heldBy = by
end
function HoverKeyboard:ungrab(by)
  self.heldBy = nil
end


return HoverKeyboard
