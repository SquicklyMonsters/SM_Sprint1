local widget = require( "widget" )
local composer = require( "composer" )
require("loadgame")
require("inventory.interactions")
-------------------------------------------------------------------------------
-- Local variables go HERE

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

local itemList;
local itemQuantities;
local gold;
local platinum;

local needsLevels;
local needsBars;
local maxNeedsLevels; -- 2880 mins = 2days*24hrs*60mins

local thoughtClouds;
local checkHungerID;
local checkTiredID;
local checkHappinessID;

-- TODO Move to Data guy
local hungerRate = -10;
local happinessRate = -10;
local hygieneRate = -10;
local energyRate = -10;
-- -----------------------

local TamaLevels = 1;
local TamaLevelsText;
-- -------------------------------------------------------------------------------

-- TODO change to function
-- Display level text
TamaLevelsText = display.newText({
  text = "Level: " .. TamaLevels,
  x = 610,
  y = 40,
  font = native.systemFontBold,
  fontSize = 18,
  align = "right",});
TamaLevelsText:setFillColor( 1, 0, 0 ) -- fill the text red
-- -------------------------------------------------------------------------------
-- Set up needs bar
function setUpNeedsBar(fileName, left)
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
            -- Empty bar frame
            fillOuterMiddleFrame = 1,
            fillOuterWidth = 0,
            fillOuterHeight = display.contentHeight/25,
            -- Full bar frame
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

function setNeedsLevel(need, lvl)
    -- Prevent lvl going over 100% and below 0%
    if lvl > maxNeedsLevels[need] then
        lvl = maxNeedsLevels[need]
    elseif lvl < 0 then
        lvl = 0
    end
    -- For saving the value
    needsLevels[need] = lvl
    -- Make change on need bar
    needsBars[need]:setProgress(lvl/maxNeedsLevels[need])
end

function setupAllNeedsBars()
    -- Starting x-axis and spacing between bars
    local startX = display.contentWidth/10
    local spacing = display.contentWidth/6
    local barsDir = "img/bars/"
    -- TODO: Update Bar files
    needsBars = {}
    needsBars.hunger = setUpNeedsBar(barsDir .. "HappinessBar.png", startX)
    needsBars.happiness = setUpNeedsBar(barsDir .. "HappinessBar.png", startX + spacing)
    needsBars.hygiene = setUpNeedsBar(barsDir .. "HygieneBar.png", startX + spacing*2)
    needsBars.energy = setUpNeedsBar(barsDir .. "EnergyBar.png", startX + spacing*3)
    needsBars.exp = setUpNeedsBar(barsDir .. "EnergyBar.png", startX + spacing*4)

    -- Load data from save
    needsLevels, maxNeedsLevels = getSavedLevels()

    -- Set All Needs Level
    setNeedsLevel("hunger", needsLevels.hunger)
    setNeedsLevel("happiness", needsLevels.happiness)
    setNeedsLevel("hygiene", needsLevels.hygiene)
    setNeedsLevel("energy", needsLevels.energy)
    setNeedsLevel("exp", needsLevels.exp)
end
-- -------------------------------------------------------------------------------
-- Setup All Icons Here

function setUpAllIcons()
    local iconsDir = "img/icons/UIIcons/"
    feedIcon = setUpIcon(iconsDir .. "feedIcon.png", 0.75)
    sleepIcon = setUpIcon(iconsDir .. "sleepIcon.png", 0.5)
    wakeupIcon = setUpIcon(iconsDir .. "wakeupIcon.png", 0.7)
    cleanIcon = setUpIcon(iconsDir .. "cleanIcon.png", 0.5)
    playIcon = setUpIcon(iconsDir .. "playIcon.png", 0.75)
    mostRecentFoodIcon1 = setUpIcon(iconsDir .. "blank.png", 0.57)
    mostRecentFoodIcon2 = setUpIcon(iconsDir .. "blank.png", 0.57)
    moreFoodIcon = setUpIcon(iconsDir .. "optionsIcon.png", 0.75)
    shopIcon = setUpIcon(iconsDir .. "shopIcon.png", 0.5)
    mostRecentPlayIcon1 = setUpIcon(iconsDir .. "blank.png", 0.57)
    mostRecentPlayIcon2 = setUpIcon(iconsDir .. "blank.png", 0.57)
    morePlayIcon = setUpIcon(iconsDir .. "optionsIcon.png", 0.75)

    inventoryIcon  = setUpIcon(iconsDir .. "inventoryIcon.png", 2, display.contentWidth*0.06, display.contentHeight*0.84, 1)

    hungerThoughtCloud = setUpIcon(iconsDir.. "hungry.png", 0.75, getMonster().x +60, getMonster().y -20)
    tiredThoughtCloud = setUpIcon(iconsDir.. "tired.png", 0.75, getMonster().x -35, getMonster().y -20)
    thoughtClouds = {hungerThoughtCloud, tiredThoughtCloud}

    itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum = setUpInventoryData()
    print(itemList)
    updateFoodIcons()
    updatePlayIcons()

    dailyRewardTrueIcon = setUpIcon(iconsDir .. "RewardTrue.png", 1.5, display.contentWidth*0.06, display.contentHeight*.6, 1)
    dailyRewardFalseIcon = setUpIcon(iconsDir .. "RewardFalse.png", 1.2, display.contentWidth*0.06, display.contentHeight*.6, 0)

    hungerThoughtCloud = setUpIcon(iconsDir.. "hungry.png", 0.75, getMonster().x +60, getMonster().y -20)
    tiredThoughtCloud = setUpIcon(iconsDir.. "tired.png", 0.75, getMonster().x -35, getMonster().y -20)
    thoughtClouds = {hungerThoughtCloud, tiredThoughtCloud}
