-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Hide android navigation bar
native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )

-- include the Corona "composer" module
local composer = require "composer"
require("data")

-- Setup All Data and Auto Save
loadData()
setAutoSaveRate(5000)

-- load menu screen
composer.gotoScene( "home" )

