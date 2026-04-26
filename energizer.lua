local e = peripheral.find("BigReactors-Energizer")
local m = peripheral.find("monitor")

m.setTextScale(1)

local function clear(bg)
 m.setBackgroundColor(bg)
 m.clear()
end

local function writeAt(x,y,text,fg,bg)
 m.setCursorPos(x,y)
 m.setTextColor(fg or colors.black)
 m.setBackgroundColor(bg or colors.white)
 m.write(text)
end

local function center(y,text,fg,bg)
 local w,_ = m.getSize()
 writeAt(math.floor((w-#text)/2)+1,y,text,fg,bg)
end

local function line(y,color)
 local w,_ = m.getSize()
 writeAt(2,y,string.rep("-",w-2),color or colors.blue,colors.white)
end

local function drawBar(y,pct)
 local w,_ = m.getSize()
 local bw = w-14
 local x = 7
 local fill = math.floor(bw*pct)

 writeAt(x-1,y,"[",colors.black,colors.white)

 for i=1,bw do
  if i<=fill then
   writeAt(x+i-1,y," ",colors.white,colors.lime)
  else
   writeAt(x+i-1,y," ",colors.black,colors.lightGray)
  end
 end

 writeAt(x+bw,y,"]",colors.black,colors.white)
end

while true do
 clear(colors.white)

 local en = e.getEnergyStoredAsText()
 local cap = e.getEnergyCapacity()
 local input = e.getEnergyInsertedLastTick()
 local output = e.getEnergyExtractedLastTick()
 local on = e.getActive()

 local num = tonumber(string.match(en,"%d+")) or 0
 local pct = math.min(num / cap, 1)

 local w,h = m.getSize()

 center(1,"/ ENERGIZER \\",colors.lightBlue,colors.white)
 line(2,colors.blue)

 center(3,"STATUS: "..(on and "ONLINE" or "OFFLINE"),on and colors.lime or colors.red,colors.black)

 center(5,string.format("%.0f%%",pct*100),colors.black,colors.white)

 drawBar(7,pct)

 center(8,en.." / "..cap.." FE",colors.gray,colors.white)

 line(10,colors.blue)

 writeAt(4,11,"IN  -> ",colors.blue,colors.white)
 writeAt(11,11,tostring(input),colors.black,colors.white)
 writeAt(20,11,"FE/t",colors.gray,colors.white)

 writeAt(4,12,"OUT -> ",colors.orange,colors.white)
 writeAt(11,12,tostring(output),colors.black,colors.white)
 writeAt(20,12,"FE/t",colors.gray,colors.white)

 center(h," TAP ANYWHERE TO TOGGLE ",colors.white,colors.black)

 local t = os.startTimer(0.5)

 while true do
  local ev,_,x,y = os.pullEvent()

  if ev=="timer" then break end

  if ev=="monitor_touch" then
   if x<=3 and y<=2 then
    clear(colors.black)
    term.clear()
    term.setCursorPos(1,1)
    print("Stopped")
    return
   end

   e.setActive(not on)
   break
  end
 end
end
