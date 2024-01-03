
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

function TryRotateMotor(ang,rpm,motor)
    local direction = Sign(ang)
    local rawRotS = CalculateRawRotationTime(rpm,ang)
    local RotS = RoundRotationTime(rawRotS)
    if (RotS <= 0.05) then
        print("Abort: " .. ang .. " Degrees may cause a precision error")
        return 0
    end
    local newAng = CalculateNewAngle(rpm,RotS) * direction
    RotateMotor(motor,RotS,direction)
    return newAng
end

function CalculatePath(curA,tarA,_min,_max,invert)
    curA = NormaliseAngle180(curA)
    tarA = NormaliseAngle180(tarA)
    _min = NormaliseAngle180(_min)
    _max = NormaliseAngle180(_max)
    local limitRange = math.abs(AngleBetweenWrapped(_min,_max))
    local angleA = math.min(curA,tarA)
    local angleB = math.max(curA,tarA)
    _max = limitRange
    
    angleA = angleA - _min
    angleB = angleB - _min
    _min = 0
    local range = angleB - angleA
    local invRange = (360-range) *-1
    if(math.min(curA,tarA) == curA) then invRange = invRange * -1
    range = range *-1
    end
    if(invert) then if((angleA + math.abs(range)) >= _max) then return invRange else print("invalid")end
        else
        if((angleA + math.abs(range)) > _max) then print("invalid") else return range end
    end
    return nil
end