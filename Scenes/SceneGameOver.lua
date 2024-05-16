local GUI = require("Scenes/GUI")
local scene = {}

scene.currentDifficulty = 0
scene.load = function(pDifficulty)
    scene.currentDifficulty = pDifficulty

    menuButton = newButton(100, 300, 300, 50, "Main Menu")
    restartButton = newButton(400, 300, 300, 50, "Restart")

    groupTest = GUI.newGroup()
    groupTest:addElement(menuButton)
    groupTest:addElement(restartButton)
end

scene.unload = function()
end

scene.update = function(dt)
end

scene.draw = function()
    love.graphics.print("gameover", 100, 100, 0, 4, 4)
    love.graphics.print("you've reached difficulty " .. scene.currentDifficulty, 100, 200)

    groupTest:draw()
end

scene.mousePressed = function(pX, pY, pBtn)
    if pBtn == 1 then
        if groupTest:clickedOnButton(pX, pY) then
            if pX <= 350 then
                changeScene("menu")
            elseif pX >= 400 then
                changeScene("game", 1)
            end
        end
    end
end

scene.keyPressed = function(key)
    if key == "space" then
        changeScene("menu")
    end
end

return scene
