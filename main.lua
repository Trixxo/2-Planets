local starImg, displayWidth, displayHeight, stars, planetImg, stars, planets, world, player, playerPlanetDiff, text, newX, newY

function love.load()
	displayWidth = 1920
	displayHeight = 1080
	world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	love.window.setMode(displayWidth, displayHeight)
	text = ""
	newX, newY = 0, 0

	playerPlanetDiff = 80
	starImg = love.graphics.newImage("star.png")
	planetImg = love.graphics.newImage("circle.png")
	playerImg = love.graphics.newImage("star.png")

	stars = {}
	stars.x = {} 
	stars.y = {}

	planets = {}
	planets.width = 500
	planets.height = 500

	planets.a = {x = displayWidth * 0.2, y = displayHeight / 2 , r = 250, img = planetImg}
	planets.a.xCenter = planets.a.x 
	planets.a.yCenter = planets.a.y 

	planets.b = {x = displayWidth * 0.8, y = displayHeight / 2, r = 250, img = planetImg}

	playerb = {}
	playerb.x = displayWidth * 0.8
	playerb.y = planets.a.y - planets.height / 2 - playerPlanetDiff
	playerb.r = 4
	playerb.img = playerImg
	playerb.angle = 270 * math.pi / 180 
	playerb.speed = 0.03

	player = {}
	player.x = displayWidth * 0.2
	player.y = planets.a.y - planets.height / 2 - playerPlanetDiff
	player.r = 4
	player.img = playerImg
	player.angle = 270 * math.pi / 180 
	player.speed = 0.03
	

	--bodies
	planets.a.body = love.physics.newBody(world, planets.a.x, planets.a.y, "static")
	planets.b.body = love.physics.newBody(world, planets.b.x, planets.b.y, "static")
	player.body = love.physics.newBody(world, player.x, player.y, "dynamic")
	playerb.body = love.physics.newBody(world, playerb.x, playerb.y, "dynamic")
	
	-- shapes
	planets.a.shape = love.physics.newCircleShape(planets.a.r)
	planets.b.shape = love.physics.newCircleShape(planets.b.r)
	player.shape = love.physics.newCircleShape(player.r)
	playerb.shape = love.physics.newCircleShape(playerb.r)


	--fixture
	planets.a.fixture = love.physics.newFixture(planets.a.body, planets.a.shape)
	planets.b.fixture = love.physics.newFixture(planets.b.body, planets.b.shape)
	player.fixture = love.physics.newFixture(player.body, player.shape)
	playerb.fixture = love.physics.newFixture(playerb.body, playerb.shape)

	planets.a.fixture:setUserData("planeta")
	planets.b.fixture:setUserData("planetb")
	player.fixture:setUserData("player")
	playerb.fixture:setUserData("playerb")

	player.body:setMass(10)
	playerb.body:setMass(10)
	

	for i = 1, 100 do
		stars.x[i] = math.random(displayWidth)
		stars.y[i] = math.random(displayHeight)
	end


end

function love.update(dt)
	world:update(dt)

	local playerX, playerY = player.body:getPosition()
	local planetPlayerVec = math.sqrt(math.pow(playerX - planets.a.body:getX(), 2) + math.pow(playerY - planets.a.body:getY(), 2))
	local planetPlayerMax = math.sqrt(math.pow(newX - planets.a.body:getX(), 2) + math.pow(newY - planets.a.body:getY(), 2))
	if planetPlayerVec > planetPlayerMax then 
		player.body:setX(planets.a.xCenter + math.cos(player.angle) * (planets.a.r + playerPlanetDiff))
		player.body:setY(planets.a.yCenter + math.sin(player.angle) * (planets.a.r + playerPlanetDiff))
	end

	-- playerb.body:applyForce(0, 100)
	print ("MAX: "..planetPlayerMax)
	print ("PLAYER "..planetPlayerVec)

	
	if love.keyboard.isDown("d") then
		player.angle = player.angle + player.speed
		player.body:setX(planets.a.xCenter + math.cos(player.angle) * (planets.a.r + playerPlanetDiff))
		player.body:setY(planets.a.yCenter + math.sin(player.angle) * (planets.a.r + playerPlanetDiff))
	elseif love.keyboard.isDown("a") then
		player.angle = player.angle - player.speed
		player.body:setX(planets.a.xCenter + math.cos(player.angle) * (planets.a.r + playerPlanetDiff))
		player.body:setY(planets.a.yCenter + math.sin(player.angle) * (planets.a.r + playerPlanetDiff))
	elseif love.keyboard.isDown("s") then 
		newX, newY = player.body:getPosition() 
		player.body:setLinearVelocity(planets.a.body:getX() - playerX, planets.a.body:getY() - playerY)
	end
	
	


	
end


function love.draw()
	love.graphics.setColor(255, 255, 0)
	for i = 1, 100 do
		love.graphics.draw(starImg, stars.x[i], stars.y[i])
	end
	love.graphics.setColor(255, 255, 255)

	love.graphics.setColor(255 ,0, 0)
	love.graphics.draw(player.img, player.body:getX(), player.body:getY(), 0, 3, 3)
	love.graphics.setColor(255, 255, 255)
	

	-- love.graphics.draw(planets.a.img, planets.a.body:getX() - planets.width / 2, planets.a.body:getY() - planets.width / 2, 0, 2.5, 2.5)
	-- love.graphics.draw(planets.b.img, planets.b.body:getX() - planets.width / 2, planets.b.body:getY() - planets.width / 2, 0, 2.5, 2.5)
	love.graphics.circle("line", planets.a.body:getX(), planets.a.body:getY(), planets.a.r)
	love.graphics.circle("line", planets.b.body:getX(), planets.b.body:getY(), planets.b.r)
	love.graphics.circle("fill", playerb.body:getX(), playerb.body:getY(), playerb.r)
	-- love.graphics.circle("fill", planets.a.body:getX(), planets.a.body:getY(), 250)
	-- love.graphics.circle("fill", planets.b.body:getX(), planets.b.body:getY(), 250)

	love.graphics.print(text, 10, 10)


end
function beginContact(a, b, coll) 
		text = text.."\n"..a:getUserData().." colliding with "..b:getUserData()
		if a:getUserData() == "player" or a:getUserData() == "planeta" then
			player.body:setLinearVelocity((newX - planets.a.body:getX()), (newY - planets.a.body:getY()))
			-- player.body:setLinearVelocity(0, -150)
		end
	end

	function endContact(a, b, coll)
	end

	function preSolve(a, b, coll)
	end

	function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	end
