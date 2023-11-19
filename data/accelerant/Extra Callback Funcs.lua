function onCreate()
	addHaxeLibrary('LuaUtils', 'psychlua');
	runHaxeCode([[
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
	]]);
end
