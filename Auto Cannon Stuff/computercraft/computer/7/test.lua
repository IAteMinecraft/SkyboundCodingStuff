local rpm = 32 / 8
local dpm = rpm * 360
local dps = dpm / 60
local wait = 45 / dps
redstone.setOutput("right",false)
print(wait)
sleep(wait)
redstone.setOutput("right",true)
