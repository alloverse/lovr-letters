local Hand = {
  device = "hand/left"
}
setmetatable(Hand, {__index=letters.Node})
local Hand_mt = {
  __index = Hand
}

function Hand:new(o)
  o = letters.Node.new(self, o)
  setmetatable(o, Hand_mt)

  o.model = letters.headset.newModel and letters.headset:newModel(o.device)
  o.from = lovr.math.newVec3()
  o.to = lovr.math.newVec3()

  o.highlightedNodes = {}
  o.selectedNode = nil
  o.grabbedNode = nil
  return o
end
function Hand:draw()
  if not letters.headset:isTracked(self.device) then return end
  if self.model then
    self.model:draw(mat4(letters.headset.getPose(self.device)))
  else
    lovr.graphics.setColor(0.5, 0.7, 0.5)
    lovr.graphics.box('fill', self.from, .03, .04, .06, letters.headset:getOrientation(self.device))
  end
  if self.from and self.to then
    lovr.graphics.line(self.from, self.to)
  end
end
function Hand:update()
  local handPos = lovr.math.vec3(letters.headset:getPosition(self.device))
  if handPos.x ~= handPos.x then
    return
  end
  local straightAhead = lovr.math.vec3(0, 0, -1)
  local handRotation = lovr.math.mat4():rotate(letters.headset:getOrientation(self.device))
  local pointedDirection = handRotation:mul(straightAhead)
  local distantPoint = lovr.math.newVec3(pointedDirection):mul(10):add(handPos)
  self.from:set(handPos)
  self.to:set(distantPoint)

  local newlyHighlightedNodes = {}
  letters.world:raycast(self.from.x, self.from.y, self.from.z, self.to.x, self.to.y, self.to.z, function(shape, hx, hy, hz)
    local newPoint = lovr.math.newVec3(hx, hy, hz)
    table.insert(newlyHighlightedNodes, {
      distance= (newPoint - self.from):length(),
      node = shape:getCollider():getUserData()
    })
  end)
  table.sort(newlyHighlightedNodes, function(x, y) return x.distance < y.distance end)
  

  -- unhighlight no longer highlighted nodes
  for _, oldNode in ipairs(self.highlightedNodes) do
    local existed = false
    for _, newNode in ipairs(newlyHighlightedNodes) do
      if newNode.node == oldNode.node then existed = true end
    end
    if existed == false then
      if oldNode.node.dehighlight then
        oldNode.node:dehighlight()
      end
    end
  end
  -- highlight fresly highlighted nodes
  for _, newNode in ipairs(newlyHighlightedNodes) do
    local existed = false
    for _, oldNode in ipairs(self.highlightedNodes) do
      if newNode.node == oldNode.node then existed = true end
    end
    if existed == false then
      if newNode.node.highlight then
        newNode.node:highlight(self)
      end
    end
  end
  self.highlightedNodes = newlyHighlightedNodes

  -- select items with trigger
  if letters.headset:isDown(self.device, "trigger") and self.selectedNode == nil then
    for _, node in ipairs(self.highlightedNodes) do
      if node.node.select then
        node.node:select(self)
        self.selectedNode = node.node
        letters.headset:vibrate(self.device, 0.6, 0.02, 100)
        break
      end
    end
  end

  -- deselect items on released trigger, actuating on buttons and other clickables
  if not letters.headset:isDown(self.device, "trigger") and self.selectedNode ~= nil then
    local found = false
    for _, node in ipairs(self.highlightedNodes) do
      if node.node == self.selectedNode then found = true end
    end
    if found then
      if self.selectedNode.actuate then
        letters.headset:vibrate(self.device, 0.7, 0.03, 400)
        self.selectedNode:actuate(self) 
      end
    end
    if self.selectedNode.deselect then self.selectedNode:deselect(self) end
    self.selectedNode = nil
  end

  -- grab items with grip
  if letters.headset:isDown(self.device, "grip") and self.grabbedNode == nil then
    for _, node in ipairs(self.highlightedNodes) do
      if node.node.grab and node.node:grab(self) then
        self.grabbedNode = node.node
        letters.headset:vibrate(self.device, 0.6, 0.02, 100)
        break
      end
    end
  end

  -- deselect items on released trigger, actuating on buttons and other clickables
  if not letters.headset:isDown(self.device, "grip") and self.grabbedNode ~= nil then
    if self.grabbedNode.ungrab then self.grabbedNode:ungrab(self) end
    self.grabbedNode = nil
  end
end

return Hand
