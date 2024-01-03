os.loadAPI("TableTools.lua")
--radars send broadcast data if they have a potential target (at any time)
local r1,r2,r3,r4 = peripheral.find("sp_radar")
local results = {}
local _tmp = {}

function TryScan(_radar)
    if(_radar == nil) then return end
    local result = _radar.scan(64)
    if(result == nil) then return end
    _tmp = TableTools.Merge(result,_tmp)
end
function Execute()
    _tmp = {}
    parallel.waitForAll(function() TryScan(r1) end,function() TryScan(r2) end,function() TryScan(r3) end,function() TryScan(r4) end)
    results = _tmp
end

function Main()
    while true do
        Execute()
        sleep()
    end
end
