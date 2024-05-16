local walls = {}

function newWalls(pNumber, pX, pY)
    local wall = newSprite()

    wall.x = pX or 0
    wall.y = pY or 0
    wall.height = 0
    wakk.width = 0

    wall.draw = function()
    end

    table.insert(walls, wall)
end
