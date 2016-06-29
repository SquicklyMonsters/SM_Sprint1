require("savegame") -- For Testing
local composer = require("composer")
require("shopList")
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
local foodRecentList;
local mostRecentFoodIcon1;
local mostRecentFoodIcon2;
local moreFoodIcon;
local shopIcon;
local playRecentList;
local mostRecentPlayIcon1;
local mostRecentPlayIcon2;
local morePlayIcon;
local inventoryIcon;
local dailyRewardTrueIcon;
local dailyRewardFalseIcon;
local rewardTimer;

local iconsList; -- idx 1=play, 2=clean, 3=sleep/wakeup, 4=feed
local foodIconsList;
local playIconsList;
local currentVisibleList;

local maxNeedsLevels; -- 2880 mins = 2days*24hrs*60mins
local needsLevels;
local needsBars;

local hungerRate = -10;
local happinessRate = -10;
local hygieneRate = -10;
local energyRate = -10;

local isTouchAble;
local inventoryIsShow = false;

local monsterLevel;
local monsterLevelText;
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
    dailyRewardTrueIcon = getDailyRewardTrueIcon()
    dailyRewardFalseIcon = getDailyRewardFalseIcon()

    -- Create lists
    iconsList = {playIcon, cleanIcon, sleepIcon, feedIcon}
    foodIconsList = {shopIcon, mostRecentFoodIcon1, mostRecentFoodIcon2, moreFoodIcon}
    playIconsList = {shopIcon, mostRecentPlayIcon1, mostRecentPlayIcon2, moreFoodIcon}

    -- Instantiate hide/show icons lock
    isTouchAble = true
end

function updateFoodList(frlist,fr1,fr2)
    mostRecentFoodIcon1 = fr1
    mostRecentFoodIcon2 = fr2
    foodIconsList = {moreFoodIcon, mostRecentFoodIcon1, mostRecentFoodIcon2, shopIcon}
    foodRecentList = frlist

    mostRecentFoodIcon1:addEventListener("touch", mostRecentFood1Clicked)
    mostRecentFoodIcon2:addEventListener("touch", mostRecentFood2Clicked)
end

function updatePlayList(prlist,pr1,pr2)
    mostRecentPlayIcon1 = pr1
    mostRecentPlayIcon2 = pr2
    playIconsList = {morePlayIcon, mostRecentPlayIcon1, mostRecentPlayIcon2, shopIcon}
    playRecentList = prlist

    mostRecentPlayIcon1:addEventListener("touch", mostRecentPlay1Clicked)
    mostRecentPlayIcon2:addEventListener("touch", mostRecentPlay2Clicked)
end
-- -------------------------------------------------------------------------------
-- Setup The Decrement Rate

function setDecrementRate()
    print("set all rate")
    setRateLongTerm("hunger", 1000, hungerRate)
    setRateLongTerm("happiness", 1000, happinessRate)
    setRateLongTerm("hygiene", 1000, hygieneRate)
    -- Need sleepWakeID for canceling old loop before assign new one
    sleepWakeID = setRateLongTerm("energy", 1000, energyRate)
end

-- -------------------------------------------------------------------------------
-- Hide / Show Icons with Lock

function enableTouch()
    isTouchAble = true
end

function hideShowAllIcons(iconsTable)
    xAxis = {-75,-30,30,75} -- idx 1=play, 2=clean, 3=sleep/wakeup, 4=feed
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
            playAnimation()
            hideShowAllIcons(iconsList)
            hideShowAllIcons(playIconsList)
        end
    end
end

function mostRecentFood1Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(foodIconsList)
            if (foodRecentList ~= nil) then
                feedAnimation()
                useItem(foodRecentList[1])
            end
        end
    end
end

function mostRecentFood2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(foodIconsList)

            if (foodRecentList ~= nil) then
                if (#foodRecentList > 1) then
                    feedAnimation()
                    useItem(foodRecentList[2])
                end
            end
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
            composer.gotoScene("shop", "crossFade", 250)
        end
    end
end

function mostRecentPlay1Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)

            if (playRecentList ~= nil) then
                useItem(playRecentList[1])
            end
            -- changeToWakeupState()
            -- playAnimation()
            -- changeNeedsLevel("happiness", 500)
            -- giveTakeCareEXP(250, getHappinessBar())
        end
    end
end

