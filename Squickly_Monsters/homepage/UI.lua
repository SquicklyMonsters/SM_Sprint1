require("data")
require("loadgame")
require("itemList")
require("inventory.interactions")
local widget = require( "widget" )
local composer = require( "composer" )
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

local invenList;
local itemQuantities;
local gold;
local platinum;

local itemList = getItemList();

local needsLevels;
local needsBars;
local needsIcons;
local maxNeedsLevels; -- 2880 mins = 2days*24hrs*60mins

local thoughtClouds;
local checkHungerID;
local checkTiredID;
local checkHappinessID;

local monsterLevel;
local monsterText;
-- -------------------------------------------------------------------------------

-- TODO change to function
-- Display level text

-- -------------------------------------------------------------------------------
-- Set up needs bar
function setUpNeedsBar(fileName, fileIcon, left)
    local options = {
        width = 100,
        height = 430,
        numFrames = 2,
        sheetContentWidth = 200,
        sheetContentHeight = 430,
    }
    local progressSheet = graphics.newImageSheet( fileName, options )

    bar = widget.newProgressView(
        {
            sheet = progressSheet,
            -- Empty bar frame
            fillOuterMiddleFrame = 2,
            fillOuterWidth = 0,
            fillOuterHeight = display.contentHeight/10,
            -- Full bar frame
            fillInnerMiddleFrame = 1,
            fillWidth = 0,
            fillHeight = display.contentHeight/10,

            left = left,
            top = display.contentHeight/50,
            width = display.contentWidth/7,
            isAnimated = true
        }
    )

    icon = display.newImage(fileIcon, left, display.contentHeight/15)
    scale = display.contentHeight/320
    icon:scale(scale,scale)
    return bar, icon
end

function setNeedLevel(need, lvl)
    -- Prevent lvl going over 100% and below 0%
    if lvl > maxNeedsLevels[need] then
        lvl = maxNeedsLevels[need]
    elseif lvl < 0 then
        lvl = 0
    end
    -- For saving the value
    needsLevels[need] = lvl
    setNeedsLevels(needsLevels)
    -- Make change on need bar
    needsBars[need]:setProgress(lvl/maxNeedsLevels[need])
end

function setupAllNeedsBars()
    -- Starting x-axis and spacing between bars
    local startX = display.contentWidth/20
    local spacing = display.contentWidth/5
    local barsDir = "img/bars/"
    -- TODO: Update Bar files
    needsBars = {}
    needsIcons = {}
    needsBars.hunger, needsIcons.hunger = setUpNeedsBar(barsDir .. "HUNGER_BAR.png", barsDir .. "HUNGER_ICON.png", startX)
    needsBars.happiness, needsIcons.happiness = setUpNeedsBar(barsDir .. "HAPPINESS_BAR.png", barsDir .. "HAPPINESS_ICON.png", startX + spacing)
    needsBars.hygiene, needsIcons.hygiene = setUpNeedsBar(barsDir .. "HYGIENE_BAR.png", barsDir .. "HYGIENE_ICON.png", startX + spacing*2)
    needsBars.energy, needsIcons.energy = setUpNeedsBar(barsDir .. "ENERGY_BAR.png", barsDir .. "ENERGY_ICON.png", startX + spacing*3)
    needsBars.exp, needsIcons.exp = setUpNeedsBar(barsDir .. "EXP_BAR.png", barsDir .. "EXP_ICON.png", startX + spacing*4)

    -- Load data from save
    needsLevels = getNeedsLevels()
    maxNeedsLevels = getMaxNeedsLevels()

    -- Set All Needs Level
    setNeedLevel("hunger", needsLevels.hunger)
    setNeedLevel("happiness", needsLevels.happiness)
    setNeedLevel("hygiene", needsLevels.hygiene)
    setNeedLevel("energy", needsLevels.energy)
    setNeedLevel("exp", needsLevels.exp)

end
-- -------------------------------------------------------------------------------
-- Setup All Icons Here

function setUpAllIcons()
    local resizer = display.contentHeight/320

    local iconsDir = "img/icons/UIIcons/"
    feedIcon = setUpIcon(iconsDir .. "feedIcon.png", 0.4*resizer)
    sleepIcon = setUpIcon(iconsDir .. "sleepIcon.png", 0.5*resizer)
    wakeupIcon = setUpIcon(iconsDir .. "wakeupIcon.png", 0.75*resizer)
    cleanIcon = setUpIcon(iconsDir .. "cleanIcon.png", 0.4*resizer)
    playIcon = setUpIcon(iconsDir .. "playIcon.png", 0.4*resizer)
    mostRecentFoodIcon1 = setUpIcon(iconsDir .. "blank.png", 0.4*resizer)
    mostRecentFoodIcon2 = setUpIcon(iconsDir .. "blank.png", 0.4*resizer)
    moreFoodIcon = setUpIcon(iconsDir .. "optionsIcon.png", 0.7*resizer)
    shopIcon = setUpIcon(iconsDir .. "shopIcon.png", 0.4*resizer)
    mostRecentPlayIcon1 = setUpIcon(iconsDir .. "blank.png", 0.4*resizer)
    mostRecentPlayIcon2 = setUpIcon(iconsDir .. "blank.png", 0.4*resizer)
    morePlayIcon = setUpIcon(iconsDir .. "optionsIcon.png", 0.7*resizer)

    inventoryIcon  = setUpIcon(iconsDir .. "inventoryIcon.png", 1.2*resizer, display.contentWidth*0.06, display.contentHeight*0.84, 1)

    dailyRewardTrueIcon = setUpIcon(iconsDir .. "RewardTrue.png", 1*resizer, display.contentWidth*0.06, display.contentHeight*.6, 0)
    dailyRewardFalseIcon = setUpIcon(iconsDir .. "RewardFalse.png", 0.8*resizer, display.contentWidth*0.06, display.contentHeight*.6, 1)

    hungerThoughtCloud = setUpIcon(iconsDir.. "hungry.png", 0.75*resizer, getMonster().x + 60*resizer, getMonster().y - 20*resizer)
    tiredThoughtCloud = setUpIcon(iconsDir.. "tired.png", 0.75*resizer, getMonster().x - 35*resizer, getMonster().y - 20*resizer)
    thoughtClouds = {hungerThoughtCloud, tiredThoughtCloud}
    
    invenList, foodRecentList, playRecentList, itemQuantities, gold, platinum = getInventoryData()
    updateFoodIcons()
    updatePlayIcons()
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
-- Monster Level Functions

