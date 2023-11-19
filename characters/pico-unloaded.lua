upScale = 1 / 0.7;
picoScale = 0.96491228 * upScale * 1.1;
singAnims = {};
bfPos = {};
function onCreate()
	scaleObject('boyfriend', picoScale, picoScale);
	resizeOffsets('boyfriend', picoScale);
	
	setObjFrameRate('boyfriend', 'danceLeft-alt', 16.8);
	setObjFrameRate('boyfriend', 'danceRight-alt', 16.8);
	
	setProperty('boyfriend.danceEveryNumBeats', 2);
	
	setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'pico-gameover');
	
	singAnims = getProperty('singAnimations');
	
	bfPos = getObjPos('boyfriend');
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createCallback('picoObjFinAnim', function(o) {
			var obj = LuaUtils.getObjectDirectly(o, false);
			
			obj.animation.finishCallback = function(n) {
				parentLua.call('finishAnimPico', [o, n]);
			}
		});
	]]);
end

function onCreatePost()
	precacheSound('gun fidget');
	precacheSound('BOOOOOOOING');
end

dodgedBack = true;
curPicoElapsed = 0;
doingHold = false;
picoHold = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if not dodgedBack and dodgeFinished and canDodgeBack then
			dodgedBack = true;
			
			doTweenY('picoBusBack', 'picoBusDodge', 681 * upScale, 0.28 / playbackRate, 'quadIn');
		end
		
		if breakdancing then
			curPicoElapsed = curPicoElapsed + e;
			
			local curPicoFrame = math.floor((curPicoElapsed * 14.4) % 10);
			
			setCurFrame('picoBreakdances', curPicoFrame);
		end
		
		if doingHold then
			picoHold = picoHold + e;
			if picoHold >= (stepCrochet / 2000) then
				playAnim('boyfriend', singAnims[curDir + 1], true);
				doingHold = false;
			end
		end
		
		if keyboardJustPressed('SPACE') then
			if not getCurAnim('boyfriend'):find('hey') then playAnim('boyfriend', 'hey'); end
			setProperty('boyfriend.specialAnim', true);
			setProperty('boyfriend.heyTimer', 1);
		end
	end
end

curDir = 0
function goodNoteHit(i, d, n, s)
	if n == '' and s then
		curDir = d;
		doingHold = true;
		picoHold = 0;
	end
end

dodgeFinished = false;
function picoDodge()
	setObjAlpha('picoBusDodge', 1);
	playAnim('picoBusDodge', 'dodge', true);
	
	setObjAlpha('boyfriendGroup', 0.00001);
	
	doTweenY('picoDodgesBus', 'picoBusDodge', 781 * upScale, 0.45 / playbackRate, 'quadOut');
	
	dodgedBack = false;
end

canDodgeBack = false;
function picoBack()
	canDodgeBack = true;
end

function onEventPushed(n, v1, v2, s)
	if cacheEvents[n] then 
		cacheEvents[n](v1, v2, s); 
		cacheEvents[n] = nil;
	end
end

