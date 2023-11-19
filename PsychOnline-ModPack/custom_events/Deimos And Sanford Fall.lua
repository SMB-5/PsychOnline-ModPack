upScale = 1 / 0.7;
function onCreatePost()
	luaDebugMode = true;
	
	local bgOff = subScrollPos(0.5);
	makeAnimatedLuaSprite('deimosCliff', 'nevada/deimos', (68 * upScale) + bgOff[1], (134 * upScale) + bgOff[2]);
	addAnimationByPrefix('deimosCliff', 'enter', 'DeimosEnter', 29, false);
	addAnimationByPrefix('deimosCliff', 'idle', 'DeimosIdle', 29, false);
	addAnimationByPrefix('deimosCliff', 'shoot', 'DeimosShoot', 24, false);
	scaleObject('deimosCliff', 0.75 * upScale, 0.75 * upScale);
	local deimosCen = getObjCen('deimosCliff');
	offsetFrameRate('deimosCliff', 'enter', deimosCen[1] + (math.floor(280 * 0.75) * upScale), deimosCen[2] + (math.floor(686 * 0.75) * upScale), 28.8);
	offsetFrameRate('deimosCliff', 'idle', deimosCen[1] + (math.floor(199 * 0.75) * upScale), deimosCen[2] + (math.floor(245 * 0.75) * upScale), 28.8);
	addOffset('deimosCliff', 'shoot', deimosCen[1] + (math.floor(202 * 0.75) * upScale), deimosCen[2] + (math.floor(249 * 0.75) * upScale));
	setScrollFactor('deimosCliff', 0.5, 0.5);
	setProperty('deimosCliff.color', getColorFromHex('976666'));
	setObjectOrder('deimosCliff', getObjectOrder('cliff') + 1);
	playAnim('deimosCliff', 'idle', true);
	setObjAlpha('deimosCliff', 0.00001);
	
	makeAnimatedLuaSprite('sanfordCliff', 'nevada/sanford', (1194 * upScale) + bgOff[1], (114 * upScale) + bgOff[2]);
	addAnimationByPrefix('sanfordCliff', 'enter', 'SanfordEnter', 29, false);
	addAnimationByPrefix('sanfordCliff', 'idle', 'SanfordIdle', 29, false);
	addAnimationByPrefix('sanfordCliff', 'shoot', 'SanfordShoot', 24, false);
	scaleObject('sanfordCliff', 0.75 * upScale, 0.75 * upScale);
	local sanfoCen = getObjCen('sanfordCliff');
	offsetFrameRate('sanfordCliff', 'enter', sanfoCen[1] + (math.floor(221 * 0.75) * upScale), sanfoCen[2] + (math.floor(626 * 0.75) * upScale), 28.8);
	offsetFrameRate('sanfordCliff', 'idle', sanfoCen[1] + (math.floor(194 * 0.75) * upScale), sanfoCen[2] + (math.floor(228 * 0.75) * upScale), 28.8);
	addOffset('sanfordCliff', 'shoot', sanfoCen[1] + (math.floor(394 * 0.75) * upScale), sanfoCen[2] + (math.floor(243 * 0.75) * upScale));
	setScrollFactor('sanfordCliff', 0.5, 0.5);
	setProperty('sanfordCliff.color', getColorFromHex('976666'));
	setObjectOrder('sanfordCliff', getObjectOrder('cliff') + 1);
	playAnim('sanfordCliff', 'idle', true);
	setObjAlpha('sanfordCliff', 0.00001);
	
	local gfPos = getObjPos('gfGroup');
	makeAnimatedLuaSprite('lazerDot', 'nevada/lazerdot', getProperty('gfGroup.x') + (249 * upScale), getProperty('gfGroup.y') + (62 * upScale)); --642, 129 --95
	addAnimationByPrefix('lazerDot', 'dot', 'Lazer', 36, false);
	scaleObject('lazerDot', upScale, upScale);
	local lazCen = getObjCen('lazerDot');
	addOffset('lazerDot', 'dot', lazCen[1] + (34 * upScale), lazCen[2] + (34 * upScale));
	playAnim('lazerDot', 'dot', true);
	setObjectOrder('lazerDot', getObjectOrder('gfGroup') + 2);
	setObjAlpha('lazerDot', 0.00001);
	
	runHaxeCode([[
		game.modchartSprites.get('deimosCliff').animation.finishCallback = function(n) parentLua.call('onDeimosFinAnim', [n]);
		
		game.modchartSprites.get('sanfordCliff').animation.finishCallback = function(n) parentLua.call('onSanfordFinAnim', [n]);
		
		createGlobalCallback('sanfordDeimosShoot', function(?s) {
			parentLua.call('sanDeiShoot', [s]);
		});
	]]);
	lazDotY = getProperty('lazerDot.y');
