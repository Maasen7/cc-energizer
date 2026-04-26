local e = peripheral.find("BigReactors-Energizer")
local m = peripheral.find("monitor")

m.setTextScale(2)

local units = {
 FE = 1,
 KFE = 1e3,
 MFE = 1e6,
 GFE = 1e9,
 TFE = 1e12,
 PFE = 1e15,
 EFE = 1e18
}

local function parseFE(text)
 local n,u = string.match(text,"([%d%.]+)%s*(%a+)")
 n = tonumber(n) or 0
 u = units[u] or 1
 return n * u
end

local function clear()
 m.setBackgroundColor(colors.white)
 m.setTextColor(colors.black)
 m.clear()
end

local function center(y,text,fg,bg)
 local w,_ = m.getSize()
 m.setCursorPos(math.floor((w-#text)/2)+1,y)
 m.setTextColor(fg or colors.black)
 m.setBackgroundColor(bg or colors.white)
 m.write(text)
end

local function bar(y,pct)
 local w,_ = m.getSize()
 local bw = w - 6
 local fill = math.floor(bw * pct)

 m.setCursorPos(4,y)
 for i=1,bw do
  if i<=fill then
   m.setBackgroundColor(colors.lime)
  else
   m.setBackgroundColor(colors.lightGray)
  end
  m.write(" ")
 end
 m.setBackgroundColor(colors.white)
end

while true do
 clear()

 local storedText = e.getEnergyStoredAsText()
 local storedFE = parseFE(storedText)
 local capFE = e.getEnergyCapacity()
 local pct = math.min(storedFE / capFE, 1)

 local input = e.getEnergyInsertedLastTick()
 local output = e.getEnergyExtractedLastTick()
 local on = e.getActive()

 local w,h = m.getSize()

 center(1,"ENERGIZER",colors.blue)
 center(2,string.format("%.0f%%",pct*100),colors.black)
 center(3,on and "ONLINE" or "OFFLINE", on and colors.green or colors.red)

 bar(4,pct)

 center(5,storedText,colors.gray)
 center(6,"IN "..input,colors.blue)
 center(7,"OUT "..output,colors.orange)

 center(h," TAP = TOGGLE ",colors.white,colors.black)

 local t=os.startTimer(0.5)

 while true do
  local ev,_,x,y=os.pullEvent()

  if ev=="timer" then break end

  if ev=="monitor_touch" then
   if x<=2 and y<=1 then
    clear()
    print("Stopped")
    return
   end

   e.setActive(not on)
   break
  end
 end
end
