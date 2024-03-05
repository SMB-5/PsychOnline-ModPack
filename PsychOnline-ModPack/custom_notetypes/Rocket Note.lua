targetPos = {};
function onCreate()
	luaDebugMode = true;
	
	makeLuaSprite('targetCache', 'notes/rocketTarget');
	setObjectCamera('targetCache', 'hud');
	addLuaSprite('targetCache');
	setObjAlpha('targetCache', 0.00001);
	
	makeAnimatedLuaSprite('rocketCache', 'notes/rocket');
	setObjectCamera('rocketCache', 'hud');
	addLuaSprite('rocketCache');
	setObjAlpha('rocketCache', 0.00001);
	
	makeAnimatedLuaSprite('plosionCache', 'notes/noteSplashes/explosion');
	setObjectCamera('plosionCache', 'hud');
	addLuaSprite('plosionCache');
	setObjAlpha('plosionCache', 0.00001);
	
	runHaxeCode([[		
		createCallback('getScaleX', function(o) {
			var obj = game.modchartSprites.get(o);
			return obj.scale.x;
		});
		
		createCallback('setNoteFrameRate', function(i, f) {
			game.notes.members[i].animation.curAnim.frameRate = f;
		});
		
		createCallback('noteSplashSetter', function(i) {
			var curNote = game.notes.members[i];
			var splash = curNote.noteSplashData;
			
			splash.texture = 'notes/notesplashes/explosion';
			splash.useRGBShader = false;
			splash.disabled = true;
			splash.a = 1;
			
			game.spawnNoteSplash(curNote.x - 8, curNote.y + (ClientPrefs.data.downScroll ? 207 : 0), curNote.noteData, curNote);
		});
	]]);
	
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if unspawnProperty(i, 'noteType') == 'Rocket Note' then
			unspawnProperty(i, 'texture', 'notes/rocket');
			unspawnProperty(i, 'multSpeed', 1.46);
			unspawnProperty(i, 'noAnimation', true);
			unspawnProperty(i, 'scale.x', 0.8);
			unspawnProperty(i, 'scale.y', 0.8);
			unspawnProperty(i, 'offsetX', 4);
			unspawnProperty(i, 'offsetY', (downscroll and -195.5 or 7));
			unspawnProperty(i, 'flipY', downscroll);
			unspawnProperty(i, 'missHealth', 5);
			unspawnProperty(i, 'rgbShader.enabled', false);
			
			table.insert(targetPos, {
				startAt = unspawnProperty(i, 'strumTime') - (crochet * 4);
				dir = unspawnProperty(i, 'noteData');
			});
		end
	end
	
	for i = 0, 3 do
		targetStrums[i] = {
			isOn = false,
			scaling = false,
			alphaSub = false,
			blinkAt = 0,
			curBlink = 1,
			alphaTime = 0,
			alpha = 1;
			scale = 2.2
		};
	end
	
	blinkTimes = {
		[0] = 0;
		crochet, --c 1
		crochet * 2, --d 2
		crochet * 2.5, --e 3 
		crochet * 3, --f 4
		crochet * 3.5, --g 5
		(crochet * 4) - 150, --k play tord about to press button 6
		crochet * 4 --h play tord pressing button and kill targets 7
	}
end

function onCountdownStarted()
	for i = 0, 3 do
		local targWidth = getProperty('targetCache.width') * 0.25;
		local targHeight = getProperty('targetCache.height') * 0.25;
		
		local noteX = _G['defaultPlayerStrumX' .. i];
		local noteY = _G['defaultPlayerStrumY' .. i];
		
		local grp = 'tordTargGrp' .. i;
		makeSpriteGrp(grp);
		setObjectCamera(grp, 'hud');
	
		local t = 'targTord' .. i;
		makeLuaSprite(t, 'notes/rocketTarget', (-targWidth * 0.7) + noteX - 2, (-targHeight * 0.7) + noteY - 4);
		scaleObject(t, 0.7, 0.7, false);
		setObjectCamera(t, 'hud');
		setObjAlpha(t, 0.00001);
		addToGrp(t, grp);
		
		local tW = 'targTordWhite' .. i;
		makeLuaSprite(tW, 'notes/rocketTarget', (-targWidth * 0.7) + noteX - 2, (-targHeight * 0.7) + noteY - 4);
		scaleObject(tW, 0.7 * 2.2, 0.7 * 2.2, false);
		setObjectCamera(tW, 'hud');
		setObjectOrder(tW, getObjectOrder('strumLineNotes') + 2);
		setProperty(tW .. '.colorTransform.blueOffset', 255);
		setProperty(tW .. '.colorTransform.greenOffset', 255);
		setObjAlpha(tW, 0.00001);
		addToGrp(tW, grp);
		
		setObjectOrder(grp, getObjectOrder('noteGroup') + 1);
	end
