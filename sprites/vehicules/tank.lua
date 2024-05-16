require "sprites/ammo/bullet"

local imgBody = love.graphics.newImage("images/tank.png")
local imgTurret = love.graphics.newImage("images/turret.png")
local imgAmmo = love.graphics.newImage("images/ammo.png")

local tank = newSprite(imgBody)

tank.label = "tank"

tank.offset.x = imgBody:getWidth() * 0.5
tank.offset.y = imgBody:getHeight() * 0.5

tank.speed = 200
tank.reloadSpeed = 100
tank.rotationSpeed = 3
tank.ammo = 10

tank.life = {}
tank.life.max = 100
tank.life.current = 100

tank.lifeBarre = {}
tank.lifeBarre.x = tank.x + tank.offset.x
tank.lifeBarre.y = tank.y + tank.offset.y
tank.lifeBarre.width = 50
tank.lifeBarre.height = 5

tank.radius = 30
tank.radiusMovement = 200
tank.targetDistance = 0
tank.mode = FREE
tank.attackMalus = 0.05

tank.turret = newSprite(imgTurret)
tank.turret.label = "turret"
tank.turret.offset.x = imgBody:getWidth() * 0.5
tank.turret.offset.y = imgBody:getHeight() * 0.5

tank.init = function()
    tank.x = 200
    tank.y = 200
    tank.angle = 0
    tank.turret.turretAngle = 0
    tank.ammo = 10
    tank.movementLeft = tank.radiusMovement
    tank.targetDistance = 0

    tank.turret = newSprite(imgTurret)
    tank.turret.label = "turret"
    tank.turret.offset.x = imgBody:getWidth() * 0.5
    tank.turret.offset.y = imgBody:getHeight() * 0.5

    tank.life.current = 100

    tank.mode = FREE
end

tank.update = function(dt)
    tank.turret.x = tank.x
    tank.turret.y = tank.y

    --increment de moved distance
    --if tank.targetDistance < tank.movementLeft then
    if tank.targetDistance > 0 and tank.movementLeft > tank.radius then
        tank.move(dt)
    end
    tank.reloadMovement(dt)
    tank.aim(love.mouse.getPosition())
end

tank.move = function(dt)
    if tank.mode == FREE then
        --pas de limite de déplacement
        tank.x = tank.x + math.cos(tank.angle) * math.min(tank.speed * dt, tank.targetDistance)
        tank.y = tank.y + math.sin(tank.angle) * math.min(tank.speed * dt, tank.targetDistance)

        tank.targetDistance = tank.targetDistance - tank.speed * dt
    elseif tank.mode == MOVE then
        -- pour eviter les cas ou speed > targetDistance
        tank.x = tank.x + math.cos(tank.angle) * math.min(tank.speed * dt, tank.targetDistance)
        tank.y = tank.y + math.sin(tank.angle) * math.min(tank.speed * dt, tank.targetDistance)

        tank.movementLeft = tank.movementLeft - tank.speed * dt
        tank.targetDistance = tank.targetDistance - tank.speed * dt
    end
end
tank.reloadMovement = function(dt)
    if tank.movementLeft <= tank.radiusMovement then
        tank.movementLeft = tank.movementLeft + tank.reloadSpeed * dt
    end
end

tank.drawAmmo = function()
    local yOffset = 20
    for i = 1, tank.ammo do
        love.graphics.draw(imgAmmo, 10, yOffset)
        yOffset = yOffset + 20
    end
end

tank.drawBoxes = function()
    tank.drawLife()
    tank.drawAmmo()
    if tank.mode == FREE then
        --pas de limite de déplacement
    elseif tank.mode == MOVE then
        love.graphics.circle("line", tank.x, tank.y, tank.radius)

        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle("line", tank.x, tank.y, tank.radiusMovement)

        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.circle("line", tank.x, tank.y, tank.movementLeft)

        love.graphics.setColor(1, 1, 1, 1)
    end
end
-- plutot voir avec les coordonnees cible
-- rejoindre tank sur coordonnee target
tank.setTargetDistance = function(pX, pY)
    local targetDistance = checkDistances(tank.x, pX, tank.y, pY)
    --check inside circle
    if targetDistance < tank.movementLeft or tank.mode == FREE then
        tank.targetDistance = targetDistance
        tank.angle = math.atan2(pY - tank.y, pX - tank.x)
    end
end

tank.aim = function(pX, pY)
    tank.turret.angle = math.atan2(pY - tank.y, pX - tank.x)
end

tank.changeFightMode = function()
    -- etat shield pour se protéger des coup?
    if tank.mode == MOVE then
        tank.mode = FIRE
    elseif tank.mode == FIRE then
        tank.mode = MOVE
    end
end

--todo faire fonction generique
tank.drawLife = function()
    love.graphics.rectangle(
        "fill",
        tank.x - tank.lifeBarre.width / 2,
        tank.y + 20,
        tank.lifeBarre.width,
        tank.lifeBarre.height
    )
    love.graphics.setColor(0, 1, 0)

    local ratio = tank.life.current / tank.life.max
    love.graphics.rectangle(
        "fill",
        tank.x - tank.lifeBarre.width / 2,
        tank.y + 20,
        tank.lifeBarre.width * ratio,
        tank.lifeBarre.height
    )
    love.graphics.setColor(1, 1, 1)
end

tank.takeDamage = function(amount)
    tank.life.current = tank.life.current - amount
    -- if tank.life.current <= 0 then
    --     changeScene("over")
    -- end
end

tank.fire = function()
    local barrelSize = 25
    local firePoint = {}

    -- x = r * cos(angle)
    -- ==> r = distance entre centre du tank + taille du barrel
    firePoint.x = math.cos(tank.turret.angle) * barrelSize + tank.x
    firePoint.y = math.sin(tank.turret.angle) * barrelSize + tank.y

    if tank.ammo <= 0 then
        return
    end

    --remplissage de la liste dans la lib bullet
    -- permet + de lisibilite

    newBullet(firePoint.x, firePoint.y, tank.label, tank.turret.angle)
    --tank.ammo = tank.ammo + 1
    tank.ammo = tank.ammo - 1
end

tank.addAmmo = function(pAmmoCount)
    tank.ammo = tank.ammo + pAmmoCount
end
tank.addLife = function(pLifeCount)
    tank.life.current = tank.life.current + pLifeCount
end

return tank
