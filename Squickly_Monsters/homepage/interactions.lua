local widget = require( "widget" )
require("homepage.monster")
require("homepage.background")

-- -------------------------------------------------------------------------------
-- Local variables go HERE

-- TODO: List of each bar
local monster;
local background;
local menuBar;

local hunger_tm; -- for rate timer loop
local happiness_tm; -- for rate timer loop
local hygiene_tm; -- for rate timer loop
local energy_tm; -- for rate timer loop
local exp_tm; -- for rate timer loop

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

local iconsList; -- idx 1=feed, 2=sleep/wakeup, 3=clean, 4=play
local foodIconsList;
local playIconsList;
local currentVisibleList;

local hungerBar;
local happinessBar;
local hygieneBar;
local energyBar;
local expBar;

local isTouchAble;

function cacheVariables()
    monster = getMonster()
    menuBar = getMenuBar()
    background = getBackground()
    iconsList = {feedIcon, sleepIcon, cleanIcon, playIcon}
    foodIconsList = {moreFoodIcon, mostRecentFoodIcon1, mostRecentFoodIcon2, shopIcon}
    playIconsList = {morePlayIcon, mostRecentPlayIcon1, mostRecentPlayIcon2, shopIcon}
    isTouchAble = true
end

-- -------------------------------------------------------------------------------
-- Setup The Needs Bars Here

function setupAllNeedsBars()
    local startX = display.contentWidth/10
    local spacing = 95

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

    -- Set All Needs Decrement/Increment rates (1000 = 1sec)
    setHungerRateLongTerm(false, 1000, 0.1)
    setHappinessRateLongTerm(false, 1000, 0.1)
    setHygieneRateLongTerm(false, 1000, 0.1)
    setEnergyRateLongTerm(false, 1000, 0.1)
    setExpRateLongTerm(true, 1000, 0.1)
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
            top = 10,
            width = 80,
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
-- Needs Rate Event Handler

local function hungerRateEventHandler( event )
    local params = event.source.params
    changeNeedsLevel(hungerBar, params.increase,params.amount)
end

local function happinessRateEventHandler( event )
    local params = event.source.params
    changeNeedsLevel(happinessBar, params.increase,params.amount)
end

local function hygieneRateEventHandler( event )
    local params = event.source.params
    changeNeedsLevel(hygieneBar, params.increase,params.amount)
end

local function energyRateEventHandler( event )
    local params = event.source.params
    changeNeedsLevel(energyBar, params.increase,params.amount)
end

local function expRateEventHandler( event )
    local params = event.source.params
    changeNeedsLevel(expBar, params.increase,params.amount)
end

-- ------------------------------------------------
-- Adds forever increasing/decreasing needs level

function setHungerRateLongTerm(increasing, rate, amount) -- increasing is boolean val which shows that rate should increase if true
                                                         -- rate is frequency of the change, amount is the magnitude of change
    if (hunger_tm ~= nil) then
        timer.cancel(hunger_tm)
    end
    hunger_tm = timer.performWithDelay(rate, hungerRateEventHandler, -1) -- rate 1000 = 1sec, -1 is infinite interations
    hunger_tm.params = {increase=increasing,amount=amount}
end

function setHappinessRateLongTerm(increasing, rate, amount)
    if (happiness_tm ~= nil) then
        timer.cancel(happiness_tm)
    end
    happiness_tm = timer.performWithDelay(rate, happinessRateEventHandler, -1)
    happiness_tm.params = {increase=increasing,amount=amount}
end

function setHygieneRateLongTerm(increasing, rate, amount)
    if (hygiene_tm ~= nil) then
        timer.cancel(hygiene_tm)
    end
    hygiene_tm = timer.performWithDelay(rate, hygieneRateEventHandler, -1)
    hygiene_tm.params = {increase=increasing,amount=amount}
end

function setEnergyRateLongTerm(increasing, rate, amount)
    if (energy_tm ~= nil) then
        timer.cancel(energy_tm)
    end
    energy_tm = timer.performWithDelay(rate, energyRateEventHandler, -1)
    energy_tm.params = {increase=increasing,amount=amount}
end

function setExpRateLongTerm(increasing, rate, amount)
    if (exp_tm ~= nil) then
        timer.cancel(exp_tm)
    end
    exp_tm = timer.performWithDelay(rate, expRateEventHandler, -1)
    exp_tm.params = {increase=increasing,amount=amount}
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

function enableTouch()
    isTouchAble = true
end

