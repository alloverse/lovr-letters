local KeyboardConfig = require("keyboard-config")
local TapKeyboard  = require("tap-keyboard")

local IndeckKeyboard = {
}
setmetatable(IndeckKeyboard, {__index=TapKeyboard})
local IndeckKeyboard_mt = {
  __index = IndeckKeyboard
}

function IndeckKeyboard:new(o)
  o = o or {}
  if not o.keyboardConfig then
    o.keyboardConfig = KeyboardConfig:new()
    o.keyboardConfig:addStandardKeys()
    o.keyboardConfig:addIndeckMacroRows()
    o.keyboardConfig:addLeftCommands()
    o.keyboardConfig:addRightCommands()
  end
  o = TapKeyboard:new(o)
  setmetatable(o, IndeckKeyboard_mt)
  o.transform:translate(-1.0, 0, 0)
  return o
end


-- An Indeck-specific macro pad
function KeyboardConfig:addIndeckMacroRows()
  local macroRows = {
    {
      {'lovr.',     width = 2.5}, 
      {'graphics.', width = 3}, 
      {'headset.',  width = 3}, 
      {'get',       width = 1.5}, 
      {'set',       width = 1.5}, 
      {'new',       width = 1.5}, 
      {'vec3(',     width = 2},
    },
    {
      {'local',    width = 2}, 
      {'self',     width = 2}, 
      {'function', width = 3}, 
      {'end',      width = 1.5}, 
      ':', '()', '{}', 
      {'print(\'', width = 2}, 
      {'--',       width = 1.5},
    },
    {
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
  }
  for i, row in ipairs(macroRows) do
    self:insertRow(i, row)
  end
end

-- Add Indeck-specific commands as a sidebar
function KeyboardConfig:addLeftCommands()
  local commands = {
    {'load session', width = 4}, 
    {'save session', width = 4}, 
    {'new window', width = 4}, 
    {'close window', width = 4}, 
    {'fullscreen', width = 4}, 
    {'profiler', width = 4}, 
    {'', type = 'spacer', width = 4},
  }
  -- if we have macro rows, pad them
  for i=1, #self.rows-#commands-1 do
    table.insert(commands, 1, {'', type='spacer', width=4})
  end
  self:insertColumn(1, 1, commands)
  self:insertBlankColumn(2)
end

-- Add Indeck-specific commands as a sidebar
function KeyboardConfig:addRightCommands()
  local commands = {
    {'open file',  width = 4},
    {'save file',  width = 4},
    {'center view',  width = 4},
    {'restart game', width = 4},
    {'docs', width = 4},
    {'execute line', width = 4},
  }
  -- if we have macro rows, pad them
  for i=1, #self.rows-#commands-2 do
    table.insert(commands, 1, {'', type='spacer', width=4})
  end
  self:insertBlankColumn(255)
  self:insertColumn(255, 1, commands)
end

return IndeckKeyboard
