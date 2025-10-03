var card:FunkinSprite;
var card_text:FunkinText;
var show_titleCard:Bool = true;

function postCreate() {
    card = new FunkinSprite(-520, 250).loadGraphic(Paths.image('title_Card/titlecard'));
    card.scale.set(1.1,1.1);
    card.cameras = [camHUD];
    add(card);

    card_text = new FunkinText(-500, 260, 0, 'rundown by RAK', 48);
    card_text.alignment = 'left';
    Reflect.setProperty(card_text, "alignment", "left");    
    card_text.font = Paths.font('metro.otf');
    card_text.cameras = [camHUD];
    add(card_text); 

    trace('rrr');
}

function showTitleCard()
{
    FlxTween.tween(card, {x: -33}, 0.6, {ease: FlxEase.elasticOut});
    FlxTween.tween(card_text, {x: card.x + 520}, 0.6, {ease: FlxEase.elasticOut});
    new FlxTimer().start(3, function(timer:FlxTimer) 
    {
        FlxTween.tween(card, {x: -500}, 0.5, {ease: FlxEase.smoothStepInOut, onComplete: function(twn:FlxTween) {card.kill();remove(card, true);card.destroy();}});
        FlxTween.tween(card_text, {x: -500}, 0.5, {ease: FlxEase.smoothStepInOut, onComplete: function(twn:FlxTween) {card_text.kill();remove(card_text, true);card_text.destroy();}}); 
    });
}

function onSongStart()
{
    showTitleCard();
}