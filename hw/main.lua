require "physics"
physics.start()
physics.setGravity (0,0)
physics.setDrawMode ("hybrid")

local score = 0 

local width = display.contentWidth
local height = display.contentHeight

local bg = display.newRect (0,0, width, height)
bg: setFillColor (0,0,0)



local ship = display.newImage ("space.png")
ship.x = width / 2
ship.y = height / 2

local count = 0 

local max = 12


local bullets = {}


local scoreText = display.newText("Score: " .. score .. " Space Points", 20,100, "Marker Felt", 36)
scoreText: setTextColor (255,0,0)

local enemyg = display.newGroup()

local uig = display.newGroup()

uig: insert ( scoreText )


local function angleBetween (srcx, srcy, dstx, dsty)
	local angle = (math.deg(math.atan2(dsty - srcy, dstx - srcx )) + 90)
	if angle < 0 then 
	angle = angle + 360
	end
	return angle
end

local function aim (event)
 	if event.phase == "began" or event.phase == "moved" then 

 		print (event.x, event.y)
 		local ang = angleBetween (ship.x, ship.y, event.x, event.y)
		ship.rotation = ang

		local bullet = display.newCircle (ship.x, ship.y, 7)
		bullet: setFillColor (100,100,100)
		bullets [#bullets + 1] = bullet

		physics.addBody (bullet, "dynamic", {mass = 1, radius = 7})

		local bulletx = math.cos ((ship.rotation - 90) * math.pi / 180)
		local bullety = math.sin ((ship.rotation - 90) * math.pi / 180)

		bullet: setLinearVelocity(bulletx * 400, bullety * 400)
		bullet.type = "bullet"
 	end
end

bg: addEventListener( "touch", aim)
local function createso() 

	--print "I am your Father"
	local randomizer = math.random (1,2)
	
	local so

	if randomizer == 1 then 

	so = display.newImage ("darth.png")

	physics.addBody( so, "dynamic", {bounce=.9, density = 4, radius = 35})
	so:setLinearVelocity(math.random(-25,25),100)
	so.health = 100
	so.score = 200
	
	elseif randomizer == 2 then 

		so = display.newImage ("boss.png")

		so.x = math.random(50,width-50)
	physics.addBody( so, "dynamic", {bounce=.9, density = 4, radius = 50})
	so:setLinearVelocity(math.random(-10,10),100)
	so.health = 100
	so.score = 400
	end

	so.type = "so"
	enemyg: insert (so)

end


local function rtl ()

	count = count + 1
	if count == max then
	
		count =0
		createso()
		
		end
end

Runtime: addEventListener ("enterFrame", rtl)


local function scoreincrease(scorevalue)

	score = score + scorevalue
	scoreText.text = "Score:" .. score .. "Space Points" 


end


local function onCollision (event)

	print(event.object1.type,event.object2.type)
	if event.object1.x ~= nil and event.object2~=nil and event.object1.type == "so" and event.object2.type == "bullet" then
		
	
		display.remove (event.object2)

		event.object1.health = event.object1.health - 25
		
		if event.object1.health <= 0 then
			
			scoreincrease( event.object1.score)
			display.remove (event.object1)
			event.object1 = nil

			

		end

	elseif event.object1.x ~= nil and event.object1~=nil and event.object2.type == "so" and event.object2.type == "bullet" then

		display.remove (event.object1)
		display.remove (event.object2)

		event.object2.health = event.object2.health - 25
		
		if event.object2.health <= 0 then
			
			scoreincrease(event.object2.score)
			display.remove (event.object2)
			event.object2 = nil
			

		end
	end

end


Runtime:addEventListener("collision" , onCollision)









