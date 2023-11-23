function onCreate()
	addCharacterToList('garDTface', 'dad')
	addCharacterToList('annieDTface', 'bf')
	addCharacterToList('DTDeath', 'bf')

	setPropertyFromClass('GameOverSubstate', 'characterName', 'DTDeath')
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'DilemmaDeath')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'DilemmaGameOver')
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'DilemmaRetry')
end

local iPos = 0
local jPos = 0
local j    = 0
function onSongStart()
	for i = 0, 3 do
		j = i + 4

		iPos = _G['defaultPlayerStrumX'..i]
		jPos = _G['defaultOpponentStrumX'..i]
		--if alreadySwapped then
		--	iPos = _G['defaultOpponentStrumX'..i]
		--	jPos = _G['defaultPlayerStrumX'..i]
		--end
		noteTweenX('note'..i..'TwnX', i, iPos, 7.93, 'quadOut')
		noteTweenX('note'..j..'TwnX', j, jPos, 7.93, 'quadOut')
	end
end