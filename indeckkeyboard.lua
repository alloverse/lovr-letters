-- tab and arrows keys don't do anything in textfield, so I haven't tested them yet
-- ctrl and caps lock don't work
-- command buttons to the left and right of the keyboard don't work


local IndeckKeyboard = {
  caps= false,
  canBeGrabbed= true
}
setmetatable(IndeckKeyboard, {__index=letters.Node})
local IndeckKeyboard_mt = {
  __index = IndeckKeyboard
}

local rows = {
  -- macros
  {
    {'', type = 'spacer', width = 5},
    {'lovr.',     width = 2.5}, 
    {'graphics.', width = 3}, 
    {'headset.',  width = 3}, 
    {'get',       width = 1.5}, 
    {'set',       width = 1.5}, 
    {'new',       width = 1.5}, 
    {'vec3(',     width = 2},
  },
  {
    {'', type = 'spacer', width = 5}, 
    {'local',    width = 2}, 
    {'self',     width = 2}, 
    {'function', width = 3}, 
    {'end',      width = 1.5}, 
    ':', '()', '{}', 
    {'print(\'', width = 2}, 
    {'--',       width = 1.5},
  },
  {
    {'', type = 'spacer', width = 5}, 
    {'for ',  width = 1.5}, 
    ' in ', 'i', 
    {'pairs', width = 1.5}, 
    {' do ',  width = 1}, 
    {'if ',   width = 1.5}, 
    {'then',  width = 1.5}, 
    {'else',  width = 1.5}, 
    {' not ', width = 1.5}, 
    {' and ', width = 1.5}, 
    {' or ',  width = 1.5},
  },
  {
    {'', type = 'spacer', width = 5},
    {'~'}, 
    {'!'}, 
    {'@'}, 
    {'#'}, 
    {'$'}, 
    {'%'}, 
    {'^'}, 
    {'&'}, 
    {'*'}, 
    {'('}, 
    {')'}, 
    {'_'}, 
    {'+'}, 
    {'{'}, 
    {'}'}, 
  },
  {},

  -- command on left, keyboard row, command on right
  {
    {'load session', width = 4}, 
    {'', type = 'spacer'},
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
    {'', type = 'spacer'}, 
    {'open file',  width = 4},
  },
  {
    {'save session', width = 4}, 
    {'', type = 'spacer'},
    {'`', shift = '~'}, 
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
    {'backspace', label = 'delete', type = 'function', width = 2},
    {'', type = 'spacer'}, 
    {'save file',  width = 4},
  },
  {
    {'new window', width = 4}, 
    {'', type = 'spacer'},
    {'tab', label = 'tab', type = 'function', width = 2},
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    {'[',  shift = '{'},
    {']',  shift = '}'},
    {'\\', shift = '|'},
    {'', type = 'spacer'}, 
    {'center view',  width = 4},
  },
  {
    {'close window', width = 4}, 
    {'', type = 'spacer'},
    {'capslock', label = 'caps', type = 'function', width = 2},
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
    {';', shift = ':'},
    {'\'', shift = '"'},
    {'return', label = 'return', type = 'function', width = 2},
    {'', type = 'spacer'}, 
    {'restart game', width = 4},
  },
  {
    {'fullscreen', width = 4}, 
    {'', type = 'spacer'},
    {'lshift', label = 'shift', type = 'function', width = 2.5},
    'z', 'x', 'c', 'v', 'b', 'n', 'm', 
    {',', shift = '<', type = 'function'}, 
    {'.', shift = '>', type = 'function'}, 
    {'/', shift = '?', type = 'function'},
    {'rshift', label = 'shift', type = 'function', width = 2.5},
    {'', type = 'spacer'}, 
    {'docs', width = 4},
  },
  {
    {'profiler', width = 4}, 
    {'', type = 'spacer'},
    {'lctrl', label = 'ctrl', type = 'function', width = 3},
    {'lalt',  label = 'alt',  type = 'function', width = 1.5},
    {'space', label = '    ', text = " ", type = 'function', width = 5},
    {'ralt',  label = 'alt',  type = 'function', width = 1.5},
    {'up',    label = '▲',    type = 'function', width = 2},
    {'rctrl', label = 'ctrl', type = 'function', width = 2},
    {'', type = 'spacer'}, 
    {'execute line', width = 4},
  },
  {
    {'', type = 'spacer', width = 14},
    {'left',  label = '◀',    type = 'function', width = 2},
    {'down',  label = '▼',    type = 'function', width = 2},
    {'right', label = '►',    type = 'function', width = 2},
  }
}

function IndeckKeyboard:new(o)
  o = o or {}
  o.keySize = 0.08
  o.keysWide = 15
  o.size = lovr.math.newVec3(o.keysWide * o.keySize, o.keySize * #rows, 0.1)
  o = letters.Node.new(self, o)
  setmetatable(o, IndeckKeyboard_mt)
  o.transform
    :translate(-0.0, 1.5, -1.3)
    :rotate(-6.28/10, 1, 0, 0)
  o:_createButtons()
  return o
end

function IndeckKeyboard:_createButtons()
  for rowIndex, row in ipairs(rows) do
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


return IndeckKeyboard
