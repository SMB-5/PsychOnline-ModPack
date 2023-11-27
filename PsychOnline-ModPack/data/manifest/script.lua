local xx = 520
local yy = 450
local xx2 = 820
local yy2 = 450
local ofs = 60

function onUpdate()
	if mustHitSection == false then
		if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
			triggerEvent('Camera Follow Pos',xx-ofs,yy)
		elseif getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
			triggerEvent('Camera Follow Pos',xx+ofs,yy)
		elseif getProperty('dad.animation.curAnim.name') == 'singUP' then
			triggerEvent('Camera Follow Pos',xx,yy-ofs)
		elseif getProperty('dad.animation.curAnim.name') == 'singDOWN' then
			triggerEvent('Camera Follow Pos',xx,yy+ofs)
		else
			triggerEvent('Camera Follow Pos',xx,yy)
		end
	else
		if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
			triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
		elseif getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
			triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
		elseif getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
			triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
		elseif getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
			triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
		else
			triggerEvent('Camera Follow Pos',xx2,yy2)
		end
	end
end