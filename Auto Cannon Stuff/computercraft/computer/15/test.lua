local detector = peripheral.find("playerDetector")

local pos = detector.getPlayerPos("3F0x")
print("Position: " .. pos.x .. "," .. pos.y .. "," .. pos.z)
