local Hand = {
  device = "hand/left"
}

function Hand:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.model = lovr.headset.newModel(o.device)
  o.from = lovr.math.newVec3()
  o.to = lovr.math.newVec3()
  return o
end
function Hand:draw()
  if not lovr.headset.isTracked(self.device) then return end
  if self.model then
    self.model:draw(mat4(lovr.headset.getPose(self.device)))
  else
    lovr.graphics.setColor(0.5, 0.7, 0.5)
    lovr.graphics.box('fill', self.from, .03, .04, .06, lovr.headset.getOrientation(self.device))
  end
  if self.from and self.to then
    lovr.graphics.line(self.from, self.to)
  end
end
function Hand:update()
  local handPos = lovr.math.vec3(lovr.headset.getPosition(self.device))
  if handPos.x ~= handPos.x then
    return
  end
  local straightAhead = lovr.math.vec3(0, 0, -1)
  local handRotation = lovr.math.mat4():rotate(lovr.headset.getOrientation(self.device))
  local pointedDirection = handRotation:mul(straightAhead)
  local distantPoint = lovr.math.newVec3(pointedDirection):mul(10):add(handPos)
  self.from:set(handPos)
  self.to:set(distantPoint)

  local highlightedItem = nil
  Hand.letters.world:raycast(self.from.x, self.from.y, self.from.z, self.to.x, self.to.y, self.to.z, function(shape, hx, hy, hz)
    highlightedItem = shape:getCollider():getUserData()
    local newPoint = lovr.math.newVec3(hx, hy, hz)
    if (self.to - self.from):length() > (newPoint - self.from):length() then
      self.to = newPoint
    end
  end)
  if self.highlightedItem ~= highlightedItem then 
    lovr.headset.vibrate(self.device, 0.5, 0.05) 
    if self.highlightedItem and self.highlightedItem.dehighlight then self.highlightedItem:dehighlight(self) end
    if highlightedItem and highlightedItem.highlight then highlightedItem:highlight(self) end
    self.highlightedItem = highlightedItem
  end

  if lovr.headset.isDown(self.device, "trigger") and self.highlightedItem ~= nil and self.selectedItem == nil then
    if self.highlightedItem.select then self.highlightedItem:select(self) end
    self.selectedItem = self.highlightedItem
    lovr.headset.vibrate(self.device, 0.7, 0.2, 100)
  end
  if not lovr.headset.isDown(self.device, "trigger") and self.selectedItem ~= nil then
    if self.highlightedItem == self.selectedItem then
      lovr.headset.vibrate(self.device, 0.7, 0.2, 100)
      if self.selectedItem.actuate then self.selectedItem:actuate(self) end
    end
    if self.selectedItem.deselect then self.selectedItem:deselect(self) end
    self.selectedItem = nil
  end
end

return Hand
