
-- A basic scenegraph node
local Node = {
  selected = false,
  parent = nil,
  heldBy = nil,
}
local Node_mt = {
  __index = Node
}

function Node:new(o)
  o = o or {}
  setmetatable(o, Node_mt)
  o.transform = o.transform or lovr.math.newMat4()
  o.size = o.size or lovr.math.newVec3(0.01, 0.01, 0.01)
  o.offset = lovr.math.newMat4()
  o.collider = letters.world:newBoxCollider(-o.size.x/2, -o.size.y/2, -o.size.z/2, o.size.x, o.size.y, o.size.z)
  o.collider:setUserData(o)
  o.children = {}
  return o
end

function Node:addChild(c)
  table.insert(self.children, c)
  c.parent = self
  return c
end

function Node:removeFromParent()
  self.collider:destroy()

  for i, c in ipairs(self.parent.children) do
    if c == self then
      table.remove(self.parent.children, i)
      self.parent = nil
      return
    end
  end
end

function Node:transformInWorld()
  if self.parent then
    return lovr.math.mat4(self.parent:transformInWorld()):mul(self.transform)
  else
    return lovr.math.mat4(self.transform)
  end
end

function Node.convert(m, a, b)
  local worldFromA = a and a:transformInWorld() or lovr.math.mat4()
  local worldFromB = b and b:transformInWorld() or lovr.math.mat4()
  local bFromWorld = worldFromB:invert()
  local bFromA = bFromWorld * worldFromA
  return bFromA * m
end

function Node:transformAndDraw()
  lovr.graphics.push()
  lovr.graphics.transform(self.transform)
  
  self:draw()

  for _, child in ipairs(self.children) do
    child:transformAndDraw()
  end
  lovr.graphics.pop()
end

function Node:draw()

end

function Node:grab(hand)
  if self.canBeGrabbed then
    print("grab2")
    self:ungrab(self.heldBy) -- if held by another hand
    self.selected = true
    self.heldBy = hand
    local handTransform = lovr.math.mat4(lovr.headset.getPose(hand.device))
    self.offset:set(handTransform:invert()):mul(self:transformInWorld())
    return true
  end
  return false
end
function Node:ungrab(hand)
  if self.heldBy == hand then
    self.selected = false
    self.heldBy = nil
  end
end

function Node:update()
  if self.heldBy then
    stickX, stickY = letters.headset:getAxis(self.heldBy.device, "thumbstick")

    if math.abs(stickY) > 0.05 then
      local translation = lovr.math.mat4():translate(0,0,-stickY*0.1)
      local newOffset = translation * self.offset
      if newOffset:mul(lovr.math.vec3()).z < 0 then
        self.offset:set(newOffset)
      end
    end
    local handTransform = lovr.math.mat4(letters.headset:getPose(self.heldBy.device))
    local newInWorld = handTransform:mul(self.offset)
    local newInLocal = Node.convert(newInWorld, nil, self.parent)
    self.transform:set(newInLocal)
  end
  local x, y, z, w, h, d, a, ax, ay, az = self:transformInWorld():unpack()
  w, h, d = self.size:unpack()
  self.collider:setPose(x, y, z, a, ax, ay, az)

  for _, child in ipairs(self.children) do
    child:update()
  end
end

return Node
