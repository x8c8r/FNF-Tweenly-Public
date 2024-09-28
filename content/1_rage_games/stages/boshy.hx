// i would like to personally apologize for this song, i failed you boshy fans.... -x8
var clouds1:FlxBackdrop;
var clouds2:FlxBackdrop;
function onLoad() {
    setGameOverVid('boshy_gameover');
    var fire:FlxSprite = new FlxSprite(0, 600);
    fire.frames = Paths.getSparrowAtlas('stages/boshy/fire');
    fire.animation.addByPrefix('burn', 'fire bun', 6, true);
    fire.scale.set(2, 1); // sorry chief
    fire.scrollFactor.set(0.8, 0.8);
    fire.animation.play('burn');
    add(fire);

    var cloudG = Paths.image('stages/boshy/clouds');

    clouds1 = new FlxBackdrop(cloudG, -2, 0, true, false);
    clouds1.scale.set(0.15, 0.15);
    clouds1.scrollFactor.set(0.8, 0.8);
    clouds1.screenCenter(FlxAxes.XY);
    add(clouds1);

    clouds2 = new FlxBackdrop(cloudG, -3.5, 0, true, false);   
    clouds2.scale.set(0.15, 0.15);
    clouds2.scrollFactor.set(0.8, 0.8);
    clouds2.y += 50;
    clouds2.screenCenter(FlxAxes.XY);
    add(clouds2);

    var platform:FlxSprite = new FlxSprite(-50, 650).loadGraphic(Paths.image('stages/boshy/platform'));
    platform.antialiasing = false;
    // platform.scrollFactor.set(game.bf.scrollFactor.x, game.bf.scrollFactor.y);
    add(platform);
}

function update(elapsed:Float) {
    clouds1.x -= 2 * 60 * elapsed;
    clouds2.x -= 3.5 * 60 * elapsed;
}

var thing:Int = 1;
function onStepHit() {
    if (game.curBeat < 258) return;

    if (game.curStep % 2 == 0) thing *= -1;
    game.dad.angle = 25 * thing;
}

function onBeatHit() {
    if (game.curBeat >= 258) {
        var explode:FlxSprite = new FlxSprite(game.dad.x + FlxG.random.int(-100, 200), game.dad.y + FlxG.random.int(-100, 200));
        explode.scale.set(0.75, 0.75);
        explode.frames = Paths.getSparrowAtlas('stages/boshy/explosion');
        explode.animation.addByPrefix('e', 'e', 24);
        explode.animation.play('e', true);
        foreground.add(explode);
    }

    if (game.curBeat == 258) {
        var beginblack = new FlxSprite(640,360).makeGraphic(1, 1, 0xFF000000);
        beginblack.setGraphicSize(1280,1000);
        beginblack.cameras = [PlayState.instance.camOther];
        add(beginblack);

        beginblack.visible = true;
		beginblack.alpha = 0;
		FlxTween.tween(beginblack, {alpha: 1}, 8, {ease: FlxEase.linear});
    }
}