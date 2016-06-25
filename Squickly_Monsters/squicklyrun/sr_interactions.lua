-- -----------------------------------------------------------------------------
-- Local variables go HERE

local blocks;
local groundMin;
local groundMax;
local groundLevel;
local speed;
local inEvent;
local eventRun;
-- ---------------
local isDone;
local numGen;
-- ---------------
local score;
local gameOver;
-- --------------
local scoreText;
local hero;
-- --------------

local ghosts;
local spikes;
local blasts;
local boss;
local bossSpits
local collisionRect;

-- ---------------------------------------------------------------------------------------------------------------------

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



    -- screen:insert(blocks)
end

function getBlocks()
    return blocks
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
    --screen:insert(gameOver)
    --screen:insert(scoreText)
end

function getGameOver()
    return gameOver
end

function getScoreText()
    return scoreText
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
    hero.x = 60
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

    --screen:insert(hero)
    --screen:insert(collisionRect)
end

function getHero()
    return hero
end

function getCollisionRect()
    return collisionRect
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

    boss = display.newImage("img/squicklyrun/boss.png", 150, 150)
    boss.x = 300
    boss.y = 550
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
        bossSpit.x = 400
        bossSpit.y = 550
        bossSpit.isAlive = false
        bossSpit.speed = 3
        bossSpits:insert(bossSpit)
    end

    --screen:insert(spikes)
    --screen:insert(blasts)
    --screen:insert(ghosts)
    --screen:insert(boss)
    --screen:insert(bossSpits)
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


-- ---------------------------------------------------------------------------------------------------------------------
-- get functions HERE

function getScreenLayer()
    return screen
end

function getPlayerLayer()
    return player
end

function getScore()
    return score
end

function getSpeed()
    return speed
end

