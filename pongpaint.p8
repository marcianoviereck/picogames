pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _update()
	if game_state == "playing" then
		if time_left > 0 then
		 time_left -= 1
		
			update_enemy()
			update_arrows()
			update_animation(player)
			update_dead_timers()
			if shoot_cooldown_frames > 0 then
				shoot_cooldown_frames -= 1
			end
			
			if player.dead == false then
				local speed = player.speed
				if btn(0) then
					player.x -= speed
					player.direction = 0
				elseif btn(1) then
					player.x += speed
					player.direction = 2
				end
				if btn(2) then
					player.y -= speed
					player.direction = 1
				elseif btn(3) then
					player.y += speed
					player.direction = 3
				end	
				
				if btn(5) and shoot_cooldown_frames <= 0 then
				 shoot_cooldown_frames = 20
				 shoot_arrow(player)
				end
			end
		else
			for i=1, #level do
				if level[i].c == player.c then
					tiles_player += 1
				else
					tiles_enemy += 1
				end
			end
			
			winner = "draw"
			if tiles_player > tiles_enemy then
				winner = "player"
			elseif tiles_enemy > tiles_player then
				winner = "enemy"
			end
			
			game_state = "game_over"
		end
	elseif game_state == "menu" then
		if btn(5) then
			game_state = "playing"
			_init()
		end
	elseif game_state == "game_over" then
		if btn(5) then
			game_state = "playing"
			_init()
		end
	end
end

