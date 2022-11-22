local KeyboardConfig = require("keyboard-config")

local TapKeyboard = {
  caps= false,
  canBeGrabbed= true
}
setmetatable(TapKeyboard, {__index=letters.Node})
local TapKeyboard_mt = {
  __index = TapKeyboard
}

function TapKeyboard:new(o)
  o = o or {}
  if not o.keyboardConfig then
    o.keyboardConfig = KeyboardConfig:new()
    o.keyboardConfig:addStandardKeys()
  end
  if not o.keySize then
    o.keySize = 0.08
  end
  o.keysWide = 0
  for i, key in ipairs(o.keyboardConfig.rows[1]) do
    if type(key) == "table" and key.width then
      o.keysWide = o.keysWide + key.width
    else
      o.keysWide = o.keysWide + 1
    end
  end
  o.size = lovr.math.newVec3(o.keysWide * o.keySize, o.keySize * # o.keyboardConfig.rows, 0.1)
  o = letters.Node.new(self, o)
  setmetatable(o, TapKeyboard_mt)
  o.transform
    :translate(-0.0, 1.5, -1.3)
    :rotate(-6.28/10, 1, 0, 0)
  o:_createButtons()
  return o
end

function TapKeyboard:_createButtons()
  for rowIndex, row in ipairs(self.keyboardConfig.rows) do
    local leftOffset = 0
    for keyIndex, key in ipairs(row) do
      local size = lovr.math.newVec3(self.keySize,self.keySize, 0.05)
      local label = key
      local rawKey = key
      if type(key) == 'table' then
        label = key[1]
        rawKey = key[1]
        if key.width then
          size:set(key.width * self.keySize, self.keySize, 0.05)
        end
        if key.label then 
          label = key.label
        end
      end
      leftOffset = leftOffset + size.x/2

      if not (key.type and key.type == 'spacer') then
        self:addChild(letters.Button:new{
          size = size,
          transform = lovr.math.newMat4(vec3(
            -self.size.x/2 + leftOffset+.1,
            self.size.y/2 - rowIndex*size.y,
            self.size.z/2
          )),
          
          onPressed = function(button)
            if rawKey == "lshift" or rawKey == 'capslock' then
              self.caps=button.selected
            end

            if type(key) == 'table' then
              if key.type then
                if key.type == 'function' then
                  lovr.event.push("keypressed", rawKey, -1, false)
                  if key.text then
                    -- function key has associated textinput
                    lovr.event.push("textinput", key.text, -1)
                  end
                elseif key.type == 'spacer' then
                  -- ignored, not a real button
                end
              else
                -- special character
                lovr.event.push("keypressed", rawKey, -1, false)
                local character = key[1]
                if self.caps then
                  character = key.shift
                end
                lovr.event.push("textinput", character, -1)
              end
            else
              lovr.event.push("keypressed", rawKey, -1, false)
              -- regular character
              local character = key
              if self.caps then
                character = string.upper(key)
              end
              lovr.event.push("textinput", character, -1)
            end
          end,

          onReleased = function(button)
            if rawKey == "lshift" or rawKey == 'capslock' then
              self.caps=button.selected
            end
            lovr.event.push("keyreleased", rawKey, -1)
          end,
          label = label,
          isToggle = rawKey == "lshift" or rawKey == 'capslock'
        })
      end


      leftOffset = leftOffset + size.x/2
    end
  end
end


return TapKeyboard
