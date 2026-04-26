local e = peripheral.find("BigReactors-Energizer")
local m = peripheral.find("monitor")

m.setTextScale(2)

local units={FE=1,KFE=1e3,MFE=1e6,GFE=1e9,TFE=1e12,PFE=1e15,EFE=1e18}

local function parseFE(t)
 local n,u=string.match(t,"([%d%.]+)%s*(%a+)")
 return (tonumber(n) or 0)*(units[u] or 1)
end

local function bg(c)
 m.setBackgroundColor(c)
 m.setTextColor(colors.black)
 m.clear()
end

local function at(x,y,t,fg,bgcol)
 m.setCursorPos(x,y)
 m.setTextColor(fg or colors.black)
 m.setBackgroundColor(bgcol or colors.white)
 m.write(t)
end

local function center(y,t,fg,bgcol)
 local w,_=m.getSize()
 at(math.floor((w-#t)/2)+1,y,t,fg,bgcol)
end

local function hline(y,c)
 local w,_=m.getSize()
 at(2,y,string.rep("-",w-2),c or colors.blue,colors.white)
end

local function bar(y,pct)
 local w,_=m.getSize()
 local x=4
 local bw=w-6
 local fill=math.floor(bw*pct)

 at(x-1,y,"[",colors.black,colors.white)

 for i=1,bw do
  if i<=fill then
   at(x+i-1,y," ",colors.white,colors.lime)
  else
   at(x+i-1,y," ",colors.white,colors.lightGray)
  end
 end

 at(x+bw,y,"]",colors.black,colors.white)
end

while true do
 bg(colors.white)

 local storedText=e.getEnergyStoredAsText()
 local storedFE=parseFE(storedText)
 local capFE=e.getEnergyCapacity()
 local pct=math.min(storedFE/capFE,1)

 local input=e.getEnergyInsertedLastTick()
 local output=e.getEnergyExtractedLastTick()
 local on=e.getActive()
 local w,h=m.getSize()

 -- Header
 center(1,"* ENERGIZER *",colors.blue,colors.white)
 hline(2,colors.blue)

 -- Black status strip
 center(3," STATUS: "..(on and "ONLINE" or "OFFLINE").." ",
  on and colors.lime or colors.red,
  colors.black
 )

 -- Big percent
 center(5,string.format("%.0f%%",pct*100),colors.black,colors.white)

 -- Energy bar
 bar(7,pct)

 -- Stored energy
 center(8,storedText.." / "..string.format("%.2e",capFE).." FE",colors.gray,colors.white)

 -- Divider
 local mid=math.floor(w/2)
 for y=10,13 do
  at(mid,y,"|",colors.blue,colors.white)
 end

 -- IN left
 at(4,10,"IN ->",colors.blue,colors.white)
 at(4,11,tostring(input),colors.blue,colors.white)
 at(4,12,"FE/t",colors.gray,colors.white)

 -- OUT right
 local outText=tostring(output)
 at(w-12,10,"OUT ->",colors.orange,colors.white)
 at(w-12,11,outText,colors.orange,colors.white)
 at(w-12,12,"FE/t",colors.gray,colors.white)

 -- Bottom black strip
 center(h," ... TAP ANYWHERE TO TOGGLE ... ",colors.white,colors.black)

 local timer=os.startTimer(0.5)

 while true do
  local ev,_,x,y=os.pullEvent()

  if ev=="timer" then break end

  if ev=="monitor_touch" then
   if x<=2 and y<=1 then
    bg(colors.black)
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