end

function setUpIcon(img, scale, x, y, alpha)
    x = x or getMonster().x
    y = y or getMonster().y
    alpha = alpha or 0

    icon = display.newImage(img, x, y)
    icon:scale(scale, scale)
    icon.alpha = alpha
    return icon
end

-- -------------------------------------------------------------------------------
-- Needs Rate Event Handler

local function needRateEventHandler( event )
    local params = event.source.params
    changeNeedsLevel(params.need, params.change)
end

-- ------------------------------------------------
-- Adds forever increasing/decreasing needs level

function setRateLongTerm(need, rate, amount)
    -- increasing is boolean val which shows that rate should increase if true
    -- rate is frequency of the change, amount is the magnitude of change
    -- rate 1000 = 1sec, -1 is infinite interations
    local tmp = timer.performWithDelay(rate, needRateEventHandler, -1)
    tmp.params = {need=need, change=amount}
    if needBar == energyBar then
        return tmp
    end
end
-- ------------------------------------------------
-- Changing by a certain amount (Still needs to have more calculations later)
function changeNeedsLevel(need, change)
    setNeedsLevel(need, needsLevels[need] + change)
end
-- -----------------------------------------------------------------------------
-- Update most recent icons

function isInMostRecentFood(name)
    for i, food in ipairs(foodRecentList) do
        -- If item exists in inventory: return its index
        if food.name == name then
            return i
        end
    end
    return false
end

function isInMostRecentPlay(name)
    for i, toy in ipairs(playRecentList) do
        -- If item exists in inventory: return its index
        if toy.name == name then
            return i
        end
    end
    return false
end

