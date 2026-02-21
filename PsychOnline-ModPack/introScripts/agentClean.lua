upScale = 1 / 0.7;
pos = {-690, -1500, -2400};
trash = {};
function onCreate()
	runHaxeCode([[
		import psychlua.LuaUtils;
		import flixel.math.FlxAngle;
		import flixel.math.FlxVelocity;
		
		createCallback('pixPerfectOverlap', function(o, r) {
			var obj1 = LuaUtils.getObjectDirectly(o, false);
			var obj2 = LuaUtils.getObjectDirectly(r, false);
			
			return FlxG.pixelPerfectOverlap(obj1, obj2, 0);
		});
		
		createCallback('angleFromSpr', function(o, r) {
			var obj1 = LuaUtils.getObjectDirectly(o, false);
			var obj2 = LuaUtils.getObjectDirectly(r, false);
			
			return FlxAngle.angleBetween(obj1, obj2, true);
		});
		
		createCallback('velFromAng', function(a, s) {
			var p = FlxVelocity.velocityFromAngle(a, s);
			return [p.x, p.y];
		});
		
		createCallback('setObjVelPos', function(o, x, y) {
			var ob = LuaUtils.getObjectDirectly(o, false);
			ob.velocity.set(x, y);
		});
	]]);
	
	local agentScale = 1.03829787 * upScale;
	for i = 1, 3 do
		local t = 'agentCleanUp' .. i;
		local t2 = 'agentBox' .. i;
		local s = (i == 3);
		makeAnimatedLuaSprite(t, 'agent/agents/walk/' .. (s and 'sign' or 'sweep'), 500 * upScale, 424 * upScale);
		addAnimationByPrefix(t, 'walk', (s and 'AgentNOTHINTOSEE' or 'AgentSweeping'), 15);
		scaleObject(t, agentScale, agentScale);
		local cen = getObjCen(t);
		addOffset(t, 'walk', cen[1] + ((s and 244 or 298) * upScale), cen[2] + ((s and 197 or 207) * upScale));
		playAnim(t, 'walk', true);
		addLuaSprite(t, true);
		setObjAlpha(t, 0.00001);
		
		if i < 3 then
			makeLuaSprite(t2, 'hitboxes/HITBOX', 500 * upScale, 424 * upScale);
			scaleObject(t2, 210 * upScale, 207 * upScale);
			addLuaSprite(t2, true);
			setObjAlpha(t2, 0);
		end
	end
	
	local trashPos = {{230, 601}, {702, 601}, {920, 607}};
	local trashoffset = {{51, 84}, {107, 55}, {52, 47}};
	local trashScale = {1.14814814, 1.16289592, 1.17582417};
	for i = 1, 3 do
		local t = 'trashGroundIntro' .. i;
		local t2 = 'trashHitboxIntro' .. i;
		local tr = (4 - i);
		
		makeLuaSprite(t, 'anywhereUSA/trash/' .. tr);
		scaleObject(t, trashScale[tr] * upScale, trashScale[tr] * upScale);
		addToOffsets(t, (trashoffset[tr][1] - 32) * upScale, (trashoffset[tr][2] - 25) * upScale);
		addLuaSprite(t, true);
		
		makeLuaSprite(t2, 'hitboxes/HITBOX', (trashPos[i][1] - 32) * upScale, (trashPos[i][2] - 25) * upScale);
		scaleObject(t2, 64 * upScale, 50 * upScale);
		addLuaSprite(t2, true);
		setObjAlpha(t2, 0);
		setProperty(t2 .. '.drag.x', 300 * upScale);
		
		table.insert(trash, {
			box = t2,
			mask = t,
			hitCool = 0,
			thrown = false
		});
	end
end

walking = false;
function onUpdatePost(e)
	e = e * playbackRate;
	
	local constNum = (e * 60);
	
	if walking then
		for i = 1, 2 do
			local t = 'agentCleanUp' .. i;
			setObjPos('agentBox' .. i, getObjX(t) + (89 * upScale), getObjY(t) + upScale);
		end
		
		for i = 1, 3 do
			if trash[i].hitCool <= 0 and pixPerfectOverlap(trash[i].box, (i == 1 and 'agentCleanUp2' or 'agentCleanUp1')) then
				trash[i].hitCool = 10;
				setObjVelX(trash[i].box, 800 * upScale);
			end
		end

		if getObjX('agentCleanUp3') > (1550 * upScale) then
			walking = false;
			
			for i = 1, 3 do 
				removeLuaSprite('agentCleanUp' .. i); 
				removeLuaSprite('agentBox' .. i); 
			end
			
			callOnLuas('stealCream', {});
		end
	end
	
	if #trash > 0 then for i = 1, #trash do
		trash[i].hitCool = trash[i].hitCool - constNum;
		
		local t = trash[i].box;
		setObjPos(trash[i].mask, getObjX(t), getObjY(t));
		if trash[i].thrown and getObjY(t) + (50 * upScale) >= (626 * upScale) then
			trash[i].thrown = false;
			setObjVelPos(t, 0, 0);
			setProperty(t .. '.acceleration.y', 0);
		end
	end end
end

function onTimerCompleted(t)
	if timers[t] then timers[t](); end
end

timers = {
	['agentGoCS'] = function()
		walking = true;
		for i = 1, 3 do
			local t = 'agentCleanUp' .. i;
			
			setObjAlpha(t, 1);
			setObjX(t, pos[i] * upScale);
			setObjVelX(t, 15.2 * 60 * upScale * playbackRate);
			playAnim(t, 'walk', true);
		end
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['shipCrash'] = function()
		for i = 1, 3 do
			if i == 3 then addToY(trash[i].box, -10 * upScale); end
			local vel = velFromAng(180 + angleFromSpr('ship', trash[i].box), 200);
			setObjVelPos(trash[i].box, -vel[1], vel[2]);
			setProperty(trash[i].box .. '.acceleration.y', 300 * upScale);
			trash[i].thrown = true;
		end
	end
}

function destroyIntro()
	for i = 1, 3 do
		removeLuaSprite(trash[i].mask);
		removeLuaSprite(trash[i].box);
	end
	trash = nil;
end