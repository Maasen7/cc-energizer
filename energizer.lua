local e=peripheral.wrap("BigReactors-Energizer_0")
local m=peripheral.wrap("left")
m.setTextScale(0.5)

while true do
 m.clear()
 local w,h=m.getSize()
 local en=e.getEnergyStoredAsText()
 local cap=e.getEnergyCapacity()
 local i=e.getEnergyInsertedLastTick()
 local o=e.getEnergyExtractedLastTick()
 local on=e.getActive()

 local num=tonumber(string.match(en,"%d+")) or 0
 local pct=num/cap

 m.setCursorPos(2,1)
 m.write("ENERGIZER CONTROL")

 m.setCursorPos(2,3)
 m.write("State: "..(on and "ON" or "OFF"))

 m.setCursorPos(2,5)
 m.write(en)

 m.setCursorPos(2,6)
 m.write(string.format("%.1f%%",pct*100))

 local bw=w-2
 local fill=math.floor(bw*pct)

 m.setCursorPos(2,8)
 for i2=1,bw do
  if i2<=fill then m.setBackgroundColor(colors.green)
  else m.setBackgroundColor(colors.gray) end
  m.write(" ")
 end
 m.setBackgroundColor(colors.black)

 m.setCursorPos(2,10)
 m.write("In: "..i)

 m.setCursorPos(2,11)
 m.write("Out: "..o)

 m.setCursorPos(2,h-1)
 m.setBackgroundColor(on and colors.red or colors.green)
 m.write(" TAP TO TOGGLE ")
 m.setBackgroundColor(colors.black)

 local t=os.startTimer(0.5)
 while true do
  local ev,a,x,y=os.pullEvent()
  if ev=="timer" then break end
  if ev=="monitor_touch" then
   e.setActive(not on)
   break
  end
 end
end
