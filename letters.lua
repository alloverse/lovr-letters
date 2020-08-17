local Hand = require("hand")

local letters = {
  HoverKeyboard = require('hoverkeyboard'),
  hands = {},
  world = lovr.physics.newWorld()
}

function letters.load()
  for i, device in ipairs(lovr.headset.getHands()) do
    local hand = Hand:new{device=device,world=letters.world}
    table.insert(letters.hands, hand)
  end
end

function letters.update()
  for i, hand in ipairs(letters.hands) do
    hand:update()
  end
end

return letters