function updateFoodIcons()
    if (#foodRecentList > 0) then
        mostRecentFoodIcon1 = setUpIcon(foodRecentList[1].image, 0.75)
    else
        mostRecentFoodIcon1 = setUpIcon("img/icons/UIIcons/blank.png", 0.57)
    end

    if (#foodRecentList > 1) then
        mostRecentFoodIcon2 = setUpIcon(foodRecentList[2].image, 0.75)
    else
        mostRecentFoodIcon2 = setUpIcon("img/icons/UIIcons/blank.png", 0.57)
    end
    updateFoodList(foodRecentList,mostRecentFoodIcon1,mostRecentFoodIcon2)
end

function updatePlayIcons()
    if (#playRecentList > 0) then
        mostRecentPlayIcon1 = setUpIcon(playRecentList[1].image, 0.75)
    else
        mostRecentPlayIcon1 = setUpIcon("img/icons/UIIcons/blank.png", 0.57)
    end

    if (#playRecentList > 1) then
        mostRecentPlayIcon2 = setUpIcon(playRecentList[2].image, 0.75)
    else
        mostRecentPlayIcon2 = setUpIcon("img/icons/UIIcons/blank.png", 0.57)
    end
    updatePlayList(playRecentList,mostRecentPlayIcon1,mostRecentPlayIcon2)
end

function updateMostRecentFood(latest_food)
    -- Remove current from recent list first
    if (#foodRecentList > 0) then
        recent_idx = isInMostRecentFood(latest_food.name) -- false, if not in inv
        if recent_idx then
            table.remove(foodRecentList,recent_idx)
        end
    end
    -- Insert food to head of list if in inventory
    if isInInventory(latest_food.name) then
        table.insert(foodRecentList,1,latest_food)
    end
    updateFoodIcons()
end

function updateMostRecentPlay(latest_toy)
    -- Remove current from recent list first
    if (#playRecentList > 0) then
        recent_idx = isInMostRecentPlay(latest_toy.name) -- false, if not in inv
        if recent_idx then
            table.remove(playRecentList,recent_idx)
        end
    end
    -- Insert food to head of list if in inventory
    if isInInventory(latest_toy.name) then
        table.insert(playRecentList,1,latest_toy)
    end
    updatePlayIcons()
end

-- -----------------------------------------------------------------------------
-- Thought Cloud functions

function showThoughtCloud(idx)
    if composer.getSceneName("current") == "home" then
        transition.fadeIn( thoughtClouds[idx], { time=1500 } )
    end
end

function hideThoughtCloud(idx)
    transition.fadeOut( thoughtClouds[idx], { time=1500 } )
end

function checkHungerEventHandler(event)
    if needsBars.hunger:getProgress() < 0.4 then
        showThoughtCloud(1)
    end
    checkHunger()
end

-- Does not need to loop, since we should check again when hunger increase
function checkHunger(delay)
    if (checkHungerID ~= nil) then
        timer.cancel(checkHungerID)
    end
    -- print("Check Hunger")
    local progress = needsBars.hunger:getProgress()
    local delay = delay or 5000
    if progress > 0.4 then
        -- Calculate approximate time that the hunger level will be below 40%
        -- Times 1000 to turn into 1 second, will later need to be change to 1 minute
        delay = ((progress - 0.4) / (-hungerRate/maxNeedsLevels.hunger))*1000
        hideThoughtCloud(1)
    end
    checkHungerID = timer.performWithDelay(delay, checkHungerEventHandler, 1)
end

function checkTiredEventHandler(event)
    if needsBars.energy:getProgress() < 0.4 then
        showThoughtCloud(2)
    end
    -- Later will make predict time to check if energy is over 40%
    -- due to fix rate of increasing in energy when sleep
    checkTired()
end

function checkTired(delay)
    if (checkTiredID ~= nil) then
        timer.cancel(checkTiredID)
    end

    local progress = needsBars.energy:getProgress()
    local delay = delay or 5000
    if progress > 0.4 then
        -- Calculate approximate time that the energy level will be below 40%
        -- Times 1000 to turn into 1 second, will later need to be change to 1 minute
        delay = ((progress - 0.4) / (-energyRate/maxNeedsLevels.energy))*1000
        hideThoughtCloud(2)
    end
    --print("check if tired next in", delay)
    checkTiredID = timer.performWithDelay(delay, checkTiredEventHandler, 1)
end

-- -------------------------------------------------------------------------------
-- Sad Animation

function checkHappinessEventHandler(event)
    if needsBars.happiness:getProgress() < 0.4 then
        if getMonster().sequence ~= "sleep" then
            sadAnimation()
        end
    end
    checkHappiness()
end

-- Does not need to loop, since we should check again when happiness increase
function checkHappiness(delay)
    if (checkHappinessID ~= nil) then
        timer.cancel(checkHappinessID)
    end

    local progress = needsBars.happiness:getProgress()
    local delay = delay or 5000
    if progress > 0.4 then
        -- Calculate approximate time that the happiness level will be below 40%
        -- Times 1000 to turn into 1 second, will later need to be change to 1 minute
        delay = ((progress - 0.4) / (-happinessRate/maxNeedsLevels.happiness))*1000
        defaultAnimation()
    end
    checkHappinessID = timer.performWithDelay(delay, checkHappinessEventHandler, 1)
end
-- -------------------------------------------------------------------------------
-- Get needs level

function getCurrentNeedsLevels()
    return needsLevels
end

function getMaxNeedsLevels()
    return maxNeedsLevels
end

function getHungerLevel()
    return needsLevels.hunger
end

function getHappinessLevel()
    return needsLevels.happiness
end

function getHygieneLevel()
    return needsLevels.hygiene
end

function getEnergyLevel()
    return needsLevels.energy
end

function getExpLevel()
    return needsLevels.exp
end

-- -------------------------------------------------------------------------------
-- Get needs bar

function getHungerBar()
    return needsBars.hunger
end

function getHappinessBar()
    return needsBars.happiness
end

function getHygieneBar()
    return needsBars.hygiene
end

function getEnergyBar()
    return needsBars.energy
end

function getExpBar()
    return needsBars.exp
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

function getFoodRecentList()
    return foodRecentList
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

function getPlayRecentList()
    return playRecentList
end

function getMorePlayIcon()
    return morePlayIcon
end

function getInventoryIcon()
    return inventoryIcon
end

function getDailyRewardTrueIcon()
    return dailyRewardTrueIcon
end

function getDailyRewardFalseIcon()
    return dailyRewardFalseIcon
end

function getHungerThoughtCloud()
    return thoughtClouds[1]
end

function getTiredThoughtCloud()
    return thoughtClouds[2]
end

function getTamaLevelsText()
    return TamaLevelsText
end

function getTamaLevelsNum()
    return TamaLevels
end
