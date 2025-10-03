var lyrics:Array<FunkinText> = [];
var Lyricindex = -1;
function createLyricsText(daW, mode, yO) {
    if (mode == 'double') {
        if (lyrics.length > 1) {
            removeLyrics();
        }

        if (lyrics.length > 0) {
            FlxTween.tween(lyrics[Lyricindex], {alpha: 0.5}, 0.2, {ease: FlxEase.cubeInOut});
            FlxTween.tween(lyrics[Lyricindex], {y: lyrics[Lyricindex].y - 45}, 0.2, {ease: FlxEase.cubeInOut});
        }
    }

    if (mode == '' || mode == 'normal' || mode == 'Text')
    {
        removeLyrics();
    }
  
    var text:FlxText = new FunkinText(0, 0, 0, daW, 40);
    text.alignment = 'CENTER';
    text.cameras = [camHUD2];
    text.screenCenter(); text.y += yO;

    Reflect.setProperty(text, "alignment", "center");
    text.font = Paths.font('vcr.ttf');
    Lyricindex += 1;
    add(text); lyrics.push(text);

    if (mode == 'fade')
    {
        text.alpha = 1;
        FlxTween.tween(text, {alpha: 0}, 1, {ease: FlxEase.cubeInOut});
        FlxTween.tween(text, {y: text.y - 100}, 0.7, {ease: FlxEase.cubeInOut});
    }
}

function removeLyrics()
{
    for (i in 0...lyrics.length) {lyrics[i].destroy();}
    lyrics = [];
    Lyricindex = -1;
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Lyrics") {
        var text = params[0];
        var mode = params[1];
        var y = params[2];
        if (mode != 'remove') 
            createLyricsText(text, mode, y);
        else
            removeLyrics();
    }
}