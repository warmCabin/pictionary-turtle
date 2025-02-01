require "pictionary_turtle"
init()

forward(8)
left()
forward(11)
right(8)

local width, height = 23, 16
while true do
    for _ = 1, width do
        if math.random() < 0.5 then lilcircle() else bigcircle() end
        forward()
    end
    right()
    for _ = 1, height do
        if math.random() < 0.5 then lilcircle() else bigcircle() end
        forward()
    end
    right()

    width, height = width - 1, height - 1
    if width == 0 or height == 0 then break end
end