end

function onSongStart()
	for i = 0, 3 do
		setObjAlpha('targTord' .. i, 0);
		setObjAlpha('targTordWhite' .. i, 0);
	end
	setObjAlpha('targetCache', 0);
	setObjAlpha('rocketCache', 0);
	setObjAlpha('plosionCache', 0);
end

function onSpawnNote(i, d, n, s)
	if n == 'Rocket Note' then
		setNoteFrameRate(i, 30);
	end
end

function goodNoteHit(i, d, n, s)
	if n == 'Rocket Note' then
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom', '0.05', '0.025'); end
		noteSplashSetter(i);
	end
end

daAlphTime = 0;
function onUpdatePost(e)
	e = e * playbackRate;
	
	while #targetPos > 0 and targetPos[1].startAt <= getSongPosition() do
		doTarget(targetPos[1].dir);
		table.remove(targetPos, 1);
	end
	
	for i = 0, 3 do
		local targ = targetStrums[i];
		if targ.isOn then
			local glowTarg = 'targTordWhite' .. i;
			
			local blink = targ.curBlink;
			if getSongPosition() >= targ.blinkAt + blinkTimes[blink] then
				if blink < 6 then
					targ.alpha = 1;
					targ.alphaSub = true;
					targ.alphaTime = 5;
				end
				if blink == 6 then
					callScript('scriptChars/tord', 'buttonPressTord', {'prep'});
				end
				if blink == 7 then
					callScript('scriptChars/tord', 'buttonPressTord', {'press'});
					
					targ.isOn = false;
					setObjAlpha('targTord' .. i, 0.00001);
					setObjAlpha(glowTarg, 0.00001);
					
					goto cont;
				end
				
				targ.curBlink = targ.curBlink + 1;
			end
			
			if targ.alphaSub then
				targ.alphaTime = targ.alphaTime - (e / 0.01);
				
				if targ.alphaTime <= 0 then
					local curAlpha = targ.alpha - ((32 / 255) * (e * 60));
					if curAlpha <= 0 then
						curAlpha = 0;
						targ.alphaSub = false;
					end
					targ.alpha = curAlpha;
					setObjAlpha(glowTarg, curAlpha);
				end
			end
			
			if targ.scaling then
				local newScale = targ.scale * (1 - (0.05 * (e * 60)));
				if newScale <= 1 then
					newScale = 1;
					
					targ.scaling = false;
				end
				targ.scale = newScale;
				
				scaleObject(glowTarg, 0.7 * newScale, 0.7 * newScale, false);
			end
		end
		
		::cont::
	end
end

targetStrums = {};
function doTarget(d)
	local targ = targetStrums[d];
	if targ.isOn then return; end
	
	targ.isOn = true;
	targ.scaling = true;
	targ.alphaSub = true;
	targ.blinkAt = getSongPosition();
	targ.alphaTime = 0;
	targ.alpha = 1;
	targ.curBlink = 1;
	targ.scale = 2.2;
	
	local t = 'targTord' .. d;
	setObjAlpha(t, 1);
	
	local tW = 'targTordWhite' .. d;
	scaleObject(tW, 0.7 * 2.2, 0.7 * 2.2, false);
	setObjAlpha(tW, 1);
end

function unspawnProperty(index, property, setter)
	if setter == nil then 
		return getPropertyFromGroup('unspawnNotes', index, property);
	else
		setPropertyFromGroup('unspawnNotes', index, property, setter);
	end
end
