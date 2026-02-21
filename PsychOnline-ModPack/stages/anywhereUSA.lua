upScale = 1 / 0.7;
isFucked = false;
function onCreate()
	luaDebugMode = true;
	
	runHaxeCode([[
		import psychlua.LuaUtils;
		import flixel.addons.display.FlxBackdrop;
		import flixel.group.FlxTypedSpriteGroup;
		
		var upScale = 1 / 0.7;
		
		createCallback('makeBackDropX', function(t, img, ?x, ?y) {
			var bgSprite = new FlxBackdrop(Paths.image(img), 1);
			bgSprite.setPosition(x, y);
			bgSprite.antialiasing = ClientPrefs.data.antialiasing;
			setVar(t, bgSprite);
		});
		
		function checkFloor() {
			var floor = game.modchartSprites.get('street');
			
			while ((floor.getScreenPosition().x) + ((640 / 0.7) - 640) < -3103 * upScale)
				floor.x += 2806 * upScale;
			
			while ((floor.getScreenPosition().x) + ((640 / 0.7) - 640) > 0 * upScale)
				floor.x -= 2806 * upScale;
			
		}
		
		createCallback('getCamPos', function() {
			return game.camGame.scroll.x - ((640 / 0.7) - 640);
		});
		
		setVar('camMoveMult', 1);
		setVar('unCached', false);
		setVar('camCanMove', true);
	]]);
	
	widthOff = ((640 / 0.7) - 640);
	heightOff = ((360 / 0.7) - 360);
	
	doingIntro = (isStoryMode and not seenCutscene);
	setVar('doingIntro', doingIntro);
	
	isFucked = (difficultyName == 'Fucked');
	setVar('isFucked', isFucked);
	
	makeLuaSprite('sky', 'anywhereUSA/bg/skyA', ((787 - math.floor(1747 * 0.8)) * upScale) - widthOff, ((1151 - math.floor(1499 * 0.8)) * upScale) - heightOff); -- 158 -- 192
	scaleObject('sky', upScale * 0.8, upScale * 0.8);
	setScrollFactor('sky', 0, 0);
	addLuaSprite('sky');
	
	makeBackDropX('backBuild', 'anywhereUSA/bg/cityBack', ((1308 - 1416) * upScale) + (widthOff * -0.8), ((561 - 765) * upScale) + (heightOff * -0.8));
	scaleObject('backBuild', upScale, upScale);
	setScrollFactor('backBuild', 0.2, 0.2);
	addInstance('backBuild');
	
	makeBackDropX('backBuildLight', 'anywhereUSA/bg/cityBackLight', ((1308 - 1416) * upScale) + (widthOff * -0.8), ((561 - 765) * upScale) + (heightOff * -0.8));
	scaleObject('backBuildLight', upScale, upScale);
	setScrollFactor('backBuildLight', 0.2, 0.2);
	addInstance('backBuildLight');
	setObjAlpha('backBuildLight', 0.00001);
	
	makeBackDropX('bgBuild', 'anywhereUSA/bg/buildings', ((300 - 3195) * upScale) + (widthOff * -0.6), ((796 - 900) * upScale)  + (heightOff * -0.6));
	scaleObject('bgBuild', upScale, upScale);
	setScrollFactor('bgBuild', 0.4, 0.4);
	addInstance('bgBuild');
	
	makeSea(2, 14211 * upScale);
	
	addLuaScript('randomSpawn/helicopter');
	addLuaScript('randomSpawn/bus');
	
	makeSpriteGrp('bgBuildGrp');
	setScrollFactor('bgBuildGrp', 0.8, 0.8);
	addLuaSprite('bgBuildGrp');
	
	addLuaScript('randomSpawn/agent');
	
	makeLuaSprite('frTrash1', 'anywhereUSA/bg/bgObjects/frTrash', ((1831 - 531) * upScale) + (widthOff * -0.2), ((84 - 433) * upScale) + (heightOff * -0.2));
	scaleObject('frTrash1', upScale, upScale);
	setObjectColor('frTrash1', 0x006060b3);
	addToGrp('frTrash1', 'bgBuildGrp');
	
	makeLuaSprite('frBuild1', 'anywhereUSA/bg/bgObjects/frBuild', ((3264 - 699) * upScale) + (widthOff * -0.2), ((-9 - 487) * upScale) + (heightOff * -0.2));
	scaleObject('frBuild1', upScale, upScale);
	setObjectColor('frBuild1', 0x007b7bc0);
	addToGrp('frBuild1', 'bgBuildGrp');
	
	makeLuaSprite('FBIbuilding', 'anywhereUSA/scrollingBuildings/special/FBIBuilding', (607 - 1179) * upScale, -827 * upScale);
	scaleObject('FBIbuilding', upScale, upScale);
	addLuaSprite('FBIbuilding');
	
	makeLuaSprite('street', 'anywhereUSA/floors/street', -296 * upScale, (715 - 225) * upScale);
	scaleObject('street', upScale, upScale);
	addLuaSprite('street');
	
	makeLuaSprite('streetCRACK', 'fx/cracks/crack', (449 - 431) * upScale, (634 - 116) * upScale);
	scaleObject('streetCRACK', upScale, upScale);
	addLuaSprite('streetCRACK');
	if doingIntro then setObjAlpha('streetCRACK', 0.00001); end
	
	makeSpriteGrp('mainBuildGrp');
	addLuaSprite('mainBuildGrp');
	
	if isFucked then
		gfOff = -300;
		
		local agScale = 1.03949730 * upScale;
		makeAnimatedLuaSprite('agentWalkGF', 'agent/agents/walk/gf', 218 * upScale, 250 * upScale);
		addAnimationByPrefix('agentWalkGF', 'walk', 'AgentsCarryGF', 14);
		scaleObject('agentWalkGF', agScale, agScale);
		local cen = getObjCen('agentWalkGF');
		addOffset('agentWalkGF', 'walk', cen[1] + (289 * upScale), cen[2] + (301 * upScale));
		setObjFrameRate('agentWalkGF', 'walk', 14.4);
		playAnim('agentWalkGF', 'walk', true);
		setObjectOrder('agentWalkGF', getObjectOrder('gfGroup'));
		setObjAlpha('agentWalkGF', 0.00001);
	end
	
	addLuaScript('scriptChars/fatKid');
	addLuaScript('extraScripts/car');
	addLuaScript('scriptChars/bfOtherSide');
	addLuaScript('scriptChars/agents');
	
	makeAgent(7703 * upScale, 591 * upScale, true, 'stand');
	
	addLuaScript('randomSpawn/trash');
	
	if doingIntro then addLuaScript('introScripts/introAlien'); end
	
	makeSpriteGrp('fgBuildGrpF');
	setScrollFactor('fgBuildGrpF', 1.5, 1.5);
	addLuaSprite('fgBuildGrpF', true);
	
	makeSpriteGrp('fgBuildGrpS');
	setScrollFactor('fgBuildGrpS', 1.7, 1.7);
	addLuaSprite('fgBuildGrpS', true);
	
	loadMap();
	
	makeLuaSprite('FBIBaseBlur', 'anywhereUSA/scrollingBuildings/fx/fbibaseTrans', (1816 - 47) * upScale, (756 - 355) * upScale);
	scaleObject('FBIBaseBlur', upScale, upScale);
	addToGrp('FBIBaseBlur', 'mainBuildGrp');
	
	makeLuaSprite('bayStart', 'anywhereUSA/floors/baystart', (28863 - 2682) * upScale, (996 - 708) * upScale);
	scaleObject('bayStart', upScale, upScale);
	setObjectColor('bayStart', 0x00b4b4db);
	insertInGrp('bayStart', 'mainBuildGrp', getProperty('mainBuildGrp.length') - 2);
	
	makeLuaSprite('fgTire', 'anywhereUSA/fg/rqTires', ((1181 - 225) * upScale) + (widthOff * 0.7), ((652 - 91) * upScale) + (heightOff * 0.7));
	scaleObject('fgTire', upScale, upScale);
	setObjectColor('fgTire', 0x005858af);
	addToGrp('fgTire', 'fgBuildGrpS');
	
	makeLuaSprite('killAliens', 'anywhereUSA/fg/weKillAliens', ((75 - 139) * upScale) + (widthOff * 0.5), ((568 - 161) * upScale) + (heightOff * 0.5));
	scaleObject('killAliens', upScale, upScale);
	setObjectColor('killAliens', 0x00f0e4fc);
	addToGrp('killAliens', 'fgBuildGrpF');
	
	addLuaScript('randomSpawn/agentFG');
	
	cacheSprites();
