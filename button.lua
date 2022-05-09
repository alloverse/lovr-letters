local Button = {
  position = lovr.math.newVec3(0,0,0),
  size = lovr.math.newVec3(0.4, 0.2, 0.1),
  onPressed = function() end, -- button is pressed
  onReleased = function() end, -- button is lifted
  onActuate = function() end, -- button is lifted with cursor still inside
  label = "Untitled",
  fraction = 0.0,
  isToggle = false,
  font = lovr.graphics.newFont('Inter.ttf', 32)
}
setmetatable(Button, {__index=letters.Node})
local Button_mt = {
  __index = Button
}

function Button:new(o)
  o = letters.Node.new(self, o)
  setmetatable(o, Button_mt)
  return o
end

function Button:draw()
  local buttonPos = self.position + lovr.math.vec3(0,0,(1.1-self.fraction) * self.size.z)

  -- draw the base of the button
  lovr.graphics.setShader()
  lovr.graphics.setColor(0.3, 0.3, 0.4, 1)
  local x, y, z = self.position:unpack()
  local w, h, d = self.size:unpack()
  -- unpacks are deliberate to workaround bug in... .... luajit? lovr? lodr? I dunno
  lovr.graphics.box('fill', x, y, z, w, h, d)

  -- draw the actual key cap
  lovr.graphics.setColor(0.5, 0.5, self.highlighted and 0.7 or 0.6, 1)
  x, y, z = buttonPos:unpack()
  w, h, d = lovr.math.vec3(self.size.x*0.8, self.size.y*0.8 , self.size.z):unpack()
  lovr.graphics.box('fill', x, y, z, w, h, d)

  -- draw the text
  lovr.graphics.setShader()
  lovr.graphics.setFont(self.font)
  lovr.graphics.setColor(0.9, 0.9, 0.9, 1)
  x, y, z = (buttonPos + lovr.math.vec3(0,0,self.size.z/2 + 0.001)):unpack()
  lovr.graphics.print(self.label, x, y, z, 0.04)
end

function Button:highlight()
  self.highlighted = true
end
function Button:dehighlight()
  self.highlighted = false
end
function Button:select()
  if self.isToggle == false then
    self.selected = true
    self.fraction = 1.0
    self.onPressed(self)
  end
end
function Button:deselect()
  if self.isToggle == false then
    self.selected = false
    self.onReleased(self)
  else
    self.selected = not self.selected
    if self.selected then
      self.onPressed(self)
    else
      self.onReleased(self)
    end
  end
  self.fraction = self.selected and 1.0 or 0.0
end
function Button:setSelected(newValue)
  self.selected = newValue
  self.fraction = self.selected and 1.0 or 0.0
end
function Button:actuate()
  self.onActuate(self)
end

return Button
