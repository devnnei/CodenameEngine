function new()
{
	//Effects
	if (FlxG.save.data.shaders == null) FlxG.save.data.shaders = true;
}

function update(elapsed:Float)
	if (FlxG.keys.justPressed.F5) FlxG.resetState();