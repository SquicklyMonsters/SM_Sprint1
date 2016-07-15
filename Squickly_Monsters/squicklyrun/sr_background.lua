local backbackground;
local backgroundfar;
local backgroundnear1;
local backgroundnear2;

local resizer = display.contentHeight/320;

function setupBackground()
    -- print(display.contentCenterX)
    -- print(display.contentCenterY)

    --adds an image to our game centered at x and y coordinates
    backbackground = display.newImage("img/squicklyrun/castle.jpg")
    backbackground:scale(resizer*1.5,resizer)
    backbackground.x = display.contentCenterX
    backbackground.y = 160*resizer

    backgroundfar = display.newImage("img/squicklyrun/groundtester.png")
    backgroundfar:scale(0.8*resizer,0.8*resizer)
    backgroundfar.x = 280*resizer
    backgroundfar.y = 360*resizer

    backgroundnear1 = display.newImage("img/squicklyrun/tree-1.png")
    backgroundnear1:scale(resizer*0.3,resizer*0.3)
    backgroundnear1.x = 240*resizer
    backgroundnear1.y = 200*resizer

    backgroundnear2 = display.newImage("img/squicklyrun/tree-4.png")
    backgroundnear2:scale(resizer*0.25,resizer*0.25)
    backgroundnear2.x = 280*resizer
    backgroundnear2.y = 200*resizer


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

