local radar = peripheral.wrap("bottom")


local targetPos = vector.new(0,0,0)


local function FindTarget()
    
end

function GetTarget()
    return targetPos
end

function Main()
    while true do
        SqrMag(vector.new(0,1,0),vector.new(0,1,0))
        sleep(0.1)
    end
end

print(scanForEntities(10))
