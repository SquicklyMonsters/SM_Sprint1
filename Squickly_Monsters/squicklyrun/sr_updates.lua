local interactions=require('squicklyrun.sr_interactions')
local background=require('squicklyrun.sr_background')




function update( event )
    updateBackgrounds()
    updateSpeed()
    updateHero()
    updateBlocks()
    updateBlasts()
    updateSpikes()
    updateGhosts()
    updateBossSpit()
    if(boss.isAlive == true) then
        updateBoss()
    end
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
            --only update the score if the boss is not alive
            if (boss.isAlive == false) then
                score = score + 1
                scoreText.text = "score: " .. score
            else
                --have the boss spit every three block passes
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
        --check for collisions with the boss
        if(boss.isAlive == true) then
            if(blasts[a].y - 25 > boss.y - 120 and blasts[a].y + 25 < boss.y + 120 and boss.x - 40 < blasts[a].x + 25 and boss.x + 40 > blasts[a].x - 25) then
                blasts[a].x = 800
                blasts[a].y = 500
                blasts[a].isAlive = false
                --everything is the same only 1 hit will not kill the boss so just take a little health away
                boss.health = boss.health - 1
            end
        end
        --check for collisions between the blasts and the bossSpit
        for b = 1, bossSpits.numChildren, 1 do
            if(bossSpits[b].isAlive == true) then
                if(blasts[a].y - 20 > bossSpits[b].y - 120 and blasts[a].y + 20 < bossSpits[b].y + 120 and bossSpits[b].x - 25 < blasts[a].x + 20 and bossSpits[b].x + 25 > blasts[a].x - 20) then
                    blasts[a].x = 800
                    blasts[a].y = 500
                    blasts[a].isAlive = false
                    bossSpits[b].x = 400
                    bossSpits[b].y = 550
                    bossSpits[b].isAlive = false
                    bossSpits[b].speed = 0
                end
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

function updateBoss()
    --check to make sure that the boss hasn't been killed
    if(boss.health > 0) then
        --check to see if the boss needs to change direction
        if(boss.y > 210) then
            boss.goingDown = false
        end
        if(boss.y < 100) then
            boss.goingDown = true
        end
        if(boss.goingDown) then
            boss.y = boss.y + 2
        else
            boss.y = boss.y - 2
        end
    else
        --if the boss has been killed make him slowly disappear
        boss.alpha = boss.alpha - .01
    end
    --once the hero has been killed and disappear officially
    --kill him off and reset him back to where he was
    if(boss.alpha <= 0) then
        boss.isAlive = false
        boss.x = 300
        boss.y = 550
        boss.alpha = 1
        boss.health = 10
        inEvent = 0
        boss.spitCycle = 0
    end
end

function updateBossSpit()
    for a = 1, bossSpits.numChildren, 1 do
        if(bossSpits[a].isAlive) then
            (bossSpits[a]):translate(speed * -1, 0)
            if(bossSpits[a].y > hero.y) then
                bossSpits[a].y = bossSpits[a].y - 1
            end
            if(bossSpits[a].y < hero.y) then
                bossSpits[a].y = bossSpits[a].y + 1
            end
            if(bossSpits[a].x < -80) then
                bossSpits[a].x = 400
                bossSpits[a].y = 550
                bossSpits[a].speed = 0
                bossSpits[a].isAlive = false;
            end
        end
    end
end

function isCollideBlocks()
    for a = 1, blocks.numChildren, 1 do
        if(collisionRect.y - 10 > blocks[a].y - 170 and blocks[a].x - 40 < collisionRect.x and blocks[a].x + 40 > collisionRect.x) then
            gameOverScreen()
        end
    end
end

function isCollideSpikes()
    for a = 1, spikes.numChildren, 1 do
        if(spikes[a].isAlive == true) then
            if(collisionRect.y - 10> spikes[a].y - 170 and spikes[a].x - 40 < collisionRect.x and spikes[a].x + 40 > collisionRect.x) then
                --if collideBool(spikes)
                gameOverScreen()
            end
        end
    end
end

function isCollideGhosts()
    for a = 1, ghosts.numChildren, 1 do
        if(ghosts[a].isAlive == true) then
            if(((  ((hero.y-ghosts[a].y))<70) and ((hero.y - ghosts[a].y) > -70)) and (ghosts[a].x - 40 < collisionRect.x and ghosts[a].x + 40 > collisionRect.x)) then

                gameOverScreen()
            end
        end
    end
end

function isCollidebossSpits()
    for a = 1, bossSpits.numChildren, 1 do
        if(bossSpits[a].isAlive == true) then
            if(((  ((hero.y-bossSpits[a].y))<45)) and ((  ((hero.y-bossSpits[a].y))>-45)) and ((  ((hero.x-bossSpits[a].x))>-45)) ) then

                gameOverScreen()
            end
        end
    end
end

function isOnGround()
    --this is where we check to see if the hero is on the ground or in the air, if he is in the air then he can't jump(sorry no double
    --jumping for our little hero, however if you did want him to be able to double jump like Mario then you would just need
    --to make a small adjustment here, by adding a second variable called something like hasJumped. Set it to false normally, and turn it to
    --true once the double jump has been made. That way he is limited to 2 hops per jump.
    --Again we cycle through the blocks group and compare the x and y values of each.
    wasOnGround = onGround
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

function checkCollisions()

    --checks to see if the collisionRect has collided with anything.

    -- stop if run into block
    isCollideBlocks()
    -- stop if run into spikes
    isCollideSpikes()
    -- stop if run into ghosts
    isCollideGhosts()
    -- stop if run int bossSpits
    isCollidebossSpits()
    -- check if still on ground
    isOnGround()

end