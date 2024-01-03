-- Load APIs
os.loadAPI("Targeting.lua")
os.loadAPI("MathLibrary.lua")
os.loadAPI("CannonMotor.lua")
print("test")

function Main()
    while true do
        print(Targeting.GetTarget())
        sleep(2)
    end
end








parallel.waitForAll(Main,Targeting.Main)