function setUpMonsterLevel()
    levelsTextOptions = {
        text = getMonsterLevel(),
        x = 17*display.contentWidth/20,
        y = display.contentHeight/14,
        font = native.systemFontBold,
        fontSize = 18*display.contentHeight/320,
        align = "center",};
    levelsText = display.newText(levelsTextOptions)
    levelsText:setFillColor( 1, 0, 0 ) -- fill the text red
end

function levelUp(exp)  -- Level up then change text and set exp bar to = 0
    monsterLevelText = getMonsterLevelText()
    monsterLevel = getMonsterLevel()

    monsterLevel = monsterLevel + 1
    monsterLevelText.text = monsterLevel
    
    setNeedLevel("exp", exp)
    setMonsterLevel(monsterLevel)
    saveData()
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
    setNeedLevel(need, needsLevels[need] + change)
end
-- -----------------------------------------------------------------------------
-- Update most recent icons

function isInMostRecentFood(name)
    for i, foodName in ipairs(foodRecentList) do
        -- If item exists in inventory: return its index
        if foodName == name then
            return i
        end
    end
    return false
end

function isInMostRecentPlay(name)
    for i, toyName in ipairs(playRecentList) do
        -- If item exists in inventory: return its index
        if toyName == name then
            return i
        end
    end
    return false
end

function updateFoodIcons()
    if (foodRecentList[1] ~= nil) then
        mostRecentFoodIcon1 = setUpIcon(itemList[foodRecentList[1]].image, 0.75)
    else
        mostRecentFoodIcon1 = setUpIcon("img/icons/UIIcons/blank.png", 0.47)
    end

    if (foodRecentList[2] ~= nil) then
        mostRecentFoodIcon2 = setUpIcon(itemList[foodRecentList[2]].image, 0.75)
    else
        mostRecentFoodIcon2 = setUpIcon("img/icons/UIIcons/blank.png", 0.47)
    end
    updateFoodList(foodRecentList,mostRecentFoodIcon1,mostRecentFoodIcon2)
end

function updatePlayIcons()
    if (playRecentList[1] ~= nil) then
        mostRecentPlayIcon1 = setUpIcon(itemList[playRecentList[1]].image, 0.75)
    else
        mostRecentPlayIcon1 = setUpIcon("img/icons/UIIcons/blank.png", 0.47)
    end

    if (playRecentList[2] ~= nil) then
        mostRecentPlayIcon2 = setUpIcon(itemList[playRecentList[2]].image, 0.75)
    else
        mostRecentPlayIcon2 = setUpIcon("img/icons/UIIcons/blank.png", 0.47)
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
        table.insert(foodRecentList,1,latest_food.name)
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
        table.insert(playRecentList,1,latest_toy.name)
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
        delay = ((progress - 0.4) / (-getHungerRate()/maxNeedsLevels.hunger))*1000
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
        delay = ((progress - 0.4) / (-getEnergyRate()/maxNeedsLevels.energy))*1000
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
        delay = ((progress - 0.4) / (-getHappinessRate()/maxNeedsLevels.happiness))*1000
        defaultAnimation()
    end
    checkHappinessID = timer.performWithDelay(delay, checkHappinessEventHandler, 1)
end
-- -------------------------------------------------------------------------------
-- -- Get needs level

-- function getCurrentNeedsLevels()
--     return needsLevels
-- end

-- function getMaxNeedsLevels()
--     return maxNeedsLevels
-- end

-- function getHungerLevel()
--     return needsLevels.hunger
-- end

-- function getHappinessLevel()
--     return needsLevels.happiness
-- end

-- function getHygieneLevel()
--     return needsLevels.hygiene
-- end

-- function getEnergyLevel()
--     return needsLevels.energy
-- end

-- function getExpLevel()
--     return needsLevels.exp
-- end

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

function getHungerIcon()
    return needsIcons.hunger
end

function getHappinessIcon()
    return needsIcons.happiness
end

function getHygieneIcon()
    return needsIcons.hygiene
end

function getEnergyIcon()
    return needsIcons.energy
end

function getExpIcon()
    return needsIcons.exp
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

function getMonsterLevelText()
    return levelsText
end