--waves https://www.freesound.org/people/dio_333/sounds/163120/
--nuke https://www.freesound.org/people/unfa/sounds/259300/
--music http://soundimage.org/wp-content/uploads/2015/03/Autumn-Changes.mp3
--I have no idea where I found the image, I just "animated it" and resized it - find this

function love.load()
	titletimer  = 0
	frame1      = love.graphics.newImage("frame1.png")
	frame2      = love.graphics.newImage("frame2.png")
	frame3      = love.graphics.newImage("frame3.png")
	imagewidth  = frame1:getWidth()
	imageheight = frame1:getHeight()
	menumusic   = love.audio.newSource("menumusic.ogg")
	waves       = love.audio.newSource("waves.ogg")
	nuke        = love.audio.newSource("nuke.ogg", "static")
	menumusic:play()
	waves:play()
	fadetimer = 0
	
	font = love.graphics.newFont("wagner.ttf", 80)
	love.graphics.setFont(font)
	fadetitle      = false
	fadetitletimer = 0
	
	nuketimer = 0
	nukecolor = 0
	detonated = false
	nukedet   = 20
	fadedet   = 25
	
	windowwidth   = love.graphics.getWidth()
	windowheight  = love.graphics.getHeight()
	
	titleposx,titleposy = 150, windowheight - 95
	
	optionx,optiony = 150, 100
	optioncolor = 0
end

function love.update(dt)
	titletimer = titletimer + dt
	windowwidth   = love.graphics.getWidth()
	windowheight  = love.graphics.getHeight()
	if fadetimer < 255 then
		fadetimer = fadetimer + 1
		if fadetimer > 255 then
			fadetimer = 255
		end
	end
	
	nuketimer = nuketimer + dt
	--print(nuketimer)
	--set off the nuke
	if nuketimer >= nukedet and nuketimer < fadedet then
		if detonated == false then
			nuke:play()
			detonated = true
		end
		if nukecolor < 255 then
			nukecolor = nukecolor + 5
		end
	elseif nuketimer >= fadedet then
		if nukecolor > 0 then
			nukecolor = nukecolor - 2
			if nukecolor < 0 then 
				nukecolor = 0 
			end
		end
	end
	--fade title up to top and make menu buttons appear after everything's cleared
	if nuketimer >= fadedet and nukecolor == 0 then
		if titleposy > 20 then
			titleposy = titleposy - 5
		else
			if optioncolor < 255 then
				optioncolor = optioncolor + 5
				if optioncolor > 255 then
					optioncolor = 255
				end
			end
		end
	end
	--fade title in after the image fades in
	if fadetitle == true and fadetitletimer < 255 then
		fadetitletimer = fadetitletimer + 1
		if fadetitletimer > 255 then
			fadetitletimer = 255
		end
	end
end

function love.draw()

	love.graphics.setColor(optioncolor,optioncolor,optioncolor)
	love.graphics.print("Play\nSettings\nAbout\nExit", optionx,optiony)
	
	love.graphics.setColor(fadetimer,fadetimer,fadetimer)
	if nuketimer < fadedet then
		if titletimer > 0 and titletimer < 0.7 then
			love.graphics.draw(frame1, 0, 0, 0, windowwidth/imagewidth, windowwidth/imagewidth)
		elseif titletimer >= 0.7 and titletimer < 1.4 then
			love.graphics.draw(frame2, 0, 0, 0, windowwidth/imagewidth, windowwidth/imagewidth)
		elseif titletimer >= 1.4 and titletimer <= 2.1 then
			love.graphics.draw(frame3, 0, 0, 0, windowwidth/imagewidth, windowwidth/imagewidth)
		elseif titletimer >= 2.1 and titletimer <= 2.9 then
			love.graphics.draw(frame2, 0, 0, 0, windowwidth/imagewidth, windowwidth/imagewidth)
		end
	end
	if titletimer >= 2.8 then
		titletimer = 0
	end
	if fadetimer >= 255 then
		if fadetitle == false then
			fadetitle = true
		end
	end
	
	if nuketimer > nukedet then
		--draw white box
		love.graphics.setColor( nukecolor, nukecolor, nukecolor, nukecolor )
		love.graphics.rectangle("fill", 0, 0, imagewidth*(windowwidth/imagewidth) , imageheight*windowwidth/imagewidth )
		love.graphics.setColor(255,255,255)
	end
	
	love.graphics.setColor(fadetitletimer,fadetitletimer,fadetitletimer)
	love.graphics.print("Somber Journey", titleposx,titleposy)
end