cacheEvents = {
	['Pico Guns Out'] = function()
		local introScale = 1.01286764 * upScale * 1.05;
		makeAnimatedLuaSprite('picoIntro', 'characters/pico/pico-readyUp', bfPos[1], bfPos[2]);
		addAnimationByPrefix('picoIntro', 'idle', 'PicoPlans', 1);
		addAnimationByPrefix('picoIntro', 'readyUp', 'PicoStartUp', 22, false);
		scaleObject('picoIntro', introScale, introScale);
		addOffset('picoIntro', 'idle', 67 * introScale, 59 * introScale);
		addOffset('picoIntro', 'readyUp', 67 * introScale, 59 * introScale);
		setObjFrameRate('picoIntro', 'readyUp', 22.8);
		playAnim('picoIntro', 'idle', true);
		setObjectOrder('picoIntro', getObjectOrder('boyfriendGroup'));
		picoObjFinAnim('picoIntro');
		
		setObjAlpha('boyfriendGroup', 0.00001);
	end,
	['Pico Shoot'] = function()
		local shootinScale = 0.97826086 * upScale * 1.1;
		makeAnimatedLuaSprite('picoShoot', 'characters/pico/pico-shoot', bfPos[1], bfPos[2]);
		addAnimationByPrefix('picoShoot', 'shootKid', 'Pico Shootin Kid', 21, false);
		addAnimationByPrefix('picoShoot', 'shoot-left', 'Pico Shootin Left', 19, false);
		addAnimationByPrefix('picoShoot', 'shoot-right', 'Pico Shootin Right', 19, false);
		addAnimationByPrefix('picoShoot', 'noAmmo', 'Pico No Ammo', 15, false);
		scaleObject('picoShoot', shootinScale, shootinScale);
		addOffset('picoShoot', 'shootKid', 283 * shootinScale, 57 * shootinScale);
		addOffset('picoShoot', 'shoot-left', 149 * shootinScale, 53 * shootinScale);
		addOffset('picoShoot', 'shoot-right', 10 * shootinScale, 67 * shootinScale);
		addOffset('picoShoot', 'noAmmo', 10 * shootinScale, 9 * shootinScale);
		setObjFrameRate('picoShoot', 'shoot-left', 19.2);
		setObjFrameRate('picoShoot', 'shoot-right', 19.2);
		playAnim('picoShoot', 'shootKid', true);
		setObjectOrder('picoShoot', getObjectOrder('boyfriendGroup'));
		setObjAlpha('picoShoot', 0.00001);
	end,
	['Pico Breakdance'] = function()
		local breakDanceScale = 0.97716894 * upScale;
		makeAnimatedLuaSprite('picoBreakdances', 'characters/pico/pico-breakdance', 962 * upScale, 525 * upScale);
		addAnimationByPrefix('picoBreakdances', 'breakdance', 'PicoBreakDance', 0);
		addAnimationByPrefix('picoBreakdances', 'breakdance-shoot', 'PicoShootinBreakDance', 0);
		scaleObject('picoBreakdances', breakDanceScale, breakDanceScale);
		local breakCen = getObjCen('picoBreakdances');
		addOffset('picoBreakdances', 'breakdance', breakCen[1] + (320 * upScale), breakCen[2] + (181 * upScale));
		addOffset('picoBreakdances', 'breakdance-shoot', breakCen[1] + (409 * upScale), breakCen[2] + (262 * upScale));
		playAnim('picoBreakdances', 'breakdance', true);
		setObjectOrder('picoBreakdances', getObjectOrder('boyfriendGroup'));
		setObjAlpha('picoBreakdances', 0.00001);
	end,
	['Pico Shoot Bus'] = function()
		local busPicoScale = 1.01867572 * upScale * 1.045;
		makeAnimatedLuaSprite('picoShootBus', 'characters/pico/pico-shootBus', bfPos[1], bfPos[2]);
		addAnimationByPrefix('picoShootBus', 'shoot', 'Pico Shootin Bus', 19, false);
		scaleObject('picoShootBus', busPicoScale, busPicoScale);
		addOffset('picoShootBus', 'shoot', 265 * busPicoScale, 41 * busPicoScale);
		setObjFrameRate('picoShootBus', 'shoot', 19.2);
		playAnim('picoShootBus', 'shoot', true);
		setObjectOrder('picoShootBus', getObjectOrder('boyfriendGroup'));
		setObjAlpha('picoShootBus', 0.00001);
	end,
	['Bus Run In'] = function()
		local dodgeScale = 1.00257069 * upScale;
		makeAnimatedLuaSprite('picoBusDodge', 'characters/pico/pico-dodge', 836 * upScale, 681 * upScale);
		addAnimationByPrefix('picoBusDodge', 'dodge', 'PicoDodging', 14);
		scaleObject('picoBusDodge', dodgeScale, dodgeScale);
		local dodgeCen = getObjCen('picoBusDodge');
		addOffset('picoBusDodge', 'dodge', dodgeCen[1] + (55 * upScale), dodgeCen[2] + (287 * upScale));
		setObjFrameRate('picoBusDodge', 'dodge', 14.4);
		playAnim('picoBusDodge', 'dodge', true);
		setObjectOrder('picoBusDodge', getObjectOrder('bus') + 3);
		setObjAlpha('picoBusDodge', 0.00001);
	end,
	['Final Scene Prep'] = function()
		local punchScale = 1.11153119 * upScale;
		makeAnimatedLuaSprite('picoPunch', 'characters/pico/pico-punch', bfPos[1], bfPos[2]);
		addAnimationByPrefix('picoPunch', 'gonnaPunch', 'PicoGonnaPunch', 22, false);
		addAnimationByPrefix('picoPunch', 'gunsAlone', 'PicoGuns', 0, false);
		scaleObject('picoPunch', punchScale, punchScale);
		addOffset('picoPunch', 'gonnaPunch', 62 * punchScale, -8 * punchScale);
		addOffset('picoPunch', 'gunsAlone', 62 * punchScale, -8 * punchScale);
		setObjFrameRate('picoPunch', 'gonnaPunch', 22.8); 
		playAnim('picoPunch', 'gonnaPunch', true);
		setObjectOrder('picoPunch', getObjectOrder('boyfriendGroup'));
		setObjAlpha('picoPunch', 0.00001);
	end
}

