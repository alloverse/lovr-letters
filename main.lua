-- Test bed Lovr app
local letters = require('letters')

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

-- buttons to do things
local Button = {
  position = lovr.math.newVec3(0,0,0),
  onPressed = function() end,
  label = "Untitled"
}
-- todo: reuse this button for the HoverKeyboard
function Button:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    -- todo: add collider for button
    return o
end
function Button:draw()
  lovr.graphics.setColor(0.3, 0.3, 0.4)
  lovr.graphics.box('fill', self.position, .2, .2, .1)
  lovr.graphics.print(self.label, self.position + lovr.math.vec3(0,0.2,0), 0.07)
  lovr.graphics.setColor(0.5, 0.5, 0.6)
  lovr.graphics.box('fill', self.position + lovr.math.vec3(0,0,0.1), .15, .15, .1)
end


--- hands
local function drawHand(hand)
  local handPos = lovr.math.newVec3(lovr.headset.getPosition(hand))
  lovr.graphics.box('fill', handPos, .03, .04, .06, lovr.headset.getOrientation(hand))
end

-- global
function lovr.load()
  lovr.graphics.setBackgroundColor(0.95, 0.98, 0.98)
  lovr.headset.setClipDistance(0.1, 3000)
  
  lovr.handlers["keypressed"] = typehandler
  table.insert(drawables, Button:new{
    position = lovr.math.newVec3(-0.3, 1.2, -1),
    onPressed = function() 
      table.insert(drawables, letters.HoverKeyboard:new())
    end,
    label = "Hover keyboard"
  })
  table.insert(drawables, Button:new{
    position = lovr.math.newVec3(0.3, 1.2, -1),
    onPressed = function() 
      table.insert(drawables, letters.ButterflyKeyboard:new())
    end,
    label = "Butterfly keyboard"
  })
end

function lovr.update()
  -- todo: cast a ray from hand to highlight/press button
end

function lovr.draw()
  lovr.graphics.setCullingEnabled(true)
  lovr.graphics.setDepthTest('lequal', true)

  lovr.graphics.clear()

  lovr.graphics.setShader()
  lovr.graphics.setColor(0, 0, 0)
  lovr.graphics.print(current_text, 0, 0, -10, 1)
  lovr.graphics.setShader()

  lovr.graphics.setColor(0.3, 0.3, 0.3)
  for i, hand in ipairs(lovr.headset.getHands()) do
    drawHand(hand)
  end

  for i, thing in ipairs(drawables) do
    thing:draw()
  end
end
