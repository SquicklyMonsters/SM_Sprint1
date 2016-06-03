
local widget = require("widget")
local composer = require("composer")
--=====================================================================================================================================================
-- This is sliding panel function. Have 2 command show, hide,
function widget.newPanel( options )                                     -- Setting Panel : have default value and can be customize
    local customOptions = options or {}
    local opt = {}
    opt.location = "right"
    -- local default_width = display.contentWidth * 0.5
    -- local default_height = display.contentHeight
    opt.width = customOptions.width
    opt.height = customOptions.height
    opt.speed = customOptions.speed or 500
    opt.inEasing = customOptions.inEasing or easing.linear
    opt.outEasing = customOptions.outEasing or easing.linear

    local container = display.newContainer( opt.width, opt.height )
        container.anchorX = 0.0
        container.x = display.actualContentWidth
        container.anchorY = 0.5
        container.y = display.contentCenterY
    function container:show()                                             -- show function
        local options = {
            time = opt.speed,
            transition = opt.inEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "shown"
        end
        options.x = display.actualContentWidth - opt.width
        transition.to( self, options )
    end
    function container:hide()                                           -- hide function
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
            self.completeState = "hidden"
        end
        options.x = display.actualContentWidth - 80
        transition.to( self, options )
    end
    return container
end
-- ==========================================================================================================================