end

lazDotY = 0;
lazOff = 10 * upScale;
lazerActive = false;
function onBeatHit()
	sanfoDance();
	deimosDance();
	if lazerActive then 
		setObjY('lazerDot', lazDotY + lazOff); 
		lazAdjust = true;
	end
end

sanfoCanIdle = false;
function sanfoDance()
	if sanfoCanIdle then playAnim('sanfordCliff', 'idle', true); end
end

deimosCanIdle = false;
function deimosDance()
	if deimosCanIdle then playAnim('deimosCliff', 'idle', true); end
end

canShoot = false;
sanShotTime = 0;
deiShotTime = 0;
function sanDeiShoot(shooter)
	if canShoot then
		if shooter == 'san' or shooter == 'both' then
			sanfoCanIdle = false;
			
			sanShotTime = 0;
			playAnim('sanfordCliff', 'shoot', true);
			setProperty('sanfordCliff.color', getColorFromHex('ffffff'));
			sanGlow = true;
		end
		if shooter == 'dei' or shooter == 'both' then
			deimosCanIdle = false;
			
			deiShotTime = 0;
			playAnim('deimosCliff', 'shoot', true);
			setProperty('deimosCliff.color', getColorFromHex('ffffff'));
			deiGlow = true;
		end
	end
end

function onDeimosFinAnim(n)
	if animsFinDeimos[n] then animsFinDeimos[n](); end
end

animsFinDeimos = {
	['enter'] = function()
		deimosCanIdle = true;
		deimosDance();
		
		pairLands();
	end,
	['shoot'] = function()
		deimosCanIdle = true;
		deimosDance();
	end
}

function onSanfordFinAnim(n)
	if animsFinSanford[n] then animsFinSanford[n](); end
end

animsFinSanford = {
	['enter'] = function()
		sanfoCanIdle = true;
		sanfoDance();
	end,
	['shoot'] = function()
		sanfoCanIdle = true;
		sanfoDance();
	end
}

lazerTrickCond = false;

sanGlow = false;
deiGlow = false;

lazDotEl = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if lazerActive then
			if lazAdjust then adjustLazer(e); end
		
			if lazerTrickCond then
				setObjAlpha('lazerDot', (getObjAlpha('tricky') == 1 and getCurAnim('tricky'):find('dance') and 1 or 0.00001));
			end
		end
		
		if sanGlow then
			sanShotTime = sanShotTime + e;
			
			if sanShotTime >= 0.05 then
				setProperty('sanfordCliff.color', getColorFromHex('976666'));
				
				sanGlow = false;
			end
		end
		
		if deiGlow then
			deiShotTime = deiShotTime + e;
			if deiShotTime >= 0.05 then
				setProperty('deimosCliff.color', getColorFromHex('976666'));
				
				deiShotTime = 0;
				deiGlow = false;
			end
		end
	end
end

lazAdjust = false;
function adjustLazer(e)
	addToY('lazerDot', e * 60 * -upScale)
	
	if getObjPos('lazerDot')[2] < lazDotY then
		setObjY('lazerDot', lazDotY);
		lazAdjust = false;
	end
end

function pairLands()
	canShoot = true;
	
	playAnim('lazerDot', 'dot', true);
	setObjAlpha('lazerDot', 1);
	lazerActive = true;
end

function goodNoteHit(i, d, n)
	if n == 'Bullet Note' and getProperty('hellclownAppeared') then
		sanDeiShoot('both');
	end
end

function noteMiss(i, d, n)
	if n == 'Bullet Note' and getProperty('hellclownAppeared') then
		sanDeiShoot('both');
	end
end

function onEvent(n)
	if events[n] then
		events[n]();
	end
end

events = {
	['Deimos And Sanford Fall'] = function()		
		runTimer('sanDeiFall', 0.22 / playbackRate);
	end,
	['Hank Shoot Scared'] = function()
		lazerActive = false;
		removeLuaSprite('lazerDot');
	end,
	['Tricky Enter'] = function()
		lazOff = 16 * upScale;
		lazDotY = lazDotY + (10 * upScale);
		addToX('lazerDot', 132 * upScale);
		setObjAlpha('lazerDot', 0.00001);
		lazerTrickCond = true;
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['sanDeiFall'] = function()
		setObjAlpha('sanfordCliff', 1);
		setObjAlpha('deimosCliff', 1);
	
		playAnim('sanfordCliff', 'enter', true);
		playAnim('deimosCliff', 'enter', true);
	end
}

function offsetFrameRate(o, a, x, y, f)
	setObjFrameRate(o, a, f);
	addOffset(o, a, x, y);
end