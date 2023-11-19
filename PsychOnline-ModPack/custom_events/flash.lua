-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'flash' then
		duration = tonumber(value1);
		if duration == nil or duration == 0 then duration = 1 end
		if duration <= 1 then
			cameraFlash('game', 'FFFFFF', 0.35, true)
		elseif duration >= 3 then
			cameraFlash('game', 'FFFFFF', 0.35, true)
			-- setProperty('darkMono.visible', false)
			-- setProperty('saxguy.visible', false)
		else
			cameraFlash('game', 'FFFFFF', 0.35, true)
			-- setProperty('darkMono.visible', false)
		end

		-- if string.lower(curStage) == 'cargo' then
			-- setProperty('cargoDarkFG.alpha', 0)
			-- setProperty('camHUD.visible', true)
		-- end

		-- haxe code ref idk
		-- -- case 0:
		-- -- 	camGame.flash(FlxColor.WHITE, 0.35);
		-- -- case 1:
		-- -- 	camGame.flash(FlxColor.WHITE, 0.35);
		-- -- case 2:
		-- -- 	camGame.flash(FlxColor.WHITE, 0.55);
		-- -- 	darkMono.visible = true;
		-- -- case 3:
		-- -- 	camGame.flash(FlxColor.WHITE, 0.55);
		-- -- 	darkMono.visible = false;
		-- -- 	saxguy.visible = false;

		-- -- if(curStage.toLowerCase() == 'cargo'){
		-- -- 	cargoDarkFG.alpha = 0;
		-- -- 	camHUD.visible = true;
		-- -- }
    end
end