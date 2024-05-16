require "sprites/enemy/enemy"

local spawners = {}
function newSpawner(pRadomSpawnLocation, pSpawnerType, pSpawnCount, pX, pY)
    local sp = newSprite()

    sp.label = "spawner"
    sp.x = pX or love.math.random(30, screen.width - 30)
    sp.y = pY or love.math.random(30, screen.height - 30)
    sp.timer = 0
    sp.activated = false
    sp.randomSpawnLocation = pRadomSpawnLocation or false
    sp.spawnCount = pSpawnCount or 0
    sp.spawnerType = pSpawnerType

    sp.update = function(dt)
        if sp.activated == false then
            return
        end
        sp.timer = sp.timer + dt
        if sp.spawnerType == "enemy" then
            if sp.spawnCount >= 0 and sp.timer >= 10 then
                sp.randomEnemySpawn(sp.x, sp.y)
                if sp.randomSpawnLocation == true then
                    sp.resetSpawnLocation()
                end
                sp.timer = 0
                sp.spawnCount = sp.spawnCount - 1
            end
        elseif sp.spawnerType == "collectible" then
            if sp.timer >= 5 then
                sp.randomCollectibleSpawn(sp.x, sp.y)
                if sp.randomSpawnLocation then
                    sp.resetSpawnLocation()
                end
                sp.timer = 0
            end
        end
    end

    sp.setActive = function(pActive)
        sp.activated = pActive
    end

    sp.randomEnemySpawn = function(pX, pY)
        --function to choose what to spawn
        local random = love.math.random(2)
        if random == 1 then
            newEnemy(pX, pY)
        elseif random == 2 then
            newTurret(pX, pY)
        end
    end
    sp.randomCollectibleSpawn = function(pX, pY)
        --function to choose what to spawn
        local random = love.math.random(2)
        if random == 1 then
            newHeal(pX, pY)
        elseif random == 2 then
            newAmmo(pX, pY)
        end
    end

    sp.resetSpawnLocation = function()
        sp.x = love.math.random(30, screen.width - 30)
        sp.y = love.math.random(30, screen.height - 30)
    end

    table.insert(spawners, sp)

    return sp
end
