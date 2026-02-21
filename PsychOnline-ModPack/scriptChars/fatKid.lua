upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	local introing = getProperty('doingIntro');
	
	local fatKidScale = 1.03759398 * upScale;
	makeAnimatedLuaSprite('fatKid', 'interactables/fatKid/fatKid', 1145 * upScale, 357 * upScale);
	scaleObject('fatKid', fatKidScale, fatKidScale);
	local kidCen = getObjCen('fatKid');
	for tag, s in pairs({ -- THANK YOU CYN FOR THE SUGGESTION LOL
		['idleA'] = {xml = 'fatkididle', fps = 14.4, offsets = {120, 142}},
		['turnA'] = {xml = 'fatkidturns', fps = 14.4, offsets = {121, 153}},
		['idle-altA'] = {xml = 'fatkidturnidle', fps = 14.4, offsets = {121, 153}},
		['idle'] = {xml = 'fatkididle', fps = 14.4, offsets = {108, 313}},
		['offerOrb'] = {xml = 'fatkidpowerupoffer', fps = 15, offsets = {201, 315}},
		['idle-orb'] = {xml = 'fatkidpowerupidle', fps = 15, offsets = {201, 315}},
		['backFromOrb'] = {xml = 'fatkidpoweruptransition', fps = 12, offsets = {201, 315}},
		['turn'] = {xml = 'fatkidturns', fps = 14.4, offsets = {110, 324}},
		['idle-alt'] = {xml = 'fatkidturnidle', fps = 14.4, offsets = {110, 324}}
	}) do
		addAnimationByPrefix('fatKid', tag, s.xml, s.fps, false);
		addOffset('fatKid', tag, kidCen[1] + (s.offsets[1] * upScale), kidCen[2] + (s.offsets[2] * upScale));
		setObjFrameRate('fatKid', tag, s.fps);
	end
	playAnim('fatKid', 'idleA', true);
	addLuaSprite('fatKid');
	if introing then setObjAlpha('fatKid', 0.00001); end
	
	makeAnimatedLuaSprite('orbFatKid', 'fx/powerUpOrb', 200, 200);
	addAnimationByPrefix('orbFatKid', 'glow', 'hover', 28);
	scaleObject('orbFatKid', upScale, upScale);
	local orbCen = getObjCen('orbFatKid');
	addOffset('orbFatKid', 'glow', orbCen[1] + (87 * upScale), orbCen[2] + (84 * upScale));
	setObjFrameRate('orbFatKid', 'glow', 28.8);
	playAnim('orbFatKid', 'glow', true);
	addLuaSprite('orbFatKid');
	setObjAlpha('orbFatKid', 0.00001);
	
	makeAnimatedLuaSprite('iceCream', 'fx/intro/fallIce', 1040 * upScale, (357 + 85) * upScale);
	addAnimationByPrefix('iceCream', 'fall', 'ICECREAMFALL', 30, false);
	scaleObject('iceCream', upScale, upScale);
	local iceCen = getObjCen('iceCream');
	addOffset('iceCream', 'fall', iceCen[1] + (32 * upScale), iceCen[2] + (85 * upScale));
	playAnim('iceCream', 'fall', true, false, 7);
	addLuaSprite('iceCream');
	if introing then setObjAlpha('iceCream', 0.00001); end
	
	runHaxeCode([[
		game.modchartSprites.get('fatKid').animation.callback = function(n, f) {
			parentLua.call('fatKidChangeFrame', [n, f]);
		}
		game.modchartSprites.get('fatKid').animation.finishCallback = function(n) {
			parentLua.call('fatKidFinAnim', [n]);
		}
		
		createGlobalCallback('collectPowerUpKid', function() {
			return parentLua.call('tryCollectOrb', []);
		});
	]]);
end

function fatKidChangeFrame(n, f)
	if frameChangeKid[n] then frameChangeKid[n](f); end
end

frameChangeKid = {
	['offerOrb'] = function(f)
		if not orbin and f >= 6 then
			orbin = true;
			setObjAlpha('orbFatKid', 1);
		end
	end
}

function fatKidFinAnim(n)
	if finAnimsKid[n] then finAnimsKid[n](); end
end

finAnimsKid = {
	['turnA'] = function()
		setSuffKidDance('-altA');
	end,
	['offerOrb'] = function()
		setSuffKidDance('-orb');
	end,
	['backFromOrb'] = function()
		setSuffKidDance('');
	end,
	['turn'] = function()
		setSuffKidDance('-alt');
	end
}

function onBeatHit()
	if curBeat % 2 == 0 then
		fatKidDance();
	end
end

function onCountdownTick(t)
	if t % 2 == 0 then
		fatKidDance();
	end
end

lookForAli = false;
lookForBf = false;
offered = true;
orbin = false;
function onUpdatePost()
	if inGameOver then return; end
	
	if lookForAli and getObjX('fatKid') < dadXProper() + (100 * upScale) then
		lookForAli = false;
		
		fatKidCanDance = false;
		playAnim('fatKid', 'turnA', true);
	end
	
	if lookForBf and getObjX('fatKid') < bfXProper() then
		lookForBf = false;
		
		fatKidCanDance = false;
		playAnim('fatKid', 'turn', true);
	end
	
	if not offered and getObjX('fatKid') < dadXProper() + (500 * upScale) then
		offered = true;
		fatKidCanDance = false;
		playAnim('fatKid', 'offerOrb', true);
	end
end

destroyedCream = false;
walkinAlien = false;
totalPointsAli = 0;
function onEvent(n, v1)
	if events[n] then
		events[n](v1);
	end
end

events = {
	['Alien Action'] = function(v1)
		if v1 == 'dash' then
			lookForAli = true;
		end
	end,
	['Alien Can Walk'] = function()
		walkinAlien = not walkinAlien; 
		
		if walkinAlien then 
			totalPointsAli = totalPointsAli + 1; 
			if totalPointsAli == 4 then offered = false; end
		end
	end,
	['Boyfriend Can Walk'] = function()
		if not destroyedCream then
			destroyedCream = true;
			removeLuaSprite('iceCream');
		end
	end,
	['Fat Kid Move Pos'] = function()
		lookForBf = true;
		fatKidIdleSuff = '';
		fatKidDance();
		setObjPos('fatKid', 7147 * upScale, 596 * upScale);
		setObjPos('orbFatKid', (7147 - 147) * upScale, (596 - 189) * upScale);
	end
}

function setSuffKidDance(s)
	fatKidCanDance = true;
	fatKidIdleSuff = s;
	fatKidDance();
end

fatKidCanDance = true;
fatKidIdleSuff = 'A';
function fatKidDance()
	if fatKidCanDance then
		playAnim('fatKid', 'idle' .. fatKidIdleSuff, true);
	end
end

function tryCollectOrb()
	if offered and orbin and math.abs(dadXProper() - getObjX('fatKid')) < 1000 * upScale then
		orbin = false;
		playAnim('fatKid', 'backFromOrb', true);
		removeLuaSprite('orbFatKid');
		return true;
	end
	return false;
end

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['shipFalls'] = function()
		setObjAlpha('iceCream', 1);
		playAnim('iceCream', 'fall', true);
	end
}

function destroyCache()
	setObjAlpha('orbFatKid', 0);
end