upScale = 1 / 0.7;
function onCreatePost()
	luaDebugMode = true;
	
	local tomScale = 0.707182 * upScale * 1.03;
	makeAnimatedLuaSprite('tomHarpoon', 'eddsworld/end mix/tom/tomHarpoon', 696 * upScale, 717 * upScale);
	addAnimationByPrefix('tomHarpoon', 'idle', 'TomHarpoonIdle', 18);
	addAnimationByPrefix('tomHarpoon', 'talk', 'TomHarpoonLine', 19);
	addAnimationByPrefix('tomHarpoon', 'useful', 'TomHarpoonHarpoon', 21);
	scaleObject('tomHarpoon', tomScale, tomScale);
	local tomOff = getObjCen('tomHarpoon');
	local tomOffsets = {tomOff[1] + (math.floor(191 * 1.03) * upScale), tomOff[2] + (math.floor(457 * 1.03) * upScale)};
	addOffset('tomHarpoon', 'idle', tomOffsets[1], tomOffsets[2]);
	addOffset('tomHarpoon', 'talk', tomOffsets[1], tomOffsets[2]);
	addOffset('tomHarpoon', 'useful', tomOffsets[1], tomOffsets[2]);
	setObjFrameRate('tomHarpoon', 'talk', 18.6);
	setLoopPoint('tomHarpoon', 'talk', 4);
	setLoopPoint('tomHarpoon', 'useful', 9);
	playAnim('tomHarpoon', 'idle', true);
	setObjectOrder('tomHarpoon', getObjectOrder('boyfriendGroup') + 3);
	setObjAlpha('tomHarpoon', 0.00001);
end

function onSongStart()
	setObjAlpha('tomHarpoon', 0);
end

function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Prepare Ending'] = function()
		setObjAlpha('tomHarpoon', 1);
	end,
	['Tom Talk'] = function(v1)
		playAnim('tomHarpoon', (v1 == '1' and 'talk' or 'useful'), true);
	end
}
