os.loadAPI("apis/CannonControllerAPI.lua")
local controller = CannonControllerAPI

controller.SetOriginPosition(vector.new(-32,-53,-24))
controller.InitialiseCannon()

controller.AimToward(vector.new(-50,-50,-50))
controller.SetFire(true)
print("aiming at: " .. textutils.serialise(controller.GetLastAimPos()) .. " With heading: " ..controller.GetAimRotation().x .. " with pitch: " .. controller.GetAimRotation().y)
sleep(3)
controller.SetFire(false)
print("returning to 0,0")
controller.SetAimAngles(0,0)