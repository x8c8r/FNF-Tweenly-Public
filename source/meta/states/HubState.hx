package meta.states; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class HubState extends MusicBeatState
{
	var leftState:Bool = false;
	var player:Player;
	
	//var blackcover:FlxSprite;
	
	var doors:Array<String> = [
		'Play',
		'Credits'
	];
	var doorsinrange:Array<String> = [];
	
	var grpDoors:FlxTypedGroup<Door>;
	
	override function create()
	{
		super.create();
		

		var back:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hub/back'));
		var middle:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hub/middle'));
		var front:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hub/front'));
		
		var cloud1:FlxSprite = new FlxSprite(64, 52).loadGraphic(Paths.image('hub/cloud1'));
		var cloud2:FlxSprite = new FlxSprite(923, 104).loadGraphic(Paths.image('hub/cloud2'));
		
		//blackcover.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		
		player = new Player(570, 486);
		
		FlxTween.tween(cloud1, {x: 923}, 20, {ease: FlxEase.linear, type: PINGPONG});
		FlxTween.tween(cloud2, {x: 64}, 20, {ease: FlxEase.linear, type: PINGPONG});
		
		
		add(back);
		add(cloud1);
		add(cloud2);
		add(middle);
		
		grpDoors = new FlxTypedGroup<Door>();
		add(grpDoors);
		
		for (i in 0...doors.length)
		{
			var dor:Door;
			switch (doors[i])
			{
				case 'Play':
					dor = new Door(518, 464, doors[i], i);
				case 'Credits':
					dor = new Door(1020, 473, doors[i], i);
				default:
					dor = new Door(518, 513, doors[i], i);
			}
			grpDoors.add(dor);
		}
		
		add(front);
		
		//add(blackcover);
		
		new FlxTimer().start(0.1, function(tmr:FlxTimer) //sure ig
		{
			add(player);
			player.playeractive = false;
			player.velocity.x = 0;
			player.alpha = 0;
			player.playAnim('Exit', true);
			//FlxTween.tween(blackcover, {alpha: 0}, 0.4, {ease: FlxEase.linear});
			FlxTween.tween(player, {alpha: 1}, 0.5, 
			{onComplete:
				function(twn:FlxTween) 
				{
					player.playeractive = true;
				}
			});
			
		});
		
	}

	override function update(elapsed:Float)
	{
		var uppress = (FlxG.keys.pressed.UP || FlxG.keys.pressed.W);
		
		grpDoors.forEach(function(spr:Door)
		{
			if (FlxMath.isDistanceWithin(spr, player, (spr.width/2)))
			{
				if (!doorsinrange.contains(doors[spr.ID]))
					doorsinrange.push(doors[spr.ID]);
			}
			else
			{
				if (doorsinrange.contains(doors[spr.ID]))
					doorsinrange.remove(doors[spr.ID]);
			}
		});
		
		if (!leftState) 
		{
			if (uppress && doorsinrange.length > 0) 
			{
				FlxTransitionableState.skipNextTransIn = false;
				FlxTransitionableState.skipNextTransOut = false;
				leftState = true;
				player.playeractive = false;
				player.velocity.x = 0;
				player.animation.play('Enter');
				//FlxTween.tween(blackcover, {alpha: 1}, 0.6, {ease: FlxEase.linear});
				FlxTween.tween(player, {alpha: 0}, 0.5, {onComplete:
					function(twn:FlxTween) {
						switch (doorsinrange[0])
						{
							case 'Play':
								MusicBeatState.switchState(new TweenlyMainMenu());
							case 'Credits':
								MusicBeatState.switchState(new CreditsState());
							default:
								MusicBeatState.switchState(new TweenlyMainMenu());
						}
					}
				});
				
				
			}
		}
		
		super.update(elapsed);
	}
}

class Player extends FlxSprite {

	public var playeractive:Bool = true;

    public function new(?x:Float, ?y:Float) {
        super(x, y);
		
		frames = Paths.getSparrowAtlas('hub/beef');
		animation.addByPrefix('Idle', 'Idle', 24, true);
		animation.addByPrefix('walk', 'walk', 24, true);
		animation.addByPrefix('Enter', 'Enter', 24, false);
		animation.addByPrefix('Exit', 'Exit', 24, false);
		updateHitbox();
		animation.play('Idle');
		
    }

	var nexttodor:Bool = false;
	
    override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		var leftpress = (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A);
		var rightpress = (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D);

		if (playeractive) 
		{
			if (leftpress) {
				velocity.x = -500;
				animation.play('walk');
				flipX = true;
			}
			if (rightpress) {
				velocity.x = 500;
				animation.play('walk');
				flipX = false;
			}
			if ((!leftpress && !rightpress) || (leftpress && rightpress)) {
				velocity.x = 0;
				animation.play('Idle');
			}
			if (this.x < 0)
				x = 0;
			if (this.x > (1280 - this.width))
				x = (1280 - this.width);
		}
    }
}

class Door extends FlxSprite {

    public function new(?x:Float, ?y:Float, ?whereto:String, ?whichone:Int) {
        super(x, y);
		
		loadGraphic(Paths.image('hub/doors/' + whereto));
		ID = whichone;
		
    }
}