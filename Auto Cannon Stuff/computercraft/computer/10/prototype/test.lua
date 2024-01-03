local yawClutch = "right"
local yawGearBox = "front"

local pitchClutch  = "left"
local pitchGearBox = "back"

redstone.setOutput(yawClutch,true)
redstone.setOutput(pitchClutch,true)


local curYawDrg = 0
local curPitchDrg = 0

local trgYawDrg = 0
local trgPitchDrg = 0

local rpm = 48 / 8


function SmallestPath360D(curA,trgA)
    return  (trgA - curA + 540) % 360-180
end

function CalculateRawRotationTime(_rpm,deg)
    return deg / ((_rpm * 360) / 60)
end

function RoundRotationTime(time)
    return math.floor(time / 0.05 + 0.5) * 0.05
end

function CalculateNewAngle(_rpm,timeS)
    return ((_rpm * 360) / 60) * timeS
end

function RotateMotor(clutch,gearBox,timeS,dir)
    redstone.setOutput(gearBox,false)
    if(dir) == 1 then
        redstone.setOutput(gearBox,true)
    end
    sleep(0.1)
    redstone.setOutput(clutch,false)
    sleep(timeS)
    redstone.setOutput(clutch,true)
end

function TryRotateMotor(ang,clutch,gearBox)
    local direction = Sign(ang)
    local rawRotS = CalculateRawRotationTime(rpm,ang)
    local RotS = RoundRotationTime(rawRotS)
    if (RotS <= 0.05) then
        print("Abort: " .. ang .. " Degrees may cause a precision error")
        return 0
    end
    local newAng = CalculateNewAngle(rpm,RotS) * direction
    RotateMotor(clutch,gearBox,RotS,direction)
    return newAng
end

function NormaliseAngle(angle)
 return angle + math.ceil( -angle / 360 ) * 360
end

print(ShortRotDeg(259,120))
local count = 0
while true  do

-- Yaw
print("Enter Yaw")
trgYawDrg = math.random(0,359)
print("Enter Pitch")
trgPitchDrg = math.random(-35,75)
if(count % 10 == 0) then
trgYawDrg = 0
trgPitchDrg = 0
end
curYawDrg = NormaliseAngle(curYawDrg + TryRotateMotor(ShortRotDeg(curYawDrg,trgYawDrg),yawClutch,yawGearBox))
curPitchDrg = NormaliseAngle(curPitchDrg + TryRotateMotor(ShortRotDeg(curPitchDrg,trgPitchDrg),pitchClutch,pitchGearBox))
print("Current Yaw: " .. curYawDrg)
print("Current Pitch: " .. curPitchDrg)
if(count%10==0) then sleep(8) end
count = count + 1
sleep(2)
end

