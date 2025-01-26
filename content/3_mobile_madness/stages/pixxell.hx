function onLoad() {
    setGameOverVid('pixelsover');

    var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/pixxxel/pool"));
    bg.scale.set(2, 2);
    add(bg);
    
}