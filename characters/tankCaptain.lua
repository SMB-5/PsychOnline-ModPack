upScale = 1 / 0.7;
function onCreatePost()
	luaDebugMode = true;
	
	local bfSc = 0.91713 * upScale;
	
	scaleObject('boyfriend', bfSc, bfSc);
	
	makeAnimatedLuaSprite('capGunJammed', 'characters/tankman/captain-gunjammed');
	addAnimationByIndices('capGunJammed', 'gunDown', 'CaptianGUNJAMMED', '1,2,3,4,5,6,7', 29);
	addAnimationByIndices('capGunJammed', 'jammed', 'CaptianGUNJAMMED', strConcatNum(8, 37), 29);
	scaleObject('capGunJammed', bfSc, bfSc);
	addOffset('capGunJammed', 'gunDown', 152 * bfSc, -1 * bfSc);
	addOffset('capGunJammed', 'jammed', 152 * bfSc, -1 * bfSc);
	playAnim('capGunJammed', 'gunDown', true);
	setObjectOrder('capGunJammed', getObjectOrder('boyfriendGroup'));
	setProperty('capGunJammed.alpha', 0.00001);
	
	runHaxeCode([[
		for(i in game.boyfriend.animOffsets.keys()){
            game.boyfriend.animOffsets[i][0] *= ]] .. bfSc .. [[;
            game.boyfriend.animOffsets[i][1] *= ]] .. bfSc .. [[;
			
			var currFrame = game.boyfriend.animation.curAnim.curFrame;
			game.boyfriend.playAnim(game.boyfriend.animation.curAnim.name, true);
			game.boyfriend.animation.curAnim.curFrame = currFrame;
        }
		
		game.modchartSprites.get('capGunJammed').animation.finishCallback = function(n) {
			parentLua.call('onCapGunFin', [n]);
		}
		
		createCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			var sp = game.modchartSprites.get(o);
			sp.x = x;
			sp.y = y;
		});
		
		createCallback('getBFXY', function() {
			var h = game.boyfriend;
			return [h.x, h.y];
		});
		
		createCallback('setObjFrameRate', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).frameRate = f;
		});
	]]);
	
	setObjFrameRate('capGunJammed', 'gunDown', 28.8);
	setObjFrameRate('capGunJammed', 'jammed', 28.8);
	
	setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'TANK DIE');
	setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'tank-gameover');
end

function onCapGunFin(n)
	if finFuncs[n] then finFuncs[n](); end
end

finFuncs = {
	['jammed'] = function()
		removeLuaSprite('capGunJammed');
		setProperty('boyfriend.alpha', 1);
		checkJam = false;
	end
}

checkJam = false;
function onUpdatePost()
	if checkJam then
		local bfPos = getBFXY();
		
		setObjPos('capGunJammed', bfPos[1], bfPos[2]);
	end
end

capShown = false;
function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Cap Gun Jammed'] = function(v1)
		if not capShown then
			capShown = true;
			setProperty('capGunJammed.alpha', 1);
			setProperty('boyfriend.alpha', 0.00001);
		end
		checkJam = true;
		playAnim('capGunJammed', v1, true);
	end
}

function onTweenCompleted(t)
	if tweens[t] then tweens[t](); end
end

tweens = {
	['carRam'] = function()
		if playAnim('boyfriend', 'recoil', true) then setProperty('boyfriend.specialAnim', true); end
	end
}

function goodNoteHit(i, d, n, s)
	if nt[n] then nt[n](); end
end

nt = {
	['Gimmick Note'] = function()
		if playAnim('boyfriend', 'recoil', true) then setProperty('boyfriend.specialAnim', true); end
	end
}

function strConcatNum(from, to)
	local emptStr = '';
	for i = from, to do
		emptStr = emptStr .. i .. (i == to and '' or ',');
	end
	return emptStr;
end