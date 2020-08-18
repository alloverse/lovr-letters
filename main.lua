-- Test bed Lovr app
local letters = require('letters')
local Button = require('button')
local TextField = require('textfield')

-- state
local drawables = {}

-- global
function lovr.load()
  lovr.graphics.setBackgroundColor(0.95, 0.98, 0.98)
  lovr.headset.setClipDistance(0.1, 3000)
  
  table.insert(drawables, Button:new{
    world=letters.world,
    position = lovr.math.newVec3(-0.3, 1.2, -1),
    onPressed = function() 
      table.insert(drawables, letters.HoverKeyboard:new{world=letters.world})
    end,
    label = "Hover"
  })
  table.insert(drawables, Button:new{
    world=letters.world,
    position = lovr.math.newVec3(0.3, 1.2, -1),
    onPressed = function() 
      table.insert(drawables, letters.ButterflyKeyboard:new())
    end,
    label = "Butterfly"
  })
  table.insert(drawables, TextField:new{
    position = lovr.math.newVec3(0, 5, -10),
  })
  drawables[#drawables]:makeKey()

  letters.load()
  for i, hand in ipairs(letters.hands) do
    table.insert(drawables, hand)
  end
end

function lovr.update()
  letters.update()
  for i, thing in ipairs(drawables) do
    thing:update()
  end
end

function lovr.draw()
  lovr.graphics.setCullingEnabled(true)
  lovr.graphics.setDepthTest('lequal', true)
  lovr.graphics.clear()
  lovr.graphics.setShader()

  for i, thing in ipairs(drawables) do
    thing:draw()
  end
end
