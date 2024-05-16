local entities = {}

function newEntities(pTexture, pX, pY)
    local entity = newSprite(pTexture, pX, pY)

    entity.update = function()
    end

    entity.takeDamage = function(amount)
        entity.life.current = entity.life.current - amount
        if entity.life.current <= 0 then
            entity.isFree = true
            if entity.turret ~= nil then
                entity.turret.isFree = true
            end
        end
    end

    entity.fire = function()
    end

    entity.patrol = function()
    end

    entity.drawLife = function()
        love.graphics.rectangle(
            "fill",
            entity.x - entity.lifeBarre.width / 2,
            entity.y + 20,
            entity.lifeBarre.width,
            entity.lifeBarre.height
        )
        love.graphics.setColor(0, 1, 0)

        local ratio = entity.life.current / entity.life.max
        love.graphics.rectangle(
            "fill",
            entity.x - entity.lifeBarre.width / 2,
            entity.y + 20,
            entity.lifeBarre.width * ratio,
            entity.lifeBarre.height
        )
        love.graphics.setColor(1, 1, 1)
    end

    entity.onDetect = function(pPLayer)
        entity.target = pPLayer
        entity.targetDetected = true
    end

    entity.drawBoxes = function()
        entity.drawLife()
        love.graphics.circle("line", entity.x, entity.y, entity.radius)
        love.graphics.circle("line", entity.x, entity.y, entity.detectionRadius)
    end

    return entity
end
