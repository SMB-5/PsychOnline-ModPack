upScale = 1 / 0.7;
function onCreatePost()
	precacheSound('skittles ded 2');
	
	makeAnimatedLuaSprite('skittlesDeath', 'wasteland/skittles/skittlesdies');
	addAnimationByPrefix('skittlesDeath', 'death', 'skittlesdeath', 18, false);
	scaleObject('skittlesDeath', 0.915 * upScale, 0.918 * upScale);
	playAnim('skittlesDeath', 'death', true);
	setObjectOrder('skittlesDeath', getObjectOrder('carEvil') + 1);
	setProperty('skittlesDeath.alpha', 0.00001);
	
	runHaxeCode([[
		var skit = game.modchartSprites.get('skittlesDeath');
		
		skit.animation.finishCallback = function(n) {
			parentLua.call('skitFinAnim', []);
		}
		
		createCallback('setSoundPitch', function(t:String, p:Float) {
			game.modchartSounds.get(t).pitch = p;
		});
		
		createCallback('getObjXY', function(b:String) {
			var h = game.modchartSprites.get(b);
			return [h.x, h.y];
		});
		
		createCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			var sp = game.modchartSprites.get(o);
			sp.x = x;
			sp.y = y;
		});
	]]);
end

function skitFinAnim()
	if dying then
		dying = false;
		
		removeLuaSprite('skittlesDeath');
	end
end

function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Skittles Dies'] = function()
		runTimer('skitDieSound', (((crochet * 4) - 380) / 1000) / playbackRate);
	end
}

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['skitDieSound'] = function()
		doSound('skittles ded 2');
		runTimer('skitDie', 0.38 / playbackRate);
	end,
	['skitDie'] = function()
		dying = true;
		setProperty('skittlesDeath.alpha', 1);
		playAnim('skittlesDeath', 'death', true);
	end
}

dying = false;
function onUpdatePost()
	if dying then
		local truckPos = getObjXY('carEvil');
	
		setObjPos('skittlesDeath', truckPos[1] + (335 * upScale), truckPos[2] - (497 * upScale));
	end
end

totHit = 0;
function doSound(file, volume)
    if volume == nil then volume = 1 end
	totHit = totHit + 1;
	local tTag = file .. totHit
	playSound(file, volume, tTag);
	setSoundPitch(tTag, playbackRate);
end