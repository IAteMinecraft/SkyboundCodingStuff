os.loadAPI("apis/CannonMotorAPI.lua")
os.loadAPI("libs/MathLib.lua")
local cannonMotor = CannonMotorAPI

local cannonPosition = vector.new(0,0,0)
local lastTargetPos = vector.new(0,0,0) 


function SetFire(bool)
    if(redstone.getAnalogOutput("top") == 0) then return end
    if(bool) then redstone.setAnalogOutput("top",2)
    else redstone.setAnalogOutput("top",1) end
end

function AimToward(targetV)
    local targetPosition = targetV
    local heading, pitch = MathLib.GetPitchAndHeading(cannonPosition,targetPosition)
    cannonMotor.Execute(heading, pitch)
    lastTargetPos = targetV
end

function InitialiseCannon()
    cannonMotor.Initialise()
end

function SetOriginPosition(positionVector)
    cannonPosition = positionVector
end

function GetLastAimPos()
    return lastTargetPos
end

function SetAimAngles(heading,pitch)
    cannonMotor.Execute(heading, pitch)
end

function GetAimRotation()
    local heading, pitch = cannonMotor.GetAngles()
    return {x = heading, y = pitch}
end