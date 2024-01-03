os.loadAPI("MathLib.lua")
os.loadAPI("CannonMotorLibrary.lua")
----Config----
--Yaw
local yawMotor = {
-- Lets the computer know the correct side to output a redstone pulse so that it can achieve side to side motion.
clutch = "right", -- In this case the Yaw clutch is on the right side of the computer.
gearBox = "front", -- The front of the computer has a redstone link which goes to the Yaw gearbox.
curDeg = 0,
--Constraints (WORLDSPACE Degrees)
min = -360,
max = 360,
invert = false
}
--Pitch
local pitchMotor = {
-- Lets the computer know the correct side to output a redstone pulse so that it can achieve up and down motion.
clutch  = "left",
gearBox = "back",
curDeg = 0,
--Constraints (WORLDSPACE Degrees)
min = -89,
max = 35,
invert = false
}
--RPM (First number)
local rpm = 80 / 8 --Cannon is geared Down by 8


----Script Starts Here----
local trgYawDrg = 0
local trgPitchDrg = 0

function InputChannel(targetAngle,motor)
    --if(CannonMotorLibrary.AngleInRange(MathLib.NormaliseAngle180(targetAngle),motor.min,motor.max)) then return end
    targetAngle = MathLib.NormaliseAngle360(targetAngle)
    local rotationA = MathLib.AngleBetweenWrapped(motor.curDeg,targetAngle)
    if(motor.invert) then rotationA = MathLib.InvertAngleDir180(rotationA) end
    motor.curDeg = MathLib.NormaliseAngle360(motor.curDeg + CannonMotorLibrary.TryRotateMotor(rotationA,rpm,motor))
end



function Initialise()
    yawMotor.curDeg = 0
    pitchMotor.curDeg = 0
    redstone.setAnalogOutput("top",0)
    redstone.setOutput(yawMotor.clutch,true)
    redstone.setOutput(pitchMotor.clutch,true)
    sleep(1)
    redstone.setAnalogOutput("top",1)
    sleep(1)
end

function Execute(targetXDeg,targetYDeg)
    parallel.waitForAll(
        function() InputChannel(targetXDeg,yawMotor) end,
        function() InputChannel(targetYDeg,pitchMotor) end
    )
end

