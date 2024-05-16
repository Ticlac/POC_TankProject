local collectibles = {}

function newCollectible(pTexture, pX, pY)
    local collectible = newSprite(pTexture, pX, pY)

    collectible.onCollide = function(otherCollider)
        if otherCollider.label == "tank" then
            collectible.isFree = true
            if collectible.label == "ammo" then
                otherCollider.addAmmo(collectible.addCapacity)
            elseif collectible.label == "heal" then
                otherCollider.addLife(collectible.addCapacity)
            end
        end
    end

    return collectible
end
