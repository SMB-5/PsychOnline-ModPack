upScale = 1 / 0.7;
function onCreate()
	luaDebugMode = true;
	
	tankScale = 0.91836735 * upScale;
	
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		createCallback('addObjFChange', function(a:String) {
			game.modchartSprites.get(a).animation.callback = function(n, f) {
				parentLua.call('onSkidFChange', [n, f]);
			}
		});
		
		createCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			var sp = game.modchartSprites.get(o);
			sp.x = x;
			sp.y = y;
		});
		
		createCallback('getObjXY', function(b:String) {
			var h = game.modchartSprites.get(b);
			return [h.x, h.y];
		});
		
		createCallback('setObjFrameRate', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).frameRate = f;
		});
		
		createCallback('setLoopPoint', function(o, a, l) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).loopPoint = l;
		});
		
		createCallback('setCurFrame', function(o, f) {
			LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame = f;
		});
		
		createCallback('getCurFrame', function(o) {
			LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame;
		});
	]]);
	
	makeAnimatedLuaSprite('tankSkid', 'cars/tankSkid');
	addAnimationByIndices('tankSkid', 'skid', 'TankSkidSegment', '1,2,3,4,5,6,7,8,9,10,11', 29, true);
	addAnimationByIndices('tankSkid', 'prepShoot', 'TankTurn', '1,2,3,4,5,6,7,8', 29);
	addAnimationByIndices('tankSkid', 'shoot', 'TankTurn', '9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24', 29);
	addAnimationByIndices('tankSkid', 'talkLoop', 'TankPitagoremTheorem', '30,33,36,38,40', 18, true);
	addAnimationByIndices('tankSkid', 'theorem', 'TankPitagoremTheorem', '30,31,33,36,38,40,42,43,45,46,48,49,51,54,56,57,59', 14);
	addAnimationByIndices('tankSkid', 'bitch', 'TankPitagoremTheorem', '68,69,71,73,75,77,77,77,77,85,87', 14);
	addAnimationByIndices('tankSkid', 'mock', 'TankPitagoremTheorem', '89,91,93,97,99,101,103,105,107,109,111,113,115,117,119', 14);
	setObjFrameRate('tankSkid', 'skid', 28.8);
	setLoopPoint('tankSkid', 'skid', 7);
	setObjFrameRate('tankSkid', 'prepShoot', 28.8);
	setObjFrameRate('tankSkid', 'shoot', 28.8);
	setObjFrameRate('tankSkid', 'theorem', 14.4);
	setObjFrameRate('tankSkid', 'bitch', 14.4);
	setObjFrameRate('tankSkid', 'mock', 14.4);
	scaleObject('tankSkid', tankScale, tankScale);
	addOffset('tankSkid', 'skid', 0, 0);
	addOffset('tankSkid', 'prepShoot', 250 * tankScale, 42 * tankScale);
	addOffset('tankSkid', 'shoot', 250 * tankScale, 42 * tankScale);
	addOffset('tankSkid', 'talkLoop', 107 * tankScale, -42 * tankScale);
	addOffset('tankSkid', 'theorem', 107 * tankScale, -42 * tankScale);
	addOffset('tankSkid', 'bitch', 107 * tankScale, -42 * tankScale);
	addOffset('tankSkid', 'mock', 107 * tankScale, -42 * tankScale);
	playAnim('tankSkid', 'mock', true);
	setObjectOrder('tankSkid', getObjectOrder('tank') + 1);
	setProperty('tankSkid.alpha', 0.00001);
	addObjFChange('tankSkid');
	
	makeAnimatedLuaSprite('shootSkidSmoke', 'cars/carObjects/skidshoot');
	addAnimationByPrefix('shootSkidSmoke', 'shoot', 'TankTurnShot', 29, false);
	setObjFrameRate('shootSkidSmoke', 'shoot', 28.8);
	scaleObject('shootSkidSmoke', tankScale, tankScale);
	addOffset('shootSkidSmoke', 'shoot', 799 * tankScale, 261 * tankScale);
	playAnim('shootSkidSmoke', 'shoot', true);
	setObjectOrder('shootSkidSmoke', getObjectOrder('tankSkid') - 1);
	setProperty('shootSkidSmoke.alpha', 0.00001);
	
	makeAnimatedLuaSprite('steveSkid', 'characters/steve/steve-skid');
	addAnimationByIndices('steveSkid', 'skid', 'SteveSkidSegment', '1,2,3,4,5,6,7,8,9,10,11', 0);
	addAnimationByIndices('steveSkid', 'prepShoot', 'SteveTurn', '1,2,3,4,5,6,7,8', 0);
	addAnimationByIndices('steveSkid', 'shoot', 'SteveTurn', '9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24', 0);
	addAnimationByIndices('steveSkid', 'talkLoop', 'StevePitagoremTheorem', '30,33,36,38,40', 0);
	addAnimationByIndices('steveSkid', 'theorem', 'StevePitagoremTheorem', '30,31,33,36,38,40,42,43,45,46,48,49,51,54,56,57,59', 0);
	addAnimationByIndices('steveSkid', 'bitch', 'StevePitagoremTheorem', '68,69,71,73,75,77,77,77,77,85,87', 0);
	addAnimationByIndices('steveSkid', 'mock', 'StevePitagoremTheorem', '89,91,93,97,99,101,103,105', 0);
	scaleObject('steveSkid', tankScale, tankScale);
	addOffset('steveSkid', 'skid', -130 * tankScale, 139 * tankScale);
	addOffset('steveSkid', 'prepShoot', -102 * tankScale, 154 * tankScale);
	addOffset('steveSkid', 'shoot', -102 * tankScale, 154 * tankScale);
	addOffset('steveSkid', 'talkLoop', -136 * tankScale, 159 * tankScale);
	addOffset('steveSkid', 'theorem', -136 * tankScale, 159 * tankScale);
	addOffset('steveSkid', 'bitch', -136 * tankScale, 159 * tankScale);
	addOffset('steveSkid', 'mock', -136 * tankScale, 159 * tankScale);
	playAnim('steveSkid', 'mock', true);
	setObjectOrder('steveSkid', getObjectOrder('tankSkid'));
	setProperty('steveSkid.alpha', 0.00001);
	
	makeAnimatedLuaSprite('capSkid', 'characters/tankman/captain-skid');
	addAnimationByIndices('capSkid', 'skid', 'CapSkidSegment', '1,2,3,4,5,6,7,8,9,10,11', 0);
	addAnimationByIndices('capSkid', 'prepShoot', 'CapTurn', '1,2,3,4,5,6,7,8', 0);
	addAnimationByIndices('capSkid', 'shoot', 'CapTurn', '9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24', 0);
	addAnimationByIndices('capSkid', 'talkLoop', 'CapPitagoremTheorem', '30,33,36,38,40', 0);
	addAnimationByIndices('capSkid', 'theorem', 'CapPitagoremTheorem', '30,31,33,36,38,40,42,43,45,46,48,49,51,54,56,57,59', 0);
	addAnimationByIndices('capSkid', 'bitch', 'CapPitagoremTheorem', '68,69,71,73,75,77,77,77,77,85,87', 0);
	addAnimationByIndices('capSkid', 'mock', 'CapPitagoremTheorem', '89,91,93,97,99,101,103,105,107,109,111,113,115,117,119', 0);
	scaleObject('capSkid', tankScale, tankScale);
	addOffset('capSkid', 'skid', -31 * tankScale, 187 * tankScale);
	addOffset('capSkid', 'prepShoot', -221 * tankScale, 210 * tankScale);
	addOffset('capSkid', 'shoot', -221 * tankScale, 210 * tankScale);
	addOffset('capSkid', 'talkLoop', -348 * tankScale, 142 * tankScale);
	addOffset('capSkid', 'theorem', -348 * tankScale, 142 * tankScale);
	addOffset('capSkid', 'bitch', -348 * tankScale, 142 * tankScale);
	addOffset('capSkid', 'mock', -348 * tankScale, 142 * tankScale);
	playAnim('capSkid', 'mock', true);
	setObjectOrder('capSkid', getObjectOrder('tankSkid') + 1);
	setProperty('capSkid.alpha', 0.00001);
