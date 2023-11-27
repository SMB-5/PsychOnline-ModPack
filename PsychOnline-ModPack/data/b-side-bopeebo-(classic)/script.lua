local boppingVel = 0
local leenInTime = 0
local modchartPhase = 0

local reverseBop = false

function onCreatePost()
	triggerEvent('Set GF Speed', 2, '')

	runTimer('updateOn60', 1 / 60, 0)
end

function onBeatHit()
	if curBeat == 32 or curBeat == 96 then
		modchartPhase = 1

		triggerEvent('Set GF Speed', 1, '')
	elseif curBeat == 64 then
		modchartPhase = 0

		triggerEvent('Set GF Speed', 2, '')
	elseif curBeat == 128 then
		modchartPhase = 2
	end
end

function onStepHit()
	local stepCounter = curStep % 16
	if stepCounter == 0 or stepCounter == 4 or stepCounter == 6 or stepCounter == 10 or stepCounter == 12 then
		boppingVel = 7

		if reverseBop then
			boppingVel = boppingVel * -1
			reverseBop = false
		else
			reverseBop = true
		end
	end
end

function onUpdate(elapsed)
	local beatOnTheSpot = (getSongPosition() / 1000) * (curBpm / 60) * 0.25

	if modchartPhase == 0 then
		luaDebugMode = true
		for i = 0, 3 do
			local horizontalMovement = leenInTime * (24 * math.cos((beatOnTheSpot + (i * 0.50)) * math.pi)) * (boppingVel / 9)
			setProperty('playerStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i] - horizontalMovement)
			setProperty('opponentStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i] + horizontalMovement)

			local verticalMovement = -boppingVel
			if i % 2 == 0 then
				verticalMovement = boppingVel
			end
			setProperty('playerStrums.members['..i..'].y', _G['defaultPlayerStrumY'..i] + verticalMovement)
			setProperty('opponentStrums.members['..i..'].y', _G['defaultOpponentStrumY'..i] + verticalMovement)
		end
	elseif modchartPhase == 1 then
		for i = 0, 3 do
			local horizontalMovement = leenInTime * (24 * math.cos((beatOnTheSpot + (i * 0.50)) * math.pi)) * (boppingVel / 9)
			setProperty('playerStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i] - horizontalMovement)
			setProperty('opponentStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i] + horizontalMovement)

			setProperty('playerStrums.members['..i..'].y', _G['defaultPlayerStrumY'..i])
			setProperty('opponentStrums.members['..i..'].y', _G['defaultOpponentStrumY'..i])
		end
	else
		for i = 0, 3 do
			setProperty('playerStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i])
			setProperty('opponentStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i])
			setProperty('playerStrums.members['..i..'].y', _G['defaultPlayerStrumY'..i])
			setProperty('opponentStrums.members['..i..'].y', _G['defaultOpponentStrumY'..i])
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'updateOn60' then
		if modchartPhase == 1 then
			if leenInTime < 1 then
				leenInTime = leenInTime + 0.01
			end
		else
			if leenInTime > 0 then
				leenInTime = leenInTime - 0.01
				if leenInTime < 0 then
					leenInTime = 0
				end
			end
		end
		boppingVel = boppingVel * 0.90
	end
end