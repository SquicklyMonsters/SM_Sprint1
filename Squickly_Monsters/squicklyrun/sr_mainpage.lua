-- Import dependency
local composer = require( "composer" )
local scene = composer.newScene()

require('inventory.interactions')
require('squicklyrun.sr_interactions')
require('squicklyrun.sr_background')
require('squicklyrun.sr_updates')
--require('squicklyrun.sr_collisions')


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here

local screen;
local player;

--insert places
local back;
local middle;
local front;

--Background
local backbackground;
local backgroundfar;
local backgroundnear1;
local backgroundnear2;

--Ground
local blocks;

--ObstaclesandEnemies
local spikes;
local blasts;
local ghosts;
local boss;
local bossSpits;

--Sprite
local hero;
local collisionRect;

--ScoreandGameOver
local gameOver;
local scoreText;


-- -------------------------------------------------------------------------------
-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view

    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()

    --Set background
	setupBackground()
    backbackground = getBackbackground()
    backgroundfar = getBackgroundfar()
    backgroundnear1 = getBackgroundnear1()
    backgroundnear2 = getBackgroundnear2()

	setupGround()
    blocks = getBlocks()


	setupObstaclesAndEnemies()
    spikes = getSpikes()
    blasts = getBlasts()
    ghosts = getGhosts()
    boss = getBoss()
    bossSpits = getBossSpits()

	setupSprite()
    hero = getHero()
    collisionRect = getCollisionRect()

	setupScoreAndGameOver()
    gameOver = getGameOver()
    scoreText = getScoreText()


	--player = getPlayerLayer()

	--sceneGroup:insert( screen )
	--sceneGroup:insert( player )

	timer.performWithDelay(1, update, -1)
	Runtime:addEventListener("touch", touched, -1)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
        -- Add display objects into group
        -- ============BACK===============
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
        -- ===============================
        sceneGroup:insert(back)
        sceneGroup:insert(middle)
        sceneGroup:insert(front)

        restartGame()
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
	--reward
	print (getScore())
	if getScore() ~= nil then
		print("in here!")
		updateCurrency(getScore(), 0)
	end
	--exp
	changeNeedsLevel("exp", getScore()*10)
	changeNeedsLevel("energy", -getScore()*10)
	saveAllData()
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene