-- Test bed Lovr app
local letters = require('letters')


-- state
local font = lovr.graphics.newFont(24)

local app = {}

-- global
function lovr.load()
  letters.load()

  lovr.graphics.setBackgroundColor(0.95, 0.98, 0.98)

  local x = -0.3
  for name, keeb in pairs(letters.keyboards) do
    keeb.button = letters.root:addChild(letters.Button:new{
      transform = lovr.math.newMat4():translate(x, 2.0, -2),
      onPressed = function() 
        letters.defaultKeyboard = keeb
        if letters.currentKeyboard ~= nil then
          letters.hideKeyboard()
          letters.displayKeyboard()
        end
        for _, keeb2 in pairs(letters.keyboards) do
          if keeb2 ~= keeb then
            keeb2.button:setSelected(false)
          end
        end
      end,
      label = name,
      size = lovr.math.newVec3(0.4, 0.2, 0.1),
      isToggle = true
    })  
    x = x + 0.6
  end
  
  -- Sample UI to test keyboards
  local foodField = letters.root:addChild(letters.TextField:new{
    transform = lovr.math.newMat4():translate(-3, 4.3, -7),
    font = font,
    placeholder = "Favorite food"
  })
  local nameField = letters.root:addChild(letters.TextField:new{
    transform = lovr.math.newMat4():translate(-3, 5, -7),
    font = font,
    onReturn = function() foodField:makeKey(); return false; end,
    placeholder = "Name"
  })
  letters.keyboards.Indeck.button:deselect()
  nameField:makeKey()

  for i, hand in ipairs(letters.hands) do
    letters.root:addChild(hand)
  end

  
end

function lovr.update()
  letters.update()
end

function lovr.draw()
  lovr.graphics.setCullingEnabled(true)
  lovr.graphics.setDepthTest('lequal', true)
  lovr.graphics.clear()
  lovr.graphics.setShader()

  lovr.graphics.setFont(font)
  letters.draw()
end
