pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- init, update, draw

function _init()
  add_commit_message()
end

function _update60()
  move(p)
  move(g,1,1)
  ticks += 1
end

function _draw()
  cls()
  print(p.x..", "..p.y..", "..p.f, 0,0)
  spr(p.f,p.x,p.y)
  spr(g.f,g.x,g.y,1,1,true)
end
-->8
-- util function

function add_commit_message()
  -- check breadcrumb if reset
  -- call in _init()
  if stat(6) ~= "~~~" then
    ?"commit message set"
    printh(stat(6), "msg", true)
    -- sleep 1 second
    for i=1, 30 do flip() end
    -- reset breadcrumb
    run("~~~")
  end
end
-->8
-- player code

p = {}
p.x = 0
p.y = 0
p.f = 1 -- draw frame for p
ticks = 0

function cycle_f(f, s, l)
  -- given list with x, y & f
  -- start frame number,
  -- length of animation
  f -= s
  f = (f+1)%l
  f += s
  return f
end

function move(self)
  local dy, dx = 0,0
  if (btn(⬆️)) dy = -1
  if (btn(⬇️)) dy = 1
  if (btn(⬅️)) dx = -1
  if (btn(➡️)) dx = 1
  -- select frame
  if dy == 0 and dx == 0 then
    p.f = 1
  elseif ticks%8 == 0 then
    p.f = cycle_f(p.f, 2, 2)
  end
  -- normalize
  if ticks*70%99 >= 70
      and dy ~= 0
      and dx ~= 0 then
    dy, dx = 0, 0
  end
  self.y += dy
  self.x += dx
end
-->8
-- npc code
g = {}
g.x = 20
g.y = 20
g.f = 64

function move(self, dy, dx)
  -- normalize
  if ticks*70%99 >= 70
      and dy ~= 0
      and dx ~= 0 then
    dy, dx = 0, 0
  end
  self.y += dy
  self.x += dx
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
