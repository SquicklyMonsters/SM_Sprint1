require("savegame") -- For Testing
local composer = require("composer")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local monster;
local background;

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
local inventoryIcon;

local iconsList; -- idx 1=feed, 2=sleep/wakeup, 3=clean, 4=play
local foodIconsList;
local playIconsList;
local currentVisibleList;

local maxNeedsLevels; -- 2880 mins = 2days*24hrs*60mins
local needsLevels;
local needsBars;

local hungerRate = -10;

local isTouchAble;
local inventoryIsShow = false;

local TamaLevels = getTamaLevelsNum();
local TamaLevelsText = getTamaLevelsText();
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
    inventoryIcon = getInventoryIcon()

    -- Create lists
    iconsList = {feedIcon, sleepIcon, cleanIcon, playIcon}
    foodIconsList = {moreFoodIcon, mostRecentFoodIcon1, mostRecentFoodIcon2, shopIcon}
    playIconsList = {morePlayIcon, mostRecentPlayIcon1, mostRecentPlayIcon2, shopIcon}

    -- Instantiate hide/show icons lock
    isTouchAble = true

end
-- -------------------------------------------------------------------------------
-- Setup The Decrement Rate

function setDecrementRate()
    print("set all rate")
    setRateLongTerm("hunger", 1000, hungerRate)
    setRateLongTerm("happiness", 1000, -10)
    setRateLongTerm("hygiene", 1000, -10)
    -- Need sleepWakeID for canceling old loop before assign new one
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
            transition.to(iconsTable[i],
                {x = monster.x + xAxis[i], y = monster.y - yAxis[i],
                alpha = 1, time = 250})
        end
        currentVisibleList = iconsTable
    else -- Hide Icons
        for i = 1, #iconsTable do
            transition.to(iconsTable[i],
                {x = monster.x, y = monster.y,
                alpha = 0, time = 250})

        end
        currentVisibleList = nil
    end
    -- Release lock after icons transition is finish
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
            getMenuBar():hide()
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
            cleanAnimation()
            changeNeedsLevel("hygiene", 500)
            giveTakeCareEXP(100,getHygieneBar())
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
            foodList.burger:eat()
        end
    end
end

function mostRecentFood2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(foodIconsList)
            foodList.fish:eat()
        end
    end
end

function moreFoodClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
            saveNeedsData() -- For Testing
            setAutoSaveRate(20000) -- For Testing
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
            playAnimation()
            changeNeedsLevel("happiness", 500)
            giveTakeCareEXP(250, getHappinessBar())
        end
    end
end

function mostRecentPlay2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)
            changeToWakeupState()
            playAnimation()
            changeNeedsLevel("happiness", 1000)
            giveTakeCareEXP(500,getHappinessBar())
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

function inventoryClicked(event)
    if event.phase == "ended" then
        if inventoryIsShow then
            composer.gotoScene(composer.getSceneName("current"))
            inventoryIsShow = false
        else
            composer.showOverlay("inventory")
            inventoryIsShow = true
        end
    end
end

function giveTakeCareEXP(expGain, needBar) -- Unless the NeedBar is less than 90%,
    if needBar:getProgress() < 0.9 then     -- this function give exp to our tamagotchi
      increaseEXP(expGain)
    end
end

function increaseEXP(expGain) -- give exp and check the bar that Level up or not
    changeNeedsLevel("exp", expGain)
    if getExpBar():getProgress() >= 1 then
       levelUp()
    end
end

function levelUp()  -- Level up then change text and set exp bar to = 0
    TamaLevels = TamaLevels + 1
    TamaLevelsText.text = "Level: " .. TamaLevels
    setNeedsLevel("exp", 0)
end
-- -------------------------------------------------------------------------------
-- Sleep / Wakeup functions

function changeToSleepState()
    cancelEnergyLoop()
    sleepAnimation()
    sleepWakeID = setRateLongTerm("energy", 100, 10)
    table.remove(iconsList, 2)
    table.insert(iconsList, 2, wakeupIcon)
end

function changeToWakeupState()
    cancelEnergyLoop()
    defaultAnimation()
    sleepWakeID = setRateLongTerm("energy", 1000, -10)
    table.remove(iconsList, 2)
    table.insert(iconsList, 2, sleepIcon)
end

function cancelEnergyLoop()
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

    inventoryIcon:addEventListener("touch", inventoryClicked)
end
