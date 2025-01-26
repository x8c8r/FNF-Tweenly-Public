// import gameObjects.BGObject;

var clock:FlxSprite;
var ringer = false;

function onLoad() {
    setGameOverVid('stopwatchdeath');

    var bg:FlxSprite = new FlxSprite(100, 0).loadGraphic(Paths.image("stages/clock/floor"));
    bg.scale.set(1.5, 1.5);
    bg.scrollFactor.set(0.8, 0.8);
    bg.alpha = 0.15;
    add(bg);

    clock = new FlxSprite(925, 450);
    clock.frames = Paths.getSparrowAtlas('characters/clock');
    clock.animation.addByPrefix('Up', 'Up', 24, false);
    clock.animation.addByPrefix('Down', 'Down', 24, false);
    clock.animation.addByPrefix('Left', 'Left', 24, false);
    clock.animation.addByPrefix('Right', 'Right', 24, false);
    clock.animation.addByPrefix('Ring', 'Ring', 24);
    clock.animation.play('Up');
    clock.alpha = 0.5;
    foreground.add(clock);
}

function onCreatePost() {
    dad.visible = false;
    game.modManager.setValue("stealth", 1, 1);
    game.modManager.setValue("transformX", -5000, 1);
}

function onBeatHit() {
    if (!ringer) {
        if (curBeat % 8 == 0)
            clock.animation.play('Up');
        if (curBeat % 8 == 2)
            clock.animation.play('Right');
        if (curBeat % 8 == 4)
            clock.animation.play('Down');
        if (curBeat % 8 == 6)
            clock.animation.play('Left');
    }
}

function onUpdate() {
    if (ringer) {
        if (clock.animation.name != 'Ring')
            clock.animation.play('Ring');
    }
}

function onEvent(eventName, value1, value2){
    if(eventName == 'ClockEvents'){
        switch(value1){
            case 'ringON':
				ringer = true;
            case 'ringOFF':
                ringer = false;
        }
    }
}