require("data")
require("itemList")
local composer = require("composer")
-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

local monster;
local background;

local sleepWakeID;

local feedIcon;
local sleepIcon;
local wakeupIcon;
local cleanIcon;
local playIcon;

local foodShopIcon;
local toyShopIcon;

local moreFoodIcon;
local morePlayIcon;

local mostRecentFoodIcon1;
local mostRecentFoodIcon2;
local mostRecentPlayIcon1;
local mostRecentPlayIcon2;

local inventoryIcon;

local foodRecentList;
local playRecentList;

local dailyRewardTrueIcon;
local dailyRewardFalseIcon;
-- local rewardTimer;

local iconsList; -- idx 1=play, 2=clean, 3=sleep/wakeup, 4=feed
local foodIconsList;
local playIconsList;
local currentVisibleList;

local maxNeedsLevels; -- 2880 mins = 2days*24hrs*60mins
local needsLevels;
local needsBars;

local isTouchAble;
local inventoryIsShow = false;

local monsterLevel;
local monsterLevelText;

local chageScenceEffect = "crossFade";
local chageSceneTime = 250;
-- -------------------------------------------------------------------------------

function cacheVariables()
    monster = getMonster()
    background = getHomeBackground()

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
    foodShopIcon = getFoodShopIcon()

    mostRecentPlayIcon1 = getMostRecentPlayIcon1()
    mostRecentPlayIcon2 = getMostRecentPlayIcon2()
    morePlayIcon = getMorePlayIcon()
    toyShopIcon = getToyShopIcon()

    inventoryIcon = getInventoryIcon()
    dailyRewardTrueIcon = getDailyRewardTrueIcon()
    dailyRewardFalseIcon = getDailyRewardFalseIcon()

    -- Create lists
    iconsList = {playIcon, cleanIcon, sleepIcon, feedIcon}
    foodIconsList = {foodShopIcon, mostRecentFoodIcon1, mostRecentFoodIcon2, moreFoodIcon}
    playIconsList = {toyShopIcon, mostRecentPlayIcon1, mostRecentPlayIcon2, morePlayIcon}

    -- Instantiate hide/show icons lock
    isTouchAble = true
end

function updateFoodList(frlist,fr1,fr2)
    mostRecentFoodIcon1 = fr1
    mostRecentFoodIcon2 = fr2
    foodIconsList = {foodShopIcon, mostRecentFoodIcon1, mostRecentFoodIcon2, moreFoodIcon}
    foodRecentList = frlist

    mostRecentFoodIcon1:addEventListener("touch", mostRecentFood1Clicked)
    mostRecentFoodIcon2:addEventListener("touch", mostRecentFood2Clicked)
end

function updatePlayList(prlist,pr1,pr2)
    mostRecentPlayIcon1 = pr1
    mostRecentPlayIcon2 = pr2
    playIconsList = {toyShopIcon, mostRecentPlayIcon1, mostRecentPlayIcon2, morePlayIcon}
    playRecentList = prlist

    mostRecentPlayIcon1:addEventListener("touch", mostRecentPlay1Clicked)
    mostRecentPlayIcon2:addEventListener("touch", mostRecentPlay2Clicked)
end
-- -------------------------------------------------------------------------------
-- Setup The Decrement Rate

function setDecrementRate()
    print("set all rate")
    setRateLongTerm("hunger", 1000, getHungerRate())
    setRateLongTerm("happiness", 1000, getHappinessRate())
    setRateLongTerm("hygiene", 1000, getHygieneRate())
    -- Need sleepWakeID for canceling old loop before assign new one
    sleepWakeID = setRateLongTerm("energy", 1000, getEnergyRate())
end

-- -------------------------------------------------------------------------------
-- Hide / Show Icons with Lock

function enableHomeTouch()
    isTouchAble = true
end

function disableHomeTouch()
    isTouchAble = false
end

