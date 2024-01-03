function AngleBetweenWrapped(curA,trgA)
    return  (trgA - curA + 540) % 360-180
end

function Clamp(low,value,high)
    return math.min(high,math.max(low,value))
end

function NormaliseAngle360(angle)
    return angle + math.ceil( (-angle) / 360 ) * 360
end
function NormaliseAngle180(angle)
        if(angle > 180) then return angle - 360 end
        return angle
end
function ConstrainAngle(angle,_min,_max,invert)
    local range = math.abs(AngleBetweenWrapped(_min,_max))
    if(invert) then range = 360 - range end
    local shiftedAngle = angle
    shiftedAngle = NormaliseAngle180(shiftedAngle)
    shiftedAngle = shiftedAngle + (range * 0.5)
    local val = Clamp(shiftedAngle,0,range)
    val = val - (range * 0.5)
    return val
end

function RawRotationTime(_rpm,deg)
    return math.abs(deg) / ((_rpm * 360) / 60)
end

function RoundRotationTime(time)
    return math.floor(time / 0.05 + 0.5) * 0.05
end

function AngleFromRotationTimeS(_rpm,timeS)
    return ((_rpm * 360) / 60) * timeS
end

function Sign(v)
    return (v > 0 and 1) or (v == 0 and 0) or -1
end

