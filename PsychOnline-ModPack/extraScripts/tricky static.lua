trickyTexts = {
	'INVALID',
	'HANK!!!',
	'CORRECTION',
	'IMPROBABLE',
	'MADNESS',
	'OMFG!!!',
	"WHO'S THIS?",
	'INTERRUPTION',
	'CLOWN',
	"WHO'S THAT??",
	'FIGHT ME'
}

hellclownTexts = {
	'INVALID',
	'HANK!!!',
	'CORRECTION',
	'IMPROBABLE',
	'MADNESS',
	'OMFG!!!',
	"CLOWN CAN'T DIE",
	"CAN'T KILL CLOWN",
	'CLOWN',
	'REBOOT'
}
upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	precacheSound('staticSound');
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	addHaxeLibrary('FlxCamera', 'flixel');
	runHaxeCode([[
		FlxG.cameras.remove(game.camHUD, false);
		FlxG.cameras.remove(game.camOther, false);
		
		var trickyStaticCam = FlxG.cameras.add(new FlxCamera(), false);
		trickyStaticCam.bgColor = game.camHUD.bgColor;
		trickyStaticCam.alpha = 0.00001;
		
		FlxG.cameras.add(game.camHUD, false);
		FlxG.cameras.add(game.camOther, false);
		
		createCallback('setObjTrickyCam', function(o) {
			LuaUtils.getObjectDirectly(o).camera = trickyStaticCam;
		});
		
		createCallback('setStaticAlpha', function(a) {
			trickyStaticCam.alpha = a;
		});
		
		createGlobalCallback('triggerStatic', function(?s, ?t, ?p) {
			parentLua.call('doStatic', [s, t, p]);
		});
	]]);
	
	makeLuaSprite('trickyStatic', 'nevada/static');
	scaleObject('trickyStatic', 4, 4);
	screenCenter('trickyStatic', 'x');
	setProperty('trickyStatic.antialiasing', false);
	setObjAlpha('trickyStatic', blendCoeff(100));
	setScrollFactor('trickyStatic', 0, 0);
	setObjTrickyCam('trickyStatic');
	addLuaSprite('trickyStatic');
	
	makeLuaText('trickyText', 'CLOWN ENGAGED', 1280); -- 844
	setTextSize('trickyText', 96);
	setTextFont('trickyText', 'impact.ttf');
	setTextColor('trickyText', 'ff0000');
	setTextBorder('trickyText', 0, 'ff0000');
	setTextAlignment('trickyText', 'center');
	setProperty('trickyText.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.globalAntialiasing'));
	setProperty('trickyText.borderQuality', 1);
	setProperty('trickyText.borderSize', -1000000); --142
	setScrollFactor('trickyText', 0, 0);
	setObjTrickyCam('trickyText');
	addLuaText('trickyText');
end

staticActive = false;
staticEl = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	if not inGameOver then
		if staticActive then
			staticEl = staticEl + e;
			if staticEl >= 1 / 60 then
				staticEl = 0;
				
				setObjY('trickyStatic', Random(300) * -1);
				
				addToPos('trickyText', getRandomInt(-4, 4), getRandomInt(-4, 4));
			end
		end
	end
end

function getRandomTrickyString()
	local stringSet = getProperty('hellclownAppeared') and hellclownTexts or trickyTexts;
	return stringSet[getRandomInt(1, #stringSet)];
end

function doStatic(s, t, p)
	s = s or getRandomTrickyString();
	t = t or 0.12;
	p = p or {getRandomInt(182, 344), getRandomInt(140, 430)};
	p[1] = p[1] - 218;
	
	setStaticAlpha(1);
	staticActive = true;
	
	setTextString('trickyText', s);
	
	setObjPos('trickyText', p[1], p[2]);
	
	doSound('staticSound', 0.5);
	
	addTimer(t / playbackRate, function() hideStatic(); end);
end

function hideStatic()
	if staticActive then
		setStaticAlpha(0.00001);
		staticActive = false;
	end
end

timers = {}; -- using this code that Cherif gave me a while back
function addTimer(time, onComplete)
    timers[#timers + 1] = onComplete or function() end;
    runTimer("TRICKYTIME_" .. #timers, time);
end

function onTimerCompleted(t)
	if t:find("TRICKYTIME_") then timers[tonumber((t:gsub("TRICKYTIME_", "")))](); end
end

function Random(r) return getRandomInt(0, r - 1); end
