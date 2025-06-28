pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
	villagers = {
			{
				index=1,
				sprite=2,x=10,y=10,
				likes={"cake;school;family"},
				text={"hey, how are you?;test"}
			},
			{
				index=2,
				sprite=3,x=20,y=20, 
				likes={"testing;gaming;family"},
				text={"hey, sup?;test"}
			},
			{
				index=3,
				sprite=4,x=30,y=30, 
				likes={"testing;gaming;family"},
				text={"hey, sup bro?;test"}
			},	
	}
	frame = 0.01
	player = {
		x = 0,
		y = 0,
	}
end
-->8
function check_coll()
	for i=1, #villagers do
		local villager=villagers[i]
		if player.x + 4 > villager.x and
			player.x + 4 < villager.x + 8 and
			player.y + 4 > villager.y and
			player.y + 4 < villager.y + 8 then
				current_villager=villager
				debug_text="☉"
				return
		elseif current_villager 
			and i == current_villager.index then
				debug_text="…"
				current_villager=nil	
		end
	end
end
	
function _update()
	check_coll()
	if btn(0) then
		player.x -= 1
	elseif btn(1) then
		player.x += 1
	end
	
	if btn(2) then
		player.y -= 1
	elseif btn(3) then
		player.y += 1
	end
	
	if btn(4) and current_villager then
		debug_text="♥"
	end
	
	frame += 0.05
end

function _draw()
 	cls(2)
 	
 	print(debug_text, 1, 1,1)
 		
 	rectfill(63, 0, 128, 128, 6)
 	rectfill(0, 100, 128, 128, 16)
 	print("example text here ..", 1, 105, 6)
 	
 	for i=1,#villagers do
 		local my = cos(frame) * i * 0.1
 		spr(villagers[i].sprite, villagers[i].x, villagers[i].y)
 	end
 	spr(0, player.x, player.y)	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000070700000070000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00900900003003000077700000777000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000bb0000007000000070000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000bb0000077700000777000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00900900003003000707070007070700070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007000000070000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000070700000707000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
