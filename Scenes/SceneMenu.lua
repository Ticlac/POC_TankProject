local GUI = require("Scenes/GUI")
local scene = {}

scene.load = function()
    startGameButton = newButton(350, 300, 300, 50, "Start Game")

    groupTest = GUI.newGroup()
    groupTest:addElement(startGameButton)
end

scene.unload = function()
end

scene.update = function(dt)
end

scene.draw = function()
    love.graphics.print("Menu", 100, 100)
    groupTest:draw()
end

scene.mousePressed = function(pX, pY, pBtn)
    if pBtn == 1 then
        if groupTest:clickedOnButton(pX, pY) then
            changeScene("game", 1)
        end
    end
end

scene.keyPressed = function(key)
    if key == "space" then
        changeScene("game", 1)
    end
end

return scene
