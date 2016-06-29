-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("homepage.background")
require("homepage.monster")
require("homepage.interactions")
require("homepage.UI")
require("savegame")

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local variables go Here

local back;
local middle;
local front;

local monster;

local feedIcon;
local sleepIcon;
local wakeupIcon;
local cleanIcon;
local playIcon;

local mostRecentFoodIcon1;
local mostRecentFoodIcon2;
local foodRecentList;
local moreFoodIcon;
local shopIcon;
local mostRecentPlayIcon1;
local mostRecentPlayIcon2;
local playRecentList;
local morePlayIcon;
local inventoryIcon;
local dailyRewardTrueIcon;
local dailyRewardFalseIcon;

local itemList;
local itemQuantities;
local gold;
local platinum;

local hungerBar;
local happinessBar;
local hygieneBar;
local energyBar;
local expBar;

local monsterLevelText;
-- -------------------------------------------------------------------------------

-- Non-scene functions go Here
-- -------------------------------------------------------------------------------

-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view

    -- Setup All Data
    loadData()

    -- Setup layer
    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()

	-- Set background
    setUpBackground()
    background = getBackground()

    -- Set Up Monster
    setUpMonster("img/sprites/fireball.png")
    monster = getMonster()

    -- Set up Needs Bar
    setupAllNeedsBars()
    hungerBar = getHungerBar()
    happinessBar = getHappinessBar()
    hygieneBar = getHygieneBar()
    energyBar = getEnergyBar()
    expBar = getExpBar()
    monsterLevelText = setUpMonsterLevel()

    -- Set up all Icons
    setUpAllIcons()
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

    -- setAutoSaveRate(10000)

    -- Set up all Event Listeners
    addListeners()
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase


	if phase == "will" then
        checkHunger(1)
        checkTired(1)
        checkHappiness(1)

		-- Get Tamagotchi Level

        -- Set up all Thought Clouds
        hungerThoughtCloud = getHungerThoughtCloud()
        tiredThoughtCloud = getTiredThoughtCloud()

        -- Add display objects into group
        -- ============BACK===============
        back:insert(background)
        -- ===========MIDDLE==============
        middle:insert(monster)
        middle:insert(hungerBar)
        middle:insert(happinessBar)
        middle:insert(hygieneBar)
        middle:insert(energyBar)
        middle:insert(expBar)
        middle:insert(inventoryIcon)
        middle:insert(dailyRewardTrueIcon)
        middle:insert(dailyRewardFalseIcon)
        -- ===========FRONT===============
        front:insert(feedIcon)
        front:insert(sleepIcon)
        front:insert(wakeupIcon)
        front:insert(cleanIcon)
        front:insert(playIcon)
        front:insert(mostRecentFoodIcon1)
        front:insert(mostRecentFoodIcon2)
        front:insert(moreFoodIcon)
        front:insert(shopIcon)
        front:insert(mostRecentPlayIcon1)
        front:insert(mostRecentPlayIcon2)
        front:insert(morePlayIcon)

		front:insert(levelsText)
        front:insert(hungerThoughtCloud)
        front:insert(tiredThoughtCloud)
        -- ===============================
        sceneGroup:insert(back)
        sceneGroup:insert(middle)
        sceneGroup:insert(front)
        composer.showOverlay("menubar")
        -- composer.showOverlay("inventory")
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
        --composer.hideOverlay()
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
