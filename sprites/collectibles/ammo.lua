require "sprites/collectibles/collectible"

local ammoSprite = love.graphics.newImage("images/ammoCollectible.png")

function newAmmo(pX, pY)
    local ammo = newCollectible(ammoSprite, pX, pY)
    ammo.addCapacity = 5

    ammo.label = "ammo"
end
