local scene = {}

require "sprites/enemy/spawner"
require "sprites/objectives/objective"
require "sprites/wall"
require "sprites/enemy/turret"
require "sprites/collectibles/ammo"
require "sprites/collectibles/life"

local tank = require "sprites/vehicules/tank"
local enemies = {}
local objectives = {}
local spawners = {}
local paused = false
scene.currentDifficulty = 0
scene.load = function(pDifficulty)
    scene.currentDifficulty = pDifficulty
    enemies = {}
    objectives = {}

    newAmmo(50, 50)
    newHeal(100, 100)
    newEnemy(400, 400)
    newTurret(700, 60)
    newBuilding(500, 500)
    newSpawner(false, "enemy", pDifficulty, 30, 30)
    newSpawner(false, "enemy", pDifficulty, screen.width - 30, 30)
    newSpawner(false, "enemy", pDifficulty, screen.width - 30, screen.height - 30)
    newSpawner(false, "enemy", pDifficulty, 30, screen.height - 30)
    newSpawner(true, "collectible")

    initSprites()

    -- qui doit contenir ces listes ?
    enemies = getSprite("enemy")
    objectives = getSprite("objective")
    spawners = getSprite("spawner")
end

scene.unload = function()
    -- cleansprite
    unloadSprites()
end

scene.update = function(dt)
    if not paused then
        if tank.life.current <= 0 then
            changeScene("over", scene.currentDifficulty)
        end

        updateSprites(dt)
        checkDetection(dt)
    end
end

scene.draw = function()
    love.graphics.print("Current difficulty : " .. scene.currentDifficulty, 100, 100)
    drawSprites()

    cleanSprites()
    if paused then
        love.graphics.print("game is paused", screen.width * 0.5, screen.height * 0.5, 0, 2, 2)
    end
end

scene.mousePressed = function(x, y, btn)
    if btn == 1 and tank.mode ~= FIRE then
        tank.setTargetDistance(x, y)
    elseif btn == 1 and tank.mode == FIRE then
        tank.fire()
    end
end

scene.keyPressed = function(key)
    if key == "escape" then
        changeScene("menu")
    elseif key == "f" then
        --end turn
        tank.changeFightMode()
    elseif key == "space" then
        paused = not paused
    end
end

function checkDetection(dt)
    for i = 1, #enemies do
        local currentEnemy = enemies[i]
        local distance = checkDistances(currentEnemy.x, tank.x, currentEnemy.y, tank.y)
        local detected = distance < currentEnemy.detectionRadius
        if detected and currentEnemy.onDetect ~= nil then
            currentEnemy.onDetect(tank)
            changeGameMode()
        end
    end

    for i = 1, #objectives do
        local currentObjective = objectives[i]
        local distance = checkDistances(currentObjective.x, tank.x, currentObjective.y, tank.y)
        local detected = distance < currentObjective.captureRadius
        if detected and currentObjective.onDetect ~= nil then
            -- difficulty = f(wave)
            -- activate spawner
            currentObjective.onDetect(dt, tank, scene.currentDifficulty)
            changeGameMode()
            for k, v in pairs(spawners) do
                v.activated = true
            end
            -- degueu mais pour le moment je ne vois pas
            -- comment faire autrement
            enemies = getSprite("enemy")
            for _, v in pairs(enemies) do
                v.onDetect(tank)
            end
        end
    end
end

function changeGameMode()
    --no detected
    if tank.mode == FREE then
        tank.mode = MOVE
    end
end

function checkNoMoreEnemies()
    for k, v in pairs(enemies) do
        if v.isFree == false then
            return false
        end
    end
    return true
end

return scene
