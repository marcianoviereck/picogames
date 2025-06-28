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
	elseif btn(1) then
		player.x += 1
	end
	if btn(2) then
		player.y -= 1
	elseif btn(3) then
		player.y += 1
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

function _draw()
	cls()
	for i=1,#level do
		circfill(level[i].x, level[i].y, 2, level[i].c)	
	end
	print(debug_text, 1, 1, 7)
	circfill(ball.x, ball.y, 2, ball.c)
	circfill(player.x, player.y, 1, 3)
end
-->8
function _init()
	player = {
		x = 63,
		y = 120
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
