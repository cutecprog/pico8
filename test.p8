pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- game file
-- blah blah
i=0
j=0
avg=0
ticks=0
function _init()
  add_commit_message()
  cls()
  --a,b,c = 2, .5, -2
  --print(limit(a))
  --print(limit(b))
  --print(limit(c))
  --fps = bunpack(19)
  --for v in all(fps) do
  --  print(v)
  --end
  --args = {flip,1,2,3}
  --print_args(unpack(args,2))
  ?fm(12,6,5)
end

function _update60()
  if (fm(ticks,99,70)) i+=1
  j+=1
  ticks+=1
end

function _draw()
  cls()
  print(i/j)
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
-->8
function limit(n)
  return (n>1) and 1 or (n<-1) and -1 or n
end
-->8
-- bitfield unpack

-- 33 tokens
function bunpack(bitfield)
  local blist = {}
  while bitfield ~= 0 do
    -- add bit to blist table
    -- if bf%2==1 then true
    -- else false
    add(blist, bitfield%2==1 
        and true or false)
    -- shift to see next bit
    bitfield = flr(bitfield>>1)
  end
  return blist
end
-->8
function fm(n, den, num)
  num = num or 1
  ?num
  if (num==1) return n%den==0
  if (den-num==1) return n%den~=0
  return n*num%den < num
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
