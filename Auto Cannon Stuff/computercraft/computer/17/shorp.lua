 local radar = peripheral.find("radar")
local monitor = peripheral.find("monitor")
local i = 1

term.redirect(monitor) 

while true do
    sleep(0)
    if (i == 1) then
        local results = radar.scan(100)
        
        print(textutils.serialise(results[1]))
        
        sleep(0)
    end
    i = i + 1 
    if (i == 6) then
        monitor.clear() 
        i = 1
        sleep(0)
    end
end
