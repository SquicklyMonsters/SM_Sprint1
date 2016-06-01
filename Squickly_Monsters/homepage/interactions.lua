local widget = require( "widget" )
require("homepage.monster")

-- -------------------------------------------------------------------------------

-- Local variables go HERE

local monster;
local feedIcon;
local sleepIcon;
local wakeupIcon;
local cleanIcon;
local playIcon;
local icons; -- idx 1=feed, 2=sleep/wakeup, 3=clean, 4=play
local hungerBar;

function getAllVariables()
    monster = getMonster()
    feedIcon = getFeedIcon()
    sleepIcon = getSleepIcon()
    wakeupIcon = getWakeupIcon()
    cleanIcon = getCleanIcon()
    playIcon = getPlayIcon()
    hungerBar = getHungerBar()

    icons = {feedIcon, sleepIcon, cleanIcon, playIcon}
end

-- -------------------------------------------------------------------------------

-- Setup The Needs Bars Here

function setupAllNeedsBars()
    hungerBar = setUpHungerBar("img/others/widget-progress-view.png")
end

function setUpHungerBar(fileName)
    local options = {
        width = 64,
        height = 64,
        numFrames = 6,
        sheetContentWidth = 384,
        sheetContentHeight = 64
    }
    local progressSheet = graphics.newImageSheet( fileName, options )

    hungerBar = widget.newProgressView(
        {
            sheet = progressSheet,
            fillOuterMiddleFrame = 2,
            fillOuterWidth = 0,
            fillOuterHeight = 10,
            fillInnerMiddleFrame = 5,
            fillWidth = 0,
            fillHeight = 10,
            left = display.contentCenterX - 50,
            top = 50,
            width = 100,
            isAnimated = true
        }
    )
    setHungerLvlDecreaseRate(1000) -- 1000 = 1sec

    return hungerBar
end

-- -------------------------------------------------------------------------------

-- Setup All Icons Bars Here

function setUpAllIcons()
    feedIcon = setUpIcon("img/others/feedIcon.png", 0.06)
    sleepIcon = setUpIcon("img/others/sleepIcon2.png", 0.6)
    wakeupIcon = setUpIcon("img/others/wakeupIcon2.png", 0.07)
    cleanIcon = setUpIcon("img/others/cleanIcon2.png", 0.09)
    playIcon = setUpIcon("img/others/playIcon.png", 0.09)
end

function setUpIcon(img, scale)
    icon = display.newImage(img, getMonster().x, getMonster().y)
    icon:scale(scale, scale)
    icon.alpha = 0
    return icon
end

-- -------------------------------------------------------------------------------

-- Toggle Bar Display Functions Here

function getHungerBar()
    return hungerBar
end

function setHungerLevel(lvl)
    hungerBar:setProgress(lvl)
end

-- Add hunger decreasing loop
function setHungerLvlDecreaseRate(rate)
    timer.performWithDelay(rate, decreaseHungerLevel, -1) -- 1000 = 1sec
end

function decreaseHungerLevel()
    hungerBar:setProgress(hungerBar:getProgress() - 0.1)
end

-- -------------------------------------------------------------------------------

-- Toggle Icons Functions Here

function getFeedIcon()
    return feedIcon
end

function getSleepIcon()
    return sleepIcon
end

function getWakeupIcon()
    return wakeupIcon
end

function getCleanIcon()
    return cleanIcon
end

function getPlayIcon()
    return playIcon
end

function hideShowAllIcons()
    xAxis = {75,30,-30,-75} -- idx 1=feed, 2=sleep/wakeup, 3=clean, 4=play
    yAxis = {65,100,100,65}
    monster = getMonster()

    if (icons[1].alpha == 0) then -- Show Icons
        for i = 1, #icons do
            transition.to(icons[i], 
                {x = monster.x + xAxis[i], y = monster.y - yAxis[i],
                alpha = 1, time = 250})
        end
    else -- Hide Icons
        for i = 1, #icons do
            transition.to(icons[i], 
                {x = monster.x, y = monster.y,
                alpha = 0, time = 250})
        end 
    end     
end

-- -------------------------------------------------------------------------------

-- Add All Event Listeners Here

function addListeners()
    getAllVariables()
    monster:addEventListener("touch", interactionsToggle)
    feedIcon:addEventListener("touch", feedButtonClicked)
    sleepIcon:addEventListener("touch", sleepButtonClicked)
    wakeupIcon:addEventListener("touch", wakeupButtonClicked)
    cleanIcon:addEventListener("touch", cleanButtonClicked)
    playIcon:addEventListener("touch", playButtonClicked)
end

-- Set reaction when touch monster
function interactionsToggle(event)
    if event.phase == "ended" then
        hideShowAllIcons()
    end
end

function feedButtonClicked(event)
    if event.phase == "ended" then
        feedPetAnimation()
        hungerBar:setProgress(hungerBar:getProgress() + 0.1)
        return true
    end
end

function sleepButtonClicked(event)
    if event.phase == "ended" then
        changeToSleepState()
        return true
    end
end

function wakeupButtonClicked(event)
    if event.phase == "ended" then
        changeToWakeupState()
        return true
    end
end

function cleanButtonClicked(event)
    if event.phase == "ended" then
        cleanPetAnimation()
        return true
    end
end

function playButtonClicked(event)
    if event.phase == "ended" then
        playWithPetAnimation()
        return true
    end
end

-- -------------------------------------------------------------------------------

-- Monster Interaction Animation Here

function feedPetAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
    hideShowAllIcons(monster)
end

function cleanPetAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
    hideShowAllIcons(monster)
end

function playWithPetAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
    hideShowAllIcons(monster)
end

function changeToSleepState()
    -- FILL FUNCTION HERE
    hideShowAllIcons(monster)
    table.remove(icons, 2)
    table.insert(icons, 2, wakeupIcon)
end

function changeToWakeupState()
    -- FILL FUNCTION HERE
    hideShowAllIcons(monster)
    table.remove(icons, 2)
    table.insert(icons, 2, sleepIcon)
end