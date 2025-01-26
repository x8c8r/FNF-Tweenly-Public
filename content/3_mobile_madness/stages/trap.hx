var blackout:FlxSprite;

function onLoad() {
    setGameOverVid('trapover');


    var bg:FlxSprite = new FlxSprite(-600, -550).loadGraphic(Paths.image("stages/ta/TrapAdventureBrickBg"));
    bg.scale.set(1.5, 1.5);
    add(bg);

    blackout = new FlxSprite(0, 0).makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
    blackout.screenCenter();
    blackout.alpha = 0;
	blackout.cameras = [game.camOther];
    foreground.add(blackout);
}

// sorry didgie to lazy
function onEvent(eventName, value1, value2){
    if(eventName == 'TrapEvents'){
        switch(value1){
            case 'fadeout':
				blackout.alpha = 1;
        }
    }
}