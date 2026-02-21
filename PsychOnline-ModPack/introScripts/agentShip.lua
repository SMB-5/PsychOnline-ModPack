upScale = 1 / 0.7;
walkSnd = '';
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
	
	local pickUpScale = 1.03818615 * upScale;
	makeAnimatedLuaSprite('agentShip', 'agent/intro/agentPickUpShip', 357 * upScale, 355 * upScale);
	addAnimationByPrefix('agentShip', 'pickUp', 'AgentsPickUpShip', 14, false);
	scaleObject('agentShip', pickUpScale, pickUpScale);
	local shipCen = getObjCen('agentShip');
	addOffset('agentShip', 'pickUp', shipCen[1] + (434 * upScale), shipCen[2] + (220 * upScale));
	setObjFrameRate('agentShip', 'pickUp', 14.4);
	playAnim('agentShip', 'pickUp', true);
	addLuaSprite('agentShip', true);
	setObjAlpha('agentShip', 0.00001);
	
	local agentScale = 1.03829787 * upScale;
	local dir = {'Left', 'Right'}; 
	for i = 1, 2 do
		local t = 'agentOn' .. dir[i];
		makeAnimatedLuaSprite(t, 'agent/agents/agent', 500 * upScale, 386 * upScale);
		addAnimationByPrefix(t, 'idle', 'AgentIdle', 15, false); addAnimationByPrefix(t, 'idleF', 'AgentIdle', 15, false);
		addAnimationByPrefix(t, 'walk', 'AgentWalk', 15); addAnimationByPrefix(t, 'walkF', 'AgentWalk', 15);
		scaleObject(t, agentScale, agentScale);
		local cen = getObjCen(t);
		local off = {{cen[1] + (210 * upScale), cen[2] + (197 * upScale)}, 
			{{cen[1] + (244 * upScale), cen[1] + (243 * upScale)}, cen[2] + (199 * upScale)}};
		addOffset(t, 'idle', off[1][1], off[1][2]); addOffset(t, 'idleF', off[1][1], off[1][2]);
		addOffset(t, 'walk', off[2][1][1], off[2][2]); addOffset(t, 'walkF', off[2][1][2], off[2][2]);
		setObjFlipXAnim(t, 'idleF', true); setObjFlipXAnim(t, 'walkF', true);
		playAnim(t, 'idle', true);
		addLuaSprite(t, true);
		setObjAlpha(t, 0.00001);
	end
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['agentCutscene'] = function()
		walkSnd = doSound('intro/walking noises');
		
		setObjAlpha('agentOnLeft', 1);
		setObjX('agentOnLeft', -700 * upScale);
		playAnim('agentOnLeft', 'walk', true);
		
		setObjAlpha('agentOnRight', 1);
		setObjX('agentOnRight', 1488 * upScale);
		playAnim('agentOnRight', 'walkF', true);
		
		doTweenX('agentLeftWalk', 'agentOnLeft', 90 * upScale, 0.85 / playbackRate);
		doTweenX('agentRightWalk', 'agentOnRight', 560 * upScale, 0.85 / playbackRate);
		
		runTimer('pickUpShip', 0.8 / playbackRate);
	end,
	['pickUpShip'] = function()
		stopSound(walkSnd);
		doSound('intro/grabbing ship');
		
		setObjAlpha('agentOnLeft', 0.00001);
		setObjAlpha('agentOnRight', 0.00001);
		setObjAlpha('agentShip', 1);
		
		playAnim('agentShip', 'pickUp', true);
		objFinAnim('agentShip');
		
		onChangeFrame('agentShip', function(f)
			if f >= 12 then
				doSound('intro/ship woosh', 0.5);
				callScript('introScripts/fbiTruck', 'shipOnTruck', {});
				runTimer('truckGoCS', 1 / playbackRate);
				
				return true;
			end
			return false;
		end);
	end,
	['truckGoCS'] = function()
		runTimer('agentGoCS', 0.7 / playbackRate);
	end,
	['agentGoCS'] = function()
		doSound('intro/walking noises');
		
		setObjVelX('agentOnLeft', 16 * 60 * upScale * playbackRate);
		playAnim('agentOnLeft', 'walk', true);
		
		setObjVelX('agentOnRight', 16 * 60 * upScale * playbackRate);
		playAnim('agentOnRight', 'walk', true);
	end
}

function destroyIntro()
	removeLuaSprite('agentOnLeft');
	removeLuaSprite('agentOnRight');
end

function objFinishAnim(n)
	if finAnims[n] then finAnims[n](); end
end

finAnims = {
	['agentShip'] = function()
		setObjAlpha('agentOnLeft', 1);
		playAnim('agentOnLeft', 'idle', true);
		
		setObjAlpha('agentOnRight', 1);
		playAnim('agentOnRight', 'idleF', true);
		
		removeLuaSprite('agentShip');
	end
}

function onChangeFrame(grp, f)
	curObjFrameChange(grp);
	funcsForGrp[grp] = f;
end

function objChangeframe(o, f)
	if funcsForGrp[o] and funcsForGrp[o](f) then
		funcsForGrp[o] = nil;
	end
end

funcsForGrp = {};
