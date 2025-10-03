import StringTools;

//the idea from forever engine 0.3.1 lol
var cameraMovementStrength = 25;
var stopCameraMovement:Bool = false;
function postUpdate() {
    if (stopCameraMovement || strumLines.members[curCameraTarget].characters[0].animation.curAnim.name == null) return;
    switch(strumLines.members[curCameraTarget].characters[0].animation.curAnim.name) {
        case "singLEFT": camFollow.x -= cameraMovementStrength;
        case "singDOWN": camFollow.y += cameraMovementStrength;
        case "singUP": camFollow.y -= cameraMovementStrength; 
        case "singRIGHT": camFollow.x += cameraMovementStrength; 
    }
}