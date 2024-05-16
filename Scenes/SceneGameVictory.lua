local GUI = require("Scenes/GUI")
local scene = {}

scene.currentDifficulty = 0
scene.load = function(pDifficulty)
    scene.currentDifficulty = pDifficulty
    startGameButton = newButton(350, 300, 300, 50, "Continue")

    groupTest = GUI.newGroup()
    groupTest:addElement(startGameButton)
end

scene.unload = function()
end

scene.update = function(dt)
end

scene.draw = function()
    love.graphics.print("gameWin !", 100, 100)

    groupTest:draw()
end

scene.mousePressed = function(pX, pY, pBtn)
    if pBtn == 1 then
        if groupTest:clickedOnButton(pX, pY) then
            changeScene("game", scene.currentDifficulty + 1)
        end
    end
end

scene.keyPressed = function(key)
    if key == "space" then
        changeScene("game", scene.currentDifficulty + 1)
    end
end

return scene
