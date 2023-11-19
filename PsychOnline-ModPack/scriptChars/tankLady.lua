upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	TankLS = 1.03279 * upScale;
	makeAnimatedLuaSprite('tankLady', 'wasteland/objectEvents/bar/tankGirl', 0, -218 * upScale);
	addAnimationByPrefix('tankLady', 'drink', 'TankLadyDrink0', 9, false);
	addAnimationByPrefix('tankLady', 'drinkDown', 'TankLadyDrinkDown', 12, false);
	addAnimationByPrefix('tankLady', 'react', 'TankLadyReact', 12, false);
	scaleObject('tankLady', TankLS, TankLS);
	addOffset('tankLady', 'drink', 0, 0);
	addOffset('tankLady', 'drinkDown', 0, 0);
	addOffset('tankLady', 'react', -16 * TankLS, -11 * TankLS);
	playAnim('tankLady', 'drink', true);
	setScrollFactor('tankLady', 1.5, 1.5);
	addLuaSprite('tankLady', true);
	setProperty('tankLady.alpha', 0.00001);
	
	runHaxeCode([[
		game.modchartSprites.get('tankLady').animation.callback = function(n:String, f:Int) {
			parentLua.call('tankLadFChange', [n, f]);
		}
		
		createCallback('setSoundPitch', function(t:String, p:Float) {
			game.modchartSounds.get(t).pitch = p;
		});
	]]);
end

function onCreatePost()
	precacheSound('gulp');
	precacheSound('beer down');
end

function tankLadFChange(n, f)
	if frameChangeLady[n] then
		if frameChangeLady[n][f] then frameChangeLady[n][f](); end
	end
end

frameChangeLady = {
	['drinkDown'] = {
		[2] = function()
			doSound('beer down', 0.6);
		end
	}
}

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Pan To Bar'] = function()
		setProperty('tankLady.alpha', 1);
		setProperty('tankLady.x', 1227 * upScale);
	end,
	['Tank Lady Drink'] = function()
		doSound('gulp');
		playAnim('tankLady', 'drink', true);
	end,
	['Tank Lady Stop Drink'] = function()
		playAnim('tankLady', 'drinkDown', true);
	end,
	['Tank Lady React'] = function()
		playAnim('tankLady', 'react', true);
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

function setObjFrameRate(obj, anim, fr)
	playAnim(obj, anim, true);
	setProperty(obj .. '.animation.curAnim.frameRate', fr);
end
