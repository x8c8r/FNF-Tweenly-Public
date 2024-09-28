package meta.states.substate;

class VideoGameOverSubstate extends MusicBeatSubstate {
    public var video:FlxVideo;

    override function create() {
        PlayState.instance.callOnScripts('onGameOverStart', []);
        
        try {
            video = new FlxVideo();
            video.onEndReached.add(end,true);
            video.load(Paths.video(PlayState.gameOverVid));
            video.play();
        }
        catch(e) {
            trace(e);
            end;
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.ACCEPT)
            end();

        if (controls.BACK) {
            PlayState.gameOverVid = '';
            if(PlayState.isStoryMode) Init.SwitchToPrimaryMenu(TweenlyMainMenu);
			else Init.SwitchToPrimaryMenu(FreeplayState);

            PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
		}

    }

    function end() {
        if (video != null) video.stop();
        PlayState.gameOverVid = '';
        MusicBeatState.resetState();
        PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
    }
}