end

function onCreatePost()
	local widthHalf = (screenWidth / 2);
	local heightHalf = (screenHeight / 2);
	
	defaultScreenPos = {widthHalf + ((widthHalf / 0.7) - widthHalf), heightHalf + ((heightHalf / 0.7) - heightHalf)};
	setCamFollow(defaultScreenPos[1], defaultScreenPos[2]);
	
	setProperty('camGame.scroll.x', ((640 / 0.7) - 640));
	setProperty('camGame.scroll.y', ((360 / 0.7) - 360));
	
	setProperty('freezeCamera', true);
end

function onCountdownTick(t)
	if t == 1 then
		if not getVar('unCached') then
			setVar('unCached', true);
			callOnLuas('destroyCache', {});
			destroyCache();
		end
	end
	if t % 2 == 0 then lightBop(); end
end

function onBeatHit()
	if curBeat % 2 == 0 then lightBop(); end
end

function onUpdate()
	if not getProperty('isCameraOnForcedPos') then 
		moveCam();
	end
	
	cancelTween('followGame');
	if getVar('camCanMove') then
		local fol = getCamFollow();
		startTween('followGame', 'camGame.scroll', {
			x = fol[1] - (screenWidth / 2), 
			y = fol[2] - (screenHeight / 2)
		}, (0.5 * getVar('camMoveMult')) / playbackRate, {
			ease = 'QuadOut'
		});
	end
