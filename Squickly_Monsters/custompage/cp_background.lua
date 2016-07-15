-------------------------------------------------------------------------------
-- Local variables go HERE

local cp_background;

-- -------------------------------------------------------------------------------

function setUpBackground() 
    cp_background = display.newImage("img/bg/pokemon_psychic.png", display.contentCenterX, display.contentCenterY)
    cp_background:scale(display.contentWidth/cp_background.width, display.contentHeight/cp_background.height )
end

function getBackground()
    return cp_background
end

