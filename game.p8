pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
     function _init()
	player={}
	dead=false
	timess = 1
	score=0
	graze=0
	bombfx=0
	player.x = 64
	player.y = 118
	player.dx = 0
	player.dy = 0
	bombhold = 0
	bullets={}
	hbullets={}
	bombs={}
	enemies={}
	lasers={}
	lasorbs={}
	lasermode = false
	stage=1
	randtime=flr(rnd(20)+120)
end
function draw_player()
	if graze == 1 then
		graze = 0
		if (btn(0)) then
			spr(13,player.x,player.y)
		elseif (btn(1)) then
			spr(14,player.x,player.y)
		else
			spr(12,player.x,player.y)
		end
	elseif dead == true then
 	spr(9,player.x,player.y)
 elseif (btn(0)) then
			spr(7,player.x,player.y)
	elseif (btn(1)) then
			spr(8,player.x,player.y)
	else
			spr(1,player.x,player.y)
	end
end
function draw_bullet()
	for bullet in all (bullets) do
 	spr(2,bullet.x,bullet.y)
	end
end	
function draw_hbullet()
	for hbullet in all (hbullets) do
 	spr(3,hbullet.x,hbullet.y)
 end
end
function draw_bomb()
	for bomb in all (bombs) do
 	spr(4,bomb.x,bomb.y)
 end
end
function draw_enemy()
	for enemy in all (enemies) do
 	spr(10,enemy.x,enemy.y)
 end
end
function draw_lasorb()
	for lasorb in all (lasorbs) do
 	spr(11,lasorb.x,lasorb.y)
 end
end
function draw_laser()
 for laser in all (lasers) do
 	line(laser.x0, laser.y0, laser.x1, laser.y1, laser.col)
 end
end
function _draw()
	if dead == true then
 	cls(8)
 else
 	cls(6)
 end
	draw_player()
	draw_bullet()
	draw_hbullet()
	draw_bomb()
	draw_enemy()
	draw_laser()
	draw_lasorb()
	if dead == true then
		print("you are dead press x to restart",3,64,64)
 end		
	print(score,1,1,0)
	print(bombhold,120,1,0)
	if bombhold>=1 then
	 spr(6,110,0) else
	 spr(5,110,0)
	end
	if bombfx > 0 then
		if bombfx == 5 then
			circfill(player.x+4,player.y+4,35,9)
			bombfx-=1
		elseif bombfx == 4 then
			circfill(player.x+4,player.y+4,40,10)
			bombfx-=1
		elseif bombfx == 3 then
			circfill(player.x+4,player.y+4,35,9)
			bombfx-=1
		elseif bombfx == 2 then
			circfill(player.x+4,player.y+4,30,10)
			bombfx-=1
		elseif bombfx == 1 then
			circfill(player.x+4,player.y+4,25,9)
			bombfx-=1
		end
	end
	for lasorb in all (lasorbs) do
		if lasorb.lasorbfx > 0 then
			if lasorb.lasorbfx == 3 then
				circfill(lasorb.x+4,lasorb.y+4,10,10)
				lasorb.lasorbfx-=1
			elseif lasorb.lasorbfx == 2 then
				circfill(lasorb.x+4,lasorb.y+4,15,9)
				lasorb.lasorbfx-=1
			elseif lasorb.lasorbfx == 1 then
				circfill(lasorb.x+4,lasorb.y+4,7,10)
				lasorb.lasorbfx-=1
			end
		end
	end
end
function move_player()
	if dead == false then
		if (btn(0)) then
			player.dx-=2
		end
		if (btn(1)) then
			player.dx+=2
		end
		if (btn(2)) then
			player.dy-=2
		end
		if (btn(3)) then
			player.dy+=2
		end
		if player.x>120 then
			player.dx-=2
		end
		if player.x<0 then
			player.dx=2
		end
		if player.y>120 then
			player.dy-=2
		end
		if player.y<0 then
			player.dy=2
		end
	end
	player.x+=player.dx
	player.y+=player.dy
	if bombhold > 0 and (btnp(4)) then
		bomb_explode()
		bombhold-=1
	end
end
function create_bullet(x, y, dx, dy)
	local bullet = {}
	bullet.x=x
	bullet.y=y
	bullet.dx=dx
	bullet.dy=dy
	add (bullets, bullet)
end
function create_hbullet(x, y, dy)
	local hbullet = {}
		bullet.x=x
	hbullet.y=y
	hbullet.dx=0
	hbullet.dy=dy
	add (hbullets, hbullet)
end
function move_bullet()
	for bullet in all (bullets) do
 	bullet.x+=bullet.dx
 	bullet.y+=bullet.dy
 	if bullet.y > 125 then
 		del(bullets, bullet)
 		score += 1
 	end
	end
