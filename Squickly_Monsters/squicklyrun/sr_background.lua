-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here
require('inventory.interactions')
require('squicklyrun.sr_interactions')

--adds an image to our game centered at x and y coordinates
local backbackground;
local backgroundfar;
local backgroundnear1;
local backgroundnear2;

--display groups
local blocks;
local ghosts;
local spikes;
local blasts;
local boss;
local bossSpits;

--main display groups
local screen;
local player;

--setup some variables that we will use to position the ground
local groundMin;
local groundMax;
local groundLevel;
local speed;

--Sprite Hero Character
local hero;
local collisionRect;

--these 2 variables will be the checks that control our event system.
local inEvent;
local eventRun;

--Game score and Game over
local score;
local scoreText;
local gameOver;


--local variables required for each file
-- sr_interactions.lua
-- for get functions
local screen;
local player;
local score;
-- for others




-- SR_INTERACTIONS.LUA--------------------------------------------------------------------------------------------------

-- moved

-- -----------------------------------------------------------------------------------------------------------------
--Setup functions


-- SR_BACKGROUND.LUA  ----------------------------------------------------------------------------------------------
function setupBackground()
	screen = display.newGroup()

	--adds an image to our game centered at x and y coordinates
	backbackground = display.newImage("img/squicklyrun/background.png")
	backbackground.x = display.contentCenterX
	backbackground.y = 160
	 
	backgroundfar = display.newImage("img/squicklyrun/bgfar1.png")
	backgroundfar.x = 480
	backgroundfar.y = 160

	backgroundnear1 = display.newImage("img/squicklyrun/bgnear2.png")
	backgroundnear1.x = 240
	backgroundnear1.y = 160
	 
	backgroundnear2 = display.newImage("img/squicklyrun/bgnear2.png")
	backgroundnear2.x = 760
	backgroundnear2.y = 160


end

function getBackbackground()
    return backbackground
end

function getBackgroundfar()
    return backgroundfar
end

function getBackgroundnear1()
    return backgroundnear1
end

function getBackgroundnear2()
    return backgroundnear2
end

-- SR_INTERACTIONS.LUA -----------------------------------------------------------------------------------------------------

-- moved

-- SR_UPDATE.LUA ------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------
--Update functions
-- moved

-- DON'T KNOW WHERE THIS GOES

function gameOverScreen()
	--stop the hero
	speed = 0
	hero.isAlive = false
	--this simply pauses the current animation
	hero:pause()
	gameOver.x = display.contentWidth*.65
	gameOver.y = display.contentHeight/2
end


-- SR_COLLISIONS.LUA----------------------------------------------------------------------------------------------------

-- MOVED

-- -----------------------------------------------------------------------------------------------------------------
--Event Handlers

--this is the function that handles the jump events. If the screen is touched on the left side
--then make the hero jump
function checkEvent()
	--first check to see if we are already in an event, we only want 1 event going on at a time
	if(eventRun > 0) then
		 --if we are in an event decrease eventRun. eventRun is a variable that tells us how
		  --much longer the event is going to take place. Everytime we check we need to decrement
		  --it. Then if at this point eventRun is 0 then the event has ended so we set inEvent back
		  --to 0.
		eventRun = eventRun - 1
		if(eventRun == 0) then
			inEvent = 0
		end
	end
	 --if we are in an event then do nothing
	if(inEvent > 0 and eventRun > 0) then
		  --Do nothing
	else
		--this is where we spawn the boss after every 30 blocks
		--also control the boss's health from here
		if(boss.isAlive == false and score%30 == 0) then
			boss.isAlive = true
			boss.x = 400
			boss.y = -200
			boss.health = 10
		end

		--if the boss is alive then keep the event set to 15
		--this will prevent the other events from spawning
		if(boss.isAlive == true) then
			inEvent = 15
		else
			--if we are not in an event check to see if we are going to start a new event.
			check = math.random(100)
			--ghost event
			if(check > 60 and check < 73) then
					inEvent = 13
					eventRun = 1
			end
			--the more frequently you want events to happen then
			--greater you should make the checks
			if(check > 72 and check < 81) then
				inEvent = 12
				eventRun = 1
			end
			  --this first event is going to cause the elevation of the ground to change. For this game we
			  --only want the elevation to change 1 block at a time so we don't get long runs of changing
			  --elevation that is impossible to pass so we set eventRun to 1.
			if(check > 80 and check < 99) then
				   --since we are in an event we need to decide what we want to do. By making inEvent another
				   --random number we can now randomly choose which direction we want the elevation to change.
				inEvent = math.random(10)
				eventRun = 1
			elseif(check > 98) then
				inEvent = 11
				eventRun = 2
			end
		end
	end
	 --if we are in an event call runEvent to figure out if anything special needs to be done
	if(inEvent > 0) then
		runEvent()
	end
	--this will be a little bit different as we want this to really
	--make the game feel even more random. change where the ghosts
	--spawn and how fast they come at the hero.
	if(inEvent == 13) then
		for a=1, ghosts.numChildren, 1 do
			if(ghosts[a].isAlive == false) then
				ghosts[a].isAlive = true
				ghosts[a].x = 500
				ghosts[a].y = math.random(-50, 400)
				ghosts[a].speed = math.random(2,4)
				break
			end
		end
	end
