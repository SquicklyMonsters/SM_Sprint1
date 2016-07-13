-- Import dependency
local composer = require( "composer" )
local scene = composer.newScene()

require( 'inventory.interactions' )
-- require( 'menubar' )

require( 'squicklyrun.sr_interactions' )
require( 'squicklyrun.sr_background' )
require( 'squicklyrun.sr_update' )
require( 'squicklyrun.sr_interactions' )
require( 'squicklyrun.sr_pause' )

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here

local screen;
local player;

local updateTimer

-- -------------------------------------------------------------------------------
-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view

    -- Setup layer
    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()


    -- Set background
	setupBackground()
	backbackground = getBackbackground()
	backgroundfar = getBackgroundfar()
	backgroundnear1 = getBackgroundnear1()
	backgroundnear2 = getBackgroundnear2()


    -- set ground
	setupGround()
    blocks = getBlocks()

    -- set obstacles and enemies
    setupObstaclesAndEnemies()
    spikes = getSpikes()
    blasts = getBlasts()
    ghosts = getGhosts()
    boss = getBoss()
    bossSpits = getBossSpits()

    -- set hero
    setupSprite()
    hero = getHero()
    collisionRect = getCollisionRect() --if enemies hit this then gameover, it surrounds him.

    -- set gameover
    setupScoreAndGameOver()
    gameOver = getGameOver()
    scoreText = getScoreText()
    pauseButton = getPauseButton()

	updateTimer = timer.performWithDelay(1, update, 0)

    pauseButton:addEventListener("touch", paused)
	Runtime:addEventListener("touch", touched, -1)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
        -- composer.showOverlay("menubar")
        -- Background
        back:insert(backbackground)
        back:insert(backgroundfar)
        back:insert(backgroundnear1)
        back:insert(backgroundnear2)
        -- ===========MIDDLE==============
        -- Ground
        middle:insert(blocks)
        -- ObstaclesandEnemies
        middle:insert(spikes)
        middle:insert(blasts)
        middle:insert(ghosts)
        middle:insert(boss)
        middle:insert(bossSpits)
        --Sprite
        middle:insert(hero)
        middle:insert(collisionRect)

        -- ===========FRONT===============
        --ScoreAndGameOver
        front:insert(gameOver)
        front:insert(scoreText)
        front:insert(pauseButton)
        -- ===============================
        sceneGroup:insert(back)
        sceneGroup:insert(middle)
        sceneGroup:insert(front)

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
    print("DESTROYED!")
	getReward()
    timer.cancel(updateTimer)
    pauseButton:removeEventListener("touch", paused)
    Runtime:removeEventListener("touch", touched, -1)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene