pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- init, update, draw

function _init()
  add_commit_message()
end

function _update()
  move(p)
  ticks += 1
end

function _draw()
  cls()
  print(p.x..", "..p.y..", "..p.f, 0,0)
  spr(p.f,p.x,p.y)
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
  if (btn(⬆️)) self.y -= 1
  if (btn(⬇️)) self.y += 1
  if (btn(⬅️)) self.x -= 1
  if (btn(➡️)) self.x += 1
  if ticks%4 == 0 then
    p.f = cycle_f(p.f, 2, 2)
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
