upScale = 1 / 0.7;
diffKill = {
	['Fucked'] = true,
}
bulletOffset = {
	[0] = {19, 33},
	{35, 13},
	{35, 13},
	{19, 33}
}
function onCreate()
	luaDebgMode = true;
	
	makeAnimatedLuaSprite('bulNCache', 'notes/bulletNote');
	setProperty('bulNCache.alpha', 0.00001);
	addLuaSprite('bulNCache');
	setObjectCamera('bulNCache', 'hud');
	
	makeLuaSprite('bulHCache', 'gameover/bulletHole');
	setProperty('bulHCache.alpha', 0.00001);
	addLuaSprite('bulHCache');
	setObjectCamera('bulHCache', 'hud');
	
	makeLuaSprite('healthTweener');
	
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/bulletNote');
			setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false);
			setPropertyFromGroup('unspawnNotes', i, 'scale.x', 1);
			setPropertyFromGroup('unspawnNotes', i, 'scale.y', 1);
			
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0.7);
			
			local nData = getPropertyFromGroup('unspawnNotes', i, 'noteData');
			setPropertyFromGroup('unspawnNotes', i, 'offsetX', bulletOffset[nData][1]);
			setPropertyFromGroup('unspawnNotes', i, 'offsetY', bulletOffset[nData][2]);
		end
	end
	
	for i = getProperty('unspawnNotes.length')-1, 0, -1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet Note' and getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			removeFromGroup('unspawnNotes', i);
		end
	end
	
	runHaxeCode([[
		createCallback('setNoteFrameRate', function(i, f) {
			game.notes.members[i].animation.curAnim.frameRate = f;
		});
	]]);
end

checkBleed = false;
function onCreatePost() -- dying via missing from the bullet or from bullet drain can trigger the alt death
	precacheSound('hankshoot');
	precacheSound('death sound');
	
	makeAnimatedLuaSprite('bfBleed', 'nevada/blood', (1082 - 341) * upScale, (552 - 192) * upScale);
	addAnimationByPrefix('bfBleed', 'blood', 'BloodSplash', 30, false);
	scaleObject('bfBleed', upScale, upScale);
	local bleedCen = getObjCen('bfBleed');
	addOffset('bfBleed', 'blood', bleedCen[1] + (190 * upScale), bleedCen[2] + (190 * upScale));
	playAnim('bfBleed', 'blood', true);
	setObjectOrder('bfBleed', getObjectOrder('boyfriendGroup') + 1);
	setObjAlpha('bfBleed', 0.00001);
	hideObjOnFinishAnim('bfBleed');
end

drainTime = 0;
diedFromShot = false;
isDraining = false;
healthSub = 0;
barAlpha = 0;
barAlphMult = 1;
bfColors = {};
toColors = {255, 0, 0};
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if isDraining then
			drainTime = drainTime - (e / 0.01);
			
			if drainTime > 0 then
				local healthToTake = ((healthSub / 100) * 2) * (e / 0.09);
				addHealth(-healthToTake);
				
				if getHealth() <= 0 then
					diedFromShot = true;
				end
			elseif drainTime < 0 then
				isDraining = false;
				
				drainTime = 0;
				healthSub = 0;
				
				onEndDrain();
			end
		end
		
		if tweenHealth then
			if healthSub > 0 then
				barAlpha = barAlpha + (((barAlphMult * healthSub) * 5) * (e * 60));
				
				if barAlpha >= 225 then barAlphMult = -1; end
				if barAlpha <= 0 then barAlphMult = 1; end
			
				if barAlpha > 255 then barAlpha = 255; end
				if barAlpha < 0 then barAlpha = 0; end
				
				setObjX('healthTweener', 1 - (barAlpha / 255));
			end
			
			local newColors = {};
			for i = 1, 3 do
				newColors[i] = math.floor(math.lerp(toColors[i], bfColors[i], getObjX('healthTweener')));
			end
			setProperty('healthBar.rightBar.color', RGBToHex(newColors));
		end
	end
end