end

gfOff = -640;
gfMoves = 0;
gfTaken = false;
checkGf = true;
function onUpdatePost(e)
	if inGameOver then return; end
	
	local camX = getCamPos();
	
	while checkGf and getGraphicMidpointX('gf') - camX < gfOff * upScale do
		addToX('gfGroup', 2400 * upScale);
		gfMoves = gfMoves + 1;
		
		if isFucked and not gfTaken and gfMoves >= 4 then
			checkGf = false;
			gfTaken = true;
			
			setObjAlpha('gfGroup', 0.00001);
			agentTakeGf();
		end
	end
	
	runHaxeFunction('checkFloor');
	
	while #rqAgents > 0 and rqAgents[1] + (-camX * 1.7) - (widthOff * 0.7) < 1000 * upScale do
		table.remove(rqAgents, 1);
		callScript('randomSpawn/agentFG', 'spawnAgentDuo');
	end
end

function agentTakeGf()
	setObjAlpha('agentWalkGF', 1);
	playAnim('agentWalkGF', 'walk', true);
	setObjVelX('agentWalkGF', 289 * upScale * 2.5 * playbackRate);
end

firstWalk = false;
function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Boyfriend Can Walk'] = function()
		if not firstWalk then
			firstWalk = true;
			
			removeLuaSprite('streetCRACK');
		end
	end
}

function onEndSong()
	setProperty('camCanMove', false);
	setProperty('isCameraOnForcedPos', true);
end

function lightBop()
	cancelTween('lightDimBG');
	setProperty('backBuildLight.alpha', 1);
	startTween('lightDimBG', 'backBuildLight', {alpha = 0.00001}, ((255 / 7) / 60) / playbackRate, {ease = 'linear'});
end

madeSea = false;
function makeSea(l, x)
	if not madeSea then
		madeSea = true;
		makeGroup('seaGrp');
		addInstance('seaGrp');
	end
	
	for i = 1, l do
		local t = 'sea' .. i;
		local last = i - 1;
		local seaX = (x - (2442 * upScale)) + (widthOff * -0.45) + ((i > 1) and ((getWidth('sea' .. last) * last) - (67 * upScale * last)) or 0);
		
		makeLuaSprite(t, 'anywhereUSA/bg/bgObjects/sea', seaX, ((636 - 316) * upScale) + (heightOff * -0.45));
		scaleObject(t, upScale, upScale);
		setScrollFactor(t, 0.55, 0.55);
		setObjectColor(t, 0x007b7bc0);
		addToGrp(t, 'seaGrp');
	end
end

totalBuilds = 0;
rqAgents = {};
function loadMap()
	for i = 1, #buildingList do		
		local curBuild = buildingList[i];
		if chunks[curBuild] or frBuilds[curBuild] or rqBuilds[curBuild] then
			local buildInfo = {};
			totalBuilds = totalBuilds + 1;
			
			if curBuild:startsWith('FR') then
				buildInfo = frBuilds[curBuild](bgBuildX);
				if buildInfo.t then addToGrp(buildInfo.t, 'bgBuildGrp'); end
			elseif curBuild:startsWith('RQ') then
				buildInfo = rqBuilds[curBuild](bgBuildX);
				if buildInfo.t then addToGrp(buildInfo.t, 'fgBuildGrp' .. (buildInfo.s == 1.7 and 'S' or 'F')); end
			else
				buildInfo = chunks[curBuild](buildX);
				
				buildX = buildX + buildInfo.mid;
				bgBuildX = buildX;
				buildX = buildX + buildInfo.w - buildInfo.mid;
				
				if buildInfo.t then addToGrp(buildInfo.t, 'mainBuildGrp'); end
			end
		end
	end
	
	table.sort(rqAgents);
