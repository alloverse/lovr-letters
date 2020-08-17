-- Test bed Lovr app
local letters = require('letters')
local Button = require('button')

-- state
local current_text = ""
local drawables = {}

---- drawing text
function typehandler(code, scancode, repetition)
  if code == "backspace" then
    current_text = current_text:sub(1, -2)
  elseif code == "space" then
    current_text = current_text .. " "
  else
    current_text = current_text .. code
  end
end

-- global
function lovr.load()
  world = lovr.physics.newWorld()

  lovr.graphics.setBackgroundColor(0.95, 0.98, 0.98)
  lovr.headset.setClipDistance(0.1, 3000)
  
  lovr.handlers["keypressed"] = typehandler
  table.insert(drawables, Button:new{
    position = lovr.math.newVec3(-0.3, 1.2, -1),
    onPressed = function() 
      table.insert(drawables, letters.HoverKeyboard:new())
    end,
    label = "Hover"
  })
  table.insert(drawables, Button:new{
    position = lovr.math.newVec3(0.3, 1.2, -1),
    onPressed = function() 
      table.insert(drawables, letters.ButterflyKeyboard:new())
    end,
    label = "Butterfly"
  })

  letters.load()
  for i, hand in ipairs(letters.hands) do
    table.insert(drawables, hand)
  end
end

function lovr.update()
  letters.update()
end

function lovr.draw()
  lovr.graphics.setCullingEnabled(true)
  lovr.graphics.setDepthTest('lequal', true)

  lovr.graphics.clear()

  lovr.graphics.setShader()
  lovr.graphics.setColor(0, 0, 0)
  lovr.graphics.print(current_text, 0, 0, -10, 1)
  lovr.graphics.setShader()

  for i, thing in ipairs(drawables) do
    thing:draw()
  end
end
