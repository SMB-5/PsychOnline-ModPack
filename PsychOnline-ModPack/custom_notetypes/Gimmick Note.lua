--[[
	This script is pretty confusing honestly, so I left several notes throughout to help those understand how it works.
	
	Gimmick note, trying to compress it all into one script without relying on external things.
]]
playLeverSong = {
	['roadkill'] = true --table for songs if you want them to also trigger the tank chumps' car's catapult
}
gimmickNotes = {}; 

playSoundTime = {};
leverTimes = {};
smokeTime = {};
function onCreate()
	luaDebugMode = true;
	
	makeAnimatedLuaSprite('ballCache', 'cars/carObjects/cannonball');
	setObjectCamera('ballCache', 'hud');
	addLuaSprite('ballCache');
	setProperty('ballCache.alpha', 0.00001);
	
	makeAnimatedLuaSprite('chain', 'notes/chains/noteChain'); --precache the chain link
	addLuaSprite('chain');
	setProperty('chain.alpha', 0.00001);
	setObjectCamera('chain', 'hud');
	
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Gimmick Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_GIMMICK'); -- setting some gimmick note settings
			
			setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false);
			
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 200); -- miss = death
			
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true); -- will instead play the hit anim
		end
	end
	
	local alertedSustain = false;
	for i = getProperty('unspawnNotes.length') - 1, 0, -1 do -- remove any sustain notes that are present with the gimmick noteType
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Gimmick Note' then
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
				if not alertedSustain then
					debugPrint('Sustain notes are not supported for this note!'); -- gives an error message if you try
					alertedSustain = true;
				end
				removeFromGroup('unspawnNotes', i, false);
			end
		end
	end
	
	local strumTimeExists = false;
	
	for i = 0, getProperty('unspawnNotes.length') - 1 do --we start collecting only the gimmick note types in a table
		if (getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Gimmick Note' and getPropertyFromGroup('unspawnNotes', i, 'mustPress')) then	
			local str = getPropertyFromGroup('unspawnNotes', i, 'strumTime');
			local fStr = tostring(math.floor(str));
			
			if tblLen(gimmickNotes) == 0 then
				gimmickNotes[fStr] = {
					strumTime = str,
					id = i, -- when a NEW index is made, store the id, if this index does not contain two or more pairings by the end, delete the note and the index
					chainLen = 0,
					wasHit = {
						false
					},
					chainDestroyed = false,
					notes = {
						getPropertyFromGroup('unspawnNotes', i, 'noteData') + 1
					}
				}
			else
				if gimmickNotes[fStr] then
					table.insert(gimmickNotes[fStr].notes, getPropertyFromGroup('unspawnNotes', i, 'noteData') + 1);
					table.insert(gimmickNotes[fStr].wasHit, false); -- as said before, if the index already exists we dont need to store the id anymore
				else
					gimmickNotes[fStr] = {
						strumTime = str,
						id = i,
						chainLen = 0,
						wasHit = {
							false
						},
						chainDestroyed = false,
						notes = {
							getPropertyFromGroup('unspawnNotes', i, 'noteData') + 1
						}
					}
				end
			end
		end
	end
	
	local isPult = playLeverSong[songName:lower()];
	
	for i in pairs(gimmickNotes) do
		local tableRemoved = false;
		
		local curGmk = gimmickNotes[i]
		table.sort(curGmk.notes);
		
		if #curGmk.notes == 1 then
			removeFromGroup('unspawnNotes', curGmk.id) -- remove the notes without a pairing
			
			debugPrint('note at ' .. math.floor(curGmk.strumTime) .. ' has no other note(s) to chain with!');
			
			gimmickNotes[i] = nil;
			
			tableRemoved = true;
		end
		
		if not tableRemoved then
			curGmk.chainLen = curGmk.notes[#curGmk.notes] - curGmk.notes[1]; -- furthest chain - closest chain
			
			table.insert(playSoundTime, 1, { --the hitsound for the gimmick notes
				playedSound = false;
				strumTime = curGmk.strumTime - 181;
			});
			
			table.insert(smokeTime, 1, { -- smoke when catapult ball
				exploded = false;
				strumTime = curGmk.strumTime;
			});
			
			if isPult then
				table.insert(leverTimes, 1, { --the catapult if the song you chose supports it
					levSound = false;
					strumTime = curGmk.strumTime - 432;
				});
				
				table.sort(leverTimes, function(a, b) return a.strumTime < b.strumTime; end);
			end
			
			table.sort(playSoundTime, function(a, b) return a.strumTime < b.strumTime; end);
			table.sort(smokeTime, function(a, b) return a.strumTime < b.strumTime; end);
		end
	end
	
	runHaxeCode([[
		createCallback('getNoteXY', function(i:Int) {
			var note = game.notes.members[i];
			return [note.x, note.y];
		});
		
		createCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			var sp = game.modchartSprites.get(o);
			sp.x = x;
			sp.y = y;
		});
		
		createCallback('setSoundPitch', function(t:String, p:Float) {
			game.modchartSounds.get(t).pitch = p;
		});
		
		createCallback('setNoteFrameRate', function(i:Int, f:Float) {
			return game.notes.members[i].animation.curAnim.frameRate = f;
		});
		
		createCallback('getNoteStrumTime', function(i:Int) {
			return game.notes.members[i].strumTime;
		});
		
		createCallback('gmkNoteExtras', function(i:Int, d:Int) {
			var curNote = game.notes.members[i];
			curNote.noteSplashData.texture = 'notes/notesplashes/gimmickSplash';
			curNote.noteSplashData.useRGBShader = false;
			curNote.noteSplashData.a = 1;
			
			var curStrum = game.playerStrums.members[d];
			game.spawnNoteSplash(curStrum.x - 28, curStrum.y, d, curNote);
			
			game.grpNoteSplashes.forEachAlive(function(f) {
				if (StringTools.endsWith(f.graphic.key, 'gimmickSplash.png')) {
					f.animation.curAnim.frameRate = 28.8;
				}
			});
			
			curStrum.playAnim('static', true);
		});
	]]);
