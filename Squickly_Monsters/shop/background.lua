-------------------------------------------------------------------------------
require('currency')
-- Local variables go HERE

local background;

-- -------------------------------------------------------------------------------

function setUpBackground() 
    -- Set Background
    -- local background = display.newImage("background.png", display.contentCenterX, display.contentCenterY)
    local backgroundOption = {
        width = 1024,
        height = 768,
        numFrames = 1,

        -- sheetContentWidth = 1024,
        -- sheetContentHeight = 768,

    }
    local backgroundSheet = graphics.newImageSheet("img/bg/shop.png", backgroundOption)
    local backgroundSequence = {
        start = 1,
        count = 8,
        time = 1400,
        loopcount = 0,
        loopdirection = "forward"
    }
    background = display.newSprite(backgroundSheet, backgroundSequence)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background:scale(
                    display.contentWidth/backgroundOption.width, 
                    display.contentHeight/backgroundOption.height
                    )
    
end

function getBackground()
    return background
end

-- -------------------------------------------------------------------------------