function _draw()
	cls()
	
	if game_state == "playing" then
		for i=1,#level do
			circfill(level[i].x, level[i].y, 4, level[i].c)	
		end
		draw_character(player) 
		draw_character(enemy)
		draw_animations()
		draw_arrows()
		
			-- ui --
		rectfill(0, 0, 128, 6, 8)
		print(ceil(time_left / 30), 1, 1, 7) -- /30 because; 30 fps --
		if debug_text then
			print(debug_text, 100 - #debug_text, 1, 7)
		end
		
		-- endof ui --
	elseif game_state == "menu" then
		rectfill(0, 0, 128, 128, 2)
		print("start game?", 30, 50, 15)
		print("press ❎ to start", 30, 60, 15)
		print("controls: ❎ = shoot", 30, 70, 15)
	elseif game_state == "game_over" then
		local score = "player: "..tiles_player.." / enemy: "..tiles_enemy
		local text = "its a draw!..."
		local c = 5
		local c_t = 6
		if winner == "enemy" then
			c = enemy.c
			c_t = player.c
		elseif winner == "player" then
			c = player.c
			c_t = enemy.c
		end
		rectfill(0, 0, 128, 128, c)
		print(score, 10, 40, c_t)
		print("winner: "..winner, 20, 60, c_t)
		print("❎ to play again!", 20, 70, c_t)
	end
end
-->8
game_state = "menu" -- can be: menu, playing, game_over --
	
function _init()
	tiles_enemy = 0
	tiles_player = 0
			
	winner = "draw"
	round_time = 15 * 30 -- becaue: 30 fps --
	time_left = round_time
	map_size=32
	tile_size=4
	shoot_cooldown_frames = 5
	enemy_shoot_cooldown_frames = 50
	
	player = {
		x = 63,
		y = 120,
		direction=0, -- 0 = left, 1 = up, 2 = right, 3 = down --
		base_spr_index = 0,
		current_animation=nil,
		c = 2,
		drawcolor = 1,
		dead = false,
		dead_timer = 100,
		speed = 1.5
	}
	enemy={
		x = 63,
		y = 10,
		direction = 0,
		base_spr_index = 16,
		current_animation=nil,
		c = 15,
		drawcolor = 3,
		dead = false,
		dead_timer = 100,
		speed = 1.5
	}
	characters = {enemy, player}
	arrows={}
	ball = {
		x = 62,
		y = 62,
		dx = 1,
		dy = 1,
		c = 0
	}
	level = {}
	for x=1, map_size do
		for y=1, map_size do
				local col = player.c
				if y <= (map_size / 2) then
					col = enemy.c
				end
			add(level, {x=x*tile_size-1, y=y*tile_size-1, c=col})
		end
	end
end

function update_level_once(target_x, target_y, new_c)
	for i=1, #level do
			if level[i].c ~= new_c 
			 and target_x > level[i].x
				and target_x < level[i].x + 4
				and target_y > level[i].y
				and target_y < level[i].y + 4 then			 
				
					local stored = level[i]
					stored.c = new_c
				-- remove it from list and re-add it to make it render last --
				del(level, stored)
				add(level, stored)
				return				
			end
		end
end

function update_dead_timers()
 for i=1, #characters do
		if characters[i].dead then
			characters[i].dead_timer -=1
			if characters[i].dead_timer < 0 then
				characters[i].dead = false
				characters[i].dead_timer = 100
				characters[i].x = rnd(32) + 1
				characters[i].y = rnd(32) + 1

			end
		end
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

function draw_character(character)
	local base_spr_index = character.base_spr_index
	local direction = character.direction
	local x = character.x
	local y = character.y
		
	if character.dead then
		spr(base_spr_index + 5, x, y)
	else
		if direction == 0 then -- 0 = left --
				spr(base_spr_index + 2, x, y)
				spr(base_spr_index + 3, x - 2, y)	
		elseif direction == 1 then -- top --
			spr(base_spr_index + 4, x, y - 2)
			spr(base_spr_index + 1, x, y)	
		elseif direction == 2 then -- right --
			spr(base_spr_index + 2, x, y, 1, 1, true, false)
			spr(base_spr_index + 3, x + 2, y, 1, 1, true, false)	
		elseif direction == 3 then -- down
		 spr(base_spr_index, x, y)
			spr(base_spr_index + 4, x, y, 1, 1, false, true)	
		end
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

-->8
function shoot_arrow(character)
	local dx = 0
 local dy = 0
 if character.direction == 0 then
 	dx = -1
 elseif character.direction == 1 then
 	dy = -1
 elseif character.direction == 2 then
 	dx = 1
 elseif character.direction == 3 then
 	dy = 1
 end
				
	local spawn_x = character.x + 4
	local spawn_y = character.y + 4
	local corrected_x = (ceil(spawn_x / tile_size) * tile_size) + 1
	local corrected_y = (ceil(spawn_y / tile_size) * tile_size) + 1
	
	local arrow = {
	 x = corrected_x - 2, -- to put in middle --
	 y = corrected_y - 2,
		dx = dx,
		dy = dy,
		c = character.c,
		drawcolor = character.drawcolor,
		size = 0.5,
		speed = 8
	}
	add(arrows, arrow)
end

function arrow_hit(character_hit)
	character_hit.dead = true
	-- idea: blow character up and splash paint --
end

function draw_arrows()
	for i=1, #arrows do
		local arrow = arrows[i]
		rectfill(arrow.x, arrow.y, arrow.x + 1, arrow.y + 1, arrow.drawcolor) 		
	end
end

function update_arrows()
	local arrow_to_del = nil
	for i=1, #arrows do
		local arrow = arrows[i]
		arrow.x += arrow.dx * arrow.speed
		arrow.y += arrow.dy * arrow.speed
		if arrow.x > 128 or arrow.x < 0
		or arrow.y > 128 or arrow.y < 0 then
			arrow_to_del = arrow
		else
			-- + 2 is to fix the offset of the arrow.. --
			update_level_once(arrow.x + 2, arrow.y + 2, arrow.c)
			if arrow.c == player.c then
				if arrow.x > enemy.x and
				arrow.x < enemy.x + 8 and
				arrow.y > enemy.y and
				arrow.y < enemy.y + 8 then
					arrow_hit(enemy)
				end
			else
				if arrow.x > player.x and
				arrow.x < player.x + 8 and
				arrow.y > player.y and
				arrow.y < player.y + 8 then
					arrow_hit(player)
				end
			end
		end
	end
	
	if arrow_to_del then
		del(arrows, arrow_to_del)
	end
end
-->8

-->8
function update_enemy()
	if enemy.dead then
		return
	end
 enemy_shoot_cooldown_frames -= 1
 if enemy_shoot_cooldown_frames <= 0 then
 	enemy_shoot_cooldown_frames = rnd(40) + 40	
 	local dir_to_player = -1
  -- todo: fix later --
 	if dir_to_player == -1 then
 		dir_to_player = flr(rnd(4))
 	end
 	enemy.direction = dir_to_player
 	shoot_arrow(enemy)
 end
 
 local speed = enemy.speed
 
	if enemy.direction == 0 then
		enemy.x -= speed
	elseif enemy.direction == 2 then
		enemy.x += speed
	elseif enemy.direction == 1 then
		enemy.y -= speed
	elseif enemy.direction == 3 then
		enemy.y += speed
	end
	
	if enemy.x < 2 then
		enemy.x += speed
		enemy.direction = 2
	elseif enemy.x > 120 then
		enemy.x -= speed
		enemy.direction = 0
	elseif enemy.y < 2 then
		enemy.y += speed
		enemy.direction = 3
	elseif enemy.y > 120 then
		enemy.y -= speed
		enemy.direction = 1
	end
end
__gfx__
01111100001111100111100006000000066116600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111100001111100111100060000000600000060001000020202020000000000000000000000000000000000000000000000000000000000000000000000000
01626100001111100261100060000000000000000011100002020200000000000000000000000000000000000000000000000000000000000000000000000000
01666100001111100666100010000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000000010000006000010000000000000000001000020202020000000000000000000000000000000000000000000000000000000000000000000000000
00661000000661000011100060000000000000000001000002020200000000000000000000000000000000000000000000000000000000000000000000000000
00626000000616000021600060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00166000000166000016600006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03333300033333000333300006000000066336600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03333330033333003333300060000000600000060003000000000000000000000000000000000000000000000000000000000000000000000000000000000000
036f6300033333000f33300060000000000000000033300000000000000000000000000000000000000000000000000000000000000000000000000000000000
03666300033333000666300030000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000000300000006000030000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00663000006630000033300060000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000
006f60000063600000f3600060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00366000003660000036600006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
