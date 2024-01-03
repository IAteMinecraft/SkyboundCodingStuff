os.loadAPI("MathLib.lua")
os.loadAPI("CannonMotorLibrary.lua")
----Config----
--Yaw
local yawMotor = {
-- Lets the computer know the correct side to output a redstone pulse so that it can achieve side to side motion.
clutch = "right", -- In this case the Yaw clutch is on the right side of the computer.
gearBox = "front", -- The front of the computer has a redstone link which goes to the Yaw gearbox.
curDeg = 0
}
--Pitch
local pitchMotor = {
-- Lets the computer know the correct side to output a redstone pulse so that it can achieve up and down motion.
clutch  = "left",
gearBox = "back",
curDeg = 0
}
--RPM (First number)
local rpm = 48 / 8 --Cannon is geared Down by 8
--Constraints (WORLDSPACE Degrees)
local yawConstraints = {
    min = 0,
    max = 360,
    invertAngle = false
}
local pitchConstraints = {
    min = -35,
    max = 50,
    invertAngle = false
}
----Script Starts Here----
local trgYawDrg = 0
local trgPitchDrg = 0

function InputChannel(targetAngle,motor,constraints)
    local constrainedTargetAngle = MathLib.ConstrainAngle(targetAngle,constraints.min,constraints.max)
    targetAngle = CannonMotorLibrary.CalculatePath(motor.curDeg,targetAngle,constraints.min,constraints.max,constraints.invertAngle)
    motor.curDeg = motor.curDeg + CannonMotorLibrary.TryRotateMotor(targetAngle)
end

function Initialise()
    redstone.setAnalogOutput("top",0)
    redstone.setOutput(yawMotor.clutch,true)
    redstone.setOutput(pitchMotor.clutch,true)
    sleep(1)
    redstone.setAnalogOutput("top",0)
end

function Execute(targetXDeg,targetYDeg)
    parallel.waitForAll(
        function() InputChannel(targetXDeg,yawMotor,yawConstraints) end, 
        function() InputChannel(targetYDeg,pitchMotor,pitchConstraints) end
    )
end

----TEST----
local count = 0
while true  do
print("Enter Yaw")
trgYawDrg = math.random(0,359)
print(trgYawDrg)
print("Enter Pitch")
trgPitchDrg = math.random(-35,75)
print(trgPitchDrg)
if(count % 10 == 0) then
trgYawDrg = 0
trgPitchDrg = 0
end
Execute(trgYawDrg,trgPitchDrg)
print("Current Yaw: " .. curYawDrg)
print("Current Pitch: " .. curPitchDrg)
if(count%10==0) then sleep(8) end
count = count + 1
sleep(2)
end