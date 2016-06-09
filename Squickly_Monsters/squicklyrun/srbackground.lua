-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here

--adds an image to our game centered at x and y coordinates
local backbackground;
local backgroundfar;
local backgroundnear1;
local backgroundnear2;

--create a new group to hold all of our blocks
local blocks;

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
	speed = 5;

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

function setupSprite()
	local imgsheetSetup = {
		width = 100,
		height = 100,
		numFrames = 3
	}
	local spriteSheet = graphics.newImageSheet("img/squicklyrun/monsterSpriteSheet.png", imgsheetSetup);
	
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

-- -- -----------------------------------------------------------------------------------------------------------------
-- --Update functions

-- function update( event )
--     updateBackgrounds()
--     updateSpeed()
--     updateHero()
--     updateBlocks()
--     checkCollisions()
-- end

-- function updateBackgrounds()
-- 	--far background movement
-- 	backgroundfar.x = backgroundfar.x - (speed/55)
	 
-- 	--near background movement
-- 	backgroundnear1.x = backgroundnear1.x - (speed/5)
-- 	if(backgroundnear1.x < -239) then
-- 		backgroundnear1.x = 760
-- 	end
	 
-- 	backgroundnear2.x = backgroundnear2.x - (speed/5)
-- 	if(backgroundnear2.x < -239) then
-- 		backgroundnear2.x = 760
-- 	end
-- end

-- function updateSpeed()
-- 	speed = speed + .05
-- end

-- function updateHero()
--      --if our hero is jumping then switch to the jumping animation
--      --if not keep playing the running animation
--      if(onGround) then
--           if(wasOnGround == false) then
--                hero:setSequence("running")
--                hero:play()
--           end
--      else
--           hero:setSequence("jumping")
--           hero:play()
--      end
 
--      if(hero.accel > 0) then
--           hero.accel = hero.accel - 1
--      end
 
--      --update the heros position accel is used for our jump and
--      --gravity keeps the hero coming down. You can play with those 2 variables
--      --to make lots of interesting combinations of gameplay like 'low gravity' situations
--      hero.y = hero.y - hero.accel
--      hero.y = hero.y - hero.gravity
--      --update the collisionRect to stay in front of the hero
--      collisionRect.y = hero.y
-- end

-- function updateBlocks()
-- 	for a = 1, blocks.numChildren, 1 do
-- 		if(a > 1) then
-- 			newX = (blocks[a - 1]).x + 79
-- 		else
-- 			newX = (blocks[8]).x + 79 - speed
-- 		end
		 
-- 		if((blocks[a]).x < -40) then
-- 			(blocks[a]).x, (blocks[a]).y = newX, (blocks[a]).y
-- 		else
-- 			(blocks[a]):translate(speed * -1, 0)
-- 		end
-- 	end
-- end
 
-- function checkCollisions()
--      wasOnGround = onGround
--      --checks to see if the collisionRect has collided with anything.
--      for a = 1, blocks.numChildren, 1 do
--           if(collisionRect.y - 10 > blocks[a].y - 170 and blocks[a].x - 40 < collisionRect.x and blocks[a].x + 40 > collisionRect.x) then
--                speed = 0
--           end
--      end
--      --this is where we check to see if the hero is on the ground or in the air, if he is in the air then he can't jump(sorry no double
--      --jumping for our little hero, however if you did want him to be able to double jump like Mario then you would just need
--      --to make a small adjustment here, by adding a second variable called something like hasJumped. Set it to false normally, and turn it to
--      --true once the double jump has been made. That way he is limited to 2 hops per jump.
--      --Again we cycle through the blocks group and compare the x and y values of each.
--      for a = 1, blocks.numChildren, 1 do
--           if(hero.y >= blocks[a].y - 170 and blocks[a].x < hero.x + 60 and blocks[a].x > hero.x - 60) then
--                hero.y = blocks[a].y - 171
--                onGround = true
--                break
--           else
--                onGround = false
--           end
--      end
-- end

-- -- -----------------------------------------------------------------------------------------------------------------
-- --Event Handlers

-- --this is the function that handles the jump events. If the screen is touched on the left side
-- --then make the monster jump
-- function touched( event )
--      if(event.phase == "began") then
--           if(event.x < 241) then
--                if(onGround) then
--                     hero.accel = hero.accel + 20
--                end
--           end
--      end
-- end