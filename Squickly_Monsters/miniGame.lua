local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()

local image;
local text1;
local srIcon;
local sfIcon;

function goToSRGame(event)
	if ( event.phase == "ended" ) then
		composer.gotoScene( "squicklyrun.sr_mainpage" )
    end
end

function goToSFGame(event)
	if ( event.phase == "ended" ) then
		composer.gotoScene( "squicklyfarm.sf_mainpage" )
    end
end

function scene:create( event )
	local sceneGroup = self.view
	
	image = display.newImage( "bg2.jpg" )
	image.x = display.contentCenterX
	image.y = display.contentCenterY
	
	text1 = display.newText( "Squickly MiniGames", 0, 0, native.systemFontBold, 30 )
	text1:setFillColor( 255 )
	text1.x, text1.y = display.contentWidth * 0.5, 50
	
	srIcon = widget.newButton{
		width = 100,
		height = 100,
		defaultFile = "img/squicklyrun/srIcon.png",
	}
	srIcon.x, srIcon.y = display.contentCenterX-75, display.contentCenterY-20

	sfIcon = widget.newButton{
		width = 100,
		height = 100,
		defaultFile = "img/squicklyfarm/sfIcon.png",
	}
	sfIcon.x, sfIcon.y = display.contentCenterX+75, display.contentCenterY-20


	srIcon:addEventListener('touch',goToSRGame)
	sfIcon:addEventListener('touch',goToSFGame)

	sceneGroup:insert( image )
	sceneGroup:insert( text1 )
	sceneGroup:insert( srIcon )
	sceneGroup:insert( sfIcon )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	

	if phase == "will" then
		composer.showOverlay("menubar")
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		--composer.hideOverlay()
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene