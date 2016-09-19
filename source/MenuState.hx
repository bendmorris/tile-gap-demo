package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxImageFrame;
import flixel.graphics.frames.FlxTileFrames;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import flixel.util.FlxColor;
import flixel.system.scaleModes.RatioScaleMode;


class MenuState extends FlxState
{
	static inline var SCROLL_SPEED = 32;
	static inline var DEFAULT_ZOOM = 1;
	static inline var TILE_SIZE = 64;
	static inline var COLS = 15;
	static inline var ROWS = 15;

	var tilemap:FlxTilemap;
	var tilemap2:FlxTilemap;
	var label:FlxText;
	var sprite:FlxSprite;

	var image:Dynamic;
	var paddedImage:Dynamic;
	var map:Int = 0;
	
	var w:Int = 640;
	var h:Int = 480;

	override public function create():Void
	{
		super.create();

		image = "assets/images/tiles.png";
		tilemap = new FlxTilemap();
		tilemap.pixelPerfectRender = tilemap.pixelPerfectPosition = false;

		paddedImage = FlxTileFrames.fromBitmapAddSpacesAndBorders(image, FlxPoint.get(TILE_SIZE, TILE_SIZE), FlxPoint.get(2, 2), FlxPoint.get(1, 1));
		tilemap2 = new FlxTilemap();
		tilemap2.visible = false;
		tilemap2.pixelPerfectRender = tilemap2.pixelPerfectPosition = false;
		
		toggleMapData();
		add(tilemap);
		add(tilemap2);
		
		sprite = new FlxSprite(TILE_SIZE*4, TILE_SIZE*4, FlxGraphic.fromFrame(
			FlxImageFrame.fromRectangle(
				"assets/images/tiles.png",
				new FlxRect(0,TILE_SIZE,TILE_SIZE,TILE_SIZE)
			).frame
		));
		add(sprite);
		
		var staticCamera = new FlxCamera();
		staticCamera.bgColor = FlxColor.TRANSPARENT;
		label = new FlxText(0, 0, 0, "WASD to scroll");
		label.scrollFactor.set(0,0);
		label.cameras = [staticCamera];
		label.x = label.y= 100;
		add(label);
		
		FlxG.cameras.add(staticCamera);
		FlxG.scaleMode = new RatioScaleMode(true);
		FlxCamera.defaultCameras = [FlxG.camera];
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.anyPressed(["UP", "W"]))
			FlxG.camera.scroll.y -= elapsed * SCROLL_SPEED;
		if (FlxG.keys.anyPressed(["DOWN", "S"]))
			FlxG.camera.scroll.y += elapsed * SCROLL_SPEED;
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
			FlxG.camera.scroll.x -= elapsed * SCROLL_SPEED;
		if (FlxG.keys.anyPressed(["RIGHT", "D"]))
			FlxG.camera.scroll.x += elapsed * SCROLL_SPEED;

		if (FlxG.keys.anyJustPressed(["M"]))
			toggleMapData();
		if (FlxG.keys.anyJustPressed(["U"]))
			tilemap2.useScaleHack = tilemap.useScaleHack = !tilemap.useScaleHack;
		if (FlxG.keys.anyJustPressed(["Z"]))
			FlxG.camera.zoom =
			(FlxG.camera.zoom == DEFAULT_ZOOM) ? (Math.random() * DEFAULT_ZOOM * 4) : DEFAULT_ZOOM;
		if (FlxG.keys.anyJustPressed(["P"]))
			tilemap2.pixelPerfectPosition =
			tilemap.pixelPerfectPosition =
			sprite.pixelPerfectPosition =
			FlxG.camera.pixelPerfectRender =
			!FlxG.camera.pixelPerfectRender;
		if (FlxG.keys.anyJustPressed(["B"]))
			tilemap2.visible = !(tilemap.visible = tilemap2.visible);
		if (FlxG.keys.anyJustPressed(["T"]))
			tilemap.antialiasing = tilemap2.antialiasing = !tilemap.antialiasing;
		if (FlxG.keys.anyJustPressed(["G", "H", "J", "K"]))
		{
			if (FlxG.keys.anyJustPressed(["G"]))
			{
				h -= 1;
			}
			if (FlxG.keys.anyJustPressed(["H"]))
			{
				h += 1;
			}
			if (FlxG.keys.anyJustPressed(["J"]))
			{
				w -= 1;
			}
			if (FlxG.keys.anyJustPressed(["K"]))
			{
				w += 1;
			}
			Lib.stage.resize(w, h);
		}

		label.text = "WASD to scroll" + 
			"\nZ to toggle zoom (" + FlxG.camera.zoom + ")" +
			"\nU to toggle useScaleHack (" + (tilemap.useScaleHack ? "ON" : "OFF") + ")" + 
			"\nP to toggle pixelPerfect (" + (FlxG.camera.pixelPerfectRender ? "ON" : "OFF") + ")" +
			"\nB to toggle tile border padding (" + (tilemap2.visible ? "ON" : "OFF") + ")" +
			"\nT to toggle antialiasing (" + (tilemap.antialiasing ? "ON" : "OFF") + ")" +
			"\nM to switch map layout" +
			"\nGHJK to change screen size";
	}

	function toggleMapData()
	{
		map = (map + 1) % 2;
		var tileData = [for (i in 0 ... COLS) for (j in 0 ... ROWS) (map == 1) ? (1 + ((i+j) % 2)) : 4];

		tilemap.loadMapFromArray(
			tileData, COLS, ROWS, image, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 1
		);

		tilemap2.loadMapFromArray(
			tileData, COLS, ROWS, paddedImage, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 1
		);
	}
}
