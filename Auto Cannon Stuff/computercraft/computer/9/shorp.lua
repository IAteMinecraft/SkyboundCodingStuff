os.loadAPI("CannonMotor.lua")
os.loadAPI("MathLib.lua")

local cannonPosition = vector.new(-32,-53,-24)

local radar = peripheral.find("radar")
local monitor = peripheral.find("monitor")
local computerTerm = term.native()
 
local nullWindow = window.create(monitor, 1, 1, 1, 1, false)

local i = 1
local cannonInfoWindowXPos = 1
local cannonInfoWindowYPos = 1
local scanRadius = nil
local targetShip = nil

local function askRadius ()
    term.redirect(computerTerm)
    print("Input Scan Radius")
    print("Max Radius Is 256")
    write(">")
    local scanRadiusTemp = tonumber(read())
        if (scanRadiusTemp > 256) then
        scanRadius = 256
    end
    if (scanRadiusTemp <= 256) then
        scanRadius = scanRadiusTemp
    end
    print(scanRadius)
    term.redirect(monitor)
end
local function askTargetShip ()
    term.redirect(computerTerm)
    print("Input Target Ship")
    write(">")
    local targetShip = tonumber(read())
    print(targetShip)
    term.redirect(monitor)
end

askRadius()
askTargetShip()

term.redirect(monitor)
monitor.setTextScale(0.5)
CannonMotor.Initialise()


while true do
    sleep(0)
    local results = radar.scan(scanRadius)
    if (results[1][1] == nil) then
        term.redirect(computerTerm)
        print("No Ships Found In the Given Radius")
        term.redirect(monitor)
        askRadius()
    end
    if (results[1][1] ~= nil) then
        local terminalWidth, terminalHeight = term.getSize()
        monitor.setBackgroundColor(colors.red)
        monitor.setCursorPos(1,1)
        paintutils.drawFilledBox(1, 1, terminalWidth, terminalHeight, colors.red)
        ----GUI Stuff-----
            local tempWindow = window.create(monitor, 1, 1, terminalWidth, terminalHeight, false)
                tempWindow.setBackgroundColor(colors.red)
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
            
            shipsInfoWindow = window.create(monitor, 1, 1, terminalWidth, shipsInfoWindowHeight+2)
                shipsInfoWindow.setBackgroundColor(colors.red)
                shipsInfoWindow.setTextColor(colors.white)
                shipsInfoWindow.setCursorPos(1,1)
                shipsInfoWindow.write("----Ship Info---")
                local drawShipsInfo = coroutine.create(function ()
                        term.redirect(shipsInfoWindow)
                        shipsInfoWindow.setCursorPos(1,2)
                        print("Scan Radius: " .. scanRadius)
                        print(textutils.serialise(results[1]))
                        term.redirect(monitor)
                end)

            local cannonTargetPositionWindowCursorXPos = 27

            cannonTargetPositionWindow = window.create(monitor, cannonInfoWindowXPos, cannonInfoWindowYPos, cannonTargetPositionWindowCursorXPos, 6)
                cannonTargetPositionWindow.setBackgroundColor(colors.red)
                cannonTargetPositionWindow.setTextColor(colors.white)
                cannonTargetPositionWindow.setCursorPos(1,1)
                cannonTargetPositionWindow.write("----Cannon Target Position----")
            local drawCannonTargetInfo = coroutine.create(function ()
                term.redirect(cannonTargetPositionWindow)
                cannonTargetPositionWindow.setCursorPos(1,2)
                local cannonMotorOutput = CannonMotor.Execute(heading, pitch)
                print(cannonMotorOutput)
                term.redirect(monitor)
            end)
        ----Cannon Aim----
        if (results ~= nil) then
            local targetPosition = vector.new(
                                    textutils.serialise(results[1][targetShip]['position']['x']),
                                    textutils.serialize(results[1][targetShip]['position']['y']),
                                    textutils.serialize(results[1][targetShip]['position']['z'])
                                    )
            local heading, pitch = MathLib.GetPitchAndHeading(cannonPosition, targetPosition)

            term.redirect(nullWindow)
            nullWindow.setCursorPos(1,2)
            CannonMotor.Execute(heading, pitch)
            cannonTargetPositionWindowCursorXPos, dodnontusevar = term.getCursorPos
            coroutine.resume(drawCannonTargetInfo)
            term.redirect(monitor)
                
            --term.redirect(nullWindow)
            --CannonMotor.Execute(0, 0)
            --term.redirect(monitor)
        end
        ----GUI Draw----
        coroutine.resume(drawShipsInfo)
            
        sleep(0)
        i = i + 1 
        if (i == 6) then
            --monitor.clear() 
            i = 1
            sleep(0)
        end
    end
end

