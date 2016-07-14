require('squicklyrun.sr_interactions')
local resizer = display.contentHeight/320;

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

function isCollideBlocks()
    for a = 1, blocks.numChildren, 1 do
        if(collisionRect.y - 10*resizer > blocks[a].y - 170*resizer and blocks[a].x - 40*resizer < collisionRect.x and blocks[a].x + 40*resizer > collisionRect.x) then
            gameOverScreen()
        end
    end
end

function isCollideSpikes()
    for a = 1, spikes.numChildren, 1 do
        if(spikes[a].isAlive == true) then
            if(collisionRect.y - 10*resizer> spikes[a].y - 170*resizer and spikes[a].x - 40*resizer < collisionRect.x and spikes[a].x + 40*resizer > collisionRect.x) then
                --if collideBool(spikes)
                gameOverScreen()
            end
        end
    end
end

function isCollideGhosts()
    for a = 1, ghosts.numChildren, 1 do
        if(ghosts[a].isAlive == true) then
            if(((  ((hero.y-ghosts[a].y))<70*resizer) and ((hero.y - ghosts[a].y) > -70*resizer)) and (ghosts[a].x - 40*resizer < collisionRect.x and ghosts[a].x + 40*resizer > collisionRect.x)) then
                gameOverScreen()
            end
        end
    end
end

function isCollidebossSpits()
    for a = 1, bossSpits.numChildren, 1 do
        if(bossSpits[a].isAlive == true) then
            if(((((hero.y-bossSpits[a].y))<45*resizer)) and ((  ((hero.y-bossSpits[a].y))>-45*resizer)) and ((  ((hero.x-bossSpits[a].x))>-45*resizer)) ) then
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
        if(hero.y >= blocks[a].y - 170*resizer and blocks[a].x < hero.x + 60*resizer and blocks[a].x > hero.x - 60*resizer) then
            hero.y = blocks[a].y - 171*resizer
            onGround = true
            break
        else
            onGround = false
        end
    end

end

