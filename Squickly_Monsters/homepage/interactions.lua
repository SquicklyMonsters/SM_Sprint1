require("menuBar")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local monster;
local background;
local menuBar;

local sleepWakeID;

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

local maxNeedsLevels; -- 2880 mins = 2days*24hrs*60mins 
local needsLevels;
local needsBars;

local isTouchAble;

-- -------------------------------------------------------------------------------

function cacheVariables()
    monster = getMonster()
    background = getBackground()

    -- Cache Need Levels
    needsLevels = {}
    needsLevels.hunger = getHungerLevel()
    needsLevels.happiness = getHappinessLevel()
    needsLevels.hygiene = getHygieneLevel()
    needsLevels.energy = getEnergyLevel()
    needsLevels.exp = getExpLevel()

    -- Cache Icons
    feedIcon = getFeedIcon()
    sleepIcon = getSleepIcon()
    wakeupIcon = getWakeupIcon()
    cleanIcon = getCleanIcon()
    playIcon = getPlayIcon()
    mostRecentFoodIcon1 = getMostRecentFoodIcon1()
    mostRecentFoodIcon2 = getMostRecentFoodIcon2()
    moreFoodIcon = getMoreFoodIcon()
    shopIcon = getShopIcon()
    mostRecentPlayIcon1 = getMostRecentPlayIcon1()
    mostRecentPlayIcon2 = getMostRecentPlayIcon2()
    morePlayIcon = getMorePlayIcon()

    -- Create lists
    iconsList = {feedIcon, sleepIcon, cleanIcon, playIcon}
    foodIconsList = {moreFoodIcon, mostRecentFoodIcon1, mostRecentFoodIcon2, shopIcon}
    playIconsList = {morePlayIcon, mostRecentPlayIcon1, mostRecentPlayIcon2, shopIcon}

    -- Instantiate hide/show icons lock
    isTouchAble = true

    -- Setup Menu bar and get Menu bar object
    setUpMenuBar()
    menuBar = getMenuBar()
end
-- -------------------------------------------------------------------------------
-- Setup The Decrement Rate

function setDecrementRate()
    setRateLongTerm("hunger", 1000, -10)
    setRateLongTerm("happiness", 1000, -10)
    setRateLongTerm("hygiene", 1000, -10)
    setRateLongTerm("exp", 1000, 10)

    sleepWakeID = setRateLongTerm("energy", 1000, -10)
end

-- -------------------------------------------------------------------------------
-- Hide / Show Icons with Lock

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
-- Set reaction when press button

function monsterClicked(event)
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

function backgroundClicked(event)
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
            changeNeedsLevel("hygiene", 500)
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
            changeNeedsLevel("hunger", 500)
        end
    end
end

function mostRecentFood2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(foodIconsList)
            changeToWakeupState()
            feedPetAnimation()
            changeNeedsLevel("hunger", 1000)
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
            changeNeedsLevel("happiness", 500)
        end
    end
end

function mostRecentPlay2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)
            changeToWakeupState()
            playWithPetAnimation()
            changeNeedsLevel("happiness", 1000)
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
-- Sleep / Wakeup functions

function changeToSleepState()
    cancelOldLoop()
    sleepWakeID = setRateLongTerm("energy", 1000, 10)
    table.remove(iconsList, 2)
    table.insert(iconsList, 2, wakeupIcon)
end

function changeToWakeupState()
    cancelOldLoop()
    sleepWakeID = setRateLongTerm("energy", 1000, -10)
    table.remove(iconsList, 2)
    table.insert(iconsList, 2, sleepIcon)
end

function cancelOldLoop()
    if (sleepWakeID ~= nil) then
        timer.cancel(sleepWakeID)
    end
end

-- -------------------------------------------------------------------------------
-- Add All Event Listeners Here

function addListeners()
    ---- Tag along ----
    cacheVariables()
    setDecrementRate()
    -------------------

    monster:addEventListener("touch", monsterClicked)
    background:addEventListener("touch", backgroundClicked)
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