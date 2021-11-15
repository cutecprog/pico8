pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- game file
-- blah blah
i=0
j=0
ticks=0
function _init()
  add_commit_message()
end

function _update()
  if (ticks%4~=0) i+=1
  j+=1
  attempt = j/(sqrt(2)/2)%1
  if attempt >= 0.99
      or attempt <= .009 then
    print(j)
  end
  ticks+=1
end

function _draw()
  --cls()
  --print(j/.707%1)
  --print(i.."/"..j.."="..i/j)
end
-->8
-- util functions

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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
