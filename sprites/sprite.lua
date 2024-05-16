local sprites = {}

function newSprite(pTexture, pX, pY, pAngle)
    local sprite = {}

    sprite.label = "sprite"

    sprite.texture = pTexture
    sprite.x = pX or 0
    sprite.y = pY or 0
    sprite.angle = pAngle or 0
    sprite.isFree = false
    sprite.scale = {x = 1, y = 1}
    sprite.offset = {x = 0, y = 0}
    sprite.radius = 10

    sprite.init = function()
    end

    sprite.update = function()
    end

    sprite.draw = function()
        -- verification que le sprite a une texture
        if sprite.texture ~= nil then
            love.graphics.draw(
                sprite.texture,
                sprite.x,
                sprite.y,
                sprite.angle,
                sprite.scale.x,
                sprite.scale.y,
                sprite.offset.x,
                sprite.offset.y
            )
        end

        if sprite.drawBoxes ~= nil then
            sprite.drawBoxes()
        end
    end

    sprite.onCollide = function(otherCollider)
    end

    table.insert(sprites, sprite)

    return sprite
end

function initSprites()
    for k, sprite in pairs(sprites) do
        sprite.init()
    end
end
function updateSprites(dt)
    for k, sprite in pairs(sprites) do
        sprite.update(dt)
    end

    checkColisions()
    cleanSprites()
end

function drawSprites()
    for i = 1, #sprites do
        sprites[i].draw()
    end
end

function cleanSprites()
    for i = #sprites, 1, -1 do
        if sprites[i].isFree then
            table.remove(sprites, i)
        end
    end
end

function unloadSprites()
    for i = #sprites, 1, -1 do
        if sprites[i].label ~= "tank" then
            table.remove(sprites, i)
        end
    end
end

function checkColisions()
    for i = 1, #sprites do
        local spriteA = sprites[i]
        for j = 1, #sprites do
            local spriteB = sprites[j]

            if spriteA ~= spriteB then
                local distance = checkDistances(spriteA.x, spriteB.x, spriteA.y, spriteB.y)
                local collided = distance < spriteA.radius + spriteB.radius
                if collided and spriteA.onCollide ~= nil then
                    spriteA.onCollide(spriteB)
                end
            end
        end
    end
end

function getSprite(pLabel)
    local result = {}
    for i = #sprites, 1, -1 do
        if sprites[i].label == pLabel then
            table.insert(result, sprites[i])
        end
    end
    return result
end
