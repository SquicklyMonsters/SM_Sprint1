local backbackground;

function setupBackground()

    --adds an image to our game centered at x and y coordinates
    backbackground = display.newImage("img/squicklyfarm/background.png")
    backbackground.x = display.contentCenterX
    backbackground.y = 85

end

function getBackbackground()
    return backbackground
end
