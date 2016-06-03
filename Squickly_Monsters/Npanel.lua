
local widget = require("widget")
local composer = require("composer")
--=====================================================================================================================================================
-- This is sliding panel function. Have 2 command show, hide,
function widget.newPanel( options )                                     -- Setting Panel : have default value and can be customize
    local customOptions = options
    local opt = {}
    opt.location = "right"
    opt.width = customOptions.width
    opt.height = customOptions.height
    opt.speed = customOptions.speed
    opt.inEasing = customOptions.inEasing
    opt.outEasing = customOptions.outEasing

    local container = display.newContainer( opt.width, opt.height )
        container.x = display.actualContentWidth
        container.y = display.contentCenterY
    function container:show()                                             -- show function
        local options = {
            time = opt.speed,
            transition = opt.inEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
        end
        options.x = display.actualContentWidth - opt.width + 35
        self.completeState = "shown"
        transition.to( self, options )
    end
    function container:hide()                                           -- hide function
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
        end
        options.x = display.actualContentWidth - 14
        self.completeState = "hidden"
        transition.to( self, options )
    end
    return container
end
-- ==========================================================================================================================
