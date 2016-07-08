-------------------------------------------------------------------------------
-- Local variables go HERE

local background;

-- -------------------------------------------------------------------------------

function setUpBackground() 
    -- Set Background
    -- background = display.newImage("img/bg/mountains.jpg", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/waterfall.png", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/hotday.png", display.contentCenterX, display.contentCenterY)
    background = display.newImage("img/bg/ice.png", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/planets.png", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/underwater.jpg", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/underwater2.jpg", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/underwater3.png", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/fantasy.jpg", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/jungle.png", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/beach.png", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/castle.jpg", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/swiss.png", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/village.jpeg", display.contentCenterX, display.contentCenterY)
    -- background = display.newImage("img/bg/dragon.jpg", display.contentCenterX, display.contentCenterY)
    background:scale(display.contentWidth/background.width, display.contentHeight/background.height )
    
    -- local backgroundOption = {
    --     width = 500,
    --     height = 243,
    --     numFrames = 8,

    --     sheetContentWidth = 4000,
    --     sheetContentHeight = 243,

    -- }
    -- local backgroundSheet = graphics.newImageSheet("img/bg/main_background.png", backgroundOption)
    -- local backgroundSequence = {
    --     start = 1,
    --     count = 8,
    --     time = 1400,
    --     loopcount = 0,
    --     loopdirection = "forward"
    -- }
    -- background = display.newSprite(backgroundSheet, backgroundSequence)
    -- background.x = display.contentCenterX
    -- background.y = display.contentCenterY
    -- background:scale(
    --                 display.contentWidth/backgroundOption.width, 
    --                 display.contentHeight/backgroundOption.height
    --                 )
    -- background:play()
end

function getBackground()
    return background
end

