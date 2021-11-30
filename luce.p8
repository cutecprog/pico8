pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- init, update, draw

function _init()
  add_commit_message()
  p.mask = make_bitmask(8,0,
                     p.w,p.h)
  g.mask = make_bitmask(32,0,
                     g.w,g.h)
end

function _update60()
  if ticks_fps[60]%10 == 0 then
    p.f = cycle_f(p.f, 2, 2)
  end
  if ticks_fps[60]%4 == 0 then
    update(15, ticks_fps[15])
    ticks_fps[15] += 1
  end
  if ticks_fps[60]%2 == 0 then
    update(30, ticks_fps[30])
    ticks_fps[30] += 1
  end
  update(60, ticks_fps[60])
  ticks_fps[60] += 1
end

function _draw()
  cls()
  map(0,0,0,0,8,8)
  spr(p.f,p.x,p.y)
  spr(5,p.x,p.y)
  spr(g.f,g.x,g.y,1,1)
  print(round(stat(1)*100).."%",0,0)
  print(p.aim)
end
-->8
-- util function

function fm(n, den, num)
  num = num or 1
  return n*num%den < num
end

-- helps b approach a in 1d
function approach(a,b)
  return (a > b) and 1 
         or (a==b) and 0 
         or -1
end

-- limit n to range -1 to 1
function limit(n)
  return (n>1) and 1 or (n<-1) and -1 or n
end

function round(n)
  return (n%1 >= .5) 
           and ceil(n)
           or flr(n)
end

-- > run breadcrumb text
-- write stat(6) to file to use
-- as git commit message
function add_commit_message()
  -- this saves 1 token
  local msg = stat(6)
  -- check if message entered
  if msg ~= "~~~" 
      and msg ~= "" then
    -- write message to file
    printh(msg, "msg", true)
    -- report success (opt)
    ?"commit message set"
    -- sleep for 30 frames (opt)
    for i=1, 30 do flip() end
    -- reset breadcrumb
    run("~~~")
  end
end
-- further explaination:
-- stat(6) = breadcrumb text
-- if stat(6) == "" then
--   stat(6) hasn't been set
-- after stat(6) is set then
-- it can't go back to ""
-- so stat(6) is set t0 "~~~"
-->8
-- player code

p = {}
p.x = 0
p.y = 0
p.f = 1 -- draw frame for p
p.w = 8
p.h = 8
p.dx = 0
p.dy = 0
p.aim = 0
p.mask = {}

-- in increments of pi/2
aim_angle = { 
    ["n"]=0,["ne"]=1,
    ["e"]=2,["se"]=3,
    ["s"]=4,["sw"]=5,
    ["w"]=6,["nw"]=7 }

btnp🅾️ = 0  -- global
function check_xo()
  if btn(❎) then
    func_fps[1] = 60
  else
    func_fps[1] = 30
  end
  if btn(🅾️) then
    if btnp🅾️ > 8 then
      func_fps[1] = 0
    --elseif btnp🅾️ == 0 then
      --sfx(0)
    end
    btnp🅾️ += 1
  else
    if btnp🅾️ > 0 then
      sfx(0)
      btnp🅾️ = 0
    end
  end
  local dy,dx,aim = 0,0,""
  if btn(⬆️) then
    dy = -1
    aim = "n"
  elseif btn(⬇️) then
    dy = 1
    aim = "s"
  end
  if btn(⬅️) then
    dx = -1
    aim = aim.."w"
  elseif btn(➡️) then
    dx = 1
    aim = aim.."e"
  end
  p.dx,p.dy,p.aim = dx,dy,
      aim_angle[aim] or p.aim
end

function cycle_f(f, s, l)
  -- given list with x, y & f
  -- start frame number,
  -- length of animation
  f -= s
  f = (f+1)%l
  f += s
  return f
end

function move_p(ticks)
  local dy,dx = p.dy,p.dx
  -- select frame
  if dy == 0 and dx == 0 then
    p.f = 1
  end
  -- normalize
  if not fm(ticks,99,70) 
      and dy ~= 0
      and dx ~= 0 then
    dy,dx = 0,0
  end
  p.y += dy
  p.x += dx
  p.dy = dy
  p.dx = dx
  if collide_pp(p,g) then
    p.y -= dy
    p.x -= dx
    p.dy = 0
    p.dx = 0
  end
end
-->8
-- npc code
g = {}
g.x = 20
g.y = 20
g.f = 4
g.w = 8
g.h = 8
g.dy = 0
g.dx = 0
g.mask = {}

function move_g(ticks)
  if ticks%32 < 8 then
    g.dy += 1
    g.dx += -1
  elseif ticks%32 < 16 then
    g.dy += -1
    g.dx += -1
  elseif ticks%32 < 24 then
    g.dy += -1
    g.dx += 1
  else
    g.dy += 1
    g.dx += 1
  end
  g.dy = limit(g.dy)
  g.dx = limit(g.dx)
  g.y += g.dy
  g.x += g.dx
  if collide_pp(p,g) then
    g.y -= g.dy 
    g.x -= g.dx
  end
  g.dy, g.dx = 0,0
