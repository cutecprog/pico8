pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- init, update, draw

function _init()
  add_commit_message()
  p.mask = make_bitmask(8,0,
                     p.w,p.h)
  g.mask = make_bitmask(0,512,
                     g.w,g.h)
end

function _update60()
  if ticks_60%2 == 0 then
    update(fps30, ticks_30)
    --move_p()
    --move_g()
    ticks_30 += 1
  end
  update(fps60, ticks_60)
  ticks_60+=1
end

function _draw()
  cls()
  print(p.x..", "..p.y..", "..p.f, 0,0)
  print(g.x)
  print(g.y)
  spr(p.f,p.x,p.y)
  spr(g.f,g.x,g.y,1,1,true)
end
-->8
-- util function

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

function check_xo()
  if btn(❎) then
    fps30[1] = false
    fps60[1] = true
  else
    fps30[1] = true
    fps60[1] = false
  end
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
  local dy, dx = 0,0
  if (btn(⬆️)) dy = -1
  if (btn(⬇️)) dy = 1
  if (btn(⬅️)) dx = -1
  if (btn(➡️)) dx = 1
  -- select frame
  if dy == 0 and dx == 0 then
    p.f = 1
  elseif ticks%4 == 0 then
    p.f = cycle_f(p.f, 2, 2)
  end
  -- normalize
  if ticks*70%99 >= 70
      and dy ~= 0
      and dx ~= 0 then
    dy, dx = 0, 0
  end
  p.y += dy
  p.x += dx
end
-->8
-- npc code
g = {}
g.x = 20
g.y = 20
g.f = 64
g.w = 8
g.h = 8

function move_g(ticks)
  if ticks%32 < 8 then
    g.y += 1
    g.x += -1
  elseif ticks%32 < 16 then
    g.y += -1
    g.x += -1
  elseif ticks%32 < 24 then
    g.y += -1
    g.x += 1
  else
    g.y += 1
    g.x += 1
  end
  -- set to half speed
  if (ticks%2 == 0) return
  local dy,dx
  if p.x > g.x then
    dx = 1
  elseif p.x == g.x then
    dx = 0
  else
    dx = -1
  end
  if p.y > g.y then
    dy = 1
  elseif p.y == g.y then
    dy = 0
  else
    dy = -1
  end
  -- normalize
  if ticks*70%99 >= 70
      and dy ~= 0
      and dx ~= 0 then
    dy, dx = 0, 0
  end
  g.y += dy
  g.x += dx
end
-->8
-- scheduler?
func_list = {move_p,move_g,check_xo}
fps30 = {true,true, false}
fps60 = {false,false,true}
ticks_30 = 0
ticks_60=0

function update(fps, ticks)
  for i=1, #func_list do
    if (fps[i]) func_list[i](ticks)
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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000044444400444444004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700044444400444444004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700004a44a4004a44a4004a44a40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000044444400444444004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700033333300333333003333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003003000030030000300300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003003000000030000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
__sfx__
0001000012200152002e200192001b200302002820024200212001e2001c2001b2001d2001f2002120023200262002b2002f200302002f20029200242001d20017200132000e2000d20000200002000020000200
