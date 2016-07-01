local backbackground;
local backgroundfar;
local backgroundnear1;
local backgroundnear2;

local resizer = display.contentHeight/320;

function setupBackground()

    --adds an image to our game centered at x and y coordinates
    backbackground = display.newImage("img/squicklyrun/background.png")
    backbackground:scale(resizer*1.5,resizer)
    backbackground.x = display.contentCenterX
    backbackground.y = 160*resizer

    backgroundfar = display.newImage("img/squicklyrun/bgfar1.png")
    backgroundfar:scale(resizer,resizer)
    backgroundfar.x = 480*resizer
    backgroundfar.y = 160*resizer

    backgroundnear1 = display.newImage("img/squicklyrun/bgnear2.png")
    backgroundnear1:scale(resizer,resizer)
    backgroundnear1.x = 240*resizer
    backgroundnear1.y = 160*resizer

    backgroundnear2 = display.newImage("img/squicklyrun/bgnear2.png")
    backgroundnear2:scale(resizer,resizer)
    backgroundnear2.x = 760*resizer
    backgroundnear2.y = 160*resizer


end

function getBackbackground()
    return backbackground
end

function getBackgroundfar()
    return backgroundfar
end

function getBackgroundnear1()
    return backgroundnear1
end

function getBackgroundnear2()
    return backgroundnear2
end

