upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	chumpScale = 0.915 * upScale;
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	
	makeAnimatedLuaSprite('footballChump', 'characters/footballchump');
	addAnimationByPrefix('footballChump', 'idle', 'TankGuy1', 30, false);
	addAnimationByPrefix('footballChump', 'pullLever', 'TankGuyLEVERPULL', 29, false);
	addAnimationByIndices('footballChump', 'surprise', 'SportGuySurpriseandDEATH', '1,2,3,4,5,6', 29);
	addAnimationByIndices('footballChump', 'death', 'SportGuySurpriseandDEATH', '12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28');
	scaleObject('footballChump', chumpScale, chumpScale);
	addOffset('footballChump', 'idle', 0, 0);
	addOffset('footballChump', 'pullLever', 55 * chumpScale, 4 * chumpScale);
	addOffset('footballChump', 'surprise', 345 * chumpScale, 358 * chumpScale);
	addOffset('footballChump', 'death', 345 * chumpScale, 358 * chumpScale);
	playAnim('footballChump', 'idle', true);
	setObjectOrder('footballChump', getObjectOrder('carEvil'));
	setProperty('footballChump.alpha', 0.00001);
	
	runHaxeCode([[
		game.modchartSprites.get('footballChump').animation.callback = function(n, f) {
			parentLua.call('onFootballChumpF', [n, f]);
		}
		
		createCallback('setSoundPitch', function(t:String, p:Float) {
			game.modchartSounds.get(t).pitch = p;
		});
		
		createCallback('setObjFrameRate', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).frameRate = f;
		});
	]]);
	
	setObjFrameRate('footballChump', 'pullLever', 28.8);
	setObjFrameRate('footballChump', 'death', 28.8);
end

playedSplat = false;
function onFootballChumpF(n, f)
	if frameName[n] and frameName[n][f] then frameName[n][f](); end
end

frameName = {
	['death'] = {
		[10] = function()
			playedSplat = true;
			doSound('body slam');
		end,
		[11] = function()
			if not playedSplat then
				doSound('body slam');
			end
		end
	}
}

function onCreatePost()
	precacheSound('body slam');
end

function pullLever()
	chumpCanIdle = false;
	playAnim('footballChump', 'pullLever', true);
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['runCanon'] = function()
		chumpCanIdle = true;
		chumpDance();
	end
}

function onBeatHit()
	if curBeat % 2 == 0 then
		chumpDance();
	end
end

chumpCanIdle = true;
function chumpDance()
	if chumpCanIdle then
		playAnim('footballChump', 'idle', true);
	end
end

function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Football Chump Play Anim'] = function(v1)
		chumpCanIdle = false;
		playAnim('footballChump', v1, true);
	end
}

totHit = 0;
function doSound(file, volume)
    if volume == nil then volume = 1 end
	totHit = totHit + 1;
	local tTag = file .. totHit
	playSound(file, volume, tTag);
	setSoundPitch(tTag, playbackRate);
end