end

buildX = 1769 * upScale;
bgBuildX = buildX;
buildingList = {
	'CHUNK1', 'RQSIGN', 'RQAGENT',
	'CHUNK 2',
	'CHUNK 3', 'RQAGENT', 'RQBUILD', 'FRTRASH',
	'CHUNK 4', 'RQTIRES', 'FRTREE',
	'CHUNK1', 'RQAGENT', 'RQLIGHT',
	'CHUNK 5', 'RQBUILD',
	'CHUNK 6', 'RQSIGN',
	'CHUNK 7', 'RQSIGN', 'FRTRASH',
	'CHUNK 8', 'RQBUILD', 'FRBUILD',
	'LIGHTPOST',
	'CHUNK 9', 'RQLIGHT', 'FRBUILD',
	'LIGHTPOST',
	'CHUNK 10', 'RQAGENT', 'RQTIRES', 'FRTREE',
	'CHUNK 2', 'RQSIGN',
	'CHUNK1', 'RQLIGHT',
	'LIGHTPOST',
	'CHUNK 6', 'RQAGENT', 'FRTRASH',
	'LIGHTPOST', 'FRBUILD', 'RQBUILD',
	'CHUNK 8',
	'LIGHTPOST', 'RQLIGHT',
	'LIGHTPOST',
	'LIGHTPOST', 'RQLIGHT',
	'LIGHTPOST',
	'LIGHTPOSTN', 'RQLIGHT',
	'EMPTY',
	'EMPTY',
	'EMPTY',
	'CHUNK 11'
}

chunks = {
	['CHUNK1'] = function(x) -- bench
		local t = 'streetBench' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk1', x, (214 - 311) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 870 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 2'] = function(x) -- smiley smiles
		local t = 'smileySmiles' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk2', x, (92 - 570) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 734 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 3'] = function(x) -- meow moters
		local t = 'meowMoters' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk3', x, (117 - 501) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 624 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 4'] = function(x) -- steakery cakery
		local t = 'steakeryCakery' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk4', x, (-140 - 705) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 315 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 5'] = function(x) -- hairy mommy daycare
		local t = 'hairyMommyDaycare' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk5', x, (-133 - 761) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 393 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 6'] = function(x) -- bulldozer
		local t = 'bulldozer' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk6', x, (204 - 367) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 775 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 7'] = function(x) -- parking lot
		local t = 'parkingLot' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk7', x, (225 - 293) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 1029 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 8'] = function(x) -- construction lights
		local t = 'constructionLights' .. totalBuilds;
		makeAnimatedLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk8', x, (332 - 218) * upScale);
		addAnimationByPrefix(t, 'blink', 'Flash', 3);
		scaleObject(t, upScale, upScale);
		
		return {mid = 771 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 9'] = function(x) -- graffiti
		local t = 'graffitiBuild' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk9', x, (191 - 390) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 363 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 10'] = function(x) -- gass pass
		local t = 'gassPass' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk10', x, (-125 - 645) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 668 * upScale, w = getWidth(t), t = t}
	end,
	['CHUNK 11'] = function(x) -- grease glob
		local t = 'greaseGlob' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk11', x, (70 - 464) * upScale);
		scaleObject(t, upScale, upScale);
		
		return {mid = 351 * upScale, w = getWidth(t), t = t}
	end,
	
	['EMPTY'] = function() -- nothing
		return {mid = 207 * upScale, w = 415 * upScale}
	end,
	
	['LIGHTPOST'] = function(x) -- light post
		local t = 'lightPost' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/lightPost', x, (49 - 513) * upScale);
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x00ada6db);
		
		return {mid = 207 * upScale, w = getWidth(t), t = t}
	end,
	['LIGHTPOSTN'] = function(x) -- end of light post
		local t = 'lightPostEND' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/lightPostN', x, (49 - 513) * upScale);
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x00ada6db);
		
		return {mid = 207 * upScale, w = getWidth(t), t = t}
	end
}

frBuilds = {
	['FRTRASH'] = function(x) -- dumpster
		local t = 'bgTrashDump' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/bg/bgObjects/frTrash', (x * 0.8) - (531 * upScale) + (widthOff * -0.2), ((84 - 433) * upScale) + (heightOff * -0.2));
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x006060b3);
		
		return {t = t};
	end,
	['FRBUILD'] = function(x) -- building rubble
		local t = 'bgBuildRubble' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/bg/bgObjects/frBuild', (x * 0.8) - (699 * upScale) + (widthOff * -0.2), ((-9 - 487) * upScale) + (heightOff * -0.2));
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x007b7bc0);
		
		return {t = t};
	end,
	['FRTREE'] = function(x) -- trees
		local t = 'bgTrees' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/bg/bgObjects/frTree', (x * 0.8) - (200 * upScale) + (widthOff * -0.2), ((25 - 556) * upScale) + (heightOff * -0.2));
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x007b7bc0);
		
		return {t = t};
	end
}