end
function move_bomb()
	for bomb in all (bombs) do
 	bomb.y+=bomb.dy
 	if bomb.y > 125 then
			del(bombs,bomb)
 	end
	end
end
function create_bomb()
	local bomb = {}
	bomb.x = flr(rnd(121))-1
	bomb.y = 0
	bomb.dy = 2 
	add (bombs, bomb)
end
function move_hbullet()
	for hbullet in all (hbullets) do
		hbullet.x+=hbullet.dx
 	hbullet.y+=hbullet.dy
 	if hbullet.x < player.x then
 		hbullet.dx+=0.75
 	else
 		hbullet.dx-=0.75
 	end
 	if hbullet.y > 125 then
 		del(hbullet, hbullets)
 		score+=1
 	end
	end
end
function create_enemy(x,y,dx,dy,dx2,dy2,ftimer,buldx,buldy,msvalue,mstime,randvalue)
	local enemy = {}
	enemy.x=x
	enemy.y=y
	enemy.dx=dx
	enemy.dy=dy
	enemy.dx2=dx2
	enemy.dy2=dy2
	enemy.ftimer=ftimer
	enemy.buldx=buldx
	enemy.buldy=buldy
	enemy.msvalue=msvalue
	enemy.mstime=mstime
	enemy.randvalue=randvalue
	enemy.etimess=0
	add (enemies, enemy)
end
function create_lasorb(x,y,dx,dy,expltime,intensity)
	local lasorb = {}
	lasorb.x=x
	lasorb.y=y
	lasorb.dx=dx
	lasorb.dy=dy
	lasorb.lasorbfx=0
	lasorb.expltime=expltime
	lasorb.intensity=intensity
	lasorb.lotimess=0
	add (lasorbs, lasorb)
end
function enemy_fire()
	for enemy in all (enemies) do
		if enemy.randvalue == 1 then
			if enemy.etimess % enemy.ftimer == 0 then
				create_bullet(enemy.x,enemy.y,rnd(6)-3,rnd(6)-3)
			end
		else
		if enemy.etimess % enemy.ftimer == 0 then
			create_bullet(enemy.x,enemy.y,enemy.buldx,enemy.buldy)
		end
		end
	end
end
function laser_fire(x0,y0,x1,y1)
	local laser = {}
	laser.x0=x0
	laser.y0=y0
	laser.x1=x1
	laser.y1=y1
	laser.col=15
	laser.ltimess=0
	add (lasers, laser)
end
	
function move_enemy()
	for enemy in all (enemies) do
		if enemy.x > 125 then
			del(enemies, enemy)
		elseif enemy.x < -5 then
			del(enemies, enemy)
		elseif enemy.y > 125 then
			del(enemies, enemy)
		elseif enemy.y < -5 then
			del(enemies, enemy)
		end
		if enemy.mstime<1 then
			enemy.x+=enemy.dx
			enemy.y+=enemy.dy
		else
			enemy.x+=enemy.dx2
			enemy.y+=enemy.dy2
		end
	end
end
function move_lasorb()
	for lasorb in all (lasorbs) do
		if lasorb.x > 125 then
			del(lasorbs, lasorb)
		elseif lasorb.x < -5 then
			del(lasorbs, lasorb)
		elseif lasorb.y > 125 then
			del(lasorbs, lasorb)
		elseif lasorb.y < -5 then
			del(lasorbs, lasorb)
		end
			lasorb.x+=lasorb.dx
			lasorb.y+=lasorb.dy
	end
end
function collide()
	for bullet in all (bullets) do
		if player.x<bullet.x+6 and
		player.x+8>bullet.x+2 and
		player.y<bullet.y+6 and
		player.y+8>bullet.y+2 then
			gameover()
		end
		if player.x<bullet.x+9 and
		player.x+8>bullet.x-1 and
		player.y<bullet.y+9 and
		player.y+8>bullet.y-1 then
			score+=1
			graze=1
		end
	end
	for hbullet in all (hbullets) do
		if player.x+1<hbullet.x+6 and
		player.x+7>hbullet.x+2 and
		player.y<hbullet.y+6 and
		player.y+8>hbullet.y+2 then
			gameover()
		end
	end
	for lasorb in all (lasorbs) do
		if player.x+1<lasorb.x and
		player.x+7>lasorb.x+8 and
		player.y<lasorb.y+7 and
		player.y+8>lasorb.y+1 then
			del(lasorbs, lasorb)
		end
	end
	for bomb in all (bombs) do
		if player.x+1<bomb.x+5 and
		player.x+7>bomb.x+1 and
		player.y<bomb.y+5 and
		player.y+8>bomb.y+1 then
			bombhold+=1
			del(bombs, bomb)
		end
	end
