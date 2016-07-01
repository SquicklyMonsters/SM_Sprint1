local backbackground;
local resizer = display.contentHeight/320

function setupBackground()

    --adds an image to our game centered at x and y coordinates
    backbackground = display.newImage("img/squicklyfarm/background.png", display.contentCenterX, display.contentCenterY)
    backbackground:scale(display.contentWidth/backbackground.width, display.contentHeight/backbackground.height)

end

function getBackbackground()
    return backbackground
end
