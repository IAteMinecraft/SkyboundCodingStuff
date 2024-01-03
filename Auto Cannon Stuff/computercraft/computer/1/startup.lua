-- Load APIs
os.loadAPI("TargetingAPI.lua")
os.loadAPI("CannonMathLibrary.lua")
os.loadAPI("CannonMotorAPI.lua")
print("test")

function Main()
    while true do
        print(GetTarget())
        sleep(0)
    end
end








parallel.waitForAll()