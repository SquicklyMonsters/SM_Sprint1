local backbackground;
local backgroundfar;
local backgroundnear1;
local backgroundnear2;



function setupBackground()
    -- print(display.contentCenterX)
    -- print(display.contentCenterY)

    --adds an image to our game centered at x and y coordinates
    backbackground = display.newImage("img/squicklyrun/background.png")
    backbackground.x = display.contentCenterX
    backbackground.y = display.contentCenterY

    backgroundfar = display.newImage("img/squicklyrun/bgfar1.png")
    backgroundfar.x = display.contentCenterX/2
    backgroundfar.y = display.contentCenterY

    backgroundnear1 = display.newImage("img/squicklyrun/bgnear2.png")
    backgroundnear1.x = 240
    backgroundnear1.y = 160

    backgroundnear2 = display.newImage("img/squicklyrun/bgnear2.png")
    backgroundnear2.x = 760
    backgroundnear2.y = 160


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

