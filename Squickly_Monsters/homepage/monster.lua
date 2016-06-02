-- -------------------------------------------------------------------------------

-- Local variables go HERE

local monster;

-- -------------------------------------------------------------------------------

function setUpMonster(fileName)
	-- Set Monster
	local options = {
    width = 300,
    height = 300,
    numFrames = 16,

    sheetContentWidth = 2400,
    sheetContentHeight = 600,

	}
    local imageSheet = graphics.newImageSheet(fileName, options)

    -- Setup seqences for each animation
    local sequence = {
        {
            name = "normal",
            start = 1,
            count = 8,
            time = 1600*1.5,
            loopcount = 0,
            loopdirection = "forward"
        },

        {
            name = "happy",
            start = 6,
            count = 11,
            time = 1600,
            loopcount = 0,
            loopdirection = "forward"
        }
    }

    monster = display.newSprite(imageSheet, sequence)
    monster.x = display.contentCenterX
    monster.y = 225
    monster:scale(0.5, 0.5)
    monster:play()
end

function getMonster()
    return monster
end

function setMonsterSequence(sequence)
    monster:setSequence(sequence)
    monster:play()
end

function setSequenceNormal(event)
    monster:setSequence("normal")
    monster:play()
end