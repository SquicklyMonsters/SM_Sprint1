-- -----------------------------------------------------------------------------------------------------------------
require('inventory.interactions')
-- Local variables go Here
local resizer = display.contentHeight/320;

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

-- -----------------------------------------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------------------------------------
--Setup functions



function setupGround()
	blocks = display.newGroup()
	--setup some variables that we will use to position the ground
	groundMin = 420*resizer
	groundMax = 340*resizer
	groundLevel = groundMin
	speed = 5

	--Event identifiers
	inEvent = 0
	eventRun = 0

	--this for loop will generate all of your ground pieces, we are going to
	--make 8 in all.
	for a = 1, 8, 1 do
		local newBlock
		isDone = false
		numGen = math.random(3) --get a random number between 1 and 2
		if(numGen == 1 and isDone == false) then
			newBlock = display.newImage("img/squicklyrun/ground1.png")
			newBlock:scale(resizer,resizer)
			isDone = true
		end
	 
		if(numGen == 2 and isDone == false) then
			newBlock = display.newImage("img/squicklyrun/ground2.png")
			newBlock:scale(resizer,resizer)
			isDone = true
		end
	 
		if(numGen == 3 and isDone == false) then
			newBlock = display.newImage("img/squicklyrun/ground3.png")
			newBlock:scale(resizer,resizer)
			isDone = true
		end
	 
		newBlock.name = ("block" .. a) -- name to keep track of blocks
		newBlock.id = a
		 
		--because a is a variable that is being changed each run we can assign
		--values to the block based on a. In this case we want the x position to
		--be positioned the width of a block apart.
		newBlock.x = a*newBlock.width - newBlock.width
		newBlock.y = groundLevel
		blocks:insert(newBlock)
	end

end

function setupScoreAndGameOver()
	score = getScore()
	score = 0

	gameOver = getGameOver()
	gameOver = display.newImage("img/squicklyrun/gameOver.png")
	gameOver:scale(resizer,resizer)
	gameOver.name = "gameOver"
	gameOver.x = 0*resizer
	gameOver.y = 500*resizer

	local options = {
		text = "score: " .. score,
		x = 50*resizer,
		y = 30*resizer,
		font = native.systemFontBold,   
		fontSize = 18*resizer,
		align = "left",
	}
	scoreText = display.newText(options);
end

function setupSprite()
	local imgsheetSetup = {
		width = 100,
		height = 100,
		numFrames = 3
	}
	local spriteSheet = graphics.newImageSheet("img/squicklyrun/heroSpriteSheet.png", imgsheetSetup);
	
	local sequenceData = {
		{ name = "running", start = 1, count = 6, time = 600, loopCount = 0},
		{ name = "jumping", start = 7, count = 7, time = 1, loopCount = 1 }
	}
	
	--Hero Animation
	hero = getHero()
	hero = display.newSprite(spriteSheet, sequenceData);
	hero:scale(resizer,resizer)
	hero:setSequence("running")
	hero:play()

	-- Hero Attributes
	hero.x = 60*resizer
	hero.y = 200*resizer
	hero.gravity = -6
	hero.accel = 0
	hero.isAlive = true

	--rectangle used for our collision detection it will always be in front of the hero sprite
	--that way we know if the hero hit into anything
	collisionRect = getCollisionRect()
	collisionRect = display.newRect(hero.x + 36*resizer, hero.y, 1, 70)
	collisionRect:scale(resizer,resizer)
	collisionRect.strokeWidth = 1
	collisionRect:setFillColor(140, 140, 140)
	collisionRect:setStrokeColor(180, 180, 180)
	collisionRect.alpha = 0
end

function setupObstaclesAndEnemies()
	ghosts = display.newGroup()
	spikes = display.newGroup()
	blasts = display.newGroup()
	boss = display.newGroup()
	bossSpits = display.newGroup()

	--create ghosts and set their position to be off-screen
	for a = 1, 3, 1 do
		local ghost = display.newImage("img/squicklyrun/ghost.png")
		ghost:scale(resizer,resizer)
		ghost.name = ("ghost" .. a)
		ghost.id = a
		ghost.x = 800*resizer
		ghost.y = 600*resizer
		ghost.speed = 0
			--variable used to determine if they are in play or not
		ghost.isAlive = false
			--make the ghosts transparent and more... ghostlike!
		ghost.alpha = .5
		ghosts:insert(ghost)
	end
	--create spikes
	for a = 1, 3, 1 do
		local spike = display.newImage("img/squicklyrun/spikeBlock.png")
		spike:scale(resizer,resizer)
		spike.name = ("spike" .. a)
		spike.id = a
		spike.x = 900*resizer
		spike.y = 500*resizer
		spike.isAlive = false
		spikes:insert(spike)
	end
	--create blasts
	blasts = getBlasts()
	for a=1, 5, 1 do
		local blast = display.newImage("img/squicklyrun/blast.png")
		blast:scale(resizer,resizer)
		blast.name = ("blast" .. a)
		blast.id = a
		blast.x = 800*resizer
		blast.y = 500*resizer
		blast.isAlive = false
		blasts:insert(blast)
	end

	boss = display.newImage("img/squicklyrun/boss.png", 150, 150)
	boss:scale(resizer,resizer)
	boss.x = 300*resizer
	boss.y = 550*resizer
	boss.isAlive = false
	boss.health = 10
	boss.goingDown = true
	boss.canShoot = false
	--spitCycle is the only thing that is not self explantory
	--every time we move a ground piece back to the right of the
	--screen we update the score by one. Now we also update the
	--spite cycle. Every time spitCycle is a multiple of three
	--the boss will shoot his projectile. This just keeps track
	--of that for us!
	boss.spitCycle = 0
	for a=1, 3, 1 do
		local bossSpit = display.newImage("img/squicklyrun/bossSpit.png")
		bossSpit:scale(resizer,resizer)
		bossSpit.x = 400*resizer
		bossSpit.y = 550*resizer
		bossSpit.isAlive = false
		bossSpit.speed = 3
		bossSpits:insert(bossSpit)
	end