end

function onSkidFChange(n, f)
	if isSkidding then 
		if skidAnims[n] and skidAnims[n][f] then skidAnims[n][f](); end
		
		local tankFrame = getCurFrame('tankSkid');
		setCurFrame('steveSkid', tankFrame);
		setCurFrame('capSkid', tankFrame);
	end
end

skidAnims = {
	['skid'] = {
		[4] = function()
			setObjectOrder('capSkid', getObjectOrder('steveSkid') - 1);
		end,
		[5] = function()
			setObjectOrder('capSkid', getObjectOrder('steveSkid') - 1);
		end
	}
}

firstSkid = true;
function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Tank Skid'] = function(v1)
		if firstSkid then
			isSkidding = true;
			firstSkid = false;
			
			local tankPos = getObjXY('tank');
			local tankX = tankPos[1] + (46 * upScale);
			local tankY = tankPos[2] + (46 * upScale);
			
			setProperty('tankSkid.alpha', 1);
			setProperty('steveSkid.alpha', 1);
			setProperty('capSkid.alpha', 1);
			
			setObjPos('tankSkid', tankX, tankY);
			setObjPos('shootSkidSmoke', tankX, tankY);
			setObjPos('steveSkid', tankX, tankY);
			setObjPos('capSkid', tankX, tankY);
		end
		
		skidTank(v1);
	end
}

skidAnim = 'skid';
skidStarted = false;
function skidTank(anim)	
	playAnim('tankSkid', anim, true);
	playAnim('steveSkid', anim, true);
	playAnim('capSkid', anim, true);
	
	if animFuncs[anim] then animFuncs[anim](); end
end

animFuncs = {
	['shoot'] = function()
		setObjectOrder('capSkid', getObjectOrder('tankSkid'));
		
		setProperty('shootSkidSmoke.alpha', 1);
		playAnim('shootSkidSmoke', 'shoot', true);
	end
}