function doBulletDrain()
	healthSub = healthSub + 1;
	
	drainTime = drainTime + 350;
	if drainTime > 500 then drainTime = 500; end
	
	bfColors = getProperty('boyfriend.healthColorArray');
	isDraining = true;
	tweenHealth = true;
end

function onEndDrain()
	doTweenX('healthDrainerBACK', 'healthTweener', 1, 0.2833333 / playbackRate);
end

function onSpawnNote(i, d, n)
	if n == 'Bullet Note' then
		setNoteFrameRate(i, 30);
	end
end

function goodNoteHit(i, d, n ,s)
	if n == 'Bullet Note' then
		hankDoShoot(d);
		
		cameraShake('game', 0.01, 0.15 / playbackRate);
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom', '0.02', '0.01'); end
		
		doSound('hankshoot', 0.5, 'HANKSHOTNOTE');
		
		playAnim('boyfriend', 'dodge', true);
		setProperty('boyfriend.specialAnim', true);
		
		runTimer('bfIdlesBullet', (crochet / 1000) / playbackRate);
	end
end

function noteMiss(i, d, n, s)	
	if n == 'Bullet Note' then
		hankDoShoot(d);
		
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom', '0.05', '0.025'); end
		
		doSound('hankshoot', 0.9, 'HANKSHOTNOTE');
		doSound('death sound', 1, 'HURTSOUNDHANK');
		
		if diffKill[difficultyName] then 
			setHealth(-4);
		else
			doBulletDrain();
		end
		
		if getHealth() <= 0 then diedFromShot = true; end
		
		setObjAlpha('bfBleed', 1);
		playAnim('bfBleed', 'blood', true);
		
		playAnim('boyfriend', 'hurt', true);
		setProperty('boyfriend.specialAnim', true);
		
		runTimer('bfIdlesBullet', 0.49 / playbackRate);
	end
end

function onGameOverStart()
	if diedFromShot then
		makeLuaSprite('bulletHoleDeath', 'gameover/bulletHole', getProperty('boyfriend.x') + 193, getProperty('boyfriend.y') + 88);
		scaleObject('bulletHoleDeath', upScale, upScale);
		setObjectOrder('bulletHoleDeath', getObjectOrder('boyfriend') + 1);
		
		makeAnimatedLuaSprite('bloodDeath', 'nevada/blood', getProperty('boyfriend.x') - 60, getProperty('boyfriend.y') - 40);
		scaleObject('bloodDeath', upScale, upScale);
		addAnimationByPrefix('bloodDeath', 'blood', 'BloodSplash', 20, false);
		local bloodCen = getObjCen('bloodDeath');
		addOffset('bloodDeath', 'blood', bloodCen[1] + (190 * upScale), bloodCen[2] + (190 * upScale));
		setObjFrameRate('bloodDeath', 'blood', 20.4);
		playAnim('bloodDeath', 'blood', true);
		setObjectOrder('bloodDeath', getObjectOrder('boyfriend') + 3);
		removeObjOnFinishAnim('bloodDeath');
		
		makeLuaSprite('rayDeath', nil, getProperty('boyfriend.x') + 300, getProperty('boyfriend.y') + 109);
		makeGraphic('rayDeath', 1, 1, 'ffffff');
		scaleObject('rayDeath', 1768,  3 * upScale);
		addLuaSprite('rayDeath');
		doTweenAlpha('shotGAMEOVER', 'rayDeath', 0, 0.2125 / playbackRate);
	end
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['bfIdlesBullet'] = function()
		local anim = getCurAnim('boyfriend');
		if anim:find('dodge') or anim:find('hurt') then
			setProperty('boyfriend.specialAnim', false);
			characterDance('boyfriend');
		end
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['healthDrainerBACK'] = function()
		tweenHealth = false;
	end,
	['shotGAMEOVER'] = function()
		removeLuaSprite('rayDeath');
	end
}

function math.lerp(a, b, ratio) return a + ratio * (b - a); end

function RGBToHex(tabl)
    return tonumber(string.format('0x00%.2x%.2x%.2x', tabl[1], tabl[2], tabl[3])); 
end