var pixel:CustomShader;

//chroma beat
var chromaBeat:CustomShader;
public var enableChromaBeat:Bool = false;
var chromaVal = 0;

var cinematicBarTween1:FlxTween = null;
var cinematicBarTween2:FlxTween = null;

var cinematicBar1:FlxSprite = null;
var cinematicBar2:FlxSprite = null;

var normalStrumPoses:Array<Array<Array<Int>>> = [];

function postCreate()
{
    for (i in 0...2) {
        var cinematicBar:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.fromRGB(0, 0, 0));
        cinematicBar.scrollFactor.set(0, 0);
        cinematicBar.cameras = [camHUD];
        insert(0, cinematicBar);

        cinematicBar.scale.set(FlxG.width, 0);
        cinematicBar.updateHitbox();

        if (i == 1) cinematicBar2 = cinematicBar;
        else cinematicBar1 = cinematicBar;
    }
    cinematicBar2.y = FlxG.height - cinematicBar2.height;

    pixel = new CustomShader("pixel");
	pixel.pxSize = 0.01;
    for (cam in [camGame, camHUD])  
        if (FlxG.save.data.shaders)
            cam.addShader(pixel);

    chromaBeat = new CustomShader("ChromaticAbberationHUD");
	chromaBeat.amount = 0.0;
    for (cam in [camGame, camHUD])  
        if (FlxG.save.data.shaders)
            cam.addShader(chromaBeat);

    defaultCamZoom = 0.6;
    FlxG.camera.zoom = 0.6;

    for (i=>strum in strumLines.members) {
        normalStrumPoses[i] = [for (s in strum.members) [s.x, s.y]];
    }
}

function pixelate(val, time) {
    FlxTween.num(pixel.pxSize, val, ((Conductor.crochet / 4) / 1000) * time, {ease: FlxEase.quadOut}, (val:Float) -> {pixel.pxSize = val;});
}

var speed = 0.04;
var chromaStrength = 0.5;
var shake = false;
function update(elapsed) {
    chromaVal = FlxMath.lerp(chromaVal, 0, (elapsed / (1 / 120)) * speed);
    chromaBeat.amount = chromaVal;

    for (s => strum in cpuStrums.members) {
        if (shake) {
            strum.angle = FlxG.random.int(-2,2);
            iconP2.angle = FlxG.random.int(-4,4);
        }
    }
}

function beatHit(beat) {
    if (enableChromaBeat && camZooming && FlxG.camera.zoom < maxCamZoom && beat % camZoomingInterval == 0)
        chromaVal = chromaStrength;
}

function resetArrows() {
    for (i => strumLine in strumLines.members) {
        for (k=>s in strumLine.members) {
            s.x = normalStrumPoses[i][k][0];
        }
    }
}

