-- tab and arrows keys don't do anything in textfield, so I haven't tested them yet
-- ctrl and caps lock don't work

local LaptopKeyboard = {
  caps= false,
  canBeGrabbed= true
}
setmetatable(LaptopKeyboard, {__index=letters.Node})
local LaptopKeyboard_mt = {
  __index = LaptopKeyboard
}

local s = 0.08
local keysWide = 15
local rows = {
  {
    {'escape', label = 'esc', type = 'function', width = 2}, 
    {'f1',  label = 'F1',  type = 'function'},
    {'f2',  label = 'F2',  type = 'function'},
    {'f3',  label = 'F3',  type = 'function'},
    {'f4',  label = 'F4',  type = 'function'},
    {'f5',  label = 'F5',  type = 'function'},
    {'f6',  label = 'F6',  type = 'function'},
    {'f7',  label = 'F7',  type = 'function'},
    {'f8',  label = 'F8',  type = 'function'},
    {'f9',  label = 'F9',  type = 'function'},
    {'f10', label = 'F10', type = 'function'},
    {'f11', label = 'F11', type = 'function'},
    {'f12', label = 'F12', type = 'function'},
    {'f13', label = 'F13', type = 'function'},
  },
  {
    {'`', shift = '~', width = 1.25},
    {'1', shift = '!'},
    {'2', shift = '@'},
    {'3', shift = '#'},
    {'4', shift = '$'},
    {'5', shift = '%'},
    {'6', shift = '^'},
    {'7', shift = '&'},
    {'8', shift = '*'},
    {'9', shift = '('},
    {'0', shift = ')'},
    {'-', shift = '_'},
    {'=', shift = '+'},
    {'backspace', label = 'back', type = 'function', width = 1.75},
  },
  {
    {'tab', label = 'tab', type = 'function', width = 1.75},
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    {'[',  shift = '{'},
    {']',  shift = '}'},
    {'\\', shift = '|', width = 1.25},
  },
  {
    {'capslock', label = 'caps', type = 'function', width = 2},
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
    {';',  shift = ':'},
    {'\'', shift = '"'},
    {'return', label = 'enter', type = 'function', width = 2},
  },
  {
    {'lshift', label = 'shift', type = 'function', width = 2.5},
    'z', 'x', 'c', 'v', 'b', 'n', 'm',
    {',', shift = '<'},
    {'.', shift = '>'},
    {'/', shift = '?'},
    {'rshift', label = 'shift', type = 'function', width = 2.5},
  },
  {
    {'lctrl', label = 'ctrl', type = 'function', width = 2.5},
    {'lalt',  label = 'alt',  type = 'function', width = 2},
    {'space', label = '    ', type = 'function', width = 5},
    {'ralt',  label = 'alt',  type = 'function', width = 2},
    {'up',    label = '▲',    type = 'function', width = 1.75},
    {'rctrl', label = 'ctrl', type = 'function', width = 1.75},
  },
  {
    {'', type = 'spacer', width = 9.75},
    {'left',  label = '◀', type = 'function', width = 1.75},
    {'down',  label = '▼', type = 'function', width = 1.75},
    {'right', label = '►', type = 'function', width = 1.75},
  }
}

function LaptopKeyboard:new(o)
  o = o or {}
  o.size = lovr.math.newVec3(keysWide * s, s * #rows, 0.1)
  o = letters.Node.new(self, o)
  setmetatable(o, LaptopKeyboard_mt)
  o.transform
    :translate(-0.0, 1.5, -1.3)
    :rotate(-6.28/10, 1, 0, 0)
  o:_createButtons()
  return o
end

function LaptopKeyboard:_createButtons()

  
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


return LaptopKeyboard
