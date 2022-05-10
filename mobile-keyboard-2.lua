-- tab and arrows keys don't do anything in textfield, so I haven't tested them yet
-- ctrl and caps lock don't work

local MobileKeyboard2 = {
  caps= false,
  canBeGrabbed= true
}
setmetatable(MobileKeyboard2, {__index=letters.Node})
local MobileKeyboard2_mt = {
  __index = MobileKeyboard2
}

local s = 0.08
local keysWide = 15
local rows = {
  {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 
  },
  {
    '-', '/', ':', ';', '(', ')', '$', '&', '@', '"', 
  },
  {
    {'', label = '#+=', type = 'function', width = 1.25},
    {'', type = 'spacer', width = .25},
    {'.', width = 1.4},
    {',', width = 1.4},
    {'?', width = 1.4},
    {'!', width = 1.4},
    {'\'', width = 1.4},
    {'', type = 'spacer', width = .25},
    {'backspace', label = '⌫', type = 'function', width = 1.25},
  },
  {
    {'', label = 'ABC', type = 'function', width = 2},
    {'space', label = '    ', type = 'function', width = 5.5},
    '.',
    {'return', label = '⏎', type = 'function', width = 1.5},
  },
}

function MobileKeyboard2:new(o)
  o = o or {}
  o.size = lovr.math.newVec3(keysWide * s, s * #rows, 0.1)
  o = letters.Node.new(self, o)
  setmetatable(o, MobileKeyboard2_mt)
  o.transform
    :translate(-0.0, 1.5, -1.3)
    :rotate(-6.28/10, 1, 0, 0)
  o:_createButtons()
  return o
end

function MobileKeyboard2:_createButtons()

  
  for rowIndex, row in ipairs(rows) do
    local leftOffset = 0
    for keyIndex, key in ipairs(row) do
      local size = lovr.math.newVec3(s, s, 0.05)
      local label = key
      local rawKey = key
      if type(key) == 'table' then
        label = key[1]
        rawKey = key[1]
        if key.width then
          size:set(key.width * s, s, 0.05)
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
                end
                if key.type == 'spacer' then
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


return MobileKeyboard2
