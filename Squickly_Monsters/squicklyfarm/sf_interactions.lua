-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here

--display groups
local blocks;

--main display groups
local screen;

-- -----------------------------------------------------------------------------------------------------------------
--Setup functions

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

end

-- GET FUNCTIONS BELOW-------------------------------------------------------------

function getBlocks()
	return blocks
end