upScale = 1 / 0.7;
function onCreate()
	local alienScale = 0.728 * upScale * 1.01;
	
	setVar('alienBounds', {0, 0});
	makeAnimatedLuaSprite('bossHominid', 'characters/alien/alien-boss', 0, 593 * upScale);
	addAnimationByPrefix('bossHominid', 'walk', 'alienwalkcycle', 12); addAnimationByPrefix('bossHominid', 'walkF', 'alienwalkcycle', 12);
	addAnimationByPrefix('bossHominid', 'dash', 'AlienDash', 18); addAnimationByPrefix('bossHominid', 'dashF', 'AlienDash', 18);
	addAnimationByPrefix('bossHominid', 'gunSpin', 'hominidGunSpin', 25); addAnimationByPrefix('bossHominid', 'gunSpinF', 'hominidGunSpin', 25);
	addAnimationByPrefix('bossHominid', 'gunSkew', 'hominidGunSKEW', 18, false); addAnimationByPrefix('bossHominid', 'gunSkewF', 'hominidGunSKEW', 18, false);
	addAnimationByPrefix('bossHominid', 'shoot', 'HominidShootUp', 28, false);
	scaleObject('bossHominid', alienScale, alienScale);
	local alienCen = getObjCen('bossHominid');
	addOffset('bossHominid', 'walk', alienCen[1] + m1(78), alienCen[2] + m1(341)); addOffset('bossHominid', 'walkF', alienCen[1] + m1(172), alienCen[2] + m1(341));
	addOffset('bossHominid', 'dash', alienCen[1] + m1(179), alienCen[2] + m1(293)); addOffset('bossHominid', 'dashF', alienCen[1] + m1(262), alienCen[2] + m1(293));
	addOffset('bossHominid', 'gunSpin', alienCen[1] + m1(104), alienCen[2] + m1(386)); addOffset('bossHominid', 'gunSpinF', alienCen[1] + m1(250), alienCen[2] + m1(386));
	addOffset('bossHominid', 'gunSkew', alienCen[1] + m1(104), alienCen[2] + m1(386)); addOffset('bossHominid', 'gunSkewF', alienCen[1] + m1(250), alienCen[2] + m1(386));
	addOffset('bossHominid', 'shoot', alienCen[1] + m1(131), alienCen[2] + m1(704));
	setObjFlipXAnim('bossHominid', 'walkF', true); setObjFlipXAnim('bossHominid', 'dashF', true);
	setObjFlipXAnim('bossHominid', 'gunSpinF', true); setObjFlipXAnim('bossHominid', 'gunSkewF', true);
	setObjFrameRate('bossHominid', 'gunSpin', 25.2); setObjFrameRate('bossHominid', 'gunSpinF', 25.2);
	setObjFrameRate('bossHominid', 'shoot', 28.8);
	setLoopPoint('bossHominid', 'dash', 5); setLoopPoint('bossHominid', 'dashF', 5);
	setLoopPoint('bossHominid', 'gunSpin', 6); setLoopPoint('bossHominid', 'gunSpinF', 6);
	playAnim('bossHominid', 'gunSpin', true);
	
	makeAnimatedLuaSprite('bossHomMuzzle', 'fx/shoot/gunFlash', 0, 593 * upScale);
	addAnimationByIndices('bossHomMuzzle', 'shoot', 'AlienMussleFlashDef', '1,1,2,3,4,5,5,6', 28);
	scaleObject('bossHomMuzzle', alienScale, alienScale);
	local muzCen = getObjCen('bossHomMuzzle');
	addOffset('bossHomMuzzle', 'shoot', muzCen[1] + m1(194), muzCen[2] + m1(645));
	setObjFrameRate('bossHomMuzzle', 'shoot', 28.8);
	playAnim('bossHomMuzzle', 'shoot', true);
	setProperty('bossHomMuzzle.angle', -88.8085);
	setObjAlpha('bossHomMuzzle', 0.00001);
	
	makeSpriteGrp('hominidBOSS');
	addToGrp('bossHominid', 'hominidBOSS');
	addToGrp('bossHomMuzzle', 'hominidBOSS');
	setObjAlpha('hominidBOSS', 0.00001);
	setObjectOrder('hominidBOSS', getObjectOrder('boyfriendGroup') - 1);
	
	runHaxeCode([[
		game.modchartSprites.get('bossHominid').animation.finishCallback = function(n) {
			parentLua.call('aliFinishAnim', [n]);
		}
	]]);
