-- Test bed Lovr app
local letters = require('letters')


-- state
local drawables = {}
local font = lovr.graphics.newFont(32)

-- global
function lovr.load()
  letters.load()

  lovr.graphics.setBackgroundColor(0.95, 0.98, 0.98)
  lovr.headset.setClipDistance(0.1, 3000)
  
  table.insert(drawables, letters.Button:new{
    position = lovr.math.newVec3(-0.3, 1.2, -1),
    onActuate = function() 
      letters.defaultKeyboard = letters.HoverKeyboard
    end,
    label = "Hover"
  })
  table.insert(drawables, letters.Button:new{
    position = lovr.math.newVec3(0.3, 1.2, -1),
    onActuate = function() 
      etters.defaultKeyboard = letters.ButterflyKeyboard
    end,
    label = "Butterfly"
  })
  font = lovr.graphics.newFont(24)
  table.insert(drawables, letters.TextField:new{
    position = lovr.math.newVec3(-3, 5, -7),
    font = font
  })

  
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
  font:setPixelDensity(32)
  lovr.graphics.setCullingEnabled(true)
  lovr.graphics.setDepthTest('lequal', true)
  lovr.graphics.clear()
  lovr.graphics.setShader()

  lovr.graphics.setFont(font)
  letters.draw()
  for i, thing in ipairs(drawables) do
    thing:draw()
  end
end