function stepHit(curStep:Int) {
    switch(curStep) {
      case 304:
      for (strum in playerStrums.members) FlxTween.tween(strum, {x: strum.x - 300}, 0.35, {ease: FlxEase.linear});
      for (strum in cpuStrums.members) FlxTween.tween(strum, {x: strum.x - 600}, 0.35, {ease: FlxEase.linear});
      case 405:
      FlxTween.tween(camGame, {alpha: 0}, 1.5, {ease: FlxEase.linear});
      FlxTween.tween(camGame, {angle: 25, zoom: 3}, 2.5, {ease: FlxEase.circIn});
      case 413:
      FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.linear});
      FlxTween.tween(camHUD, {angle: 25, zoom: 2.5}, 2.5, {ease: FlxEase.circIn});
      case 472:
      resetArrows();

      shake = true;
      camHUD.alpha = 1;
      camHUD.angle = 0;
      camGame.zoom = 2.5;
      FlxTween.tween(camGame, {alpha: 1}, 0.8, {ease: FlxEase.linear});
      FlxTween.tween(camGame, {angle: 0, zoom: 0.6}, 0.8, {ease: FlxEase.circOut});
      case 1247:
      FlxTween.tween(camGame, {alpha: 0}, ((Conductor.crochet / 4) / 1000) * 4, {ease: FlxEase.linear});      
      FlxTween.tween(camHUD, {alpha: 0}, ((Conductor.crochet / 4) / 1000) * 4, {ease: FlxEase.linear});
      case 1283:
      camGame.alpha = camHUD.alpha = 1;
      camHUD.flash(FlxColor.WHITE, 1);

      cinematicCut(0.6, 2);

      for (hud in [scoreTxt, missesTxt, accuracyTxt, healthBar, healthBarBG, iconP1, iconP2]) hud.alpha = 0;

      for (strum in playerStrums.members) strum.alpha = 0;
      for (strum in cpuStrums.members) strum.alpha = 0;
      for (strumLine in strumLines) 
        for (note in strumLine.notes) 
             note.alpha = 0;
      case 1429:
        camHUD.alpha = camGame.alpha = 0;         
      case 1445:
      FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.linear});
      FlxTween.tween(camGame, {alpha: 1}, 1, {ease: FlxEase.linear});

      cinematicCut(0, 2);

      for (hud in [scoreTxt, missesTxt, accuracyTxt, healthBar, healthBarBG, iconP1, iconP2]) hud.alpha = 1;

      for (strum in playerStrums.members) strum.alpha = 1;
      for (strum in cpuStrums.members) strum.alpha = 1;
      for (strumLine in strumLines) 
        for (note in strumLine.notes) 
             note.alpha = 1;        
      case 1790:
      cinematicCut(0.6, 2);

      for (hud in [scoreTxt, missesTxt, accuracyTxt, healthBar, healthBarBG, iconP1, iconP2]) FlxTween.tween(hud, {alpha: 0}, 0.3, {ease: FlxEase.linear});

      for (strum in playerStrums.members) FlxTween.tween(strum, {alpha: 0}, 0.3, {ease: FlxEase.linear});
      for (strum in cpuStrums.members) FlxTween.tween(strum, {alpha: 0}, 0.3, {ease: FlxEase.linear});
      for (strumLine in strumLines) 
        for (note in strumLine.notes) 
             FlxTween.tween(note, {alpha: 0}, 0.3, {ease: FlxEase.linear});
      case 1844:
      FlxTween.tween(camGame, {alpha: 1}, 0.3, {ease: FlxEase.linear});
      FlxTween.tween(camHUD, {alpha: 1}, 0.3, {ease: FlxEase.linear});

      cinematicCut(0, 2);

      for (hud in [scoreTxt, missesTxt, accuracyTxt, healthBar, healthBarBG, iconP1, iconP2]) FlxTween.tween(hud, {alpha: 1}, 0.3, {ease: FlxEase.linear});

      for (strum in playerStrums.members) FlxTween.tween(strum, {alpha: 1}, 0.3, {ease: FlxEase.linear});
      for (strum in cpuStrums.members) FlxTween.tween(strum, {alpha: 1}, 0.3, {ease: FlxEase.linear});
      for (strumLine in strumLines) 
        for (note in strumLine.notes) 
            FlxTween.tween(note, {alpha: 1}, 0.3, {ease: FlxEase.linear});
      case 1903:
        cinematicCut(0.6, 2);      
      case 1904 | 1911 | 1918 | 1925 | 1932 | 1939 | 1946 | 1948 | 1950 | 1952 | 1954 | 1956 | 1958 | 1960:
        camGame.flash(FlxColor.RED, 0.5); 
      case 1988:
        FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.linear});
        FlxTween.tween(camGame, {alpha: 0}, 1, {ease: FlxEase.linear});
    }
}

function cinematicCut(newV:Float, time:Float) {
    if (newV != 1) {
        for (twn in [cinematicBarTween1, cinematicBarTween2])
            if (twn != null) twn.cancel();
    
        for (bar in [cinematicBar1, cinematicBar2]) {
            var tween:FlxTween = FlxTween.tween(bar.scale, {y: (FlxG.height/2) * newV}, ((Conductor.crochet / 4) / 1000) * time, {ease: FlxEase.linear});
            if (bar == cinematicBar1) cinematicBarTween1 = tween;
            else cinematicBarTween2 = tween;
        }
    } else {
        for (twn in [cinematicBarTween1, cinematicBarTween2])
            if (twn != null) twn.cancel();
    
        for (bar in [cinematicBar1, cinematicBar2]) {
            var tween:FlxTween = FlxTween.tween(bar.scale, {y: FlxG.height}, ((Conductor.crochet / 4) / 1000) * time, {ease: FlxEase.linear});
            if (bar == cinematicBar1) cinematicBarTween1 = tween;
            else cinematicBarTween2 = tween;
        }
    }
}

function jumpscare()
{
    var jump = new FlxSprite(0, 0).loadGraphic(Paths.image('jumpscare'));
    jump.screenCenter();
    jump.cameras = [camExtra];
    add(jump);

    FlxG.sound.play(Paths.sound('piano'));

    health = 0.5;

    new FlxTimer().start(0.3, function(timer:FlxTimer)
    {
        FlxTween.tween(jump, {alpha: 0}, 0.05, {
            onComplete: function(twn:FlxTween) {
                jump.kill();
                remove(jump, true);
                jump.destroy();
            }
        });
    });
}