function hideShowAllIcons(iconsTable)
    xAxis = {75,30,-30,-75} -- idx 1=feed, 2=sleep/wakeup, 3=clean, 4=play
    yAxis = {65,100,100,65}
    monster = getMonster()

    isTouchAble = false
    if (iconsTable[1].alpha) == 0 then -- Show Icons
        for i = 1, #iconsTable do
            iconsTable[i].isTouchEnabled = true
            transition.to(iconsTable[i], 
                {x = monster.x + xAxis[i], y = monster.y - yAxis[i],
                alpha = 1, time = 250})
        end
        currentVisibleList = iconsTable
    else -- Hide Icons
        for i = 1, #iconsTable do
            iconsTable[i].isTouchEnabled = true
            transition.to(iconsTable[i], 
                {x = monster.x, y = monster.y,
                alpha = 0, time = 250})

        end 
        currentVisibleList = nil
    end   
    timer.performWithDelay(250, enableTouch)
end

-- -------------------------------------------------------------------------------
-- Add All Event Listeners Here

function addListeners()
    cacheVariables()
    monster:addEventListener("touch", monsterToggle)
    background:addEventListener("touch", backgroundToggle)
    feedIcon:addEventListener("touch", feedButtonClicked)
    sleepIcon:addEventListener("touch", sleepButtonClicked)
    wakeupIcon:addEventListener("touch", wakeupButtonClicked)
    cleanIcon:addEventListener("touch", cleanButtonClicked)
    playIcon:addEventListener("touch", playButtonClicked)

    mostRecentFoodIcon1:addEventListener("touch", mostRecentFood1Clicked)
    mostRecentFoodIcon2:addEventListener("touch", mostRecentFood2Clicked)
    moreFoodIcon:addEventListener("touch", moreFoodClicked)
    shopIcon:addEventListener("touch", shopButtonClicked)

    mostRecentPlayIcon1:addEventListener("touch", mostRecentPlay1Clicked)
    mostRecentPlayIcon2:addEventListener("touch", mostRecentPlay2Clicked)
    morePlayIcon:addEventListener("touch", morePlayClicked)
end

-- Set reaction when touch monster
function monsterToggle(event)
    if isTouchAble then
        if event.phase == "ended" then
            if (currentVisibleList == nil) then
                hideShowAllIcons(iconsList)
            else 
                hideShowAllIcons(currentVisibleList)
            end
        end
    end
end

function backgroundToggle(event)
    if isTouchAble then
        if event.phase == "ended" then
            if (currentVisibleList ~= nil) then
                hideShowAllIcons(currentVisibleList)
            end
            menuBar:hide()
        end
    end
end

function feedButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(iconsList)
            hideShowAllIcons(foodIconsList)
        end
    end
end

function sleepButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(iconsList)
            changeToSleepState()
        end
    end
end

function wakeupButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(iconsList)
            changeToWakeupState()
        end
    end
end

function cleanButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(iconsList)
            changeToWakeupState()
            cleanPetAnimation()
            changeNeedsLevel(hygieneBar, true, 0.3)
        end
    end
end

function playButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(iconsList)
            hideShowAllIcons(playIconsList)
        end
    end
end

function mostRecentFood1Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(foodIconsList)
            changeToWakeupState()
            feedPetAnimation()
            changeNeedsLevel(hungerBar, true, 0.3)
        end
    end
end

function mostRecentFood2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(foodIconsList)
            changeToWakeupState()
            feedPetAnimation()
            changeNeedsLevel(hungerBar, true, 0.6)
        end
    end
end

function moreFoodClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
        end
    end
end

function shopButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
        end
    end
end

function mostRecentPlay1Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)
            changeToWakeupState()
            playWithPetAnimation()
            changeNeedsLevel(happinessBar, true, 0.3)
        end
    end
end

function mostRecentPlay2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)
            changeToWakeupState()
            playWithPetAnimation()
            changeNeedsLevel(happinessBar, true, 0.6)
        end
    end
end

function morePlayClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
        end
    end
end

-- -------------------------------------------------------------------------------
-- Monster Interaction Animation Here

function feedPetAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
end

function cleanPetAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
end

function playWithPetAnimation()
    setMonsterSequence("happy")
    timer.performWithDelay(1600, setSequenceNormal) -- reset animation to default
end

function changeToSleepState()
    setEnergyRateLongTerm(true, 1000, 0.1)
    table.remove(iconsList, 2)
    table.insert(iconsList, 2, wakeupIcon)
end

function changeToWakeupState()
    setEnergyRateLongTerm(false, 1000, 0.1)
    table.remove(iconsList, 2)
    table.insert(iconsList, 2, sleepIcon)
end