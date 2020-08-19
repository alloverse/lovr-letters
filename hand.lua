local Hand = {
  device = "hand/left"
}

function Hand:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.model = lovr.headset.newModel(o.device)
  return o
end
function Hand:draw()
  if not lovr.headset.isTracked(self.device) then return end
  if self.model then
    model:draw(mat4(lovr.headset.getPose(hand)))
  else
    lovr.graphics.setColor(0.5, 0.7, 0.5)
    lovr.graphics.box('fill', self.from, .03, .04, .06, lovr.headset.getOrientation(self.device))
  end
  if self.from and self.to then
    lovr.graphics.line(self.from, self.to)
  end
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
  Hand.letters.world:raycast(self.from.x, self.from.y, self.from.z, self.to.x, self.to.y, self.to.z, function(shape, hx, hy, hz)
    highlightedItem = shape:getCollider():getUserData()
    self.to = lovr.math.newVec3(hx, hy, hz)
  end)
  if self.highlightedItem ~= highlightedItem then 
    lovr.headset.vibrate(self.device, 0.5, 0.05) 
    if self.highlightedItem and self.highlightedItem.dehighlight then self.highlightedItem:dehighlight() end
    if highlightedItem and highlightedItem.highlight then highlightedItem:highlight() end
    self.highlightedItem = highlightedItem
  end

  if lovr.headset.isDown(self.device, "trigger") and self.highlightedItem ~= nil and self.selectedItem == nil then
    if self.highlightedItem.select then self.highlightedItem:select() end
    self.selectedItem = self.highlightedItem
    lovr.headset.vibrate(hand, 0.7, 0.2, 100)
  end
  if not lovr.headset.isDown(self.device, "trigger") and self.selectedItem ~= nil then
    if self.highlightedItem == self.selectedItem then
      lovr.headset.vibrate(hand, 0.7, 0.2, 100)
      if self.selectedItem.actuate then self.selectedItem:actuate() end
    end
    if self.selectedItem.deselect then self.selectedItem:deselect() end
    self.selectedItem = nil
  end
end

return Hand