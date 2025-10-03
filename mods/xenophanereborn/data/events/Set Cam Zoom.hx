var ZoomTween:FlxTween = null;
var customZooming:Bool = false;
function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Set Cam Zoom") {
        customZooming = params[1];
        if (params[0] == false)
            defaultCamZoom = params[2];
        else {
            if (ZoomTween != null) ZoomTween.cancel();

            var flxease:String = params[4] + (params[4] == "linear" ? "" : params[5]);
            ZoomTween = FlxTween.tween(PlayState.instance, {defaultCamZoom: params[2]}, ((Conductor.crochet / 4) / 1000) * params[3], {ease: Reflect.field(FlxEase, flxease)});
        }
    }
}

function postUpdate(elapsed)
{
    var easeLerp = 1 - (elapsed * 3.125);
    if (customZooming) FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, easeLerp);
}