-- Load APIs
os.loadAPI("TargetingAPI.lua")
os.loadAPI("CannonMathLibrary.lua")
os.loadAPI("CannonMotorAPI.lua")
print("test")

function Main()
    while true do
        GetTarget()
        sleep(1)
    end
end








parallel.waitForAll(Main)