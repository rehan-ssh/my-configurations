hs.hotkey.bind({"ctrl"}, "I", function()
    hs.eventtap.event.newKeyEvent({}, "up", true):post()
    hs.eventtap.event.newKeyEvent({}, "up", false):post()
    return true;
  end)

  hs.hotkey.bind({"ctrl"}, "J", function()
    hs.eventtap.event.newKeyEvent("left", true):post()
    hs.eventtap.event.newKeyEvent("left", false):post()
  end)

  hs.hotkey.bind({"ctrl"}, "K", function()
    hs.eventtap.event.newKeyEvent("down", true):post()
    hs.eventtap.event.newKeyEvent("down", false):post()

  end)

  hs.hotkey.bind({"ctrl"}, "L", function()
    hs.eventtap.event.newKeyEvent("right", true):post()
    hs.eventtap.event.newKeyEvent("right", false):post()
  end)

  hs.hotkey.bind({"ctrl"}, ",", function()
    hs.eventtap.leftClick(hs.mouse.absolutePosition())
end)


hs.hotkey.bind({"ctrl"}, ".", function()
   -- Simulate a middle click at a specific position

--    hs.alert(hs.eventtap.event.newMouseEvent) -- This should not be nil
print(hs.eventtap.middleClick) 
local position = {x = 500, y = 300}
hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseUp, position):post()
hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.otherMouseDown, position):post()
end)

hs.hotkey.bind({"ctrl"}, "/", function()
    hs.eventtap.rightClick(hs.mouse.absolutePosition())
end)

hs.hotkey.bind({"ctrl"}, "o", function()
     hs.eventtap.event.newKeyEvent("alt", true):post()

end)

hs.hotkey.bind({"ctrl"}, ".", function()
    hs.eventtap.event.newKeyEvent("alt", false):post()
end)

hs.hotkey.bind({"ctrl"}, "p", function()
    hs.eventtap.event.newKeyEvent("cmd", true):post()  

end)

hs.hotkey.bind({"ctrl"}, "/", function()
    hs.eventtap.event.newKeyEvent("cmd", false):post()  
end)

hs.hotkey.bind({"ctrl"}, "[", function()
    hs.eventtap.event.newKeyEvent("shift", true):post()  
end)

hs.hotkey.bind({"ctrl"}, "]", function()
    hs.eventtap.event.newKeyEvent("shift", false):post()  
end)

hs.loadSpoon("AClock")
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
    spoon.AClock.format = "%a, %b %d %Y\n %I:%M %p" 
    spoon.AClock.textSize = 62
    spoon.AClock.textColor = {red=0, green=1, blue=0} 
    spoon.AClock:toggleShow()
  end)

  mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    --Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.absolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function()
      mouseCircle:delete()
      mouseCircle = nil
    end)
end
hs.hotkey.bind({"cmd","alt","ctrl"}, "M", mouseHighlight)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
  
    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
    return true
  end)

  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
  
    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end)

  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "I", function()
    hs.osascript.applescript([[
        tell application "System Settings"
            reveal pane id "com.apple.systempreferences.GeneralSettings"
        end tell
        tell application "System Events"
            tell process "System Settings"
                delay 1
                click button "Privacy & Security" of scroll area 1 of window 1
                delay 1
                click table row "Input Monitoring" of table 1 of scroll area 1 of window 1
            end tell
        end tell
    ]])
end)


-- Function to quit and restart an app
function restartApp(appName)
    -- Get the application object
    local app = hs.application.get(appName)
    
    if app then
        -- Quit the application if it's running
        app:kill()  -- Graceful quit (uses the app's standard quit process)
        -- Alternatively, use app:kill9() for a force quit
    end

    -- Wait for a short moment to ensure the app quits before restarting
    hs.timer.doAfter(1, function()
        -- Launch the application again
        hs.application.launchOrFocus(appName)
    end)
end


-- Bind the restartApp function to a hotkey
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    restartApp("rcmd")  -- Replace "Safari" with the app name you want
end)


-- Function to schedule app restart every 24 hours
function scheduleDailyRestart(appName)
    -- Restart the app immediately for the first run
    restartApp(appName)
    
    -- Set up a timer to run the restart every 24 hours (in seconds)
    hs.timer.doEvery(1 * 60 * 60, function()
        print("Restarting ".. appName .. " now..");
        restartApp(appName)
    end)
end

scheduleDailyRestart("rcmd")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
    -- Get the mouse position
    local mousePos = hs.mouse.getAbsolutePosition()

    -- Take a small screenshot of the area around the mouse pointer
    local image = hs.screen.mainScreen():snapshot({ x = mousePos.x, y = mousePos.y, w = 1, h = 1 })

    if image then
        -- Extract the color of the single pixel
        local color = image:colorAt({ x = 0, y = 0 })

        if color then
            -- Convert the color to a hex code
            local hexColor = string.format("#%02X%02X%02X", math.floor(color.red * 255), math.floor(color.green * 255), math.floor(color.blue * 255))
            hs.pasteboard.setContents(hexColor)
            hs.alert.show("Color at pointer: " .. hexColor)
        else
            hs.alert.show("Unable to detect color.")
        end
    else
        hs.alert.show("Unable to capture screen snapshot.")
    end
end)




hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()



hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
    local pasteboardText = hs.pasteboard.getContents()
    if pasteboardText and pasteboardText ~= "" then
        local query = hs.http.encodeForQuery(pasteboardText)
        local url = "https://www.google.com/search?q=" .. query
        hs.urlevent.openURL(url)
    else
        hs.alert.show("Clipboard is empty!")
    end
end)


hs.loadSpoon("ClipboardTool")
spoon.ClipboardTool.show_in_menubar = false  -- or similar method based on spoon
spoon.ClipboardTool:start()
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "V", function() spoon.ClipboardTool:showClipboard() end)
-- Hide the menubar icon for a spoon



hs.hotkey.bind({"cmd", "ctrl"}, "W", function()
    hs.caffeinate.systemSleep()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "C", function()
    local pasteboardText = hs.pasteboard.getContents()
    if pasteboardText and pasteboardText ~= "" then
        local query = hs.http.encodeForQuery(pasteboardText)
        local url = "https://chat.openai.com/?query=" .. query
        hs.urlevent.openURL(url)
    else
        hs.alert.show("Clipboard is empty!")
    end
end)



hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
    local mods = event:getFlags()

    if mods.alt then
        print("Alt key is being held")
    else
        print("Alt key was just released")
    end

    return false  -- don't block the event
end):start()