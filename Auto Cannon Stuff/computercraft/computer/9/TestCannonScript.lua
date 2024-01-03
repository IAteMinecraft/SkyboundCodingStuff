os.loadAPI("CannonMotor.lua")
os.loadAPI("MathLib.lua")

local cannonPosition = vector.new(-32,-53,-24)

CannonMotor.Initialise()

--point towards -50,-50,-20
local targetPosition = vector.new(-50,-50,-20)
local heading, pitch = MathLib.GetPitchAndHeading(cannonPosition,targetPosition)
CannonMotor.Execute(heading, pitch)

-- return to origin
CannonMotor.Execute(0, 0)
