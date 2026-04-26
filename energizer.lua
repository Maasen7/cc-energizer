local e = peripheral.find("BigReactors-Energizer")
local m = peripheral.find("monitor")

m.setTextScale(1.5)

local function center(y,text,color)
 local w,_ = m.getSize()
 m.setCursorPos(math.floor((w-#text)/2)+1,y)
 m.setTextColor(color or colors.white)
 m.write(text)
end

while true do
 m.clear()

 local en = e.getEnergyStoredAsText()
 local cap = e.getEnergyCapacity()
 local i = e.getEnergyInsertedLastTick()
 local o = e.getEnergyExtractedLastTick()
 local on = e.getActive()

 local num = tonumber(string.match(en,"%d+")) or 0
 local pct = num / cap

 -- TITLE (top)
 center(1,"ENERGIZER",colors.cyan)

 -- BIG % (center focus)
 center(3,string.format("%.0f%%",pct*100),colors.white)

 -- STATUS (big + colored)
 center(5,on and "ONLINE" or "OFFLINE", on and colors.green or colors.red)

 -- INPUT / OUTPUT (bottom)
 center(7,"IN "..i,colors.lightBlue)
 center(8,"OUT "..o,colors.orange)

 local t = os.startTimer(0.5)

 while true do
  local ev,_,x,y = os.pullEvent()

  if ev=="timer" then break end

  if ev=="monitor_touch" then
   -- exit corner
   if x <= 3 and y <= 2 then
    m.clear()
    m.setCursorPos(1,1)
    print("Stopped")
    return
   end

   e.setActive(not on)
   break
  end
 end
end
