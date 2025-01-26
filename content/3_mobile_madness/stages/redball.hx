var blackout:FlxSprite;

function onLoad() {
    setGameOverVid('redball_gameover');
	game.skipCountdown = true;

    var sky:FlxSprite = new FlxSprite(50,200).loadGraphic(Paths.image('stages/redball/sky'));
    var back:FlxSprite = new FlxSprite(0,450).loadGraphic(Paths.image('stages/redball/stageback'));
    var front:FlxSprite = new FlxSprite(380, 800).loadGraphic(Paths.image('stages/redball/stagefront'));
	sky.scrollFactor.set(0.8,0.8);
	back.scrollFactor.set(0.9,0.9);

	sky.scale.set(2, 2);
	back.scale.set(2, 2);
	front.scale.set(2, 2);

    add(sky);
    add(back);
    add(front);
	
	blackout = new FlxSprite(0, 0).makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
    blackout.screenCenter();
    blackout.alpha = 1;
	blackout.cameras = [game.camOther];
    foreground.add(blackout);
}

function onEvent(eventName, value1, value2){
    if(eventName == 'PopEvents'){
        switch(value1){
            case 'fadein':
				FlxTween.tween(blackout, {alpha: 0}, value2);
        }
    }
}