function onCreate()
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
		import psychlua.LuaUtils;
		import flixel.group.FlxTypedGroup;
		import flixel.group.FlxTypedSpriteGroup;
		
		function sizeUpOff(obj:String, s:Float) {
			var o = LuaUtils.getObjectDirectly(obj, false);
			 for(i in o.animOffsets.keys()) {
				o.animOffsets[i][0] *= s;
				o.animOffsets[i][1] *= s;
			}
			
			var currFrame = o.animation.curAnim.curFrame;
			o.playAnim(o.animation.curAnim.name, true);
			o.animation.curAnim.curFrame = currFrame;
		}
		
		var widthOff = ((640 / 0.7) - 640);
		var heightOff = ((360 / 0.7) - 360);
		
		createGlobalCallback('subScrollPos', function(s) {
			return [widthOff * (s - 1), heightOff * (s - 1)];
		});
		
		createGlobalCallback('resizeOffsets', function(o:String, s:Float) {
			sizeUpOff(o, s);
		});
		
		createGlobalCallback('makeGroup', function(o) {
			var grp:FlxTypedGroup<FlxBasic>;
			grp = new FlxTypedGroup();
			setVar(o, grp);
		});
		
		createGlobalCallback('makeSpriteGrp', function(o, ?x, ?y) {
			var grp:FlxTypedSpriteGroup<FlxSprite>;
			grp = new FlxTypedSpriteGroup(x, y);
			setVar(o, grp);
		});
		
		createGlobalCallback('addToGrp', function(o, g) {
			getVar(g).add(LuaUtils.getObjectDirectly(o, false));
		});
		
		createGlobalCallback('setObjFrameRate', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).frameRate = f;
		});
		
		createGlobalCallback('setLoopPoint', function(o, a, l) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).loopPoint = l;
		});
		
		createGlobalCallback('setObjAlpha', function(o, a) {
			var b = LuaUtils.getObjectDirectly(o, false);
			return b.alpha = a;
		});
		
		createGlobalCallback('getObjCen', function(o:String) {
			var b = LuaUtils.getObjectDirectly(o, false);
			return [(b.frameWidth - b.width) * 0.5, (b.frameHeight - b.height) * 0.5];
		});
		
		createGlobalCallback('getObjPos', function(b) {
			var h = LuaUtils.getObjectDirectly(b, false);
			return [h.x, h.y];
		});
		
		createGlobalCallback('setObjPos', function(b, x, y) {
			LuaUtils.getObjectDirectly(b, false).setPosition(x, y);
		});
		
		createGlobalCallback('getObjX', function(o) {
			return LuaUtils.getObjectDirectly(o, false).x;
		});
		
		createGlobalCallback('setObjX', function(o, x) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.x = x;
		});
		
		createGlobalCallback('getObjY', function(o) {
			return LuaUtils.getObjectDirectly(o, false).y;
		});
		
		createGlobalCallback('addToY', function(o, y) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.y += y;
		});
		
		createGlobalCallback('getCurFrame', function(o) {
			return LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame;
		});
		
		createGlobalCallback('setCurFrame', function(o, f) {
			LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame = f;
		});
		
		createGlobalCallback('setObjectColor', function(o, c) {
			LuaUtils.getObjectDirectly(o, false).color = c;
		});
		
		createGlobalCallback('setCamFollow', function(?x:Float = 0., ?y:Float = 0.) {
			game.camFollow.setPosition(x, y);
		});
		
		createGlobalCallback('removeObjOnFinishAnim', function(o) {
			var obj = LuaUtils.getObjectDirectly(o, false);
			obj.animation.finishCallback = function() {
				parentLua.call('removeLuaSprite', [o]);
			}
		});
		
		createGlobalCallback('reloadHealthBar', function() {
			game.reloadHealthBarColors();
		});
		
		function sizeUpOff(obj:String, s:Float) {
			var o = LuaUtils.getObjectDirectly(obj, false);
			 for(i in o.animOffsets.keys()) {
				o.animOffsets[i][0] *= s;
				o.animOffsets[i][1] *= s;
			}
			
			var currFrame = o.animation.curAnim.curFrame;
			o.playAnim(o.animation.curAnim.name, true);
			o.animation.curAnim.curFrame = currFrame;
		}
		
		var widthOff = ((640 / 0.7) - 640);
		var heightOff = ((360 / 0.7) - 360);
		
		createGlobalCallback('subScrollPos', function(s) {
			return [widthOff * (s - 1), heightOff * (s - 1)];
		});
		
		createGlobalCallback('resizeOffsets', function(o:String, s:Float) {
			sizeUpOff(o, s);
		});
		
		createGlobalCallback('setObjFrameRate', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).frameRate = f;
		});
		
		createGlobalCallback('setLoopPoint', function(o, a, l) {
			return LuaUtils.getObjectDirectly(o, false).animation._animations.get(a).loopPoint = l;
		});
		
		createGlobalCallback('setObjAlpha', function(o, a) {
			var b = LuaUtils.getObjectDirectly(o, false);
			return b.alpha = a;
		});
		
		createGlobalCallback('getObjAlpha', function(o) {
			return LuaUtils.getObjectDirectly(o, false).alpha;
		});
		
		createGlobalCallback('getObjCen', function(o:String) {
			var b = LuaUtils.getObjectDirectly(o, false);
			return [(b.frameWidth - b.width) * 0.5, (b.frameHeight - b.height) * 0.5];
		});
		
		createGlobalCallback('getObjPos', function(b) {
			var h = LuaUtils.getObjectDirectly(b, false);
			return [h.x, h.y];
		});
		
		createGlobalCallback('setObjPos', function(o:String, x:Float, y:Float) {	
			var sp = LuaUtils.getObjectDirectly(o);
			sp.x = x;
			sp.y = y;
		});
		
		createGlobalCallback('setObjX', function(o, x) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.x = x;
		});
		
		createGlobalCallback('getObjX', function(o) {
			return LuaUtils.getObjectDirectly(o, false).x;
		});
		
		createGlobalCallback('setObjY', function(o, y) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.y = y;
		});
		
		createGlobalCallback('addToX', function(o, x) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.x += x;
		});
		
		createGlobalCallback('addToY', function(o, y) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.y += y;
		});
		
		createGlobalCallback('addToPos', function(o, x, y) {
			var sp = LuaUtils.getObjectDirectly(o);
			sp.x += x;
			sp.y += y;
		});
		
		createGlobalCallback('blendCoeff', function(a) {
			return (1 - (a / 255));
		});
		
		createGlobalCallback('getWidth', function(x) {
			return LuaUtils.getObjectDirectly(x, false).width;
		});
		
		createGlobalCallback('getCurFrame', function(o) {
			return LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame;
		});
		
		createGlobalCallback('setCurFrame', function(o, f) {
			LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame = f;
		});
		
		createGlobalCallback('getCurAnim', function(o) {
			return LuaUtils.getObjectDirectly(o, false).animation.name;
		});
		
		createGlobalCallback('getObjectColor', function(o) {
			return LuaUtils.getObjectDirectly(o, false).color;
		});
		
		createGlobalCallback('setObjectColor', function(o, c) {
			LuaUtils.getObjectDirectly(o, false).color = c;
		});
		
		createGlobalCallback('doSound', function(sound, ?volume = 1, ?tag = null) {
			if(tag != null && tag.length > 0) {
				tag = StringTools.replace(tag, '.', '');
				if (game.modchartSounds.exists(tag)) {
					game.modchartSounds.get(tag).stop();
				}
				
				var sound = FlxG.sound.play(Paths.sound(sound), volume, false, function() {
					game.modchartSounds.remove(tag);
					game.callOnLuas('onSoundFinished', [tag]);
				});
				
				sound.pitch = game.playbackRate;
				
				game.modchartSounds.set(tag, sound);
				
				return;
			}
			var s = FlxG.sound.play(Paths.sound(sound), volume);
			s.pitch = game.playbackRate;
		});
		
		createGlobalCallback('getDefaultScreenPositions', function() {
			return [(FlxG.width / 2) + ((640 / 0.7) - 640), (FlxG.height / 2) + ((360 / 0.7) - 360)];
		});
		
		createGlobalCallback('getCamFollow', function() {
			return [game.camFollow.x, game.camFollow.y];
		});
		
		createGlobalCallback('setCamFollow', function(?x:Float = 0., ?y:Float = 0.) {
			game.camFollow.setPosition(x, y);
		});
		
		createGlobalCallback('hideObjOnFinishAnim', function(o) {
			var obj = LuaUtils.getObjectDirectly(o, false);
			obj.animation.finishCallback = function() {
				obj.alpha = 0.00001;
			}
		});
		
		createGlobalCallback('removeObjOnFinishAnim', function(o) {
			var obj = LuaUtils.getObjectDirectly(o, false);
			obj.animation.finishCallback = function() {
				parentLua.call('removeLuaSprite', [o]);
			}
		});

				createGlobalCallback('subScrollPos', function(s) {
			return [widthOff * (s - 1), heightOff * (s - 1)];
		});
		
		createGlobalCallback('resizeOffsets', function(o, s) {
			sizeUpOff(o, s);
		});
		
		createGlobalCallback('makeCharDance', function(o) { // this looks stupid, since 'characterDance' exists, but this is just for characters with variable names
			getVar(o).dance();
		});
		
		createGlobalCallback('makeGroup', function(o) {
			var grp:FlxTypedGroup<FlxBasic>;
			grp = new FlxTypedGroup();
			setVar(o, grp);
		});
		
		createGlobalCallback('makeSpriteGrp', function(o, ?x, ?y) {
			var grp:FlxTypedSpriteGroup<FlxSprite>;
			grp = new FlxTypedSpriteGroup(x, y);
			setVar(o, grp);
		});
		
		createGlobalCallback('addToGrp', function(o, g) {
			getVar(g).add(LuaUtils.getObjectDirectly(o, false));
		});
		
		createGlobalCallback('insertInGrp', function(o, g, i) {
			getVar(g).insert(i, LuaUtils.getObjectDirectly(o));
		});
		
		createGlobalCallback('removeFromGrp', function(o, g) {
			getVar(g).remove(LuaUtils.getObjectDirectly(o, false));
		});
		
		createGlobalCallback('killAndDestroy', function(g) {
			var obj = getVar(g);
			obj.kill();
			LuaUtils.getTargetInstance().remove(obj, true);
			//obj.destroy(); // causing crashes, how cool
			removeVar(g);
		});
		
		createGlobalCallback('killObjGrp', function(o, g) {
			var spr = game.modchartSprites.get(o);
			spr.animation.finishCallback = function() {
				getVar(g).remove(spr, true);
				
				parentLua.call('removeLuaSprite', [o]);
			}
		});
		
		createGlobalCallback('setObjFrameRate', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation.getByName(a).frameRate = f;
		});
		
		createGlobalCallback('setObjFlipXAnim', function(o, a, f) {
			return LuaUtils.getObjectDirectly(o, false).animation.getByName(a).flipX = f;
		});
		
		createGlobalCallback('setLoopPoint', function(o, a, l) {
			return LuaUtils.getObjectDirectly(o, false).animation.getByName(a).loopPoint = l;
		});
		
		createGlobalCallback('getAnimExists', function(o, a) {
			return LuaUtils.getObjectDirectly(o, false).animation.getByName(a) != null;
		});
		
		createGlobalCallback('setObjAlpha', function(o, a) {
			var b = LuaUtils.getObjectDirectly(o, false);
			return b.alpha = a;
		});
		
		createGlobalCallback('getObjAlpha', function(o) {
			return LuaUtils.getObjectDirectly(o, false).alpha;
		});
		
		createGlobalCallback('setObjVelX', function(o, v) {
			return LuaUtils.getObjectDirectly(o, false).velocity.x = v;
		});
		
		createGlobalCallback('moveCam', function() {
			game.moveCameraSection();
		});
		
		createGlobalCallback('getObjCen', function(o) {
			var b = LuaUtils.getObjectDirectly(o, false);
			return [(b.frameWidth - b.width) * 0.5, (b.frameHeight - b.height) * 0.5];
		});
		
		createGlobalCallback('getObjPos', function(b) {
			var h = LuaUtils.getObjectDirectly(b, false);
			return [h.x, h.y];
		});
		
		createGlobalCallback('setObjPos', function(o, x, y) {
			LuaUtils.getObjectDirectly(o).setPosition(x, y);
		});
		
		createGlobalCallback('setObjX', function(o, x) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.x = x;
		});
		
		createGlobalCallback('getObjX', function(o) {
			return LuaUtils.getObjectDirectly(o, false).x;
		});
		
		createGlobalCallback('setObjY', function(o, y) {
			var sp = LuaUtils.getObjectDirectly(o, false);
			sp.y = y;
		});
		
		createGlobalCallback('getObjY', function(o) {
			return LuaUtils.getObjectDirectly(o, false).y;
		});
		
		createGlobalCallback('addToX', function(o, x) {
			LuaUtils.getObjectDirectly(o, false).x += x;
		});
		
		createGlobalCallback('addToY', function(o, y) {
			LuaUtils.getObjectDirectly(o, false).y += y;
		});
		
		createGlobalCallback('addToPos', function(o, x, y) {
			var sp = LuaUtils.getObjectDirectly(o);
			sp.x += x; sp.y += y;
		});
		
		createGlobalCallback('blendCoeff', function(a) {
			return (1 - (a / 255));
		});
		
		createGlobalCallback('getWidth', function(x) {
			return LuaUtils.getObjectDirectly(x, false).width;
		});
		
		createGlobalCallback('getCurFrame', function(o) {
			return LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame;
		});
		
		createGlobalCallback('setCurFrame', function(o, f) {
			LuaUtils.getObjectDirectly(o, false).animation.curAnim.curFrame = f;
		});
		
		createGlobalCallback('getCurAnim', function(o) {
			return LuaUtils.getObjectDirectly(o, false).animation.name;
		});
		
		createGlobalCallback('addToOffsets', function(o, x, y) {
			var sp = LuaUtils.getObjectDirectly(o);
			sp.offset.x += x;
			sp.offset.y += y;
		});
		
		createGlobalCallback('setObjectColor', function(o, c) {
			LuaUtils.getObjectDirectly(o, false).color = c;
		});
		
		var thisLua = parentLua;
		createGlobalCallback('doSound', function(f, ?v, ?t) {
			return thisLua.call('doSoundLocal', [f, v, t]);
		});
		
		createGlobalCallback('Random', function(r) {
			return FlxG.random.int(1, r) - 1;
		});
		
		createGlobalCallback('getCamFollow', function() {
			return [game.camFollow.x, game.camFollow.y];
		});
		
		createGlobalCallback('setCamFollow', function(?x, ?y) {
			game.camFollow.setPosition(x, y);
		});
		
		createGlobalCallback('getCamScroll', function() {
			return game.camGame.scroll.x;
		});
		
		createGlobalCallback('removeObjOnFinishAnim', function(o) {
			var obj = LuaUtils.getObjectDirectly(o, false);
			obj.animation.finishCallback = function() {
				parentLua.call('removeLuaSprite', [o]);
			}
		});
	]]);
end

totSounds = 0;
function doSoundLocal(file, volume, tag)
	totSounds = totSounds + 1;
    volume = (volume or 1);
	local t = (tag or (file .. totSounds));
	
	playSound(file, volume, t);
	setSoundPitch(t, playbackRate);
	
	return t;
end
