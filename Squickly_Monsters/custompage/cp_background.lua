-------------------------------------------------------------------------------
-- Local variables go HERE

local cp_background;

-- -------------------------------------------------------------------------------

function setUpEvolveBackground() 
    cp_background = display.newImage("img/bg/pokemon_psychic.png", display.contentCenterX, display.contentCenterY)
    cp_background:scale(display.contentWidth/cp_background.width, display.contentHeight/cp_background.height )
end

function getEvolveBackground()
    return cp_background
end