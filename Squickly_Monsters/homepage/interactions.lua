local widget = require( "widget" )
require("homepage.monster")

-- -------------------------------------------------------------------------------

-- Local variables go HERE

-- TODO: List of each bar
local monster;

local feedIcon;
local sleepIcon;
local wakeupIcon;
local cleanIcon;
local playIcon;
local icons; -- idx 1=feed, 2=sleep/wakeup, 3=clean, 4=play

local hungerBar;
local happinessBar;
local hygieneBar;
local energyBar;
local expBar;

function getAllVariables()
    monster = getMonster()
    feedIcon = getFeedIcon()
    sleepIcon = getSleepIcon()
    wakeupIcon = getWakeupIcon()
    cleanIcon = getCleanIcon()
    playIcon = getPlayIcon()
    hungerBar = getHungerBar()
    happinessBar = getHappinessBar()
    hygieneBar = getHygieneBar()
    energyBar = getEnergyBar()
    expBar = getExpBar()

    icons = {feedIcon, sleepIcon, cleanIcon, playIcon}
end

-- -------------------------------------------------------------------------------

-- Setup The Needs Bars Here

function setupAllNeedsBars()
    local startX = 0
    local spacing = 105

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

    -- Set All Needs Decrement rate (1000 = 1sec)
    setHungerRateLongTerm(false, 1000, 0.2)
    setHappinessRateLongTerm(false, 1000, 0.2)
    setHygieneRateLongTerm(false, 1000, 0.2)
    setEnergyRateLongTerm(false, 1000, 0.2)
    setExpRateLongTerm(true, 1000, 0.2)
end

function setUpNeedBar(fileName, left)
    local options = {
        width = 64,
        height = 64,
        numFrames = 6,
        sheetContentWidth = 384,
        sheetContentHeight = 64
    }
    local progressSheet = graphics.newImageSheet( fileName, options )

    return widget.newProgressView(
        {
            sheet = progressSheet,
            fillOuterMiddleFrame = 2,
            fillOuterWidth = 0,
            fillOuterHeight = 10,
            fillInnerMiddleFrame = 5,
            fillWidth = 0,
            fillHeight = 10,
            left = left,
            top = 50,
            width = 100,
            isAnimated = true
        }
    )
end

-- -------------------------------------------------------------------------------

-- Setup All Icons Bars Here

function setUpAllIcons()
    feedIcon = setUpIcon("img/others/feedIcon.png", 0.75)
    sleepIcon = setUpIcon("img/others/sleepIcon.png", 0.5)
    wakeupIcon = setUpIcon("img/others/wakeupIcon.png", 0.7)
    cleanIcon = setUpIcon("img/others/cleanIcon.png", 0.5)
    playIcon = setUpIcon("img/others/playIcon.png", 0.75)
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

function setNeedLevel(need, lvl)
    need:setProgress(lvl)
end

-- ------------------------------------------------
-- Adds forever increasing/decreasing needs level
function setHungerRateLongTerm(increasing, rate, amount) -- increasing is boolean val which shows that rate should increase if true
    if (increasing) then                                 -- rate is frequency of the change, amount is the magnitude of change
        timer.performWithDelay(rate, toggleHungerLevel(true, amount), -1) -- rate 1000 = 1sec, -1 is infinite interations
    else
        timer.performWithDelay(rate, toggleHungerLevel(false, amount), -1)
    end
end

function setHappinessRateLongTerm(increasing, rate, amount) -- increasing is boolean val which shows that rate should increase if true
    if (increasing) then                                    -- rate is frequency of the change, amount is the magnitude of change
        timer.performWithDelay(rate, toggleHappinessLevel(true, amount), -1) -- rate 1000 = 1sec, -1 is infinite interations
    else
        timer.performWithDelay(rate, toggleHappinessLevel(false, amount), -1)
    end
end

function setHygieneRateLongTerm(increasing, rate, amount) -- increasing is boolean val which shows that rate should increase if true
    if (increasing) then                                  -- rate is frequency of the change, amount is the magnitude of change
        timer.performWithDelay(rate, toggleHygieneLevel(true, amount), -1) -- rate 1000 = 1sec, -1 is infinite interations
    else
        timer.performWithDelay(rate, toggleHygieneLevel(false, amount), -1)
    end
end

function setEnergyRateLongTerm(increasing, rate, amount) -- increasing is boolean val which shows that rate should increase if true
    if (increasing) then                                 -- rate is frequency of the change, amount is the magnitude of change
        timer.performWithDelay(rate, toggleEnergyLevel(true, amount), -1) -- rate 1000 = 1sec, -1 is infinite interations
    else
        timer.performWithDelay(rate, toggleEnergyLevel(false, amount), -1)
    end
end

function setExpRateLongTerm(increasing, rate, amount) -- increasing is boolean val which shows that rate should increase if true
    if (increasing) then                              -- rate is frequency of the change, amount is the magnitude of change
        timer.performWithDelay(rate, toggleExpLevel(true, amount), -1) -- rate 1000 = 1sec, -1 is infinite interations
    else
        timer.performWithDelay(rate, toggleExpLevel(false, amount), -1)
    end
end

-- ------------------------------------------------
-- Toggling a certain amount (Still needs to have more calculations later)
function toggleHungerLevel(increase, amount)
    if (increase) then
        hungerBar:setProgress(hungerBar:getProgress() + amount)
    else
        hungerBar:setProgress(hungerBar:getProgress() - amount)
    end
end

function toggleHappinessLevel(increase, amount)
    if (increase) then
        happinessBar:setProgress(happinessBar:getProgress() + amount)
    else
        happinessBar:setProgress(happinessBar:getProgress() - amount)
    end
end

function toggleHygieneLevel(increase, amount)
    if (increase) then
        hygieneBar:setProgress(hygieneBar:getProgress() + amount)
    else
        hygieneBar:setProgress(hygieneBar:getProgress() - amount)
    end
end

function toggleEnergyLevel(increase, amount)
    if (increase) then
        energyBar:setProgress(energyBar:getProgress() + amount)
    else
        energyBar:setProgress(energyBar:getProgress() - amount)
    end
end

function toggleExpLevel(increase, amount)
    if (increase) then
        expBar:setProgress(expBar:getProgress() + amount)
    else
        expBar:setProgress(expBar:getProgress() - amount)
    end
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
        toggleHungerLevel(true, 0.1)
        return true
    end
end

function sleepButtonClicked(event)
    if event.phase == "ended" then
        changeToSleepState()
        setEnergyRateLongTerm(true, 1000, 0.2)
        return true
    end
end

function wakeupButtonClicked(event)
    if event.phase == "ended" then
        changeToWakeupState()
        setEnergyRateLongTerm(false, 1000, 0.2)
        return true
    end
end

function cleanButtonClicked(event)
    if event.phase == "ended" then
        cleanPetAnimation()
        toggleHygieneLevel(true, 0.1)
        return true
    end
end

function playButtonClicked(event)
    if event.phase == "ended" then
        playWithPetAnimation()
        toggleHappinessLevel(true, 0.1)
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