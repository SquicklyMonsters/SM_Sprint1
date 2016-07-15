-- -----------------------------------------------------------------------------
-- Local variables go HERE

local backgroundShop;

-- -------------------------------------------------------------------------------

function setUpShopBackground() 
    -- Set Background
    -- local background = display.newImage("background.png", display.contentCenterX, display.contentCenterY)
    -- local backgroundOption = {
    --     width = 1024,
    --     height = 768,
    --     numFrames = 1,

    --     -- sheetContentWidth = 1024,
    --     -- sheetContentHeight = 768,

    -- }
    -- local backgroundSheet = graphics.newImageSheet("img/bg/shop.png", backgroundOption)
    -- local backgroundSequence = {
    --     start = 1,
    --     count = 8,
    --     time = 1400,
    --     loopcount = 0,
    --     loopdirection = "forward"
    -- }
    -- backgroundShop = display.newSprite(backgroundSheet, backgroundSequence)
    -- backgroundShop.x = display.contentCenterX
    -- backgroundShop.y = display.contentCenterY
    -- backgroundShop:scale(
    --                 display.contentWidth/backgroundOption.width, 
    --                 display.contentHeight/backgroundOption.height
    --                 )
    backgroundShop = display.newImage("img/bg/shop.png", display.contentCenterX, display.contentCenterY)
    backgroundShop:scale(display.contentWidth/backgroundShop.width, display.contentHeight/backgroundShop.height )    
end

function getBackgroundShop()
    return backgroundShop
end

-- -------------------------------------------------------------------------------

