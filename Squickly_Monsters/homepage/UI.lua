local widget = require( "widget" )

local feedIcon;
local sleepIcon;
local wakeupIcon;
local cleanIcon;
local playIcon;
local mostRecentFoodIcon1;
local mostRecentFoodIcon2;
local moreFoodIcon;
local shopIcon;
local mostRecentPlayIcon1;
local mostRecentPlayIcon2;
local morePlayIcon;

local hungerBar;
local happinessBar;
local hygieneBar;
local energyBar;
local expBar;

-- -------------------------------------------------------------------------------
-- Set up needs bar

function setUpNeedBar(fileName, left)
    local options = {
        width = 192,
        height = 64,
        numFrames = 2,
        sheetContentWidth = 384,
        sheetContentHeight = 64
    }
    local progressSheet = graphics.newImageSheet( fileName, options )

    return widget.newProgressView(
        {
            sheet = progressSheet,
            fillOuterMiddleFrame = 1,
            fillOuterWidth = 0,
            fillOuterHeight = display.contentHeight/25,
            fillInnerMiddleFrame = 2,
            fillWidth = 0,
            fillHeight = display.contentHeight/25,
            left = left,
            top = 10,
            width = display.contentWidth/8,
            isAnimated = true
        }
    )
end

function setNeedLevel(need, lvl)
    need:setProgress(lvl)
end

function setupAllNeedsBars()
    local startX = display.contentWidth/10
    local spacing = display.contentWidth/6

    -- TODO: Update Bar files
    hungerBar = setUpNeedBar("img/others/HappinessBar.png", startX)
    happinessBar = setUpNeedBar("img/others/HappinessBar.png", startX + spacing)
    hygieneBar = setUpNeedBar("img/others/HygieneBar.png", startX + spacing*2)
    energyBar = setUpNeedBar("img/others/EnergyBar.png", startX + spacing*3)
    expBar = setUpNeedBar("img/others/EnergyBar.png", startX + spacing*4)

    -- Set All Needs Level (From Save File Later)
    setNeedLevel(hungerBar, 0.5)
    setNeedLevel(happinessBar, 0.5)
    setNeedLevel(hygieneBar, 0.5)
    setNeedLevel(energyBar, 0.5)
    setNeedLevel(expBar, 0.5)

end
-- -------------------------------------------------------------------------------
-- Setup All Icons Here

function setUpAllIcons()
    feedIcon = setUpIcon("img/others/feedIcon.png", 0.75)
    sleepIcon = setUpIcon("img/others/sleepIcon.png", 0.5)
    wakeupIcon = setUpIcon("img/others/wakeupIcon.png", 0.7)
    cleanIcon = setUpIcon("img/others/cleanIcon.png", 0.5)
    playIcon = setUpIcon("img/others/playIcon.png", 0.75)
    mostRecentFoodIcon1 = setUpIcon("img/others/cupcakeIcon.png", 0.75)
    mostRecentFoodIcon2 = setUpIcon("img/others/milkIcon.png", 0.5)
    moreFoodIcon = setUpIcon("img/others/optionsIcon.png", 0.75)
    shopIcon = setUpIcon("img/others/shopIcon.png", 0.5)
    mostRecentPlayIcon1 = setUpIcon("img/others/legomanIcon.png", 0.75)
    mostRecentPlayIcon2 = setUpIcon("img/others/footballIcon.png", 0.75)
    morePlayIcon = setUpIcon("img/others/optionsIcon.png", 0.75)
end

function setUpIcon(img, scale)
    icon = display.newImage(img, getMonster().x, getMonster().y)
    icon:scale(scale, scale)
    icon.alpha = 0
    return icon
end

-- -------------------------------------------------------------------------------
-- Needs Rate Event Handler

local function needRateEventHandler( event )
    local params = event.source.params
    changeNeedsLevel(params.needBar, params.increase,params.amount)
end

-- ------------------------------------------------
-- Adds forever increasing/decreasing needs level

function setRateLongTerm(needBar, increasing, rate, amount) 
    -- increasing is boolean val which shows that rate should increase if true
    -- rate is frequency of the change, amount is the magnitude of change
    -- rate 1000 = 1sec, -1 is infinite interations
    local tmp = timer.performWithDelay(rate, needRateEventHandler, -1) 
    tmp.params = {needBar=needBar, increase=increasing,amount=amount}
    if needBar == energyBar then
        print("yes")
        return tmp
    end
end
-- ------------------------------------------------
-- Changing by a certain amount (Still needs to have more calculations later)

function changeNeedsLevel(needsBar, increase, amount)
    if (increase) then
        needsBar:setProgress(needsBar:getProgress() + amount)
    else
        needsBar:setProgress(needsBar:getProgress() - amount)
    end
end

-- -------------------------------------------------------------------------------
-- Get needs bar

function getHungerBar()
    return hungerBar
end

function getHappinessBar()
    return happinessBar
end

function getHygieneBar()
    return hygieneBar
end

function getEnergyBar()
    return energyBar
end

function getExpBar()
    return expBar
end

-- -------------------------------------------------------------------------------
-- Get icons

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

function getMostRecentFoodIcon1()
    return mostRecentFoodIcon1
end

function getMostRecentFoodIcon2()
    return mostRecentFoodIcon2
end

function getMoreFoodIcon()
    return moreFoodIcon
end

function getShopIcon()
    return shopIcon
end

function getMostRecentPlayIcon1()
    return mostRecentPlayIcon1
end

function getMostRecentPlayIcon2()
    return mostRecentPlayIcon2
end

function getMorePlayIcon()
    return morePlayIcon
end