-------------------------------------------------------------------------------
-- Local variables go HERE

local background;

-- -------------------------------------------------------------------------------

function setUpBackground() 
    background = display.newImage("img/bg/pokemon_psychic.png", display.contentCenterX, display.contentCenterY)
    background:scale(display.contentWidth/background.width, display.contentHeight/background.height )
end

function getBackground()
    return background
end

