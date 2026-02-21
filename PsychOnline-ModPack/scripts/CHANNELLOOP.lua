function onCreate()
	runHaxeCode([[
		createGlobalCallback('songLoopsFromTime', function(?o = 0) {
			if (o == 0) return 0;
			
			return parentLua.call('calcSongLoops', [o]);
		});
	]]);
end

songPos = 0;
prevSongPos = 0;
curBeatThing = 0;
prevChannelLoop = 0;
function onUpdatePost()
	if inGameOver then return; end
	
	local channelLoops = 0;
	local floorSongPos = math.floor(getSongPosition());
	local totalChannelLoops = 0;
	
	if prevSongPos < floorSongPos then
		for i = 1, (floorSongPos - prevSongPos) do
			prevSongPos = prevSongPos + 1;
			
			local loopsCalc = 0;
			local fakeBeat = ((prevSongPos + 3) / crochet);
			
			loopsCalc = math.floor((fakeBeat - math.floor(fakeBeat)) * 100) - prevChannelLoop;
			
			if loopsCalc > 0 then
				totalChannelLoops = totalChannelLoops + loopsCalc
			end
			
			prevChannelLoop = prevChannelLoop + loopsCalc;
		end
	end
	
	if totalChannelLoops > 0 then
		callOnLuas('onChannelLoop', {totalChannelLoops});
	end
end

function calcSongLoops(s)
	local returnLoops = 0;
	local totalLoops = 0;
	local atPos = 0;
	
	for i = 1, s do
		atPos = atPos + 1;
		
		local beatOn = ((atPos + 3) / crochet);
		local loopChannel = math.floor((beatOn - math.floor(beatOn)) * 100) - totalLoops;
			
		if loopChannel > 0 then
			returnLoops = returnLoops + loopChannel;
		end
		
		totalLoops = totalLoops + loopChannel;
	end
	
	return returnLoops;
end