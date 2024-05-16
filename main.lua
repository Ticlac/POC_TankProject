love.window.setMode(1280, 800)

require "utils/utils"
require "sprites/sprite"
require "Scenes/SceneManager"
require "utils/constants"

-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

function love.load()
    registerScene(require("Scenes/SceneGame"), "game")
    registerScene(require("Scenes/SceneMenu"), "menu")
    registerScene(require("Scenes/SceneGameOver"), "over")
    registerScene(require("Scenes/SceneGameVictory"), "victory")
    changeScene("menu")
end

function love.update(dt)
    dt = math.min(dt, 1 / 60)
    updateCurrentScene(dt)
end

function love.draw()
    drawCurrentScene()
end

function love.mousepressed(x, y, btn)
    mousePressed(x, y, btn)
end

function love.keypressed(key)
    keyPressed(key)
end
