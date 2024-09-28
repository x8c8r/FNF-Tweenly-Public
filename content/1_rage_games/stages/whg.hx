addHaxeLibrary('FlxStringUtil', 'flixel.util');
addHaxeLibrary('FlxEase', 'flixel.tweens');
addHaxeLibrary('FlxTween', 'flixel.tweens');

var intro:PsychVideoSprite;

function onLoad() {
    setGameOverVid('whg_gameover');
	game.skipCountdown = true;
	
	FlxG.mouse.visible = false;

    var bg = new FlxSprite(-600, 60).loadGraphic(Paths.image('stages/whg/bg'));
    add(bg);
	
	var bL = new FlxSprite(0,30).loadGraphic(Paths.image('stages/whg/hudcover'));
	add(bL);
	bL.flipY = !ClientPrefs.downScroll;
	bL.y = ClientPrefs.downScroll ? 30 : 70;
	bL.scale.set(1.5,1.2);
	bL.cameras = [game.camHUD];
	
	var logo:FlxSprite; 
	if (FlxG.random.bool(5))
	{
		logo = new FlxSprite(535,720).loadGraphic(Paths.image('stages/whg/secretlogo'));
	}
	else
	{
		logo = new FlxSprite(535,720).loadGraphic(Paths.image('stages/whg/logo'));
	}
	logo.y = ClientPrefs.downScroll ? 720 : 50;
	add(logo);
	//logo.scale.set(1.5,1.2);
	logo.cameras = [game.camHUD];
	logo.updateHitbox();
	
	scorewhg = new FlxText();
    scorewhg.alignment = FlxTextAlign.LEFT;
    scorewhg.setFormat(Paths.font("whg.ttf"), 64, 0xFFFFFFFF, FlxTextAlign.LEFT);
    scorewhg.cameras = [PlayState.instance.camHUD];
    scorewhg.antialiasing = ClientPrefs.globalAntialiasing;
    scorewhg.text = 'Score: 0';
    scorewhg.x = 25;
    scorewhg.updateHitbox();
    scorewhg.y = ClientPrefs.downScroll ? 10 : FlxG.height + 44;
    add(scorewhg);
	
	misseswhg = new FlxText(0,0,1255);
    misseswhg.alignment = FlxTextAlign.RIGHT;
    misseswhg.setFormat(Paths.font("whg.ttf"), 64, 0xFFFFFFFF, FlxTextAlign.RIGHT);
    misseswhg.cameras = [PlayState.instance.camHUD];
    misseswhg.antialiasing = ClientPrefs.globalAntialiasing;
    misseswhg.text = 'Misses: 0';
    misseswhg.updateHitbox();
	misseswhg.y = ClientPrefs.downScroll ? 10 : FlxG.height + 44;
    add(misseswhg);
	
	timewhg = new FlxText(0,0,1280);
    timewhg.alignment = FlxTextAlign.CENTER;
    timewhg.setFormat(Paths.font("whg.ttf"), 64, 0xFFFFFFFF, FlxTextAlign.CENTER);
    timewhg.cameras = [PlayState.instance.camHUD];
    timewhg.antialiasing = ClientPrefs.globalAntialiasing;
    timewhg.text = 'Coins: 0 / 123';
    timewhg.updateHitbox();
	timewhg.y = ClientPrefs.downScroll ? 10 : FlxG.height + 44;
    add(timewhg);
	
	beginblack = new FlxSprite(640,360).makeGraphic(1, 1, 0xFF000000);
    beginblack.setGraphicSize(1280,1000);
	beginblack.cameras = [PlayState.instance.camOther];
	add(beginblack);
	
	flashwhite = new FlxSprite(640,360).makeGraphic(1, 1, 0xFFFFFFFF);
    flashwhite.setGraphicSize(1280,1000);
	flashwhite.cameras = [PlayState.instance.camOther];
	flashwhite.alpha = 0;
	add(flashwhite);
}

function onCreatePost(){
	Main.fpsVar.visible = false;
	modManager.setValue('opponentSwap', -0.1);
    FlxG.resizeWindow(900, 600);
    FlxG.scaleMode.height = 854;    
    FlxG.camera.height = 854;
    game.camHUD.height = 854;
	game.iconP1.visible = false;
	game.iconP2.visible = false;
	game.healthBar.visible = false;
	game.healthBarBG.visible = false;
	game.timeBar.visible = false;
	game.timeBarBG.visible = false;
	game.timeTxt.visible = false;
	game.scoreTxt.visible = false;
	
	// ty beyond
    intro = new PsychVideoSprite();
    intro.addCallback('onFormat',()->{
        intro.cameras = [game.camOther];
        intro.setGraphicSize(FlxG.width);
        intro.screenCenter();
    });
    intro.addCallback('onEnd',()->{
        beginblack.visible = false;
		flashwhite.alpha = 1;
		FlxTween.tween(flashwhite, {alpha: 0}, 1, {ease: FlxEase.linear});
    });
    intro.load(Paths.video('whgintro'), [PsychVideoSprite.muted]);
    intro.antialiasing = true;
    add(intro);
}

function noteMiss()
{
	FlxG.sound.play(Paths.sound('whgmiss'), 0.6);
}

function onBeatHit()
{
	if (curBeat == 280)
	{
		beginblack.visible = true;
		beginblack.alpha = 0;
		FlxTween.tween(beginblack, {alpha: 1}, 2, {ease: FlxEase.linear});
	}
}

function onSongStart()
{
    intro.play();
}

function onUpdatePost(elasped)
{
    var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
	if(curTime < 0) curTime = 0;
    var songCalc:Float = (game.songLength - curTime);
    var secondsTotal:Int = Math.floor(songCalc / 1000);
	if(secondsTotal < 0) secondsTotal = 0;
    
    scorewhg.text = 'Score: ' + game.songScore;
    //accuracyROR2.text = 'Accuracy: ' + Math.ffloor(game.ratingPercent * 100) + '%';
    misseswhg.text = 'Misses: ' + game.songMisses;
	if ((Math.floor(game.songLength / 1000) - secondsTotal) <=  (Math.floor(game.songLength / 1000) -3))
		timewhg.text = ('Coins: ' + (Math.floor(game.songLength / 1000) - secondsTotal) + ' / ' +  (Math.floor(game.songLength / 1000) -3));
	else
		timewhg.text = ('Coins: ' + (Math.floor(game.songLength / 1000) -3) + ' / ' +  (Math.floor(game.songLength / 1000) -3));
}

function onDestroy(){
	if (intro != null) intro.destroy();
    FlxG.resizeWindow(1280, 720);
    FlxG.scaleMode.height = 720;  
    FlxG.camera.height = 720;  
	Main.fpsVar.visible = ClientPrefs.showFPS;
}
