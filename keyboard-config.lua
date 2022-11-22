
local KeyboardConfig = {
}
local KeyboardConfig_mt = {
  __index = KeyboardConfig
}

-- A configuration of keys to use.
-- rows is a table of rows, with each row a list of keys.
-- Each key is either just a letter, or a table.
-- the table may have the keys:
--  * label: use this label instead of the keycode
--  * type: one of:
--    * function: special function key
--    * spacer: this key isn't a key, it's an invisible spacer
--  * shift: when shifted, type this character instead of the main one
--  * width: display this key as this number of key widths
--  * text: if type=function, type this key when pressed
function KeyboardConfig:new(o)
  o = o or {}
  o.rows = {}
  setmetatable(o, KeyboardConfig_mt)
  return o
end

-- Utilities for adding rows and columns of keys
function KeyboardConfig:insertRow(index, row)
  table.insert(self.rows, index, row)
end

function KeyboardConfig:insertColumn(index, startRow, column)
  for i=startRow, #self.rows do
    local row = self.rows[i]
    local key = column[i-startRow]
    local clampedIndex = math.min(index, #row+1)
    table.insert(row, clampedIndex, key)
  end
end

function KeyboardConfig:insertBlankColumn(index)
  local blanks = {}
  for i=1, #self.rows do
    table.insert(blanks, {'', type='spacer'})
  end
  self:insertColumn(index, 1, blanks)
end

-- Your regular basic US keyboard layout
function KeyboardConfig:addStandardKeys()
  local standardRows = {
    -- command on left, keyboard row, command on right
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
    },
    {
      {'tab', label = 'tab', type = 'function', width = 2},
      'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
      {'[',  shift = '{'},
      {']',  shift = '}'},
      {'\\', shift = '|'},
    },
    {
      {'capslock', label = 'caps', type = 'function', width = 2},
      'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
      {';', shift = ':'},
      {'\'', shift = '"'},
      {'return', label = 'return', type = 'function', width = 2},
    },
    {
      {'lshift', label = 'shift', type = 'function', width = 2.5},
      'z', 'x', 'c', 'v', 'b', 'n', 'm', 
      {',', shift = '<', type = 'function'}, 
      {'.', shift = '>', type = 'function'}, 
      {'/', shift = '?', type = 'function'},
      {'rshift', label = 'shift', type = 'function', width = 2.5},
    },
    {
      {'lctrl', label = 'ctrl', type = 'function', width = 3},
      {'lalt',  label = 'alt',  type = 'function', width = 1.5},
      {'space', label = '    ', text = " ", type = 'function', width = 5},
      {'ralt',  label = 'alt',  type = 'function', width = 1.5},
      {'up',    label = '▲',    type = 'function', width = 2},
      {'rctrl', label = 'ctrl', type = 'function', width = 2},
    },
    {
      {'', type = 'spacer', width = 9},
      {'left',  label = '◀',    type = 'function', width = 2},
      {'down',  label = '▼',    type = 'function', width = 2},
      {'right', label = '►',    type = 'function', width = 2},
    }
  }
  for i, row in ipairs(standardRows) do
    self:insertRow(i, row)
  end
end

return KeyboardConfig
