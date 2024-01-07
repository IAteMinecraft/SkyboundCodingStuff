os.loadAPI("apis/CannonControllerAPI.lua")
os.loadAPI("libs/MathLib.lua")

----Initialization----
---Peripheral Initialization---
local radar = peripheral.find("radar")
local monitor = peripheral.find("monitor")
local computerTerm = term.native()
---API Initialization---
local controller = CannonControllerAPI
---Screens Initialization---
term.clear()
term.redirect(monitor)
monitor.setTextScale(0.5)
monitor.clear()
---Resource Initialization---
local nullWindow = window.create(monitor, 1, 1, 1, 1, false)
---Cannon Initialization---
controller.InitialiseCannon()
controller.SetOriginPosition(vector.new(-32,-52.5,-24))

---Assigning Variables----
local i = 1
local cannonInfoWindowXPos = 1
local cannonInfoWindowYPos = 1
local noShips = textutils.serialise({  "no ships",})

----Functions & CoRoutines----
local function askRadius ()
    term.redirect(computerTerm)
    computerTerm.clear()
    local terminalWidth, terminalHeight = term.getSize()
    computerTerm.setCursorPos(1, terminalHeight-2)
    print("Input Scan Radius")
    print("Max Radius Is 256")
    write(">")
    local scanRadius = nil
    local scanRadiusTemp = tonumber(read(nil, nil, nil, "256"))
    if (scanRadiusTemp == nil) then
        print("oooooopps, you have to input a number, try again!")        
        write(">")
        scanRadiusTemp = tonumber(read(nil, nil, nil, "256"))
    end
    if (scanRadiusTemp > 256) then
        scanRadius = 256
    end
    if (scanRadiusTemp <= 256) then
        scanRadius = scanRadiusTemp
    end
    --print(scanRadius)
    term.redirect(monitor)
    computerTerm.clear()
    return scanRadius
end
local function askTargetShip ()
    term.redirect(computerTerm)
    local terminalWidth, terminalHeight = term.getSize()
    computerTerm.clear()
    computerTerm.setCursorPos(1, terminalHeight-1)
    print("Input Target Ship")
    write(">")
    local targetShipTemp = tonumber(read())
    if (targetShipTemp == nil) then
        print("Oppps, you have input a number, try again!")
        targetShipTemp = tonumber(read())
    end
    if (targetShipTemp ~= nil) then
        targetShip = targetShipTemp
    end
    --print(targetShip)
    term.redirect(monitor)
    computerTerm.clear()
    return targetShip
end
local function reAsk ()
    local scanRadius = askRadius()
    local targetShip = askTargetShip()
    return scanRadius, targetShip
end
 ---question loop function---
 local function mainQuestion ()
    term.redirect(computerTerm)
    local terminalWidth, terminalHeight = term.getSize()
    computerTerm.clear()
    computerTerm.setCursorPos(1, terminalHeight-1)
    print("What do you want to do?")
    print("Options: ")
end