end

-- -----------------------------------------------------------------------------------------------------------------
--Update functions

--THIS IS THE ONLY UPDATE FUNCTION THAT STAYS HERE FOR NOW IF YOU MOVE IT'LL GLITCH REAL HARD. I AM LAZY TO FIGURE OUT
--WHY FOR NOW.
function updateBlocks()
	blocks = getBlocks()
	for a = 1, blocks.numChildren, 1 do
		if(a > 1) then
			newX = (blocks[a - 1]).x + 79
		else
			newX = (blocks[8]).x + 79 - speed
		end
		if((blocks[a]).x < -40) then
			--only update the score if the boss is not alive
			if (boss.isAlive == false) then
				score = getScore()
				scoreText = getScoreText()
				score = score + 1
				scoreText.text = "score: " .. score
			else
				--have the boss spit every three block passes
				boss = getBoss()
				boss.spitCycle = boss.spitCycle + 1
				if(boss.y > 100 and boss.y < 300 and boss.spitCycle%3 == 0) then
					for a=1, bossSpits.numChildren, 1 do
						if(bossSpits[a].isAlive == false) then
							bossSpits[a].isAlive = true
							bossSpits[a].x = boss.x - 35
							bossSpits[a].y = boss.y + 55
							bossSpits[a].speed = math.random(5,10)
							break
						end
					end
				end
			end
			if(inEvent == 15) then
				groundLevel = groundMin
			end

			if(inEvent == 11) then
				(blocks[a]).x, (blocks[a]).y = newX, 600
			else
				(blocks[a]).x, (blocks[a]).y = newX, groundLevel
			end

			--by setting up the spikes this way we are guaranteed to
			--only have 3 spikes out at most at a time.

			if(inEvent == 12) then
				for a=1, spikes.numChildren, 1 do
					if(spikes[a].isAlive == true) then
						--do nothing
					else
						spikes[a].isAlive = true
						spikes[a].y = groundLevel - 200
						spikes[a].x = newX
						break
					end
				end
			end
			checkEvent()
		else
			(blocks[a]):translate(speed * -1, 0)
		end
	end
end



function gameOverScreen()
	--stop the hero
	speed = 0
	hero.isAlive = false
	--this simply pauses the current animation
	hero:pause()
	gameOver.x = display.contentWidth*.65
	gameOver.y = display.contentHeight/2
	score = getScore()
end


-- -------COLLISIONS------------------------------------------------------------------------------------------------








-- -----------------------------------------------------------------------------------------------------------------



--Event Handlers

--this is the function that handles the jump events. If the screen is touched on the left side
--then make the hero jump



function checkEvent()
	--first check to see if we are already in an event, we only want 1 event going on at a time
	eventRun = getEventRun()
	inEvent = getInEvent()
	--boss = getBoss()
	score = getScore()
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
	blocks = getBlocks()
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

	backgroundfar = getBackgroundfar()
	backgroundnear1= getBackgroundnear1()
	backgroundnear2 = getBackgroundnear2()

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

-- GET FUNCTIONS BELOW-------------------------------------------------------------

function getScore()
	return score
end

function getSpeed()
	return speed
end

function getBlocks()
	return blocks
end


function getGameOver()
	return gameOver
end

function getScoreText()
	return scoreText
end

function getHero()
	-- print ("hi" .. hero)
	return hero
end

function getCollisionRect()
	return collisionRect
end

function getSpikes()
	return spikes
end

function getBlasts()
	return blasts
end

function getGhosts()
	return ghosts
end

function getBoss()
	return boss
end

function getBossSpits()
	return bossSpits
end

function getGroundMin()
	return groundMin
end

function getGroundMax()
	return groundMax
end

function getGroundLevel()
	return groundLevel
end

function getInEvent()
	return inEvent
end

function getEventRun()
	return eventRun
end

function getIsDone()
	return isDone
end

function getNumGen()
	return numGen
end