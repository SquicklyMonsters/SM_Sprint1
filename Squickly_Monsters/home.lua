-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("homepage.background")
require("homepage.monster")
require("homepage.interactions")
require("menubar")
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

local menuBar;
-- -------------------------------------------------------------------------------

-- Non-scene functions go Here

-- -------------------------------------------------------------------------------

-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view

    -- Setup layer
    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()

	-- Set background
    setUpBackground()
    background = getBackground()

    -- Set Up Monster
    setUpMonster("img/sprites/egg_sprites_all.png")
    monster = getMonster()

    -- Set up Needs Bar
    setupAllNeedsBars()
    hungerBar = getHungerBar()
    happinessBar = getHappinessBar()
    hygieneBar = getHygieneBar()
    energyBar = getEnergyBar()
    expBar = getExpBar()

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

		-- Set up menu bar
		setUpMenuBar()
		menuBar = getMenuBar()

	-- Add display objects into group
    -- ============BACK===============
    back:insert(background)
    -- ===========MIDDLE==============
    middle:insert(monster)
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
    front:insert(hungerBar)
    front:insert(happinessBar)
    front:insert(hygieneBar)
    front:insert(energyBar)
    front:insert(expBar)
		front:insert(menuBar)
    -- ===============================

    -- Set up all Event Listeners
    addListeners()
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
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
