require "pictionary_turtle"

init(false)

down()
for i = 1, 16 do
    forward(i)
    right()
    forward(i)
    right()
end

up()
right(2)
forward(8)

down()
for i = 1, 8 do
    forward(i)
    --undo()
    right()
    forward(i)
    --undo()
    right()
end
