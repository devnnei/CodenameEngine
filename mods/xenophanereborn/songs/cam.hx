public var camCharacters:FlxCamera;
public var camHUD2:FlxCamera = null;
public var camExtra:FlxCamera = null;

function create()
{
    for (cam in [camGame, camHUD]) FlxG.cameras.remove(cam, false);

    camCharacters = new FlxCamera(0, 0);
    for (cam in [camGame, camCharacters, camHUD]) {cam.bgColor = 0x00000000; FlxG.cameras.add(cam, cam == camGame);}
}
 
function postCreate()
{
    camHUD2 = new FlxCamera();
    camHUD2.bgColor = FlxColor.TRANSPERENT;
    FlxG.cameras.add(camHUD2, false);

    camExtra = new FlxCamera();
    camExtra.bgColor = FlxColor.TRANSPERENT;
    FlxG.cameras.add(camExtra, false);
}

function update(elapsed:Float) 
{
    camHUD2.x = camHUD.x;
    camHUD2.y = camHUD.y;
    camHUD2.zoom = camHUD.zoom;
    camHUD2.alpha = camHUD.alpha;
    camHUD2.visible = camHUD.visible;

    for (cam in [camCharacters]) {
        cam.scroll = FlxG.camera.scroll;
        cam.zoom = FlxG.camera.zoom;
    }
}