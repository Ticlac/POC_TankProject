local imgBullet = love.graphics.newImage("images/bullet.png")
local imgOffset = {x = imgBullet:getWidth() * 0.5, y = imgBullet:getHeight() * 0.5}

function newBullet(pX, pY, pOrigin, pAngle)
    local b = newSprite(imgBullet, pX, pY, pAngle)
    b.label = "bullet"
    b.origin = pOrigin or nil
    b.speed = 600
    b.vX = math.cos(pAngle) * b.speed
    b.vY = math.sin(pAngle) * b.speed
    b.radius = 8
    b.damage = 10
    b.offset.x = imgOffset.x
    b.offset.y = imgOffset.y
    b.scale.x = 0.5
    b.scale.y = 0.5

    b.update = function(dt)
        b.x = b.x + b.vX * dt
        b.y = b.y + b.vY * dt

        b.isOutOfScreen()
    end

    b.isOutOfScreen = function()
        b.isFree = b.x < 0 or b.x > screen.width or b.y < 0 or b.y > screen.height
    end

    b.onCollide = function(otherCollider)
        if
            b.origin ~= otherCollider.label and otherCollider.label ~= "objective" and otherCollider.label ~= "ammo" and
                otherCollider.label ~= "heal"
         then
            b.isFree = true
            if otherCollider.takeDamage ~= nil then
                otherCollider.takeDamage(b.damage)
            end
        end
    end
end
