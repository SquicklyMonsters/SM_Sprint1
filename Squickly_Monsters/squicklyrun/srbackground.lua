-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here

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

function getScreenLayer()
	return screen
end

function getPlayerLayer()
	return player
end

-- -----------------------------------------------------------------------------------------------------------------
--Setup functions

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

	screen:insert(backbackground)
	screen:insert(backgroundfar)
	screen:insert(backgroundnear1)
	screen:insert(backgroundnear2)
end

function setupGround()
	blocks = display.newGroup()
	--setup some variables that we will use to position the ground
	groundMin = 420
	groundMax = 340
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
		numGen = math.random(2) --get a random number between 1 and 2
		if(numGen == 1 and isDone == false) then
			newBlock = display.newImage("img/squicklyrun/ground1.png")
			isDone = true
		end
	 
		if(numGen == 2 and isDone == false) then
			newBlock = display.newImage("img/squicklyrun/ground2.png")
			isDone = true
		end
	 
		newBlock.name = ("block" .. a) -- name to keep track of blocks
		newBlock.id = a
		 
		--because a is a variable that is being changed each run we can assign
		--values to the block based on a. In this case we want the x position to
		--be positioned the width of a block apart.
		newBlock.x = (a * 79) - 79
		newBlock.y = groundLevel
		blocks:insert(newBlock)
	end
	screen:insert(blocks)
end

function setupScoreAndGameOver()
	score = 0

	gameOver = display.newImage("img/squicklyrun/gameOver.png")
	gameOver.name = "gameOver"
	gameOver.x = 0
	gameOver.y = 500

	local options = {
		text = "score: " .. score,
		x = 50,
		y = 30,
		font = native.systemFontBold,   
		fontSize = 18,
		align = "left",
	}
	scoreText = display.newText(options);
	screen:insert(gameOver)
	screen:insert(scoreText)
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
	hero = display.newSprite(spriteSheet, sequenceData);
	hero:setSequence("running")
	hero:play()

	-- Hero Attributes
	hero.x = 110
	hero.y = 200
	hero.gravity = -6
	hero.accel = 0
	hero.isAlive = true

	--rectangle used for our collision detection it will always be in front of the hero sprite
	--that way we know if the hero hit into anything
	collisionRect = display.newRect(hero.x + 36, hero.y, 1, 70)
	collisionRect.strokeWidth = 1
	collisionRect:setFillColor(140, 140, 140)
	collisionRect:setStrokeColor(180, 180, 180)
	collisionRect.alpha = 0

	screen:insert(hero)
	screen:insert(collisionRect)
end

function setupObstaclesAndEnemies()
	ghosts = display.newGroup()
	spikes = display.newGroup()
	blasts = display.newGroup()

	--create ghosts and set their position to be off-screen
	for a = 1, 3, 1 do
		local ghost = display.newImage("img/squicklyrun/ghost.png")
		ghost.name = ("ghost" .. a)
		ghost.id = a
		ghost.x = 800
		ghost.y = 600
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
		spike.name = ("spike" .. a)
		spike.id = a
		spike.x = 900
		spike.y = 500
		spike.isAlive = false
		spikes:insert(spike)
	end
	--create blasts
	for a=1, 5, 1 do
		local blast = display.newImage("img/squicklyrun/blast.png")
		blast.name = ("blast" .. a)
		blast.id = a
		blast.x = 800
		blast.y = 500
		blast.isAlive = false
		blasts:insert(blast)
	end

	screen:insert(spikes)
	screen:insert(blasts)
	screen:insert(ghosts)
end

-- -----------------------------------------------------------------------------------------------------------------
--Update functions

function update( event )
	updateBackgrounds()
	updateSpeed()
	updateHero()
	updateBlocks()
	updateBlasts()
	updateSpikes()
	updateGhosts()
	checkCollisions()
end

function updateBackgrounds()
	--far background movement
	backgroundfar.x = backgroundfar.x - (speed/55)
	
	--near background movement
	backgroundnear1.x = backgroundnear1.x - (speed/5)
	if(backgroundnear1.x < -239) then
		backgroundnear1.x = 760
	end
	
	backgroundnear2.x = backgroundnear2.x - (speed/5)
	if(backgroundnear2.x < -239) then
		backgroundnear2.x = 760
	end
end

function updateSpeed()
	speed = speed + .0005
end

function updateHero()
	--if our hero is jumping then switch to the jumping animation
	--if not keep playing the running animation
	if(hero.isAlive == true) then
		if(onGround) then
			if(wasOnGround) then

			else
				hero:setSequence("running")
				hero:play()
			end
		else
			hero:setSequence("jumping")
			hero:play()
		end
		if(hero.accel > 0) then
			hero.accel = hero.accel - 1
		end
		--update the heros position accel is used for our jump and
		--gravity keeps the hero coming down. You can play with those 2 variables
		--to make lots of interesting combinations of gameplay like 'low gravity' situations
		hero.y = hero.y - hero.accel
		hero.y = hero.y - hero.gravity
	 else
		hero:rotate(5)
	 end
	--update the collisionRect to stay in front of the hero
	collisionRect.y = hero.y
end

function updateBlocks()
	for a = 1, blocks.numChildren, 1 do
		if(a > 1) then
			newX = (blocks[a - 1]).x + 79
		else
			newX = (blocks[8]).x + 79 - speed
		end
		if((blocks[a]).x < -40) then
			score = score + 1
			scoreText.text = "score: " .. score

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

