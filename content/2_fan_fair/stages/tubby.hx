var custard:FlxSprite;
var blackoverlay:FlxSprite;
var blackout:FlxSprite;

function onCreatePost() {
    game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(game.dad.x+500, game.dad.y+200);
	camHUD.alpha = 0;
}

function onLoad() {

game.skipCountdown = true;
    setGameOverVid('tubby_gameover');

    var sky = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/tubby/sky"));
    sky.scale.set(1.5, 1.5);
    add(sky);

    var forestFront = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/tubby/forestfront"));
    forestFront.scale.set(1.5, 1.5);
    add(forestFront);

    custard = new FlxSprite(625, 630).loadGraphic(Paths.image("stages/tubby/custard"));
    custard.scale.set(0.75, 0.75);
    foreground.add(custard);
	
	 blackoverlay = new FlxSprite(0, 0).makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
    blackoverlay.screenCenter();
    blackoverlay.alpha = 1;
    foreground.add(blackoverlay);
	

    blackout = new FlxSprite(0, 0).makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
    blackout.screenCenter();
    blackout.alpha = 0;
    foreground.add(blackout);
	
}

function onEvent(eventName, value1, value2){
    if(eventName == 'OcrEvents'){
        switch(value1){
            case 'pull up':
				FlxTween.tween(blackoverlay, {alpha: 0.5}, 5);
                game.triggerEventNote('Play Animation', 'intro', 'bf');
                FlxTween.tween(game.boyfriend, {x: 560}, 4, {onComplete: (twn:FlxTween) -> {}});
            case 'tweencustard':
                FlxTween.tween(custard, {x: game.dad.x, y: game.dad.y+250}, 1, {onComplete: (twn:FlxTween) -> {
                    blackout.alpha = 1;
                    FlxG.camera.flash(FlxColor.WHITE, 1);
                    custard.alpha = 0;
                }});
            case 'tanking':
                game.triggerEventNote('Change Character', 'dad', 'tinkytank');
                blackout.alpha = 0;
                FlxG.camera.flash(FlxColor.WHITE, 1);
            case 'yay':
                var all:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image("stages/tubby/allcustardsfound"));
                all.cameras = [game.camOther];
                all.screenCenter();
                all.alpha = 0;
                foreground.add(all);

				FlxTween.tween(blackoverlay, {alpha: 1}, 2.5);
                FlxTween.tween(all, {alpha: 1}, 2.5);

                // game.isCameraOnForcedPos = true;
                // game.snapCamFollowToPos(game.boyfriend.x+90, game.boyfriend.y+200);

                game.boyfriend.flipX = true;
                game.boyfriend.x += 200;
                game.triggerEventNote('Play Animation', 'intro', 'bf');
                FlxTween.tween(game.boyfriend, {x: 1750}, 1);
			case 'tweenzoomintro':
				game.isCameraOnForcedPos = false;
                FlxTween.tween(FlxG.camera, {zoom : 1.2}, value2, {ease: FlxEase.quadInOut});
				
			case 'tweenzoomtrans':
                FlxTween.tween(FlxG.camera, {zoom : 1.4}, value2, {ease: FlxEase.quadInOut});
        }
    }
}