breakdancing = false;
shootingLeft = true;
firstClick = true;
function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Pico Guns Out'] = function()
		doSound('gun fidget', 0.26);
		
		playAnim('picoIntro', 'readyUp', true);
	end,
	['Pico Shoot'] = function()
		setObjAlpha('boyfriendGroup', 0.00001);
		setObjAlpha('picoShoot', 1);
		
		playAnim('picoShoot', 'shootKid', true);
		
		runTimer('stopShootPico', 0.28 / playbackRate);
	end,
	['Pico Breakdance'] = function()
		breakdancing = not breakdancing;
		
		setObjAlpha('picoBreakdances', breakdancing and 1 or 0.00001);
		setObjAlpha('boyfriendGroup', breakdancing and 0.00001 or 1);
		
		curPicoElapsed = 0;
	end,
	['Pico Breakdance Shoot'] = function()
		playAnim('picoBreakdances', 'breakdance-shoot', true);
		runTimer('stopShootDancin', 0.18 / playbackRate);
	end,
	['Pico Epic Shoot'] = function()
		shootingLeft = not shootingLeft;
		
		setObjAlpha('boyfriendGroup', 0.00001);
		setObjAlpha('picoShoot', 1);
		
		playAnim('picoShoot', (shootingLeft and 'shoot-left' or 'shoot-right'), true);
		
		runTimer('stopShootPico', 0.14 / playbackRate);
	end,
	['Pico Shoot Bus'] = function()
		setObjAlpha('boyfriendGroup', 0.00001);
		
		setObjAlpha('picoShootBus', 1);
		playAnim('picoShootBus', 'shoot', true);
		picoObjFinAnim('picoShootBus');
	end,
	['Pico No Ammo'] = function()
		playAnim('picoShoot', 'noAmmo', true);
		
		if firstClick then 
			setObjAlpha('boyfriendGroup', 0.00001);
			setObjAlpha('picoShoot', 1);
			
			runTimer('stopShootPico', 0.79 / playbackRate); 
			firstClick = false;
		end
	end,
	['Final Scene Prep'] = function()
		setObjAlpha('boyfriendGroup', 0.00001);
		
		setObjAlpha('picoPunch', 1);
		playAnim('picoPunch', 'gonnaPunch', true);
	end,
	['Final Scene'] = function()
		playAnim('picoPunch', 'gunsAlone', true);
	end
}

function finishAnimPico(o, n)
	if picoFinAnims[o] then picoFinAnims[o](n); end
end

picoFinAnims = {
	['picoIntro'] = function(n)
		if n == 'readyUp' then
			removeLuaSprite('picoIntro');
			
			setObjAlpha('boyfriendGroup', 1);
		end
	end,
	['picoShootBus'] = function()
		removeLuaSprite('picoShootBus');
		
		setObjAlpha('boyfriendGroup', 1);
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['stopShootPico'] = function()
		setObjAlpha('boyfriendGroup', 1);
		setObjAlpha('picoShoot', 0.00001);
	end,
	['stopShootDancin'] = function()
		playAnim('picoBreakdances', 'breakdance', true);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['picoDodgesBus'] = function()
		dodgeFinished = true;
	end,
	['picoBusBack'] = function()
		removeLuaSprite('picoBusDodge');
		
		setObjAlpha('boyfriendGroup', 1);
	end
}

function onGameOverConfirm(t)
	if t then doSound('BOOOOOOOING'); end
end