function updateBlasts()
	--for each blast that we instantiated check to see what it is doing
	for a = 1, blasts.numChildren, 1 do
		--if that blast is not in play we don't need to check anything else
		if(blasts[a].isAlive == true) then
			(blasts[a]):translate(5, 0)
			--if the blast has moved off of the screen, then kill it and return it to its original place
			if(blasts[a].x > 550) then
				blasts[a].x = 800
				blasts[a].y = 500
				blasts[a].isAlive = false
			end
		end
		--check for collisions between the blasts and the spikes
		for b = 1, spikes.numChildren, 1 do
			if(spikes[b].isAlive == true) then
				if(blasts[a].y - 25 > spikes[b].y - 120 and blasts[a].y + 25 < spikes[b].y + 120 and spikes[b].x - 40 < blasts[a].x + 25 and spikes[b].x + 40 > blasts[a].x - 25) then
					blasts[a].x = 800
					blasts[a].y = 500
					blasts[a].isAlive = false
					spikes[b].x = 900
					spikes[b].y = 500
					spikes[b].isAlive = false
				end
			end
		end
 
		--check for collisions between the blasts and the ghosts
		for b = 1, ghosts.numChildren, 1 do
			if(ghosts[b].isAlive == true) then
				if(blasts[a].y - 25 > ghosts[b].y - 120 and blasts[a].y + 25 < ghosts[b].y + 120 and ghosts[b].x - 40 < blasts[a].x + 25 and ghosts[b].x + 40 > blasts[a].x - 25) then
					blasts[a].x = 800
					blasts[a].y = 500
					blasts[a].isAlive = false
					ghosts[b].x = 800
					ghosts[b].y = 600
					ghosts[b].isAlive = false
					ghosts[b].speed = 0
				end
			end
		end
	end
end

--check to see if the spikes are alive or not, if they are
--then update them appropriately
function updateSpikes()
	for a = 1, spikes.numChildren, 1 do
		if(spikes[a].isAlive == true) then
			(spikes[a]):translate(speed * -1, 0)
			if(spikes[a].x < -80) then
				spikes[a].x = 900
				spikes[a].y = 500
				spikes[a].isAlive = false
			end
		end
	end
end

--update the ghosts if they are alive
function updateGhosts()
	for a = 1, ghosts.numChildren, 1 do
		if(ghosts[a].isAlive == true) then
			(ghosts[a]):translate(speed * -1, 0)
			if(ghosts[a].y > hero.y) then
				ghosts[a].y = ghosts[a].y - 1
			end
			if(ghosts[a].y < hero.y) then
				ghosts[a].y = ghosts[a].y + 1
			end
			if(ghosts[a].x < -80) then
				ghosts[a].x = 800
				ghosts[a].y = 600
				ghosts[a].speed = 0
				ghosts[a].isAlive = false;
			end
		end
	end
end
 
function checkCollisions()
	wasOnGround = onGround
	--checks to see if the collisionRect has collided with anything.
	for a = 1, blocks.numChildren, 1 do
		if(collisionRect.y - 10 > blocks[a].y - 170 and blocks[a].x - 40 < collisionRect.x and blocks[a].x + 40 > collisionRect.x) then
			speed = 0
			hero.isAlive = false
			--this simply pauses the current animation
			hero:pause()
			gameOver.x = display.contentWidth*.65
			gameOver.y = display.contentHeight/2
		end
	end
	--stop the game if the hero runs into a spike wall
	for a = 1, spikes.numChildren, 1 do
		if(spikes[a].isAlive == true) then
			if(collisionRect.y - 10> spikes[a].y - 170 and spikes[a].x - 40 < collisionRect.x and spikes[a].x + 40 > collisionRect.x) then
				--stop the hero
				speed = 0
				hero.isAlive = false
				--this simply pauses the current animation
				hero:pause()
				gameOver.x = display.contentWidth*.65
				gameOver.y = display.contentHeight/2
			end
		end
	end
	--make sure the player didn't get hit by a ghost!
	for a = 1, ghosts.numChildren, 1 do
		if(ghosts[a].isAlive == true) then
			if(((  ((hero.y-ghosts[a].y))<70) and ((hero.y - ghosts[a].y) > -70)) and (ghosts[a].x - 40 < collisionRect.x and ghosts[a].x + 40 > collisionRect.x)) then
				--stop the hero
				speed = 0
				hero.isAlive = false
				--this simply pauses the current animation
				hero:pause()
				gameOver.x = display.contentWidth*.65
				gameOver.y = display.contentHeight/2
			end
		end
	end
	--this is where we check to see if the hero is on the ground or in the air, if he is in the air then he can't jump(sorry no double
	--jumping for our little hero, however if you did want him to be able to double jump like Mario then you would just need
	--to make a small adjustment here, by adding a second variable called something like hasJumped. Set it to false normally, and turn it to
	--true once the double jump has been made. That way he is limited to 2 hops per jump.
	--Again we cycle through the blocks group and compare the x and y values of each.
	for a = 1, blocks.numChildren, 1 do
		if(hero.y >= blocks[a].y - 170 and blocks[a].x < hero.x + 60 and blocks[a].x > hero.x - 60) then
			hero.y = blocks[a].y - 171
			onGround = true
			break
		else
			onGround = false
		end
	end
end

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
	hero.x = 110
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