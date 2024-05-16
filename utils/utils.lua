screen = {}

screen.width = love.graphics.getWidth()
screen.height = love.graphics.getHeight()

screen.center = function()
    return screen.width * 0.5, screen.height * 0.5
end

function checkDistances(x1, x2, y1, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end
