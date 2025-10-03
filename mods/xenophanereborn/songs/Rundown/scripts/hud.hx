import flixel.text.FlxTextBorderStyle;

function onNoteCreation(e) {
        e.noteSprite = "game/notes/NOTE_skin";
}

function onStrumCreation(e) {
        e.sprite = "game/notes/NOTE_skin";
}

function postCreate(){
    window.title = "FNF - XENOPHANES REBORN - " + SONG.meta.displayName;
    hb = new FlxSprite(261, (Options.downscroll ?  healthBarBG.y - 27: healthBarBG.y - 22));
    hb.loadGraphic(Paths.image("healthbar/healthbarSacorg"));
    hb.cameras = [camHUD];
    insert(members.indexOf(healthBar)+1, hb);

    for (txt in [scoreTxt, missesTxt, accuracyTxt]) {
        txt.setFormat(Paths.font("StatusPlz.ttf"), 16, FlxColor.RED);
        txt.borderStyle = FlxTextBorderStyle.OUTLINE;
        txt.borderSize = 2;
        txt.borderColor = 0xFF000000;
    }
    comboGroup.visible = false;
}

function update()
{
    hb.alpha = healthBar.alpha;
    hb.visible = healthBar.visible;
}

//disable rating spawn
function onPlayerHit(NoteHitEvent) {
    NoteHitEvent.showRating = false; 
}