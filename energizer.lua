local e=peripheral.wrap("BigReactors-Energizer_0")
local m=peripheral.wrap("left")

m.setTextScale(0.5)

local function center(y,text,color)
 local w,_=m.getSize()
 m.setCursorPos(math.floor((w-#text)/2)+1,y)
 m.setTextColor(color or colors.white)
 m.write(text)
end

local function bar(y,pct)
 local w,_=m.getSize()
 local bw=w-4
 local fill=math.floor(bw*pct)

 m.setCursorPos(3,y)

 for i=1,bw do
  if i<=fill then
   if pct>0.6 then m.setBackgroundColor(colors.green)
   elseif pct>0.3 then m.setBackgroundColor(colors.yellow)
   else m.setBackgroundColor(colors.red) end
  else
   m.setBackgroundColor(colors.gray)
  end
  m.write(" ")
 end

 m.setBackgroundColor(colors.black)
end

while true do
 m.clear()

 local en=e.getEnergyStoredAsText()
 local cap=e.getEnergyCapacity()
 local i=e.getEnergyInsertedLastTick()
 local o=e.getEnergyExtractedLastTick()
 local on=e.getActive()

 local num=tonumber(string.match(en,"%d+")) or 0
 local pct=num/cap

 -- Title
 center(1,"⚡ ENERGIZER ⚡",colors.cyan)

 -- Status
 center(3,"Status: "..(on and "ONLINE" or "OFFLINE"))

 -- Big %
 center(5,string.format("%.1f%%",pct*100),colors.white)

 -- Energy text
 center(6,en)

 -- Bar
 bar(8,pct)

 -- Rates
 center(10,"IN  : "..i.." FE/t")
 center(11,"OUT : "..o.." FE/t")

 -- Button
 local w,h=m.getSize()
 local bx=math.floor((w-18)/2)
 local by=h-2

 m.setCursorPos(bx,by)
 m.setBackgroundColor(on and colors.red or colors.green)
 m.setTextColor(colors.white)
 m.write("   TAP TO TOGGLE   ")
 m.setBackgroundColor(colors.black)

 local t=os.startTimer(0.5)

 while true do
  local ev,_,x,y=os.pullEvent()
  if ev=="timer" then break end
  if ev=="monitor_touch" then
   e.setActive(not on)
   break
  end
 end
end
