var RedParticles:CustomShader;
var bloom:CustomShader;
function postCreate() {
  for (name => sprite in stage.stageSprites) {
    sprite.visible = false;
    stage.stageSprites['tree'].visible = stage.stageSprites['mountain'].visible = stage.stageSprites['water'].visible = stage.stageSprites['floor'].visible = stage.stageSprites['light3'].visible = stage.stageSprites['rocks'].visible = true;
  }
  stage.stageSprites['light4'].camera = stage.stageSprites['light3'].camera = camHUD;

  RedParticles = new CustomShader("RedParticle");
  RedParticles.intensity = 0.0; RedParticles.time = 0; RedParticles.amount = 0;
  if (FlxG.save.data.shaders)
      camHUD.addShader(RedParticles);
      
  //im not sure if this doing something
  bloom = new CustomShader("ChromaticAbberationHUD");
	bloom.u_samples = [5, 5];
	bloom.u_size = [30, 30];
	bloom.u_tint = [1, 1, 1];
	bloom.u_brightness = 0.20;
	bloom.u_range = 0.0;
	bloom.u_threshold = 0.1;
  for (cam in [camGame, camHUD])  
    if (FlxG.save.data.shaders)
        cam.addShader(bloom);

}

var redIntensity:Float = 0;
var redAmount:Float = 0;

function update(elapsed) {
    RedParticles.time = Conductor.songPosition / (Conductor.stepCrochet * 8);
    RedParticles.amount = Std.int(redAmount);
    RedParticles.intensity = redIntensity;
}

function stepHit(curStep:Int) {
    switch(curStep) {
      case 472:
        //forest
        stage.stageSprites['tree'].visible = stage.stageSprites['mountain'].visible = stage.stageSprites['water'].visible = stage.stageSprites['floor'].visible = stage.stageSprites['light3'].visible = stage.stageSprites['rocks'].visible = false;
        stage.stageSprites['floor2'].visible = true; stage.stageSprites['floor'].kill();
        stage.stageSprites['tree2'].visible = true; stage.stageSprites['tree'].kill();
        stage.stageSprites['mountain2'].visible = true; stage.stageSprites['mountain'].kill();
        stage.stageSprites['brush'].visible = true;
        stage.stageSprites['light3'].alpha = 0.2;
        stage.stageSprites['water'].kill();
      case 1438:
        //xenophaneisland
        for (name => sprite in stage.stageSprites) {sprite.visible = false;}
        stage.stageSprites['sky3'].visible = true;
        stage.stageSprites['forest1'].visible = true;
        stage.stageSprites['forest2'].visible = true;
        stage.stageSprites['forest3'].visible = true;
        stage.stageSprites['floor3'].visible = true;
        stage.stageSprites['brush'].visible = true;
        stage.stageSprites['light4'].visible = true;
        stage.stageSprites['light4'].alpha = 1;
        stage.stageSprites['brush'].color = FlxColor.RED;
        stage.stageSprites['death'].visible = true;        
      case 1445:
        redAmount = 75;
        redIntensity = 0.13;
        enableChromaBeat = true;
      case 1960:
        FlxTween.num(redAmount, 0, ((Conductor.crochet / 4) / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {redAmount = val;});
        FlxTween.num(redIntensity, 0, ((Conductor.crochet / 4) / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {redIntensity = val;});
        enableChromaBeat = false;
    }
}