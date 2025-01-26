// this is the most barebones thing i ever coded there are only like 2 lines without a purpose -x8

package meta.states;

import haxe.Json;
import meta.data.Song;
import meta.data.WeekData;
import gameObjects.BGSprite;
import flixel.input.keyboard.FlxKey;
import meta.states.editors.MasterEditorMenu;
import flixel.addons.transition.FlxTransitionableState;


class TweenlyMainMenu extends MusicBeatState {
    var debugKeys:Array<FlxKey> = [];

    var buttons:Array<FlxSprite> = [];

    var tweenImg:FlxSprite;
    var leftTween:FlxSprite;
    var rightTween:FlxSprite;
    var tweenInfo:FlxText;

    var curTween:Int;

    var tweenmaster:FlxSprite;
    var doTween:Bool = true;

    var loadedTweens:Array<WeekData> = [];

    override function create() {
        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();

        Conductor.changeBPM(Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json')).bpm); // I HATE FRIDAY NIGHT FUNKIN' AND I HATE MY FUCKING SON! UNGRATEFUL BOY! UNGRATEFUL BOY! ROTTEN BOY! ROTTEN BOY! I HATE MY SON! I. HATE. MY. SON!
        persistentUpdate = persistentDraw = true;
		
		DiscordClient.changePresence("Choosing the tweenings", null);
        FlxG.mouse.visible = true;
        debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));		

        PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		// if(curTween >= WeekData.weeksList.length) curTween = 1;

        for (twee in 0...WeekData.weeksList.length) {
            //why the fuck do i have to do this shit
            var weekFile:WeekFile = WeekData.getWeekFile(Paths.mods(Paths.getModDirectories()[twee]+"/weeks/"+WeekData.weeksList[twee]+".json"));

            var weekData:WeekData = new WeekData(weekFile, WeekData.weeksList[twee]);
            weekData.folder = Paths.getModDirectories()[twee];
            loadedTweens.push(weekData); 
        }
        WeekData.setDirectoryFromWeek(loadedTweens[0]);


        var lay:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/menu_layout'));
        lay.antialiasing = ClientPrefs.globalAntialiasing;
        add(lay);
        
        var twnBut:FlxSprite = new FlxSprite(25, 15).loadGraphic(Paths.image('mainmenu/menu_tween'), true, 300, 100);
        twnBut.animation.add("pressed", [2]);
        twnBut.animation.play("pressed");
        add(twnBut);

        var freeplayBut:FlxSprite = new FlxSprite(375, 15).loadGraphic(Paths.image('mainmenu/menu_freeplay'), true, 300, 100);
        freeplayBut.animation.add("idle", [0]);
        freeplayBut.animation.add("hovered", [1]);
        freeplayBut.animation.play("idle");
        add(freeplayBut);
        buttons.insert(0, freeplayBut);

        var optionsBut:FlxSprite = new FlxSprite(725, 15).loadGraphic(Paths.image('mainmenu/menu_options'), true, 300, 100);
        optionsBut.animation.add("idle", [0]);
        optionsBut.animation.add("hovered", [1]);
        optionsBut.animation.play("idle");
        add(optionsBut);
        buttons.insert(1, optionsBut);

        var door:FlxSprite = new FlxSprite(1125, 15).loadGraphic(Paths.image('mainmenu/menu_door'));
        add(door);
        buttons.insert(2, door);

        tweenInfo = new FlxText(950, 150);
        tweenInfo.text = genTweenInfo();
        tweenInfo.setFormat(Paths.font("vcr.ttf"), 20);
        tweenInfo.alignment = LEFT;
        add(tweenInfo);

        var playBut:FlxSprite = new FlxSprite(950, 600).loadGraphic(Paths.image('mainmenu/menu_play'), true, 300, 100);
        playBut.animation.add("idle", [0]);
        playBut.animation.add("hovered", [1]);
        playBut.animation.play("idle");
        add(playBut);
        buttons.insert(3, playBut);
        FlxTween.tween(playBut, {x: 25}, 3, {type: PINGPONG});

        tweenImg = new FlxSprite(225, 200);
        add(tweenImg);

