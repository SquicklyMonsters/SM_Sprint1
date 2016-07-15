require("monsterList")
-- -------------------------------------------------------------------------------

-- Local variables go HERE

local monster;
local resizer = display.contentHeight/320

-- -------------------------------------------------------------------------------
-- Set get Monster
function setUpMonster(monsterName)
    imageAttr,statesInfo = getMonsterInfo(monsterName)
    fileName,fileWidth,fileHeight,rows,columns,nFrames,scaling = imageAttr[1],imageAttr[2],imageAttr[3],imageAttr[4],imageAttr[5],imageAttr[6],imageAttr[7]

    local options = {
        width = fileWidth/rows,
        height = fileHeight/columns,
        numFrames = nFrames,

        sheetContentWidth = fileWidth,
        sheetContentHeight = fileHeight,

    }
    local imageSheet = graphics.newImageSheet(fileName, options)

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
    monster:scale(scaling*resizer,scaling*resizer)
    monster:play()
end

function updateMonster(monsterName)
    imageAttr,statesInfo = getMonsterInfo(monsterName)
    fileName,fileWidth,fileHeight,rows,columns,nFrames,scaling = imageAttr[1],imageAttr[2],imageAttr[3],imageAttr[4],imageAttr[5],imageAttr[6],imageAttr[7]

    local options = {
        width = fileWidth/rows,
        height = fileHeight/columns,
        numFrames = nFrames,

        sheetContentWidth = fileWidth,
        sheetContentHeight = fileHeight,

    }

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

    monster.imageSheet = graphics.newImageSheet(fileName, options)
    monster.sequenceData = sequence

    monster:scale(scaling*resizer,scaling*resizer)
    monster:play()
end

function getMonster()
    return monster
end
-- -------------------------------------------------------------------------------

function setMonsterLocation(offset_x,offset_y)
    monster.x = display.contentCenterX+offset_x*resizer
    monster.y = display.contentCenterY+offset_y*resizer
end

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
