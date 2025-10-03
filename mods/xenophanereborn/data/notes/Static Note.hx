import StringTools;

function create()
    graphicCache.cache(Paths.image("game/ui/hitStatic"));

function onNoteCreation(event) {
    if (event.noteType != "Static Note") return;
    event.noteSprite = "game/notes/types/Static_notes";   
}

function onPostNoteCreation(event) {
    if (event.noteType != "Static Note") return;
    var note = event.note;
    note.frameOffset.x = 52;
    if (note.isSustainNote == true) 
    {
        note.frameOffset.x = -5;   
        note.frameOffset.y -= 25;
    }
}

function onPlayerMiss(event) {
    if (event.noteType == "Static Note") 
    {
        health -= 0.4;
        misses += 1;

        var stat = new FlxSprite();
        stat.frames = Paths.getSparrowAtlas('game/ui/hitStatic');
        stat.animation.addByPrefix('static', 'hit', 26, true);
        stat.animation.play('static');
        stat.antialiasing = true;
        stat.screenCenter();
        stat.cameras = [camHUD];
        insert(9999, stat);
        new FlxTimer().start(0.3, function(tmr:FlxTimer) {stat.destroy();});

        FlxG.sound.play(Paths.sound('hitStatic' + FlxG.random.int(1,2)));
        event.note.strumLine.deleteNote(event.note);
        event.cancel(true);
    }
}