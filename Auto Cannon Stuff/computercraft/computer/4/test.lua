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

function Sign(v)
    return (v > 0 and 1) or (v == 0 and 0) or -1
end
function ShortRotDeg(curA,trgA)

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

function Clamp(min,max,value)
    return math.min(high,math.max(low,value))
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
 
    local rawRotS = CalculateRawRotationTime(rpm,math.abs(ang))
    local RotS = RoundRotationTime(rawRotS)
    if (RotS <= 0.05) then
         print(ang .. " degrees is to small")
        return 0
    end
    local newAng = CalculateNewAngle(rpm,RotS) * Sign(ang)
    RotateMotor(clutch,gearBox,RotS,Sign(ang))
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
--curPitchDrg = Clamp(-80,20,curPitchDrg)
print("Current Yaw: " .. curYawDrg)
print("Current Pitch: " .. curPitchDrg)
if(count%10==0) then sleep(8) end
count = count + 1
sleep(2)
end

