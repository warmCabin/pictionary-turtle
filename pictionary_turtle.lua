
--[[
    This works really well, but somehow it's not as friendly a framework for optimization as when I do it manually.
    waitAfterForward helps with that.
    
    One unit of forwardness is defined as reaching the next lattice point.
      It is technically 1, sqrt(2), or sqrt(5) depending on your angle.
    Pictionary defines angles like the classic Logo turtle: 0 is up, and clockwise is positive.

    Ideas:
      setHeading
      setPosition
      report heading & position
      Undo (select)
      Shorthand function synonyms
      big/small circle
]]

local penAngle = 0
local penDown = false
local step = false
local verbose = true
local waitAfterForward = false -- Not necessary, but helps make it more TAS friendly

function textf(x, y, str, ...)
    gui.text(x, y, string.format(str, ...))
end

function vprint(...)
    if verbose then print(...) end
end

function vprintf(str, ...)
    vprint(string.format(str, ...))
end

function printf(fmt, ...)
    print(fmt:format(...))
end

function wait(frames, param)
    for _ = 1, frames do
        if type(param) == "function" then
            param()
        elseif type(param) == "table" then
            joypad.set(1, param)
        end
        emu.frameadvance()
    end
end

function waitWhile(con)
    while con() do emu.frameadvance() end
end

function sendInputWhile(joy, con)
    while con() do
        joypad.set(1, joy)
        emu.frameadvance()
    end
end

function right(ang)
    ang = ang or 4 -- TODO: maybe the default should be a nudge 1, instead of a right angle 4. Configurable default?
    vprintf("right(%d)", ang)
    if step then textf(10, 10, "right(%d)", ang) end

    if ang < 0 then left(-ang) end

    local targetAng = (penAngle + ang) % 16
    sendInputWhile({ right = true }, function() return memory.readbyte(0x22) ~= targetAng end)
    penAngle = targetAng

    if step then emu.frameadvance(); emu.pause() end
end

function left(ang)
    ang = ang or 4
    vprintf("left(%d)", ang)
    if step then textf(10, 10, "left(%d)", ang) end

    if ang < 0 then right(-ang) end

    local targetAng = (penAngle - ang) % 16
    print("targetAng: "..targetAng) -- Just making sure it doesn't go negative
    sendInputWhile({ left = true }, function() return memory.readbyte(0x22) ~= targetAng end)
    penAngle = targetAng

    if step then emu.frameadvance(); emu.pause() end
end

local vecs = {         {1, -2}, {1, -1}, {2, -1}, {1, 0}, {2, 1}, {1, 1}, {1, 2}, {0, 1}, {-1, 2}, {-1, 1}, {-2, 1}, {-1, 0}, {-2, -1}, {-1, -1}, {-1, -2}}
vecs[0] =     {0, -1} -- I hate Lua I hate Lua I hate Lua
function computeTarget(x, y, ang, amt)
    local vec = vecs[ang]
    local retX, retY = x + vec[1] * amt * 8, y + vec[2] * amt * 8
    assert(retX >= 0x18 and retX <= 0xD0 and retY >= 0x20 and retY <= 0xA0, "\n\n== BANG! Your turtle is going to hit its head. ==\n")
    return retX, retY
end

function forward(amt)
    amt = amt or 1
    vprintf("forward(%d)", amt)
    if step then textf(10, 10, "forward(%d)", amt) end

    local x, y = memory.readbyte(0x2F), memory.readbyte(0x2E)
    local targetX, targetY = computeTarget(x, y, penAngle, amt)
    vprintf("At (%02X, %02X), targeting (%02X, %02X)", x, y, targetX, targetY)

    sendInputWhile({ A = penDown, B = not penDown }, function() return memory.readbyte(0x2F) ~= targetX or memory.readbyte(0x2E) ~=targetY end)
    --wait(1, { A = penDown, B = not penDown })
    if waitAfterForward then wait(7) end

    if step then emu.pause() end
end

function up()
    vprint("up()")
    if step then gui.text(10, 20, "up()") end

    penDown = false

    if step then emu.pause() end
end

function down()
    vprint("down()")
    if step then gui.text(10, 20, "down()") end

    penDown = true

    if step then emu.pause() end
end

function undo()
    vprint("undo()")
    if step then gui.text(10, 10, "undo()") end

    wait(1, { select = true })
    sendInputWhile({}, function() return emu.lagged() end)

    if step then emu.pause() end
end

-- These don't play nicely with undo for whatever reason.
function bigcircle()
    vprint("bigcircle()")
    if step then gui.text(10, 10, "bigcircle()") end

    --sendInputWhile({}, function() return emu.lagged() end)
    --wait(5)
    wait(2, { up = true })
    sendInputWhile({}, function() return emu.lagged() end)
    --wait(2)

    if step then emu.pause() end
end

function lilcircle()
    vprint("lilcircle()")
    if step then gui.text(10, 10, "lilcircle()") end

    --sendInputWhile({}, function() return emu.lagged() end)
    --wait(5)
    wait(2, { down = true })
    sendInputWhile({}, function() return emu.lagged() end)

    if step then emu.pause() end
end

function clear()
    error("TODO (clear)")
    -- need to press start while holding select
end

-- top left is 0x18, 0x20, so...
function pos()
    return memory.readbyte(0x2F) / 8 - 3, memory.readbyte(0x2E) / 8 - 4
end

function heading()
    return penAngle
end

function init(steppy)
    emu.frameadvance() -- Is this necessary anymore?
    penAngle = memory.readbyte(0x22) -- The game code does not reset the pen angle between drawings.
    step = steppy
    if penAngle ~= 0 then
        print("Adjusting to expected starting angle")
        left(penAngle)
    end
end
