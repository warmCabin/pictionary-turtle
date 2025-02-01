require "pictionary_turtle"
init()

for i = 1, 16 do
    for j = 1, i do
        lilcircle()
        forward()
    end
    right()
    for j = 1, i do
        lilcircle()
        forward()
    end
    right()
end

--for i = 1, 2 do
--    for j = 1, 16 do
--        lilcircle()
--        forward()
--    end
--    lilcircle()
--    left()
--    forward()
--    left()
--    lilcircle()
--    for j = 1, 16 do
--        lilcircle()
--        forward()
--    end
--    lilcircle()
--    right()
--    forward()
--    right()
--end
