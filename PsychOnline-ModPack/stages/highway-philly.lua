function onCreate()
	makeLuaSprite('sky', 'skyD', -2240, -2200);
	scaleObject('sky', 1.9, 1.9);
	setScrollFactor('sky', 1, 1);
	setProperty('sky.antialiasing', true);
	setObjectOrder('sky', 0);

	makeLuaSprite('bgcity', 'bgcity', -813.333333333333, -1176.66666666667);
	scaleObject('bgcity', 1.9, 1.9);
	setScrollFactor('bgcity', 0.65, 0.85);
	setProperty('bgcity.antialiasing', true);
	setObjectOrder('bgcity', 1);

	makeLuaSprite('bridge', 'bridge', -69.9999999999999, -1093.33333333333);
	scaleObject('bridge', 1.9, 1.9);
	setScrollFactor('bridge', 0.75, 0.9);
	setProperty('bridge.antialiasing', true);
	setObjectOrder('bridge', 2);

	makeLuaSprite('traffic signpost', 'traffic signpost', 66, -22);
	scaleObject('traffic signpost', 1.9, 1.9);
	setScrollFactor('traffic signpost', 0.85, 0.95);
	setProperty('traffic signpost.antialiasing', true);
	setObjectOrder('traffic signpost', 3);

	makeLuaSprite('carback', 'carback', 193.333333333333, 260);
	scaleObject('carback', 1.9, 1.9);
	setScrollFactor('carback', 0.85, 0.95);
	setProperty('carback.antialiasing', true);
	setObjectOrder('carback', 4);

	makeLuaSprite('carback2', 'carback2', 576.666666666666, 283.333333333333);
	scaleObject('carback2', 1.9, 1.9);
	setScrollFactor('carback2', 0.9, 0.95);
	setProperty('carback2.antialiasing', true);
	setObjectOrder('carback2', 5);

	makeLuaSprite('traffic lights', 'traffic lights', 1336.66666666667, -210);
	scaleObject('traffic lights', 1.9, 1.9);
	setScrollFactor('traffic lights', 0.9, 1);
	setProperty('traffic lights.antialiasing', true);
	setObjectOrder('traffic lights', 6);

	makeLuaSprite('lightpost', 'lightpost', 1270, -666.666666666666);
	scaleObject('lightpost', 1.9, 1.9);
	setScrollFactor('lightpost', 0.95, 1);
	setProperty('lightpost.antialiasing', true);
	setObjectOrder('lightpost', 7);

	makeLuaSprite('stage front1', 'stage front1', -2579.16666666667, -1304.58333333333);
	scaleObject('stage front1', 1.9, 1.9);
	setScrollFactor('stage front1', 1, 1);
	setProperty('stage front1.antialiasing', true);
	setObjectOrder('stage front1', 8);

	makeLuaSprite('fog1', 'fog1', -296.666666666666, 246.666666666667);
	scaleObject('fog1', 1.9, 1.9);
	setScrollFactor('fog1', 0.8, 0.9);
	setProperty('fog1.antialiasing', true);
	setObjectOrder('fog1', 9);

	makeLuaSprite('fog2', 'fog2', 410, 330);
	scaleObject('fog2', 1.9, 1.9);
	setScrollFactor('fog2', 0.85, 0.9);
	setProperty('fog2.antialiasing', true);
	setObjectOrder('fog2', 10);

	makeLuaSprite('lightpost lightcast', 'lightpost lightcast', 853.333333333333, -823.333333333333);
	scaleObject('lightpost lightcast', 1.9, 1.9);
	setScrollFactor('lightpost lightcast', 1, 1);
	setProperty('lightpost lightcast.antialiasing', true);
	setObjectOrder('lightpost lightcast', 11);

	setScrollFactor('gfGroup', 1, 1);
	setProperty('gfGroup.antialiasing', true);
	setObjectOrder('gfGroup', 13);

	setScrollFactor('dadGroup', 1, 1);
	setProperty('dadGroup.antialiasing', true);
	setObjectOrder('dadGroup', 14);

	setScrollFactor('boyfriendGroup', 1, 1);
	setProperty('boyfriendGroup.antialiasing', true);
	setObjectOrder('boyfriendGroup', 15);


	close(true);
end