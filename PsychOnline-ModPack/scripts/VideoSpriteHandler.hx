import psychlua.LuaUtils;

import hxcodec.flixel.FlxVideo;

var globalData:Array<Array<Dynamic>> = [];

createGlobalCallback('makeVideoSprite', function(tag:String, videoFile:String, ?x:Float, ?y:Float, ?camera:String, ?shouldLoop:Bool)
{
	var videoData:Array<Dynamic> = [];
	
	if (game.modchartSprites.exists(tag + '_video'))
	{
		debugPrint('makeVideoSprite: This tag is not available! Use a different tag.', FlxColor.RED);
		
		return;
	}
	
	if (!FileSystem.exists(Paths.video(videoFile)))
	{
		debugPrint('makeVideoSprite: The video file "' + videoFile + '" cannot be found!', FlxColor.RED);
		
		return;
	}
	
	var sprite:FlxSprite = new FlxSprite(x, y).makeGraphic(1, 1, FlxColor.TRANSPARENT);
	sprite.camera = LuaUtils.cameraFromString(camera);
	game.modchartSprites.set(tag + '_video', sprite);
	add(sprite);
	
	var video:FlxVideo = new FlxVideo();
	
	video.alpha = 0;
	
	video.onTextureSetup.add(function()
	{
		sprite.loadGraphic(video.bitmapData);
	});
	
	video.play(Paths.video(videoFile), shouldLoop);
	
	video.onEndReached.add(function()
	{
		video.dispose();
		
		if (FlxG.game.contains(video))
			FlxG.game.removeChild(video);
		
		if (globalData.indexOf(videoData) >= 0)
			globalData.remove(videoData);
		
		if (game.modchartSprites.exists(tag + '_video'))
		{
			game.modchartSprites.get(tag + '_video').destroy();
			game.modchartSprites.remove(tag + '_video');
		}
			
		game.callOnLuas('onVideoFinished', [tag]);
	});
	
	FlxG.game.addChild(video);
	
	videoData.push(video);
	videoData.push(sprite);
	
	globalData.push(videoData);
});

function onPause()
{
	for (video in globalData)
	{
		if (video[0] != null)
		{
			video[0].pause();
			
			if (FlxG.autoPause)
			{
				if (FlxG.signals.focusGained.has(video[0].resume))
					FlxG.signals.focusGained.remove(video[0].resume);

				if (FlxG.signals.focusLost.has(video[0].pause))
					FlxG.signals.focusLost.remove(video[0].pause);
			}
		}
	}
}

function onResume()
{
	for (video in globalData)
	{
		if (video[0] != null)
			video[0].resume();
			
		if (FlxG.autoPause)
		{
			if (!FlxG.signals.focusGained.has(video[0].resume))
				FlxG.signals.focusGained.add(video[0].resume);

			if (!FlxG.signals.focusLost.has(video[0].pause))
				FlxG.signals.focusLost.add(video[0].pause);
		}
	}
}

function onDestroy()
{
	for (video in globalData)
	{
		if (video[0] != null)
			video[0].stop();
	}
}

var cacheList:Array<String> = [];

function precacheVideos(list:Array<String>)
{	
	for (i in 0 ... list.length)
	{
		if (!FileSystem.exists(Paths.video(list[i])))
		{
			debugPrint('precacheVideos: The video file "' + list[i] + '" cannot be found!', FlxColor.RED);
			
			break;
		}
		
		var video:FlxVideo = new FlxVideo();
		
		video.play(Paths.video(list[i]));
		
		video.onEndReached.add(function()
		{
			video.dispose();
		});
		
		video.stop();
	}
}

precacheVideos(cacheList);