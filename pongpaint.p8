pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function move_ball()
	ball.x += ball.dx
	ball.y += ball.dy
	if ball.x > 127 then
		ball.dx = -1
	elseif ball.x < 1 then
		ball.dx = 1
	end
	if ball.y > 127  then
		ball.dy = -1
	elseif ball.y < 1 then
		ball.dy = 1
	end
end

function _update()
	move_ball()
	if btn(0) then
		player.x -= 1
		player.direction = 0
	elseif btn(1) then
		player.x += 1
		player.direction = 2
	end
	if btn(2) then
		player.y -= 1
		player.direction = 1
	elseif btn(3) then
		player.y += 1
		player.direction = 3
	end
	
	if btn(4) then
		for i=1, #level do
			if player.x + 2 > level[i].x
				and player.x + 2 < level[i].x + 4
				and player.y + 2 > level[i].y
				and player.y + 2 < level[i].y + 4 then			 
				
				local stored = level[i]
				debug_text = stored.y
				if stored.y > 62 then
					stored.c = 2
				else
					stored.c = 15
				end
				-- remove it from list and re-add it to make it render last --
				del(level, stored)
				add(level, stored)
			end
		end
	end
end

function draw_player()
	if player.direction == 0 then -- 0 = left --
		spr(player.base_spr_index + 2, player.x, player.y)
		spr(player.base_spr_index + 4, player.x - 3, player.y + 2)	
	elseif player.direction == 1 then -- top --
		spr(player.base_spr_index + 3, player.x - 2, player.y)
		spr(player.base_spr_index + 1, player.x, player.y)	
	elseif player.direction == 2 then -- right --
		spr(player.base_spr_index + 2, player.x, player.y, 1, 1, true, false)
		spr(player.base_spr_index + 4, player.x + 3, player.y + 2, 1, 1, true, false)	
	elseif player.direction == 3 then -- down
	 spr(player.base_spr_index, player.x, player.y)
		spr(player.base_spr_index + 3, player.x + 1, player.y + 2)	
	end
end

function _draw()
	cls()
	for i=1,#level do
		circfill(level[i].x, level[i].y, 2, level[i].c)	
	end
	print(debug_text, 1, 1, 7)
	circfill(ball.x, ball.y, 2, ball.c)
	draw_player()
end
-->8
function _init()
	player = {
		x = 63,
		y = 120,
		direction=0, -- 0 = left, 1 = up, 2 = right, 3 = down --
		base_spr_index = 0
	}
	ball = {
		x = 62,
		y = 62,
		dx = 1,
		dy = 1,
		c = 0
	}
	level = {}
	for x=1, 65 do
		for y=1, 65 do
				local col = 15
				if y < 32 then
					col = 2
				end
			add(level, {x=x*2-1, y=y*2-1, c=col})
		end
	end
end
__gfx__
01111100011111000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111100011111000111100000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000
01626100011111000261100000666600006600000000000000000000000000000200000000020000000000000000000000006000000000000000000000000000
01666100011111000666100000622600002200000000000000000000000000000020000000020000000000000020000000002000000000200000000000000000
00060000000100000006000000662600006200000006000000060000022600000006000000060000000000000002000000002000000002000000000000000000
00661000006610000011100000626600002600000002000000200000200000000000000000000000000000000000600000020000000060000000000200000000
00626000006160000021600000066000000600000002000002000000000000000000000000000000022600000000000000000000000000000000622000000000
00166000001660000016600000000000000000000000200000000000000000000000000000000000200000000000000000000000000000000000000000000000
