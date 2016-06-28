require('squicklyrun.sr_interactions')
require('squicklyrun.sr_background')
require('squicklyrun.sr_collisions')


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
    speed = getSpeed()
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
    speed = getSpeed()
    speed = speed + .0005
end

function updateHero()
    --if our hero is jumping then switch to the jumping animation
    --if not keep playing the running animation
    hero = getHero()
    collisionRect=getCollisionRect()

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



function updateBlasts()
    --for each blast that we instantiated check to see what it is doing
    blasts = getBlasts()
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
        boss = getBoss()
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
        bossSpits=getBossSpits()
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
        spikes = getSpikes()
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
        ghosts = getGhosts()
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