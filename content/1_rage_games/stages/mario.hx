function onLoad() {
	setGameOverVid('unfair_gameover');
    var bg = new FlxSprite(-600, 60).loadGraphic(Paths.image('stages/mario/bg'));
    bg.scale.set(2, 2);
    add(bg);
}