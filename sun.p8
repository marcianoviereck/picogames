pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
sun = {
	x = (128/2),
	y = 10,
	r = 1
}

original_update_frame = 0
update_frame = original_update_frame

objs = {
 {
 	x = 10,
 	y = 10,
 	w = 3,
 	h = 4,
 	c = 6
 }
}

current_radians = 0

function _init()
end

function _draw()
	cls(4)
	for i=1, #objs do
		rectfill(objs[i].x, 
		objs[i].y, 
		objs[i].x + objs[i].w,
		objs[i].y + objs[i].h, 
		objs[i].c)
	end
	--draw_rays(sun.x, sun.y, 128)
	draw_ray(sun.x, sun.y, 128, current_radians)
	circfill(sun.x, sun.y, sun.r, 10)
end

function _update()
		if btn(0) then
			sun.x -= 1
		elseif btn(1) then
			sun.x += 1
		end
		
		if btn(2) then
			sun.y -= 1
		elseif btn(3) then
			sun.y += 1
		end
		update_frame -= 1
		--sun.r += 0.08
		if update_frame < 0 then
			current_radians += 0.1
			update_frame = original_update_frame
		end
end

function draw_ray(x, y, len, radians) 
	local dx = cos(radians * (3.14/ 180))
	local dy = sin(radians * (3.14/ 180))
	line(x, y, x+ (dx * len), y+ (dy * len), 10) 
end

function draw_rays(x, y, len)
	for i=0, 360 do -- do 360 degrees
		draw_ray(x, y, len, i)
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