end

function onCreatePost()
	precacheSound('cannonball');
	precacheSound('LEVER AGAIN AGAIN{');
end

function onSpawnNote(i, d, n, s)
	if n == 'Gimmick Note' then
		setNoteFrameRate(i, 30);
		
		local str = getNoteStrumTime(i);
		spawnChainsForTime(str); -- spawn the chains as the notes spawn in and not have them spawn all at once
	end
end

function spawnChainsForTime(s)
	local t = math.floor(s);
	local tPos = tostring(t);
	
	if gimmickNotes[tPos] then
		local lenOfChain = gimmickNotes[tPos].chainLen;
		local firstNote = gimmickNotes[tPos].notes[1] - 1;
		local lastNote = gimmickNotes[tPos].notes[#gimmickNotes[tPos].notes] - 1;
		
		for i = 1, lenOfChain do
			local tag = 'chain' .. t .. i;
			local prevTag = 'chain' .. t .. (i - 1);
			local chX = (i == 1 and getPropertyFromGroup('playerStrums', firstNote, 'x') + 26 or getProperty(prevTag .. '.x') + getProperty(prevTag .. '.width') - 21);
			makeAnimatedLuaSprite(tag, 'notes/chains/noteChain', chX);
			addAnimationByPrefix(tag, 'boil', 'chainlink', 30);
			scaleObject(tag, 0.7, 0.7);
			addLuaSprite(tag, true);
			setObjectCamera(tag, 'hud');
			setObjectOrder(tag, getObjectOrder('notes') - 1);
		end
		
		table.insert(gimmickChains, 1, gimmickNotes[tPos]);
		
		gimmickNotes[tPos] = nil;
	end
end

gimmickChains = {};
function onUpdatePost(e)
	local songPos = getSongPosition();
	local songSpd = getProperty('songSpeed');
	
	if #gimmickChains > 0 then
		for i = 1, #gimmickChains do
			local curInd = gimmickChains[i];
			
			if curInd then
				local targST = math.floor(curInd.strumTime);
				
				local yDist = ((0.45 * (downscroll and 1 or -1)) * (songPos - curInd.strumTime) * songSpd);
				local strumY = downscroll and (screenHeight - 150) or 50;
				local yPos = strumY + yDist + 37;
				
				for b = 1, curInd.chainLen do
					local curChain = 'chain' .. targST .. b;
					
					if luaSpriteExists(curChain) then
						setProperty(curChain .. '.y', yPos);
					end
				end
			end
		end
	end
	
	if playLeverSong[songName:lower()] then
		while #leverTimes > 0 and leverTimes[1].strumTime <= getSongPosition() do
			table.remove(leverTimes, 1);
			
			doSound('LEVER AGAIN AGAIN{', 0.7);
			callScript('cars/carEvil', 'throwPult');
		end
	end
	
	while #playSoundTime > 0 and playSoundTime[1].strumTime <= getSongPosition() do
		table.remove(playSoundTime, 1);
		
		doSound('cannonball');
	end
	
	while #smokeTime > 0 and smokeTime[1].strumTime <= getSongPosition() do
		table.remove(smokeTime, 1);
		
		callScript('cars/tank', 'ballExplode');
	end
end

function goodNoteHit(i, d, n, s)
	if nt[n] then nt[n](i, d, s); end
end

nt = {
	['Gimmick Note'] = function(i, d, s)
		if getProperty('camZooming') then triggerEvent('Add Camera Zoom'); end
		
		cameraShake('game', 0.005, 0.15 / playbackRate);
		
		gmkNoteExtras(i, d);
		
		killChains(getNoteStrumTime(i), d); -- tells the table that the note at this direction has been hit
	end
}

function killChains(st, dir)
	local destroyChain = true;
	local posTbl = -1;
	
	for i = 1, #gimmickChains do
		if gimmickChains[i] and gimmickChains[i].strumTime == st then
			posTbl = i;
		end
	end
	
	if posTbl ~= -1 then
		local curGmk = gimmickChains[posTbl]
		for i = 1, #curGmk.notes do
			if curGmk.notes[i] == dir + 1 then -- sets this direction's wasHit to true
				curGmk.wasHit[i] = true;
			end
		end
		
		for i = 1, #curGmk.wasHit do
			if not curGmk.wasHit[i] then -- instead of trying to prove something as true, since thered be too many variables to deal with, we try to prove it false
				destroyChain = false
			end
		end
		
		if destroyChain then
			for i = 1, curGmk.chainLen do -- if all the notes on a strumtime have been hit, delete the chain
				removeLuaSprite('chain' .. math.floor(curGmk.strumTime) .. i);
			end
			
			table.remove(gimmickChains, posTbl);
		end
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

function tblLen(t) -- doing this ONLY because doing #table doesnt work in my curcumstance
	local l = 0;
	for i in pairs(t) do l = l + 1; end
	return l;
end

-- GIMMICK GOOD