function mostRecentPlay2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)

            if (playRecentList ~= nil) then
                if (#playRecentList > 1) then
                    useItem(playRecentList[2])
                end
            end
            -- changeToWakeupState()
            -- playAnimation()
            -- changeNeedsLevel("happiness", 1000)
            -- giveTakeCareEXP(500,getHappinessBar())
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

function getDailyReward()
    p = math.random()
    if p >= 0.35 then
        -- get random item
        r = math.random(#shopList)
        item = shopList[shopList[r]]
        idx = isInInventory(item.name)
        if idx then
            increaseQuantity(idx)
        else
            addToInventory(item.name)
        end
    else
        if p >= 0.25 then
            -- get gold
            r = math.random(100, 1000)
            updateCurrency(r, 0)
        else
            -- get platinum
            r = math.random(5)
            updateCurrency(0, r)
        end
    end
    saveInventoryData()
end

function isItRewardTime() -- calculates how much time is left for reward, returns false if done
    lastTime = loadLastRewardDate()
    currentTime = os.date( '*t' )

    if lastTime == false then -- lastTime is false if user has never gotten daily reward before
        return false, nil
    end

    setTime = os.time{  year = lastTime.year, month = lastTime.month, day = lastTime.day,
                        hour = lastTime.hour, min = lastTime.min, sec = lastTime.sec }
    endTime = os.time{  year = currentTime.year, month = currentTime.month, day = currentTime.day,
                        hour = currentTime.hour, min = currentTime.min, sec = currentTime.sec }

    rewardTimer = ( endTime - setTime ) -- difference in seconds
    -- print(rewardTimer)
    -- set to 5 seconds for now for testing
    limit = 24*60*60 -- 24 hours in sec
    
    if rewardTimer >= limit then
        dailyRewardTrueIcon.alpha = 1
        dailyRewardFalseIcon.alpha = 0
        return true, rewardTimer
    end
    return false, rewardTimer
end

function rewardIconClicked(event)
    if event.phase == "ended" then
        timeleft = isItRewardTime()
        if timeleft == true or rewardTimer == nil then -- if the timer is done
            -- reward animation

            -- add to inventory
            getDailyReward()
            -- reset timer and save date
            saveRewardTimerData()
            --change visibility
            dailyRewardTrueIcon.alpha = 0
            dailyRewardFalseIcon.alpha = 1
        else -- if the timer is still ticking
            -- show timer
            tmp = 24*60*60 - rewardTimer
            hours = math.floor(tmp/(60*60))
            minutes = math.floor((tmp - (hours*60*60)) / 60)
            seconds = tmp - (minutes*60) - (hours*60*60)
            timeDisplay = string.format( "%02d:%02d:%02d", hours, minutes, seconds )
            clockText = display.newText(timeDisplay, display.contentCenterX, display.contentCenterY*0.7, native.systemFontBold, 80)
            clockText:setFillColor( 0.7, 0.7, 1 )
            transition.fadeOut( clockText, { time=3000 } )
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

-- -------------------------------------------------------------------------------
-- Sleep / Wakeup functions

function changeToSleepState()
    cancelEnergyLoop()
    sleepAnimation()
    sleepWakeID = setRateLongTerm("energy", 100, 10)
    table.remove(iconsList, 3)
    table.insert(iconsList, 3, wakeupIcon)
end

function changeToWakeupState()
    cancelEnergyLoop()
    defaultAnimation()
    sleepWakeID = setRateLongTerm("energy", 1000, -10)
    table.remove(iconsList, 3)
    table.insert(iconsList, 3, sleepIcon)
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
    -- moreFoodIcon:addEventListener("touch", moreFoodClicked)
    moreFoodIcon:addEventListener("touch", inventoryClicked)
    shopIcon:addEventListener("touch", shopButtonClicked)

    mostRecentPlayIcon1:addEventListener("touch", mostRecentPlay1Clicked)
    mostRecentPlayIcon2:addEventListener("touch", mostRecentPlay2Clicked)
    -- morePlayIcon:addEventListener("touch", morePlayClicked)
    morePlayIcon:addEventListener("touch", inventoryClicked)

    inventoryIcon:addEventListener("touch", inventoryClicked)

    dailyRewardTrueIcon:addEventListener("touch", rewardIconClicked)
    dailyRewardFalseIcon:addEventListener("touch", rewardIconClicked)
    timer.performWithDelay(1000, isItRewardTime, -1)
    -- timer.performWithDelay(1000, updateTime, -1 )
end
