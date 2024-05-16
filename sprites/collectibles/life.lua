require "sprites/collectibles/collectible"

local healSprite = love.graphics.newImage("images/heal.png")

function newHeal(pX, pY)
    local heal = newCollectible(healSprite, pX, pY)
    heal.addCapacity = 20

    heal.label = "heal"
end
