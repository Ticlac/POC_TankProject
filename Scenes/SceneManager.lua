local scenes = {}
local activeScene = nil

function registerScene(scene, label)
    scenes[label] = scene
end

function changeScene(pLabelScene, pDifficulty)
    if activeScene ~= nil then
        activeScene.unload()
    end

    activeScene = scenes[pLabelScene]

    if activeScene ~= nil then
        activeScene.load(pDifficulty)
    end
end

function updateCurrentScene(dt)
    if activeScene ~= nil then
        activeScene.update(dt)
    end
end

function drawCurrentScene()
    if activeScene ~= nil then
        activeScene.draw()
    end
end

function mousePressed(pX, pY, pBtn)
    if activeScene ~= nil then
        activeScene.mousePressed(pX, pY, pBtn)
    end
end

function keyPressed(key)
    if activeScene ~= nil then
        activeScene.keyPressed(key)
    end
end
