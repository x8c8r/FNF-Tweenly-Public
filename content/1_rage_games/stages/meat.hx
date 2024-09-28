function onLoad() {
    setGameOverVid('gay_overmeatboy');

    var sky:FlxSprite = new FlxSprite(50,0).loadGraphic(Paths.image('stages/meat/sky'));
    var back:FlxSprite = new FlxSprite(0,250).loadGraphic(Paths.image('stages/meat/back'));
    var middle:FlxSprite = new FlxSprite(0, 450).loadGraphic(Paths.image('stages/meat/middle'));
    var front:FlxSprite = new FlxSprite(0, 350).loadGraphic(Paths.image('stages/meat/front'));
    var overlay:FlxSprite = new FlxSprite(0, 600).loadGraphic(Paths.image('stages/meat/overlay'));
	middle.scrollFactor.set(1.1,1.1);
	back.scrollFactor.set(1.2,1.2);
	overlay.scrollFactor.set(0.5,0.5);

    add(sky);
    add(back);
    add(middle);
    add(front);
    add(overlay);
}