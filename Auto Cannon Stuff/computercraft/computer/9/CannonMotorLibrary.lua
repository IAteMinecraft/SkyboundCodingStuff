
function RotateMotor(motor,timeS,dir)
    redstone.setOutput(motor.gearBox,false)
    if(dir) == 1 then
        redstone.setOutput(motor.gearBox,true)
    end
    sleep(0.1)
    redstone.setOutput(motor.clutch,false)
    sleep(timeS)
    redstone.setOutput(motor.clutch,true)
end
function AngleInRange(ang,_min,_max,invert)
    ang = MathLib.NormaliseAngle180(ang)
    if(invert) then if(ang <= _min and ang >= _max) then return true end else if(ang >= _min and ang <= _max)then return true end end
    return false
end
function TryRotateMotor(ang,rpm,motor)
    local direction = MathLib.Sign(ang)
    local rawRotS = MathLib.RawRotationTime(rpm,ang)
    local RotS = MathLib.RoundRotationTime(rawRotS)
    local newAng = MathLib.AngleFromRotationTimeS(rpm,RotS) * direction
    print(MathLib.NormaliseAngle180(MathLib.NormaliseAngle360(motor.curDeg + newAng)))
    if (RotS <= 0.05 or AngleInRange(MathLib.NormaliseAngle360(motor.curDeg + newAng),motor.min,motor.max) == false) then
        print("Abort: " .. ang .. " Degrees may cause a precision error")
        return 0
    end
    RotateMotor(motor,RotS,direction)
    return newAng
end

function CalculatePath(curA,tarA,_min,_max,invert)

end