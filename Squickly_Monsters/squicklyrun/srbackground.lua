-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here

--adds an image to our game centered at x and y coordinates
local backbackground;
local backgroundfar;
local backgroundnear1;
local backgroundnear2;

--create a new group to hold all of our blocks
local blocks;
--create a new group to hold our background
local game_bg;
 
--setup some variables that we will use to position the ground
local groundMin;
local groundMax;
local groundLevel;
local speed;

-- -----------------------------------------------------------------------------------------------------------------

function getBlockImages()
    return blocks
end

function getBackgroundImages()
    return game_bg
end

-- -----------------------------------------------------------------------------------------------------------------

function setupBackground()
	game_bg = display.newGroup()

	--adds an image to our game centered at x and y coordinates
	backbackground = display.newImage("img/squicklyrun/background.png")
	backbackground.x = 240
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

	game_bg:insert(backbackground)
	game_bg:insert(backgroundfar)
	game_bg:insert(backgroundnear1)
	game_bg:insert(backgroundnear2)
end

function setupGround()
	--create a new group to hold all of our blocks
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
end

function updateScene( event )
	--updateBackgrounds will call a function made specifically to handle the background movement
	--called every frame(30 frames per second )
	updateBackgrounds()
	speed = speed + .05
end

function updateBlocks()
	for a = 1, blocks.numChildren, 1 do
		if(a > 1) then
			newX = (blocks[a - 1]).x + 79
		else
			newX = (blocks[8]).x + 79 - speed
		end
		 
		if((blocks[a]).x < -40) then
			(blocks[a]).x, (blocks[a]).y = newX, (blocks[a]).y
		else
			(blocks[a]):translate(speed * -1, 0)
		end
	end
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