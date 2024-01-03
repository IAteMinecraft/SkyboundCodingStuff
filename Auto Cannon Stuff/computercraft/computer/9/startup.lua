    -- Load   eAPIs
os.loadAPI("RadarDataManager.lua")
print("test")

function Main()
    while true do
        
        sleep(2)
    end
end








parallel.waitForAll(Main,RadarDataManager.Main)
