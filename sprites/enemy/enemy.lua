require "sprites/enemy/entities"

local imgBody = love.graphics.newImage("images/enemy.png")
local imgTurret = love.graphics.newImage("images/enemy_turret.png")

function newEnemy(pX, pY)
    local enemy = newEntities(imgBody)

    enemy.label = "enemy"
    enemy.x = pX
    enemy.y = pY
    enemy.vX = 0
    enemy.vY = 0
    enemy.speed = 50
    enemy.angle = 0
    enemy.offset.x = imgBody:getWidth() * 0.5
    enemy.offset.y = imgBody:getHeight() * 0.5

    enemy.target = nil
    enemy.detectionRadius = 200
    enemy.targetDetected = false

    enemy.turret = newSprite(imgTurret)
    enemy.turret.label = "turret"
    enemy.turret.x = pX
    enemy.turret.y = pY
    enemy.turret.isFree = false
    enemy.turret.offset.x = imgBody:getWidth() * 0.5
    enemy.turret.offset.y = imgBody:getHeight() * 0.5

    enemy.radius = 30
    enemy.isFree = false

    enemy.life = {}
    enemy.life.max = 50
    enemy.life.current = 50

    enemy.lifeBarre = {}
    enemy.lifeBarre.x = enemy.x + enemy.offset.x
    enemy.lifeBarre.y = enemy.y + enemy.offset.y
    enemy.lifeBarre.width = 50
    enemy.lifeBarre.height = 5

    enemy.fireTimer = 0
    enemy.patrolTimer = 0

    enemy.update = function(dt)
        enemy.turret.x = enemy.x
        enemy.turret.y = enemy.y
        enemy.turret.angle = enemy.angle

        enemy.move(dt)
    end

    enemy.move = function(dt)
        if enemy.target ~= nil and enemy.targetDetected then
            enemy.targetPlayer(dt)
        else
            enemy.patrol(dt)
        end
    end

    enemy.targetPlayer = function(dt)
        enemy.angle = math.atan2(enemy.target.y - enemy.y, enemy.target.x - enemy.x)

        enemy.vX = math.cos(enemy.angle) * enemy.speed
        enemy.vY = math.sin(enemy.angle) * enemy.speed

        enemy.x = enemy.x + enemy.vX * dt
        enemy.y = enemy.y + enemy.vY * dt

        if enemy.fireTimer > 2 then
            enemy.fire()
            enemy.fireTimer = 0
        end
        enemy.fireTimer = enemy.fireTimer + dt
    end

    enemy.patrol = function(dt)
        -- enemy.angle = 0
        enemy.vX = math.cos(enemy.angle) * enemy.speed
        enemy.vY = math.sin(enemy.angle) * enemy.speed

        enemy.x = enemy.x + enemy.vX * dt
        enemy.y = enemy.y + enemy.vY * dt

        if enemy.patrolTimer > 2 then
            enemy.changeAngle()
            enemy.patrolTimer = 0
        end
        enemy.patrolTimer = enemy.patrolTimer + dt
    end

    enemy.fire = function()
        --pas besoin de checker la presence : deja dans le if
        local firePoint = {}
        local barrelSize = 30

        firePoint.x = math.cos(enemy.turret.angle) * barrelSize + enemy.x
        firePoint.y = math.sin(enemy.turret.angle) * barrelSize + enemy.y

        newBullet(firePoint.x, firePoint.y, enemy.label, enemy.turret.angle)
    end

    enemy.changeAngle = function()
        if enemy.angle == 0 then
            enemy.angle = math.pi
        else
            enemy.angle = 0
        end
    end
end
