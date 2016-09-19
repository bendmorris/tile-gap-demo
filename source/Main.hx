package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		//FlxG.stage.quality = flash.display.StageQuality.BEST;
		//FlxG.scaleMode = new flixel.system.scaleModes.RatioScaleMode(true);
		
		addChild(new FlxGame(0, 0, MenuState));
	}
}