function hideShowAllIcons(iconsTable)
    xAxis = {-110*resizer,-45*resizer,45*resizer,110*resizer} -- idx 1=play, 2=clean, 3=sleep/wakeup, 4=feed
    yAxis = {70*resizer,120*resizer,120*resizer,70*resizer}
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
    timer.performWithDelay(250, enableHomeTouch)
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
                if (#foodRecentList > 0) then
                    feedAnimation()
                    useItem(itemList[foodRecentList[1]])
                end
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
                    useItem(itemList[foodRecentList[2]])
                end
            end
        end
    end
end

function moreFoodClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
            showInventory("food")
        end
    end
end

function foodShopButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
            local options = 
            {
              effect = chageScenceEffect, 
              time = chageSceneTime, 
              params = {tab = "food"}
            }
            composer.gotoScene("shop", options)
        end
    end
end

function mostRecentPlay1Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)
            if (playRecentList ~= nil) then
                if (#playRecentList > 0) then
                    useItem(itemList[playRecentList[1]])
                end
            end
        end
    end
end

function mostRecentPlay2Clicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(playIconsList)
            if (playRecentList ~= nil) then
                if (#playRecentList > 1) then
                    useItem(itemList[playRecentList[2]])
                end
            end
        end
    end
end

function morePlayClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
            showInventory("toy")
        end
    end
end

function toyShopButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(currentVisibleList)
            local options = 
            {
              effect = chageScenceEffect, 
              time = chageSceneTime, 
              params = {tab = "toy"}
            }
            composer.gotoScene("shop", options)
        end
    end
end

function inventoryClicked(event)
    if event.phase == "ended" then
        if inventoryIsShow then
            composer.gotoScene(composer.getSceneName("current"))
            inventoryIsShow = false
        else
            showInventory("all")
        end
    end
end

function showInventory(selectedTab)
    local options = {params = {tab = selectedTab}}
    composer.showOverlay("inventory", options)
    inventoryIsShow = true
end
-- -------------------------------------------------------------------------------
-- Daily Reward Functions

function getDailyReward()
    p = math.random()
    if p >= 0.35 then
        -- get random item
        r = math.random(#itemList)
        item = itemList[itemList[r]]
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
    saveData()
end

function isItRewardTime() -- calculates how much time is left for reward, returns false if done
    -- lastTime = loadLastRewardDate()
    local receiveDate = getReceiveDate()
    local currentDate = os.date( '*t' )

    if receiveDate == nil then -- receiveDate is false if user has never gotten daily reward before
        dailyRewardTrueIcon.alpha = 1
        dailyRewardFalseIcon.alpha = 0
        return false, currentDate, nil
    end

    setTime = os.time{  year = receiveDate.year, month = receiveDate.month, day = receiveDate.day,
                        hour = receiveDate.hour, min = receiveDate.min, sec = receiveDate.sec }
    endTime = os.time{  year = currentDate.year, month = currentDate.month, day = currentDate.day,
                        hour = currentDate.hour, min = currentDate.min, sec = currentDate.sec }

    local rewardTimer = ( endTime - setTime ) -- difference in seconds
    -- print(rewardTimer)
    -- set to 5 seconds for now for testing
    limit = 24*60*60 -- 24 hours in sec
    
    if rewardTimer >= limit then
        dailyRewardTrueIcon.alpha = 1
        dailyRewardFalseIcon.alpha = 0
        return true, currentDate, rewardTimer 
    end
    return false, currentDate, rewardTimer
end

function rewardIconClicked(event)
    if event.phase == "ended" then
        timeleft, currentDate, rewardTimer = isItRewardTime()
        if timeleft == true or rewardTimer == nil then -- if the timer is done
            -- reward animation

            -- add to inventory
            getDailyReward()
            print("GET REWARD!")

            -- reset timer and save date
            -- saveRewardTimerData()
            setReceiveDate(currentDate)
            

            --change visibility
            dailyRewardTrueIcon.alpha = 0
            dailyRewardFalseIcon.alpha = 1

        else -- if the timer is still ticking
            -- show timer
            tmp = 24*60*60 - rewardTimer
            print(tmp)
            hours = math.floor(tmp/(60*60))
            minutes = math.floor((tmp - (hours*60*60)) / 60)
            seconds = tmp - (minutes*60) - (hours*60*60)
            timeDisplay = string.format( "%02d:%02d:%02d", hours, minutes, seconds )
            clockText = display.newText(timeDisplay, display.contentCenterX, display.contentCenterY*0.7, native.systemFontBold, 80)
            clockText:setFillColor( 0.0, 0.0, 0.0 )
            transition.fadeOut( clockText, { time=1500 } )
        end
    end
end

-- -------------------------------------------------------------------------------
-- EXP functions

function giveTakeCareEXP(expGain, needBar) -- Unless the NeedBar is less than 90%,
    if needBar:getProgress() < 0.9 then     -- this function give exp to our tamagotchi
      increaseEXP(expGain)
    end
end

function increaseEXP(expGain) -- give exp and check the bar that Level up or not
    local exp = (getExpLevel() + expGain) - getMaxNeedsLevels().exp 
    changeNeedsLevel("exp", expGain)
    if exp >= 0 then
        levelUp(exp)
        setNeedLevel("exp", exp)
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
    moreFoodIcon:addEventListener("touch", moreFoodClicked)
    moreFoodIcon:addEventListener("touch", inventoryClicked)
    foodShopIcon:addEventListener("touch", foodShopButtonClicked)

    mostRecentPlayIcon1:addEventListener("touch", mostRecentPlay1Clicked)
    mostRecentPlayIcon2:addEventListener("touch", mostRecentPlay2Clicked)
    morePlayIcon:addEventListener("touch", morePlayClicked)
    morePlayIcon:addEventListener("touch", inventoryClicked)
    toyShopIcon:addEventListener("touch", toyShopButtonClicked)

    inventoryIcon:addEventListener("touch", inventoryClicked)

    dailyRewardTrueIcon:addEventListener("touch", rewardIconClicked)
    dailyRewardFalseIcon:addEventListener("touch", rewardIconClicked)
    timer.performWithDelay(1000, isItRewardTime, -1)
    -- timer.performWithDelay(1000, updateTime, -1 )
end
