package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import openfl.Assets;
import flash.Lib;
import openfl.display.FPS;
import openfl.display.Tilesheet;

class Main extends Sprite
{
	
	private var bitmapData:BitmapData;
	private var sprite:Sprite;
	private var previousTimestamp:Float;
	
	public function new ()
	{
		
		super ();
		
		bitmapData = Assets.getBitmapData ("assets/openfl.png");
		
		sprite = new Sprite();
		addChild(sprite);
		onResize(null);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, onResize);
		
		previousTimestamp = Lib.getTimer();
		
		addChild(new FPS());
	}
	
	private function onEnterFrame(event:Event):Void
	{
		// Get delta time
		var now:Float = Lib.getTimer();
		var delta:Float = (now - previousTimestamp) / 1000.0;
		previousTimestamp = now;
		
		// Move our sprite with delta
		sprite.x += delta * 200.0;
		while (sprite.x > 0.0)
			sprite.x -= bitmapData.width;
			
	}
	
	
	private function onResize(event:Event):Void
	{
		// Create tilesheet
		var tilesheet:Tilesheet = new Tilesheet(bitmapData);
		// Get index of our tile
		var tileIndex:Int = tilesheet.addTileRect(new Rectangle(0, 0, bitmapData.width, bitmapData.height));
		// Get size of tile grid
		var tilesHCount:Int = Math.ceil(stage.stageWidth / bitmapData.width) + 1;
		var tilesVCount:Int = Math.ceil(stage.stageHeight / bitmapData.height) + 1;
		// Fill tilesheet data
		var data:Array<Float> = [];
		for (i in 0...tilesVCount)
		{
			for (j in 0...tilesHCount)
			{
				data.push(j * bitmapData.width);
				data.push(i * bitmapData.height);
				data.push(tileIndex);
			}
		}
		sprite.graphics.clear();
		// Finally, draw our tiles
		tilesheet.drawTiles(sprite.graphics, data, true);
	}
}