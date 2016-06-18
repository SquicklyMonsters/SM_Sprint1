-- -------------------------------------------------------------------------------

-- Local variables go HERE

local monster;

-- -------------------------------------------------------------------------------
-- Set get Monster
function setUpMonster(fileName)
	-- Set Monster
	-- local options = {
 --    width = 300,
 --    height = 300,
 --    numFrames = 16,

 --    sheetContentWidth = 2400,
 --    sheetContentHeight = 600,

	-- }
 --    local imageSheet = graphics.newImageSheet(fileName, options)

 --    -- Setup seqences for each animation
 --    local sequence = {
 --        {
 --            name = "normal",
 --            start = 1,
 --            count = 8,
 --            time = 1600*1.5,
 --            loopcount = 0,
 --            loopdirection = "forward"
 --        },

 --        {
 --            name = "happy",
 --            start = 6,
 --            count = 11,
 --            time = 1600,
 --            loopcount = 0,
 --            loopdirection = "forward"
 --        }
 --    }

 --    monster = display.newSprite(imageSheet, sequence)
 --    monster.x = display.contentCenterX
 --    monster.y = display.contentCenterY* 27/16
 --    monster:scale(
 --                 display.contentWidth/(options.width*4),
 --                 display.contentHeight/(options.height*2.5)
 --                 )
 --    monster:play()
    local options = {
    width = 9464/8,
    height = 18531/10,
    numFrames = 80,

    sheetContentWidth = 9464,
    sheetContentHeight = 18531,

    }
    local imageSheet = graphics.newImageSheet(fileName, options)

    -- Setup seqences for each animation
    local sequence = {
        {
            name = "normal",
            start = 1,
            count = 32,
            time = 200*32,
            loopcount = 0,
            loopdirection = "forward"
        },

        {
            name = "sad",
            start = 33,
            count = 16,
            time = 200*32,
            loopcount = 0,
            loopdirection = "forward"
        },

        {
            name = "sleep",
            start = 49,
            count = 16,
            time = 200*16,
            loopcount = 0,
            loopdirection = "forward"
        },

        {
            name = "eat",
            start = 65,
            count = 16,
            time = 200*16,
            loopcount = 0,
            loopdirection = "forward"
        },
    }

    monster = display.newSprite(imageSheet, sequence)
    monster.x = display.contentCenterX
    monster.y = display.contentCenterY* 25/16
    monster:scale(
                 display.contentWidth/(options.width*7),
                 display.contentHeight/(options.height*2.5)
                 )
    monster:play()
end

function getMonster()
    return monster
end
-- -------------------------------------------------------------------------------

function setMonsterSequence(sequence)
    monster:setSequence(sequence)
    monster:play()
end

function setSequenceNormal(event)
    monster:setSequence("normal")
    monster:play()
end

-- -------------------------------------------------------------------------------
-- Monster animation

function sadAnimation()
    setMonsterSequence("sad")
    -- timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
end

function feedAnimation()
    setMonsterSequence("eat")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
end

function cleanAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
end

function playAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
end

function sleepAnimation()
    setMonsterSequence("sleep")
end

function defaultAnimation()
    setMonsterSequence("normal")
end
