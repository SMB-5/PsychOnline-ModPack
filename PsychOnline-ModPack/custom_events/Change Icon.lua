function onCreate()
	runHaxeCode([[
		createCallback('changeIcon', function(p, t) {
			if (p) {
				game.iconP1.changeIcon(t);
			} else {
				game.iconP2.changeIcon(t);
			}
		});
	]]);
end
function onEvent(n, v1, v2)
	if events[n] then events[n](v1, v2); end
end

events = {
	['Change Icon'] = function(v1, v2)
		changeIcon(v1:upper() == 'P1', v2);
	end
}
