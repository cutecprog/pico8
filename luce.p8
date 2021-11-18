pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- init, update, draw

function _init()
  add_commit_message()
end

function _update60()
  if ticks_60%2 == 0 then
    move_p()
    move_g()
    ticks += 1
  end
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
ticks = 0
ticks_60=0

function cycle_f(f, s, l)
  -- given list with x, y & f
  -- start frame number,
  -- length of animation
  f -= s
  f = (f+1)%l
  f += s
  return f
end

function move_p()
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

function move_g()
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
func_list = {move_p,move_g}
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
