function onCreate()
	luaDebugMode = true;
	
	makeAnimatedLuaSprite('comicBook', 'street/bus/comic', 350, 355);
	addAnimationByPrefix('comicBook', 'comic', 'ComicPannel', 29, false);
	scaleObject('comicBook', 0.89400164, 0.89400164);
	local comicCen = getObjCen('comicBook');
	addOffset('comicBook', 'comic', comicCen[1] + 544, comicCen[2] + 458);
	setObjFrameRate('comicBook', 'comic', 19.2);
	playAnim('comicBook', 'comic', true);
	setObjectExtrasCam('comicBook');
	addLuaSprite('comicBook');
	setObjAlpha('comicBook', 0.00001);
	
	runHaxeCode([[
		var comic = game.modchartSprites.get('comicBook');
		comic.animation.finishCallback = function(n) {
			parentLua.call('comicFinishAnim', [n]);
		}
	]]);
end

function comicFinishAnim(n)
	if comicing then
		startTween('comicEaseBack', 'comicBook', {x = -72, y = 22}, 0.5 / playbackRate, {ease = 'quadIn'});
		comicing = false;
	end
end

comicing = false;
function onEvent(n)
	if events[n] then events[n](); end
end

events = {
	['Comic Book Appear'] = function()
		setObjAlpha('comicBook', 1);
		setObjPos('comicBook', -72, 22);
		
		startTween('comicEase', 'comicBook', {x = 350, y = 355}, 0.15 / playbackRate, {ease = 'quadOut'});
		
		playAnim('comicBook', 'comic', true);
		comicing = true;
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['comicEaseBack'] = function()
		removeLuaSprite('comicBook');
	end
}