        tweenmaster = new FlxSprite(958, 367);  // hes a bloody mess rn dont mind him -x8 (I put his organs and bones back together! -PoeDev)
        tweenmaster.frames = Paths.getSparrowAtlas('mainmenu/tweenmaster');
        tweenmaster.animation.addByPrefix('Tween_Idle', 'Tween_Idle', 24, false);
        tweenmaster.animation.addByPrefix('Tween_YouPEAK', 'Tween_YouPEAK', 24, false);
        tweenmaster.animation.addByPrefix('Tween_YouGOOD', 'Tween_YouGOOD', 24, false);
        tweenmaster.animation.addByPrefix('Tween_YouSUCK', 'Tween_YouSUCK', 24, false);
        tweenmaster.animation.addByPrefix('Tween_youFUCK', 'Tween_youFUCK', 24, false);
		tweenmaster.updateHitbox();
        add(tweenmaster);

        leftTween = new FlxSprite(70, 312).loadGraphic(Paths.image('mainmenu/menu_arrowleft'));
        rightTween = new FlxSprite(780, 312).loadGraphic(Paths.image('mainmenu/menu_arrowright'));
        add(leftTween);
        add(rightTween);
        buttons.insert(4, leftTween);
        buttons.insert(5, rightTween);

        changeTween(0);
    }

    function imactuallygonnafuckingcrashoutwhythefuckdoihavetodothis() {
        if (tweenmaster != null && doTween)
            tweenmaster.animation.play('Tween_Idle');
    }

    function mbs() {
        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        var oldStep:Int = curStep;
        updateCurStep();
		updateBeat();
        if (oldStep != curStep) {
            if(curStep % 8 == 0)
                imactuallygonnafuckingcrashoutwhythefuckdoihavetodothis();
        }
    }

    override function update(elapsed:Float) {
        mbs();

        for (button in buttons) {
            if (!FlxG.mouse.overlaps(button)) {
                if (button.animation.name != "idle")
                    button.animation.play("idle");
                continue;
            }

            button.animation.play("hovered");
            if (controls.BACK) {
                FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = false;
                MusicBeatState.switchState(new HubState());
            }
            if (FlxG.mouse.justPressed) {
                switch (buttons.indexOf(button)) {
                    case 0:
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        MusicBeatState.switchState(new FreeplayState());
                    case 1:
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        LoadingState.loadAndSwitchState(new meta.data.options.OptionsState());
                    case 2:
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = false;
                        MusicBeatState.switchState(new HubState());
                    case 3:
                        playTween();
                    case 4:
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        changeTween(-1);
                    case 5:
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                        changeTween(1);
                }
            }
        }

        #if desktop
        if (FlxG.keys.anyJustPressed(debugKeys))
        {
            MusicBeatState.switchState(new MasterEditorMenu());
        }
        #end

        if (controls.BACK) {
            FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = false;
            MusicBeatState.switchState(new HubState());
        }
    }

    override function destroy() {
        FlxG.mouse.visible = false;
        super.destroy();
    }
    
    function changeTween(del:Int) {
        curTween += del;

        if (curTween > loadedTweens.length - 1)
			curTween = 0;
		if (curTween < 0)
			curTween = loadedTweens.length - 1;
        
        var twene = loadedTweens[curTween];
        WeekData.setDirectoryFromWeek(twene);

        tweenImg.visible = true;
        var tweenb = twene.weekBanner;
        if (tweenb == "null" || tweenb.length < 1)
            tweenImg.visible = false;
        else tweenImg.loadGraphic(Paths.image('mainmenu/'+tweenb));

        tweenInfo.text = genTweenInfo();

        PlayState.storyWeek = curTween;
    }

    function genTweenInfo():String {
        var twene = loadedTweens[curTween];
        var res = "";
        res += "(Tween " + Std.int(curTween+1) + ")\n";
        res += twene.storyName + ":\n";
        for (song in twene.songs) {
            res += song[0] + "\n";
        }
        return res;
    }

    function playTween() {
        doTween = false;
        var songArray:Array<String> = [];
        var leTween:Array<Dynamic> = loadedTweens[curTween].songs;
        for (i in 0...leTween.length) {
            songArray.push(leTween[i][0]);
        }
		
		CoolUtil.difficulties = ["Normal"];
		PlayState.storyDifficulty = 0;

        PlayState.storyPlaylist = songArray;
        PlayState.isStoryMode = true;
        PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
        PlayState.campaignScore = 0;
        PlayState.campaignMisses = 0;
        tweenmaster.animation.play("Tween_YouGOOD", true);
        FlxG.sound.play(Paths.sound("confirmMenu"));
        new FlxTimer().start(2, tmr -> {
            LoadingState.loadAndSwitchState(new PlayState(), true);
            FreeplayState.destroyFreeplayVocals();  
        });

    }
}