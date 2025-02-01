require "pictionary_turtle"
init()

local width, height = 24, 17
forward(math.random(0, 8))
right(math.random(0, 3) * 4 + 2)

down()
while true do
    local x, y = pos()
    print(x, y)
    local ang = heading()
    
    if ang == 2 then
        x = width - x - 1
        if x < y then
            forward(x)
            left(4)
        else
            forward(y)
            right(4)
        end
    elseif ang == 6 then
        x = width - x - 1
        y = height - y - 1
        if x < y then
            forward(x)
            right(4)
        else
            forward(y)
            left(4)
        end
    elseif ang == 10 then
        y = height - y - 1
        if x < y then
            forward(x)
            left(4)
        else
            forward(y)
            right(4)
        end
    elseif ang == 14 then
        if x < y then
            forward(x)
            right(4)
        else
            forward(y)
            left(4)
        end
    end
    -- lilcircle()
    -- undo()
    -- if math.random() < 0.5 then undo() end
end
