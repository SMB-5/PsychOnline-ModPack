upScale = (1 / 0.7);
eduardoScale = 0.71554252 * upScale * 1.03;
eduardoX = ((-475 - math.floor(121 * 1.03)) * upScale) + 9.01;
function onCreatePost()
	luaDebugMode = true;
	
	callOnLuas('loadBores', {});
	
	addLuaScript('scriptChars/jonNMark'); 
	
	createInstance('eduardo', 'objects.Character', {0, ((548 - math.floor(483 * 1.03)) * upScale) + 17.64221888, 'eduardo'});
	scaleObject('eduardo', eduardoScale, eduardoScale);
	setObjectOrder('eduardo', getObjectOrder('fence'));
	resizeOffsets('eduardo', eduardoScale);
	setObjAlpha('eduardo', 0.00001);
	setObjFrameRate('eduardo', 'hey', 10.8);
	
	runHaxeCode([[
		function setEduardoDad() {
			setVar('oldDad', game.dad);
			game.dad = getVar('eduardo');
			game.setOnScripts('dadName', game.dad.curCharacter);
		}
	]]);
	
end

function onSongStart()
	setObjAlpha('eduardo', 0);
end

noteDance = false;
firstWell = false;
function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Prepare Trio'] = function()
		setObjX('eduardo', eduardoX);
		setObjAlpha('eduardo', 1);
	end,
	['Set Eduardo Dad'] = function()
		setObjectOrder('dadGroup', getObjectOrder('eduardo') - 1);
		runHaxeFunction('setEduardoDad');
	end,
	['Well'] = function(v1)
		if v1 ~= 'r' then
			playAnim('dad', 'hey', true);
			
			if not firstWell then
				firstWell = true;
				noteDance = true;
				setProperty('dad.skipDance', true);
			end
		end
	end,
	['Focus Char'] = function(v1)
		if v1 == 'eduardo' then
			setProperty('isCameraOnForcedPos', false);
			cameraSetTarget('dad');
		end
	end
}

function opponentNoteHit()
	if noteDance then
		noteDance = false;
		
		setProperty('dad.skipDance', false);
	end
end
