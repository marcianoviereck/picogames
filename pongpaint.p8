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

function play_animation(
	character, 
	start_frame,
	end_frame, 
	speed,
	offset_x,
	offset_y
)
	if not character.current_animation then
		character.current_animation = {
			start_frame = start_frame,
			end_frame = end_frame,
			current_frame = start_frame,
			current_frame_count = 0,
			speed = speed,
			offset_x = offset_x,
			offset_y = offset_y
		}
		end
end

function update_animation(character)
	if character.current_animation then
		local anim = character.current_animation
		if anim.current_frame == anim.end_frame then
			character.current_animation = nil
			anim.current_frame = 0
		elseif anim.current_frame < anim.end_frame + 1 then
			anim.current_frame_count += anim.speed
			if anim.current_frame_count >= 1 then
				anim.current_frame += 1
				anim.current_frame_count = 0
			end
		else
			character.current_animation = nil
			anim.current_frame = 0
		end
	end
end

function move_enemy()
	if enemy.direction == 0 then
		enemy.x -= 1
	elseif enemy.direction == 2 then
		enemy.x += 1
	end
	
	if enemy.x < 2 then
		enemy.x += 1
		enemy.direction = 2
	elseif enemy.x > 120 then
		enemy.x -= 1
		enemy.direction = 0
	end
end

function _update()
	move_ball()
	move_enemy()
	update_animation(player)
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
		play_animation(player, 5, 9, 0.5, -2, -2)
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

function draw_character(x, y, direction, base_spr_index)
	if direction == 0 then -- 0 = left --
		spr(base_spr_index + 2, x, y)
		spr(base_spr_index + 4, x - 3, y + 2)	
	elseif direction == 1 then -- top --
		spr(base_spr_index + 3, x - 2, y)
		spr(base_spr_index + 1, x, y)	
	elseif direction == 2 then -- right --
		spr(base_spr_index + 2, x, y, 1, 1, true, false)
		spr(base_spr_index + 4, x + 3, y + 2, 1, 1, true, false)	
	elseif direction == 3 then -- down
	 spr(base_spr_index, x, y)
		spr(base_spr_index + 3, x + 1, y + 2)	
	end
end

function draw_animations()
	if player.current_animation then
			spr(
				player.current_animation.current_frame, 
				player.x + player.current_animation.offset_x, 
				player.y + player.current_animation.offset_y
			)
	end
	
	if enemy.current_animation then
	end
end

function _draw()
	cls()
	for i=1,#level do
		circfill(level[i].x, level[i].y, 2, level[i].c)	
	end
	print(debug_text, 1, 1, 7)
	circfill(ball.x, ball.y, 2, ball.c)
	draw_character(player.x, player.y, player.direction, player.base_spr_index) 
	draw_character(enemy.x, enemy.y, enemy.direction, enemy.base_spr_index)
	draw_animations()
end
-->8
function _init()
	player = {
		x = 63,
		y = 120,
		direction=0, -- 0 = left, 1 = up, 2 = right, 3 = down --
		base_spr_index = 0,
		current_animation=nil
	}
	enemy={
		x = 63,
		y = 0,
		direction = 0,
		base_spr_index = 16,
		current_animation=nil
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
01111100001111100111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111100001111100111100000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000
01626100001111100261100000666600006600000000000000000000000000000200000000020000000000000000000000006000000000000000000000000000
01666100001111100666100000622600002200000000000000000000000000000020000000020000000000000020000000002000000000200000000000000000
00060000000010000006000000662600006200000006000000060000022600000006000000060000000000000002000000002000000002000000000000000000
00661000000661000011100000626600002600000002000000200000200000000000000000000000000000000000600000020000000060000000000200000000
00626000000616000021600000066000000600000002000002000000000000000000000000000000022600000000000000000000000000000000622000000000
00166000000166000016600000000000000000000000200000000000000000000000000000000000200000000000000000000000000000000000000000000000
0ddddd000ddddd000dddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd00ddddd00ddddd0000000000000000000000000000000000000000000000000000000f000000000000000000000000000000000000000000000000000
0d6f6d000ddddd000fddd00000666600006600000000000000000000000000000f000000000f0000000000000000000000006000000000000000000000000000
0d666d000ddddd000666d000006ff60000ff000000000000000000000000000000f00000000f00000000000000f000000000f000000000f00000000000000000
00060000000d0000000600000066f600006f000000060000000600000ff60000000600000006000000000000000f00000000f00000000f000000000000000000
0066d0000066d00000ddd000006f660000f60000000f000000f00000f000000000000000000000000000000000006000000f0000000060000000000f00000000
006f6000006d600000fd60000006600000060000000f00000f0000000000000000000000000000000ff6000000000000000000000000000000006ff000000000
00d6600000d6600000d6600000000000000000000000f00000000000000000000000000000000000f00000000000000000000000000000000000000000000000