--[[---Window To Do Size Processing For Other Windows(I'm pretty sure this isnt actually needed anymore because of scaling)---
local function GUISizing (peripheral_monitor, terminalWidth, terminalHeight, scanResults) 
    local tempWindow = window.create(peripheral_monitor, 1, 1, terminalWidth, terminalHeight, false)
        tempWindow.setBackgroundColor(colors.black)
        term.redirect(tempWindow)
        tempWindow.setCursorPos(1,1)
        print(textutils.serialise(scanResults[1]))
        local cursorXPosShipsInfoDEPRICATED, cursorYPosShipsInfo = term.getCursorPos()
        local shipsInfoWindowHeight = cursorYPosShipsInfo
        term.redirect(peripheral_monitor)
        
        local cursorXPosShipsInfo1 = string.len(textutils.serialise(scanResults[1][1]['position']['x']))
        local cursorXPosShipsInfo2 = string.len(textutils.serialise(scanResults[1][1]['position']['y']))
        local cursorXPosShipsInfo3 = string.len(textutils.serialise(scanResults[1][1]['position']['z']))

    local cannonInfoWindowXPos = nil
    local cannonInfoWindowYPos = nil
    if (cursorYPosShipsInfo+7 >= terminalHeight) then
        cannonInfoWindowXPos = math.max(cursorXPosShipsInfo1, cursorXPosShipsInfo2, cursorXPosShipsInfo3)+2
        cannonInfoWindowYPos = 1
    end
    if (cursorYPosShipsInfo+7 < terminalHeight) then
        cannonInfoWindowXPos = 29 --1
        cannonInfoWindowYPos = 1 -- cursorYPosShipsInfo+1
    end

    return shipsInfoWindowHeight, cannonInfoWindowXPos, cannonInfoWindowYPos
end ]]

---Second Variable Stage---
local scanRadius = askRadius()
local targetShip = askTargetShip()

----Main Loop---
while true do
    sleep(0)
    ----Important  Info That This Entire Script Is Based Off Of----
    local results = radar.scan(scanRadius)
    local terminalWidth, terminalHeight = term.getSize()
    ----More screen Init----
    monitor.setBackgroundColor(colors.black)
    monitor.setCursorPos(1,1)
----GUI Stuff-----
if (textutils.serialize(results) ~= noShips) then
        --local shipsInfoWindowHeight, cannonInfoWindowXPos, cannonInfoWindowYPos = GUISizing(monitor, terminalWidth, terminalHeight, results)
        local tempWindow = window.create(monitor, 1, 1, terminalWidth, terminalHeight, false)
            tempWindow.setBackgroundColor(colors.black)
            term.redirect(tempWindow)
            tempWindow.setCursorPos(1,1)
            print(textutils.serialise(results[1]))
            local cursorXPosShipsInfoDEPRICATED, cursorYPosShipsInfo = term.getCursorPos()
            local shipsInfoWindowHeight = cursorYPosShipsInfo
            term.redirect(monitor)
            
            local cursorXPosShipsInfo1 = string.len(textutils.serialise(results[1][1]['position']['x']))
            local cursorXPosShipsInfo2 = string.len(textutils.serialise(results[1][1]['position']['y']))
            local cursorXPosShipsInfo3 = string.len(textutils.serialise(results[1][1]['position']['z']))

        if (cursorYPosShipsInfo+7 >= terminalHeight) then
            cannonInfoWindowXPos = math.max(cursorXPosShipsInfo1, cursorXPosShipsInfo2, cursorXPosShipsInfo3)+2
            cannonInfoWindowYPos = 1
        end
        if (cursorYPosShipsInfo+7 < terminalHeight) then
            cannonInfoWindowXPos = 29 --1
            cannonInfoWindowYPos = 1 -- cursorYPosShipsInfo+1
        end
        ---Window That Displays The Info On Ships---
            shipsInfoWindowHeading = window.create(monitor, 1, 1, 17, 3)
                shipsInfoWindowHeading.setBackgroundColor(colors.black)
                shipsInfoWindowHeading.setTextColor(colors.white)
                shipsInfoWindowHeading.setCursorPos(1,1)
                shipsInfoWindowHeading.write("----Ship Info----")
                shipsInfoWindowHeading.setCursorPos(1,2)
                shipsInfoWindowHeading.write("Scan Radius: " .. scanRadius)
                shipsInfoWindowHeading.setCursorPos(1,3)
                shipsInfoWindowHeading.write("Target Ship: " .. targetShip)
            shipsInfoWindow = window.create(monitor, 1, 4, terminalWidth, shipsInfoWindowHeight+2)
                shipsInfoWindow.setBackgroundColor(colors.black)
                shipsInfoWindow.setTextColor(colors.white)
                --The Info Drawing CoRoutine For Ships Info--
                local drawShipsInfo = coroutine.create(function ()
                        term.redirect(shipsInfoWindow)
                        shipsInfoWindow.setCursorPos(1,1)
                        shipsInfoWindow.setCursorPos(1, 3)
                        print(textutils.serialise(results))
                        term.redirect(monitor)
                end)
        ---Some Random Reqirement That I Forgot What Its Needed For :)---
            local cannonTargetPositionWindowCursorXPos = 27

        ---Window That Displays The Info About What The Cannon Is Doing---
            cannonTargetPositionWindowHeading = window.create(monitor, cannonInfoWindowXPos, cannonInfoWindowYPos, 26, 3)
                cannonTargetPositionWindowHeading.setBackgroundColor(colors.black)
                cannonTargetPositionWindowHeading.setTextColor(colors.white)
                cannonTargetPositionWindowHeading.setCursorPos(1,1)
                cannonTargetPositionWindowHeading.write("----Cannon Target Info----")
                cannonTargetPositionWindowHeading.setCursorPos(1,2)
                cannonTargetPositionWindowHeading.write(" With heading: " ..controller.GetAimRotation().x)
                cannonTargetPositionWindowHeading.setCursorPos(1,3)
                cannonTargetPositionWindowHeading.write(" With pitch: " .. controller.GetAimRotation().y)
            cannonTargetPositionWindow = window.create(monitor, cannonInfoWindowXPos, cannonInfoWindowYPos+4, cannonTargetPositionWindowCursorXPos, 9)
                cannonTargetPositionWindow.setBackgroundColor(colors.black)
                cannonTargetPositionWindow.setTextColor(colors.white)
                --The Info Drawing CoRoutine For Cannons--
                local drawCannonTargetInfo = coroutine.create(function ()
                    term.redirect(cannonTargetPositionWindow)
                    local lastTargetPos = controller.GetLastAimPos()
                    cannonTargetPositionWindow.setCursorPos(1,1)
                    print(" Aiming at: " .. textutils.serialise(lastTargetPos))
                    term.redirect(monitor)
                end)

        ----Cannon Aim----
        if (results[1] ~= nil) then
            local targetPosition = vector.new(
                                    textutils.serialise(results[1][targetShip]['position']['x']),
                                    textutils.serialize(results[1][targetShip]['position']['y']),
                                    textutils.serialize(results[1][targetShip]['position']['z'])
                                    )

            term.redirect(nullWindow)
            nullWindow.setCursorPos(1,2)
            controller.AimToward(targetPosition)
            cannonTargetPositionWindowCursorXPos, dodnontusevar = term.getCursorPos
            ----GUI Draw----
            coroutine.resume(drawCannonTargetInfo)
            term.redirect(monitor)
        end
        ----GUI Draw----
        coroutine.resume(drawShipsInfo)
        ----question looper thing----
        
            
        sleep(0)
        i = i + 1 
    if (i == 64) then
            monitor.clear() 
            i = 1
            sleep(0)
        end
    end
    if (textutils.serialise(results) == noShips) then
        term.redirect(computerTerm)
        print("There are no ships in this radius!")
        print("Please select a new radius or terminate the Program")
        print("Options: New Radius, Terminate")
        local completion = require "cc.completion" 
        local check = read(nil, {"New Radius", "Terminate"}, function(text) return completion.choice(text, { "New Radius", "Terminate", "terminate" }) end)
        if (check == "New Radius") then
            scanRadius, targetShip = reAsk()
        end
        if (check == "N") then
            scanRadius, targetShip = reAsk()
        end
        if (check == "n") then
            scanRadius, targetShip = reAsk()
        end
        if (check == "") then
            scanRadius, targetShip = reAsk()
        end
        if (check == "Terminate") then
            return
        end
        if (check == "terminate") then
            return
        end
        if (check == "T") then
            return
        end
        if (check == "t") then
            return
        end
    end
end

