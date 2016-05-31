local widget = require( "widget" )
require("homepage.monster")

-- -------------------------------------------------------------------------------

-- Local variables go HERE

local monster;
local icons
local feedIcon;
local hungerBar;

function getAllVariables()
    monster = getMonster()
    feedIcon = getFeedIcon()
    hungerBar = getHungerBar()
    icons = {feedIcon}
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
    feedIcon = setUpIcon("img/others/feedIcon.png")
end

function setUpIcon(img)
    icon = display.newImage(img, getMonster().x, getMonster().y)
    icon:scale(0.05, 0.05)
    icon.isVisible = false
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

function hideShowAllIcons()
    xAxis = {75}
    yAxis = {75}

    if (icons[1].isVisible == false) then
        -- print("Show")
        for i = 1, 1 do
            transition.to(icons[i], 
                {x = monster.x + xAxis[i], y = monster.y - yAxis[i],
                isVisible = true, time = 250})
        end
    else
        -- print("Hide")
        for i = 1, 1 do
            transition.to(icons[i], 
                {x = monster.x, y = monster.y,
                isVisible = false, time = 250})
        end 
    end     
end

-- -------------------------------------------------------------------------------

-- Add All Event Listeners Here

function addListeners()
    getAllVariables()
    monster:addEventListener("touch", interactionsToggle)
    feedIcon:addEventListener("touch", feedButtonClicked)
end

-- Set reaction when touch monster
function interactionsToggle(event)
    if event.phase == "ended" then
        hideShowAllIcons(monster)
    end
end

function feedButtonClicked(event)
    if event.phase == "ended" then
        feedPetAnimation()
        hungerBar:setProgress(hungerBar:getProgress() + 0.1)
        return true
    end
end

-- -------------------------------------------------------------------------------

-- Monster Interaction Animation Here

function feedPetAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
    hideShowIcons(getMonster())
end