end

function g_approach(ticks)
  -- normalize
  if not fm(ticks,99,70) 
      and p.dy ~= 0
      and p.dx ~= 0 then
    return
  end
  g.dy = approach(p.y, g.y) 
  g.dx = approach(p.x, g.x)
end
-->8
-- scheduler?
func_list = 
    {move_p,check_xo,
     g_approach,move_g}
func_fps = {30,60,15,30}
ticks_fps = {}
ticks_fps[15]=0
ticks_fps[30]=0
ticks_fps[60]=0

function update(fps, ticks)
  for i=1, #func_list do
    if (func_fps[i]==fps) func_list[i](ticks)
  end
end
-->8
-- freds72 per-pixel api
function make_bitmask(sx,sy,sw,sh,tc)
	assert(flr(sw/32)<=1,"32+pixels wide sprites not yet supported")
	tc=tc or 0
	local bitmask={}
	for j=0,sh-1 do
  local bits,mask=0,0x1000.0000
  for i=0,sw-1 do
		 local c=sget(sx+i,sy+j)
   if(c!=tc) bits=bor(bits,lshr(mask,i))  
  end
  bitmask[j]=bits
 end
 return bitmask
end

function intersect_bitmasks(a,b,x,ymin,ymax)
	local by=flr(a.y)-flr(b.y)
	for y=ymin,ymax do
	 -- out of boud b mask returns nil
	 -- nil is evaluated as zero :]
		if(band(a.mask[y],lshr(b.mask[by+y],x))!=0) return true		
	end
end

function collide_aabox(a,b)
	-- a is left most
	if(a.x>b.x) a,b=b,a
	-- screen coords
	local ax,ay,bx,by=flr(a.x),flr(a.y),flr(b.x),flr(b.y)
	local xmax,ymax=bx+b.w,by+b.h
	if ax<xmax and 
	 ax+a.w>bx and
	 ay<ymax and
	 ay+a.w>by then
	 -- collision coords in a space
 	return true,a,b,bx-ax,max(by-ay),min(by+b.h,ay+a.h)-ay
	end
end
-->8
-- additional collision code
function collide_pp(a,b)
  -- aabox collision
		local col,a,b,x0,y0,y1=
		   collide_aabox(p,g)
		-- per-pixel collision
		return col and 
		    intersect_bitmasks(a,b,
		                     x0,y0,y1)
		  and true
	   or false
end
__gfx__
000000000000000000000000000000000777777000000000000bbbbbb0000000bbb0000000000000000000000000000000000000000000000000000000000000
0000000004444440044444400444444076076007000000000bb000000bb00000000bb00000000000000000000000000000000000000000000000000000000000
007007000444444004444440044444407607700600000000b0000000000b000000000b0000000000000000000000000000000000000000000000000000000000
000770000444444004444440044444407777776700a00a000000000000000000000000b000000000000000000000000000000000000000000000000000000000
0007700004444440044444400444444077700777000000000000000000000000000000b0000000000000bbb000000000000000000bbbbbb00000000000000000
00700700033333300333333003333330677007760000000000000000000000000000000b000000000000000bb00000000000000bb000000bb000000000000000
00000000003003000030030000300300067777700000000000000000000000000000000b00000000000000000b000000000000b0000000000b00000000000000
00000000003003000000030000300000000007770000000000000000000000000000000b000000000111111000b0000000000000000000000000000000000000
0000000000000600000006000000000000000000000000000000000000000bbbbbb00000000000001111111100b0000000000000000000000000000000000000
00077000000006000000060000077000000770000000000000000000000bb000000bb0000000000114444441100b000000000000044444400000000000000000
0007700000077600000776000007700000077000000000000000000000b0000000000b000000000114444441100b000000000000044444400000000000000000
666666666666660000077600666776006667766600000000000000000b080000000080b00000000114444441100b000000000000044444400000000000000000
000770000007760000077600000776000007700000000000000000000b00aaaaaaaa00b000000001144444411000000000000000044444400000000000000000
66666666666666000007760066677600666776660000000000000000b000a800008a000b00000001133333311000000000000000033333300000000000000000
00077000000770000007760000077600000770000000000000000000b000a080080a000b00000001113113111000000000000000003003000000000000000000
00077000000770000007760000077600000770000000000000000000b000a008800a000b00000000113113110000000000000000003003000000000000000000
00000000000000000000000000000000000000000000000000000000b000a008800a000b00000000011111100000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000b000a080080a000b00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000b000a800008a000b00000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000b00aaaaaaaa00b000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000b080000000080b000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000b0000000000b0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000bb000000bb00000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000bbbbbb0000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76076007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
76077006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777767000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67700776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000014141413000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000012000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010101010101011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000020050380000900013000210002200012000010002f0003000032000340003400034000310002d00029000220001c000170001300011000240001d00017000130000e0000d00000000000000000000000
