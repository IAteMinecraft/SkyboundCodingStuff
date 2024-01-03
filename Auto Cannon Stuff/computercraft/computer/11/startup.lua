local test = peripheral.find("sp_radar")
--local h = fs.open("example", "w")
--h.write(textutils.serialise(test.scan(10)))
peripherals = peripheral.getNames()

for i = 1, #peripherals do
    print(peripherals[i]
end
