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
  size = lovr.math.newVec3(0.2, 0.2, 0.1),
  onPressed = function() end,
  label = "Untitled",
  fraction = 0.0
}
-- todo: reuse this button for the HoverKeyboard
function Button:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.collider = world:newBoxCollider(o.position.x, o.position.y, o.position.z, o.size.x, o.size.y, o.size.z)
    o.collider:setUserData(o)
    return o
end
function Button:draw()
  lovr.graphics.setColor(0.3, 0.3, 0.4)
  lovr.graphics.box('fill', self.position, self.size)
  lovr.graphics.print(self.label, self.position + lovr.math.vec3(0,0.2,0), 0.07)
  lovr.graphics.setColor(0.5, 0.5, self.highlighted and 0.7 or 0.6)
  lovr.graphics.box('fill', self.position + lovr.math.vec3(0,0,(1.0-self.fraction) * 0.1 + 0.01), self.size - lovr.math.vec3(0.05,0.05,0))
end
function Button:highlight()
  self.highlighted = true
end
function Button:dehighlight()
  self.highlighted = false
end
function Button:select()
  self.selected = true
  self.fraction = 1.0
end
function Button:deselect()
  self.selected = false
  self.fraction = 0.0
end
function Button:actuate()
  self.onPressed()
end




--- hands
local Hand = {
  device = "hand/left"
}
function Hand:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
function Hand:draw()
  lovr.graphics.setColor(0.3, 0.3, 0.3)
  lovr.graphics.box('fill', self.from, .03, .04, .06, lovr.headset.getOrientation(self.device))
  lovr.graphics.line(self.from, self.to)
end
function Hand:update()
  local handPos = lovr.math.newVec3(lovr.headset.getPosition(self.device))
  if handPos.x ~= handPos.x then
    return
  end
  local straightAhead = lovr.math.vec3(0, 0, -1)
  local handRotation = lovr.math.mat4():rotate(lovr.headset.getOrientation(self.device))
  local pointedDirection = handRotation:mul(straightAhead)
  local distantPoint = lovr.math.newVec3(pointedDirection):mul(10):add(handPos)
  self.from = handPos
  self.to = distantPoint

  local highlightedItem = nil
  world:raycast(self.from.x, self.from.y, self.from.z, self.to.x, self.to.y, self.to.z, function(shape)
    highlightedItem = shape:getCollider():getUserData()
  end)
  if self.highlightedItem ~= highlightedItem then 
    lovr.headset.vibrate(self.device, 0.5, 0.05) 
    if self.highlightedItem then self.highlightedItem:dehighlight() end
    if highlightedItem then highlightedItem:highlight() end
    self.highlightedItem = highlightedItem
  end

  if lovr.headset.isDown(self.device, "trigger") and self.highlightedItem ~= nil and self.selectedItem == nil then
    self.highlightedItem:select()
    self.selectedItem = self.highlightedItem
    lovr.headset.vibrate(hand, 0.7, 0.2, 100)
  end
  if not lovr.headset.isDown(self.device, "trigger") and self.selectedItem ~= nil then
    if self.highlightedItem == self.selectedItem then
      lovr.headset.vibrate(hand, 0.7, 0.2, 100)
      self.selectedItem:actuate()
    end
    self.selectedItem:deselect()
    self.selectedItem = nil
  end
end

local hands = {}

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
    label = "Hover keyboard"
  })
  table.insert(drawables, Button:new{
    position = lovr.math.newVec3(0.3, 1.2, -1),
    onPressed = function() 
      table.insert(drawables, letters.ButterflyKeyboard:new())
    end,
    label = "Butterfly keyboard"
  })

  for i, device in ipairs(lovr.headset.getHands()) do
    local hand = Hand:new{device=device}
    table.insert(drawables, hand)
    table.insert(hands, hand)
  end
end

function lovr.update()
  for i, hand in ipairs(hands) do
    hand:update()
  end
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