end

--this function is pretty simple it just checks to see what event should be happening, then
--updates the appropriate items. Notice that we check to make sure the ground is within a
--certain range, we don't want the ground to spawn above or below whats visible on the screen.
function runEvent()
	if(inEvent < 6) then
		groundLevel = groundLevel + 40
	end
	if(inEvent > 5 and inEvent < 11) then
		groundLevel = groundLevel - 40
	end
	if(groundLevel < groundMax) then
		groundLevel = groundMax
	end
	if(groundLevel > groundMin) then
		groundLevel = groundMin
	end
end

function restartGame()
	--move menu
	gameOver.x = 0
	gameOver.y = 500
	--reset the score
	score = 0
	--reset the game speed
	speed = 5
	--reset the hero
	hero.isAlive = true
	hero.x = 60
	hero.y = 200
	hero:setSequence("running")
	hero:play()
	hero.rotation = 0
	--reset the groundLevel
	groundLevel = groundMin
	for a = 1, blocks.numChildren, 1 do
		blocks[a].x = (a * 79) - 79
		blocks[a].y = groundLevel
	end
	--reset the ghosts
	for a = 1, ghosts.numChildren, 1 do
		ghosts[a].x = 800
		ghosts[a].y = 600
	end
	--reset the spikes
	for a = 1, spikes.numChildren, 1 do
		spikes[a].x = 900
		spikes[a].y = 500
	end
	--reset the blasts
	for a = 1, blasts.numChildren, 1 do
		blasts[a].x = 800
		blasts[a].y = 500
	end
	--reset the boss
	boss.isAlive = false
	boss.x = 300
	boss.y = 550
	--reset the boss's spit
	for a = 1, bossSpits.numChildren, 1 do
	bossSpits[a].x = 400
		bossSpits[a].y = 550
		bossSpits[a].isAlive = false
	end
	--reset the backgrounds
	backgroundfar.x = 480
	backgroundfar.y = 160
	backgroundnear1.x = 240
	backgroundnear1.y = 160
	backgroundnear2.x = 760
	backgroundnear2.y = 160
end

--the only difference in the touched function is now if you touch the
--right side of the screen the hero will fire off a little blue bolt
function touched( event )
	if(event.x < gameOver.x + 150 and event.x > gameOver.x - 150 and event.y < gameOver.y + 95 and event.y > gameOver.y - 95) then

		restartGame()
	else
		if(hero.isAlive == true) then
			if(event.phase == "began") then
				if(event.x < 241) then
					if(onGround) then
						hero.accel = hero.accel + 20
					end
				else
					for a=1, blasts.numChildren, 1 do
						if(blasts[a].isAlive == false) then
							blasts[a].isAlive = true
							blasts[a].x = hero.x + 50
							blasts[a].y = hero.y
							break
						end
					end
				end
			end
		end
	end
end