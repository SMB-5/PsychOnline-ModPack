upScale = 1 / 0.7;
function onCreatePost()
	dadScale = 0.918 * upScale;
	scaleObject('dad', dadScale, dadScale);
	--resizeOffsets('dad', dadScale, dadScale);
	
	makeAnimatedLuaSprite('tankChumpDeath', 'characters/hockeychump/chumpDie');
	addAnimationByIndices('tankChumpDeath', 'knifeSpin', 'SportKnifeSpinANDDeath', '1,2,3,4,5', 29);
	addAnimationByIndices('tankChumpDeath', 'death', 'SportKnifeSpinANDDeath', '10,11,12,13,14,15,16,17,18,19,20', 30);
	scaleObject('tankChumpDeath', dadScale, dadScale);
	addOffset('tankChumpDeath', 'knifeSpin', 365 * dadScale, 81 * dadScale);
	addOffset('tankChumpDeath', 'death', 365 * dadScale, 81 * dadScale);
	playAnim('tankChumpDeath', 'knifeSpin', true);
	setObjectOrder('tankChumpDeath', getObjectOrder('dadGroup') + 1);
	setProperty('tankChumpDeath.alpha', 0.00001);
	
	runHaxeCode([[
		for (i in game.dad.animOffsets.keys()) {
            game.dad.animOffsets[i][0] *= ]] .. dadScale .. [[;
            game.dad.animOffsets[i][1] *= ]] .. dadScale .. [[;
			game.dad.dance();
        }
		
		createCallback('getDadPos', function() {
			var h = game.dad;
			return [h.x, h.y];
		});
		
		createCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			var sp = game.modchartSprites.get(o);
			sp.x = x;
			sp.y = y;
		});
	]]);
end

inDeath = false;
function onUpdatePost()
	if inDeath then
		local dadPos = getDadPos();
		setObjPos('tankChumpDeath', dadPos[1], dadPos[2]);
	end
end

function onEvent(n, v1)
	if events[n] then events[n](v1); end
end

events = {
	['Chump Die'] = function(v1)
		inDeath = true;
		
		setProperty('dad.alpha', 0.00001);
		setProperty('tankChumpDeath.alpha', 1);
		playAnim('tankChumpDeath', v1, true);
	end
}
