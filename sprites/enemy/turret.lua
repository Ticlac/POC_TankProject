require "sprites/enemy/entities"

local imgTurret = love.graphics.newImage("images/staticTurret.png")

function newTurret(pX, pY)
    local turret = newEntities(imgTurret, pX, pY)

    turret.label = "enemy"
    turret.offset.x = imgTurret:getWidth() * 0.5
    turret.offset.y = imgTurret:getHeight() * 0.5

    turret.target = nil
    turret.detectionRadius = 200
    turret.targetDetected = false
    turret.rotationSpeed = 100

    turret.radius = 30
    turret.isFree = false

    turret.life = {}
    turret.life.max = 50
    turret.life.current = 50

    turret.lifeBarre = {}
    turret.lifeBarre.x = turret.x + turret.offset.x
    turret.lifeBarre.y = turret.y + turret.offset.y
    turret.lifeBarre.width = 50
    turret.lifeBarre.height = 5
    turret.fireTimer = 0

    turret.update = function(dt)
        if turret.target ~= nil and turret.targetDetected then
            turret.targetPlayer(dt)
        end
        turret.patrol(dt)
    end

    turret.patrol = function(dt)
        turret.angle = turret.angle + dt
    end

    turret.fire = function()
        --pas besoin de checker la presence : deja dans le if
        local firePoint = {}
        local barrelSize = 30

        firePoint.x = math.cos(turret.angle) * barrelSize + turret.x
        firePoint.y = math.sin(turret.angle) * barrelSize + turret.y

        newBullet(firePoint.x, firePoint.y, turret.label, turret.angle)
    end

    turret.targetPlayer = function(dt)
        turret.angle = math.atan2(turret.target.y - turret.y, turret.target.x - turret.x)

        if turret.fireTimer > 2 then
            turret.fire()
            turret.fireTimer = 0
        end
        turret.fireTimer = turret.fireTimer + dt
    end
end
