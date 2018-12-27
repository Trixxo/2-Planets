local stars, windowScale, drillX 
images = {}
players = {
	a: {rotation: 0}
	b: {rotation: 0}
}
building = {
	a: {rotation: math.random(math.pi * 100) / 100}
	b: {rotation: math.random(math.pi * 100) / 100}
}
drillY = 200
counter = -5

circumference = math.pi * math.pow(100, 2)



scaleFunc = (percent) -> 
	(love.graphics.getWidth! / windowScale) * (percent / 100)



love.load = ->
	love.graphics.setDefaultFilter "nearest"
	love.window.setFullscreen true
	images.planet = love.graphics.newImage("circle.png")
	images.star = love.graphics.newImage("star.png")
	windowScale = love.graphics.getHeight! / 400
	drillX = scaleFunc(25) - 100

	stars = for k = 1, 100 {
		x: math.random(love.graphics.getWidth! / windowScale), 
		y: math.random(400), 
		r: math.random(5),
		s: math.random(5) / 5
	}


love.draw = (delta) ->
	love.graphics.setColor(1, 1, 1)
	love.graphics.scale love.graphics.getHeight! / 400
	for star in *stars
		love.graphics.draw images.star, star.x, star.y, star.r, star.s, star.s

	love.graphics.setColor(0.3, 0.3, 1)
	love.graphics.draw(images.planet, scaleFunc(25), 200, 0, 1, 1, 100, 100)
	love.graphics.setColor(1, 0.2, 0.2)
	love.graphics.draw(images.planet, scaleFunc(75), 200, 0, 1, 1, 100, 100)


	love.graphics.setColor(0.5, 0.5, 0.5)
	love.graphics.draw(images.star, scaleFunc(25), 200, players.a.rotation, 1, 1, 105 * math.sin(45), 105 * math.cos(45))
	for k = 1, 5
		love.graphics.setColor(1, 0, 0)
		love.graphics.draw(images.star, scaleFunc(25), 200, building.a.rotation + (k * 2 * math.pi / 5), 1, 1, 105 * math.sin(45), 105 * math.cos(45))
		love.graphics.setColor(0, 1, 0)
		love.graphics.draw(images.star, scaleFunc(75), 200, building.b.rotation + (k * 2 * math.pi / 5), 1, 1, 105 * math.sin(45), 105 * math.cos(45))
		love.graphics.setColor(1, 1, 0.1)
		love.graphics.draw(images.star, drillX, drillY)



love.update = (delta) ->
	if love.keyboard.isDown("a")
		players.a.rotation -= delta
	if love.keyboard.isDown("d")	
		players.a.rotation += delta
	if love.keyboard.isDown("s")
		drillY = math.pow(counter, 2) + 200
		counter += 0.2
		drillX += 5