end

function onCreatePost()
	precacheSound('fireball');
end

function destroyCache()
	setObjAlpha('hominidBOSS', 0);
end

facingLeft = false;
alienActive = false;
recheckAliEl = 0;
recheckAliPos = false;
isMoving = false;
vel = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if inGameOver then return; end
	
	recheckAliEl = recheckAliEl + e;
	if recheckAliEl >= 0.56 then 
		recheckAliEl = 0;
		recheckAliPos = true;
	end
	
	if alienActive then
		local aliX = getObjX('bossHominid');
		
		checkOutOfBounds(aliX);
		
		if isMoving then
			local xAway = getVar('robotStopX') - aliX;
			local distFromStop = math.abs(xAway);
			
			shooting = false;
			
			if distFromStop <= 18 * upScale then
				setAliAnim('gunSpin');
				isMoving = false;
				vel = 0;
			end
		elseif recheckAliPos then
			local xAway = getVar('robotStopX') - aliX;
			local distFromStop = math.abs(xAway);
			if distFromStop > 18 * upScale then
				alienMove(getRandomBool(), (xAway < 0));
				isMoving = true;
			end
		end
		
		setObjVelX('hominidBOSS', 289 * upScale * vel * (facingLeft and -1 or 1) * playbackRate);
		setObjAlpha('bossHomMuzzle', ((getCurAnim('bossHominid') == 'shoot') and 1 or 0));
	end
	
	recheckAliPos = false;
end

function onBeatHit()
	if alienActive and getVar('robotStopped') and not isMoving then
		alienShoot();
	end
end

fixingPos = false;
function checkOutOfBounds(x)
	local leftAway = (x < alienArea[1] - (10 * upScale));
	if (leftAway or x > alienArea[2] + (15 * upScale)) then
		if not fixingPos then
			fixingPos = true;
			isMoving = true;
			
			alienMove(true, (not leftAway));
		end
	else
		fixingPos = false;
	end
end

function alienMove(d, l)
	facingLeft = l;
	setAliAnim((d and 'dash' or 'walk'));
	vel = (d and 3.75 or 2);
end

function aliFinishAnim(n)
	n = n:gsub('F', '');
	if finAnimsAlien[n] then finAnimsAlien[n](); end
end

finAnimsAlien = {
	['gunSkew'] = function()
		shooting = true;
		aliShotAnim();
	end
}

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Robot HIT'] = function()
		setAliAnim('gunSpin');
		shooting = false;
		alienActive = false;
		isMoving = false;
		
		setObjVelX('hominidBOSS', 0);
		setObjAlpha('bossHomMuzzle', 0);
	end,
	['Robot EXPLODE'] = function()
		setObjAlpha('hominidBOSS', 0);
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['robotPrep'] = function()
		removeLuaSprite('alienFakeout');
		alienFightBack();
	end
}

function alienFightBack()
	setObjX('hominidBOSS', dadXProper() - (907 * upScale));
	setObjAlpha('hominidBOSS', 1);
	
	alienArea = getVar('alienBounds');
	
	alienActive = true;
end

lastCheckedLeft = '';
function setAliAnim(a)
	if lastCheckedLeft == facingLeft and getCurAnim('bossHominid'):find(a) then return; end
	
	lastCheckedLeft = facingLeft;
	playAnim('bossHominid', a .. (facingLeft and 'F' or ''), true);
end

shooting = false;
function alienShoot()
	if not shooting then
		setAliAnim('gunSkew');
	else
		aliShotAnim();
	end
end

function aliShotAnim()
	playAnim('bossHomMuzzle', 'shoot', true);
	playAnim('bossHominid', 'shoot', true);
	
	doSound('fireball', 0.7);
	robotGlow();
end

function m1(n)
	return math.floor(n * 1.01) * upScale;
end
