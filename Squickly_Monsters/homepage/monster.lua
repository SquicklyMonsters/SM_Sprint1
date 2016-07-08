-- -------------------------------------------------------------------------------

-- Local variables go HERE

local monster;

-- -------------------------------------------------------------------------------
-- Set get Monster
function setUpMonster(imageAttr, statesInfo)
    fileName,fileWidth,fileHeight,rows,columns,nFrames = imageAttr[1],imageAttr[2],imageAttr[3],imageAttr[4],imageAttr[5],imageAttr[6]

    local options = {
        width = fileWidth/rows,
        height = fileHeight/columns,
        numFrames = nFrames,

        sheetContentWidth = fileWidth,
        sheetContentHeight = fileHeight,

    }
    local imageSheet = graphics.newImageSheet("img/sprites/" .. fileName, options)

    -- Setup seqences for each animation
    local sequence = {}
    for i = 1, #statesInfo do
        local state = {
            name = statesInfo[i][1],
            start = statesInfo[i][2],
            count = statesInfo[i][3],
            time = statesInfo[i][4],
            loopcount = statesInfo[i][5],
            loopdirection = statesInfo[i][6],
        }
        table.insert( sequence, state )
    end

    monster = display.newSprite(imageSheet, sequence)
    monster.x = display.contentCenterX
    monster.y = display.contentCenterY*25/16
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