rqBuilds = {
	['RQTIRES'] = function(x) -- tires
		local t = 'fgTires' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/fg/rqTires', (x * 1.7) - (225 * upScale) + (widthOff * 0.7), ((652 - 91) * upScale) + (heightOff * 0.7));
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x005858af);
		
		return {t = t, s = 1.7};
	end,
	['RQBUILD'] = function(x) -- rubble
		local t = 'fgRubble' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/fg/rqBuild', (x * 1.5) - (417 * upScale) + (widthOff * 0.5), ((744 - 262) * upScale) + (heightOff * 0.5));
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x00d1d1e8);
		
		return {t = t, s = 1.5};
	end,
	['RQLIGHT'] = function(x) -- light
		local t = 'fgLight' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/fg/rqLight', (x * 1.7) - (225 * upScale) + (widthOff * 0.7), ((793 - 359) * upScale) + (heightOff * 0.7));
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x00f9f9fc);
		
		return {t = t, s = 1.7};
	end,
	['RQSIGN'] = function(x) -- sign
		local t = 'fgSign' .. totalBuilds;
		makeLuaSprite(t, 'anywhereUSA/fg/rqSign', (x * 1.7) - (143 * upScale) + (widthOff * 0.7), ((633 - 221) * upScale) + (heightOff * 0.7));
		scaleObject(t, upScale, upScale);
		setObjectColor(t, 0x00d0d0e9);
		
		return {t = t, s = 1.7};
	end,
	['RQAGENT'] = function(x) -- agent FG
		table.insert(rqAgents, (x * 1.7) + (widthOff * 0.7));
		
		return {0};
	end
}

function string.startsWith(b, s)
	return string.sub(b, 1, #s) == s;
end

function string.endsWith(b, s)
	return string.sub(b, #b - #s + 1) == s;
end

function cacheSprites()
	for i = 1, 11 do
		local t = 'chunkCache' .. i;
		if i == 8 then makeAnimatedLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk' .. i); else
		makeLuaSprite(t, 'anywhereUSA/scrollingBuildings/chunk' .. i); end
		addLuaSprite(t);
		setObjAlpha(t, 0.00001);
	end
	for i, v in pairs({'frBuild', 'frTrash', 'frTree', 'sea'}) do
		local t = 'cacheBG' .. v;
		makeLuaSprite(t, 'anywhereUSA/bg/bgObjects/' .. v);
		addLuaSprite(t);
		setObjAlpha(t, 0.00001);
	end
	for i, v in pairs({'rqBuild', 'rqLight', 'rqSign'}) do
		local t = 'cacheFG' .. v;
		makeLuaSprite(t, 'anywhereUSA/fg/' .. v);
		addLuaSprite(t);
		setObjAlpha(t, 0.00001);
	end
	
	makeLuaSprite('bayCache', 'anywhereUSA/floors/baystart');
	addLuaSprite('bayCache');
	setObjAlpha('bayCache', 0.00001);
	
	makeLuaSprite('gradiCache', 'anywhereUSA/scrollingBuildings/fx/fbibaseTrans', 200, 200);
	addLuaSprite('gradiCache');
	setObjAlpha('gradiCache', 0.00001);
	
	makeLuaSprite('cacheLight', 'anywhereUSA/scrollingBuildings/lightPost');
	addLuaSprite('cacheLight');
	setObjAlpha('cacheLight', 0.00001);
	
	makeLuaSprite('cacheLightN', 'anywhereUSA/scrollingBuildings/lightPostN');
	addLuaSprite('cacheLightN');
	setObjAlpha('cacheLightN', 0.00001);
end

function destroyCache()
	removeLuaSprite('bayCache');
	removeLuaSprite('gradiCache');
	removeLuaSprite('cacheLight');
	removeLuaSprite('cacheLightN');
	for i = 1, 11 do
		removeLuaSprite('chunkCache' .. i);
	end
	for i, v in pairs({'frBuild', 'frTrash', 'frTree', 'sea'}) do
		removeLuaSprite('cacheBG' .. v);
	end
	for i, v in pairs({'rqBuild', 'rqLight', 'rqSign'}) do
		removeLuaSprite('cacheFG' .. v);
	end
end
