local imgBuilding = love.graphics.newImage("images/building.png")

function newBuilding(pX, pY)
    local building = newSprite(imgBuilding, pX, pY)
    building.label = "objective"

    building.captureRadius = 300
    building.currentCapturePercentage = 0
    building.maxCapturePercentage = 100
    building.baseCaptureRate = 10
    building.timer = 0

    building.init = function()
        building.captureRadius = 300
        building.currentCapturePercentage = 0
        building.maxCapturePercentage = 100
        building.baseCaptureRate = 10
        building.timer = 0
    end

    building.drawBoxes = function()
        love.graphics.circle("line", building.x, building.y, building.captureRadius)

        love.graphics.print(
            "Point de capture : " .. math.floor(building.currentCapturePercentage),
            screen.width * 0.5,
            20
        )
        love.graphics.setColor(1, 1, 1, 1)
    end

    building.onDetect = function(dt, pPlayer, pDifficulty)
        building.currentCapturePercentage =
            building.currentCapturePercentage + (building.baseCaptureRate / pDifficulty) * dt

        if building.currentCapturePercentage >= 100 then
            changeScene("victory", pDifficulty)
        end
    end
end
