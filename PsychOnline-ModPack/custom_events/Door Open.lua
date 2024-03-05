upScale = 1 / 0.7;
function onCreate()
	makeAnimatedLuaSprite('houseDoor', 'eddsworld/extraObjects/eddDoor', (592 - 101) * upScale, (326 - 127) * upScale);
	addAnimationByPrefix('houseDoor', 'door', 'Door Opening', 14, false);
	scaleObject('houseDoor', upScale, upScale);
	setObjFrameRate('houseDoor', 'door', 14.4);
	setObjectOrder('houseDoor', getObjectOrder('houses') + 1);
	setObjAlpha('houseDoor', 0.00001);
	
	runHaxeCode([[
		game.modchartSprites.get('houseDoor').animation.finishCallback = function(n){
			parentLua.call('onDoorAnimFin', []);
		}
	]]);
end

function onDoorAnimFin()
	setObjAlpha('houseDoor', 0);
	
	if killDoor then 
		removeLuaSprite('houseDoor'); 
		killDoor = false; 
	end
end

killDoor = false;
function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Door Open'] = function()
		killDoor = (v1 == 'true');
		
		setObjAlpha('houseDoor', 1);
		playAnim('houseDoor', 'door', true);
	end
}
