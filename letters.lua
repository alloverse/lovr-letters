local mod = (...):match("(.-)[^%.]+$") 

letters = {}
letters.Node = require(mod .. 'node')
letters.HoverKeyboard = require(mod .. 'hoverkeyboard')
letters.Button = require(mod .. 'button')
letters.TextField = require(mod .. 'textfield')
letters.Hand = require(mod .. "hand")



local lovrHeadset = {}
local mt = {
  -- just removes 'self' from calls so we can use : index on letters.headset,
  -- so it can be overridden with a class-style headset.
  __index = function(t, key)
    return function(...)
      local args = {...}
      table.remove(args, 1)
      return lovr.headset[key](unpack(args))
    end
  end
}
setmetatable(lovrHeadset, mt)


-- global state for the module
letters.hands = {}
letters.headset = lovrHeadset
letters.world = lovr.physics.newWorld()
letters.root = letters.Node:new{}

-- Set this from your code to make that kind of keyboard
-- appear automatically when you focus a text field
letters.defaultKeyboard = letters.HoverKeyboard

-- The keyboard currently being displayed automatically.
-- Don't touch this, it's private.
letters.currentKeyboard = nil

function letters.load()
  for i, device in ipairs({"hand/left", "hand/right"}) do
    local hand = letters.Hand:new{device=device}
    table.insert(letters.hands, hand)
  end
end

function letters.update()
  for i, hand in ipairs(letters.hands) do
    hand:update()
  end
  letters.root:update()
end

function letters.draw()
  letters.root:transformAndDraw()
  --letters.debugDraw()
end

function letters.debugDraw()
  lovr.graphics.setShader()
  lovr.graphics.setColor(0.5, 0.5, 1.0, 1)
  for _, collider in ipairs(letters.world:getColliders()) do
    local x, y, z, a, ax, ay, az = collider:getPose()
    local boxShape = collider:getShapes()[1]
    local w, h, d = boxShape:getDimensions()
    lovr.graphics.box("line", x, y, z, w, h, d, a, ax, ay, az)
  end
  lovr.graphics.setColor(0.5, 1.0, 0.5, 1)
  debugDrawNode(letters.root)
end

function debugDrawNode(node)
  local x, y, z, sx, sy, sz, a, ax, ay, az = node:transformInWorld():unpack()
  lovr.graphics.sphere(x, y, z, 0.1, a, ax, ay, az)
  for i, n in ipairs(node.children) do
    debugDrawNode(n)
  end
end

function letters.displayKeyboard()
  if not letters.currentKeyboard and letters.defaultKeyboard then
    -- todo: maybe save keyboard between invocations to save state
    letters.currentKeyboard = letters.defaultKeyboard:new()
    letters.root:addChild(letters.currentKeyboard)
  end
end

function letters.hideKeyboard()
  if letters.currentKeyboard then
    letters.currentKeyboard:removeFromParent()
  end
  letters.currentKeyboard = nil
end

return letters