end
function bomb_explode()
	bombfx=5
	sfx(0)
	for bullet in all (bullets) do
		if player.x-40<bullet.x+6 and
		player.x+40>bullet.x+2 and
		player.y-40<bullet.y+6 and
		player.y+40>bullet.y+2 then
			del(bullets,bullet)
		end
	end
	for hbullet in all (hbullets) do
		if player.x-40<hbullet.x+6 and
		player.x+40>hbullet.x+2 and
		player.y-40<hbullet.y+6 and
		player.y+40>hbullet.y+2 then
			del(hbullets,hbullet)
		end
	end
end
function gameover()
	dead = true
	sfx(01)
end
function _update()
 if dead == true then
 	bullets = {}
 	hbullets = {}
 	bombs = {}
 	enemies = {}
 	lasers = {}
 	lasorbs = {}
 	if btn(5) then
 		_init()
 	end
	end
	if stage == 1 then
		if timess == 10 then
			create_enemy(0,10,2,0,0,0,5,0,4,0,0,0)
		end
		if timess == 20 then
			create_enemy(120,20,-2,0,0,0,6,0,4,0,0,0)
		end 
		if timess == 40 then
			create_enemy(118,0,0,3,0,0,10,-2,1,0,0,0)
			create_enemy(2,0,0,3,0,0,10,2,1,0,0,0)
			end
		if timess == randtime then
			create_bomb()
			if rnd(2)<1 then
				create_enemy(0,0,-4,0,4,0,2,0,3,1,8,0)
				create_enemy(120,0,4,0,-4,0,2,0,3,1,28,0)
			else
				create_enemy(0,0,-4,0,4,0,2,0,3,1,28,0)
				create_enemy(120,0,4,0,-4,0,2,0,3,1,8,0)
			end
		end
		if timess == 160 then
		create_lasorb(60,0,0,1,80,1)
			create_enemy(0,0,.25,0,0,0,1,0,4,0,0,1)
		end  
		if timess == 300 then
			create_bomb()
			lasermode = true
			create_enemy(0,120,3,0,0,0,7,0,-2,0,0,0)
		end
		if lasermode	== true then
			if timess % 15 == 0 then
				laser_fire(rnd(138),0,rnd(138),128)
			end
		end
	end
	move_player()
	move_bullet()
	move_hbullet()
	move_bomb()
	move_enemy()
	move_lasorb()
	enemy_fire()
	player.dx = 0
	player.dy = 0
	collide()
	timess+=1
	for enemy in all (enemies) do
		enemy.etimess +=1
		if enemy.msvalue == 1 then
			enemy.mstime -=1
		end
	end
	for lasorb in all (lasorbs) do
		lasorb.lotimess +=1
		if lasorb.lotimess > lasorb.expltime then
			lasorb.lasorbfx=3
			for i=1,10*lasorb.intensity do
				laser_fire(rnd(138),0,rnd(138),128)
			end
		end
		if lasorb.lotimess > lasorb.expltime+3 then
			del(lasorbs, lasorb)
		end
	end
	for laser in all (lasers) do
		laser.ltimess +=1
		if laser.ltimess > 20 then
			laser.col=10
		end
		if laser.ltimess > 60 then
			del(lasers, laser)
		end
	end
end

__gfx__
70000007088888800000000000000000000000000000000000000000088888800888888006666660000000000000000008888880088888800888888000000000
070000708728827800000000000000000f0110000101100001011000872882788728827867766776000000000055550087a88a7887a88a7887a88a7800000000
0070070088888888000550000055550000f11100001001000012210088888888888888886cc66cc60055550005aaaa5088888888888888888888888800000000
0007700088888888005dd500005aa50001111110010000100122221088888888888888886c6666c6051dd1505aaaa1a588888888888888888888888800000000
0007700088888888005dd500005aa50001711110010000100122221008888888888888806c6666c65dddddd55a1aaaa588888888088888888888888000000000
0070070088888888000550000055550000177100001001000012210008888888888888806c6666c60555555005aaaa5088888888088888888888888000000000
0700007008888880000000000000000000011000000110000001100000888880088888000c6666c0000000000055550008888880008888800888880000000000
70000007000880000000000000000000000000000000000000000000000088000088000000066000000000000000000000088000000088000088000000000000
__sfx__
000700000160009610116201463017640196501b6601b6601a6601765014640126300e62008610026101400014000130001f6000e600056001660011600006000a70006700037000170000700000000000000000
00140000135402055023550205500d550085500e550085500e550085500d550095400553002520015100050000500005000050000500005000050000500005000050000500005000050000500005000050000500
00100000000001450000000000001450000000000001450000000205001f500115000000022500135001450000000000000000000000000000000000000000000000000000000000000000000000000000000000
