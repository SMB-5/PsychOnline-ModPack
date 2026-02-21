upScale = 1 / 0.7;
function onCreate()
	runHaxeCode([[
		import psychlua.LuaUtils;
		
		createCallback('curObjFrameChange', function(o) {
			LuaUtils.getObjectDirectly(o, false).animation.callback = function(n, f) {
				parentLua.call('objChangeframe', [o, f]);
			}
		});
		
		createCallback('objFinAnim', function(o) {
			var b = LuaUtils.getObjectDirectly(o);
			b.animation.finishCallback = function() {
				if (b.alpha > 0.00001)
					parentLua.call('objFinishAnim', [o]);
			}
		});
	]]);
	
	makeSpriteGrp('bfGfIntro', getObjX('gfGroup'), getObjY('gfGroup'));
	setObjectOrder('bfGfIntro', getObjectOrder('gfGroup'));
	
	makeAnimatedLuaSprite('bfGf', 'characters/bfGfIntro/bfGf');
	addAnimationByPrefix('bfGf', 'idle', 'IntroCutsceneBFandGF', 12);
	addAnimationByPrefix('bfGf', 'idle-alt', 'IntroCutsceneAltBFandGF', 13, false);
	addAnimationByPrefix('bfGf', 'react', 'IntroCutsceneReaction', 16, false);
	addAnimationByPrefix('bfGf', 'stealCream', 'IntroIceCreamStolen', 18, false); -- 18
	addAnimationByPrefix('bfGf', 'prep', 'IntroOfftheSpeakers', 24, false);
	addOffset('bfGf', 'idle', -1.5, -21.3);
	addOffset('bfGf', 'react', -1.5, -7.4);
	addOffset('bfGf', 'idle-alt', -1.5, -9.7);
	addOffset('bfGf', 'stealCream', -1.5, 193.5);
	addOffset('bfGf', 'prep', -1.5, 10.7);
	setObjFrameRate('bfGf', 'idle-alt', 13.8);
	setObjFrameRate('bfGf', 'react', 16.8);
	playAnim('bfGf', 'idle', true);
	addToGrp('bfGf', 'bfGfIntro');
	
	makeAnimatedLuaSprite('agentHandBfGf', 'characters/bfGfIntro/bfGf-hand');
	addAnimationByPrefix('agentHandBfGf', 'stealCream', 'IntroIceCreamStolen', 18, false);
	addOffset('agentHandBfGf', 'stealCream', -1.5, 193.5);
	playAnim('agentHandBfGf', 'stealCream', true);
	addToGrp('agentHandBfGf', 'bfGfIntro');
	setObjAlpha('agentHandBfGf', 0.00001);
	
	runTimer('bfGfIdle', 1.1 / playbackRate, 0);
end

function onCreatePost()
	setObjAlpha('gfGroup', 0.00001);
	setObjAlpha('boyfriendGroup', 0.00001);
end

canIdle = false;
function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['bfGfIdle'] = function()
		if canIdle then playAnim('bfGf', 'idle-alt', true); end
	end,
	['debugCut'] = function()
		playAnim('bfGf', 'prep', true);
		objFinAnim('bfGf');
		
		onChangeFrame('bfGf', function(f)
			if f >= 13 then
				doSound('intro/bf fall', 0.3);
				return true;
			end
			return false;
		end);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['shipCrash'] = function()
		playAnim('bfGf', 'react', true);
		
		onChangeFrame('bfGf', function(f)
			if f >= 3 then
				canIdle = true;
				return true;
			end
			return false;
		end);
	end
}

function stealCream()
	canIdle = false;
	
	doSound('intro/enter arm', 0.5);
	
	setObjAlpha('agentHandBfGf', 1);
	playAnim('agentHandBfGf', 'stealCream', true);
	playAnim('bfGf', 'stealCream', true);
	
	onChangeFrame('bfGf', function(f)
		if f >= 7 then
			doSound('intro/exit arm', 0.5);
			return true;
		end
		return false;
	end);
end

function objFinishAnim(n)
	if finAnims[n] then finAnims[n](); end
end

finAnims = {
	['bfGf'] = function()
		runTimer('beginSong', 0.5 / playbackRate);
		
		removeFromGrp('bfGf', 'bfGfIntro');
		removeLuaSprite('bfGf');
		removeFromGrp('agentHandBfGf', 'bfGfIntro');
		removeLuaSprite('agentHandBfGf');
		killAndDestroy('bfGfIntro');
		
		setObjAlpha('gfGroup', 1);
		setProperty('gf.danced', true);
		characterDance('gf');
		
		setObjAlpha('boyfriendGroup', 1);
		characterDance('boyfriend');
	end
}

function onChangeFrame(o, f)
	curObjFrameChange(o);
	funcsForGrp[o] = f;
end

function objChangeframe(o, f)
	if funcsForGrp[o] and funcsForGrp[o](f) then
		funcsForGrp[o] = nil;
	end
end

funcsForGrp = {};
