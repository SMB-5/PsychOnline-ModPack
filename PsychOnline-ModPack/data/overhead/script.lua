local allowCountdown = false
function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	for i = 0, 7, 1 do
		setStrumVisibilty(i, false)
	end

	if not allowCountdown and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onCreatePost()
	for i = 0, 7, 1 do
		setStrumVisibilty(i, false)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue');
	end
end

function setStrumVisibilty(v1,vis)
	strum = v1
	strumset = 'opponentStrums'

	if strum > 3 then
		strumset = 'playerStrums'
	end

	strum = v1 % 4
	setPropertyFromGroup(strumset,strum,'visible',vis)
end