package  
{
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.ColorTransform;
    import flash.utils.Timer;
    import flash.utils.getDefinitionByName;

    /**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public final class Misc	
	{			
		public static const APP_WIDTH:int = 807;
		public static const APP_HEIGHT:int = 782;
		
		public static function definitionExists(definition:String):Boolean
		{
			var exists:Boolean = true;
			try
			{
				getDefinitionByName(definition) as Class;
			}
			catch (e:Error)
			{
				exists = false;
			}
			return exists;
		}
		
		public static function applyColorTransform(mc:MovieClip, color:uint):void
		{
			var colorTransform:ColorTransform = new ColorTransform();		
			colorTransform.color = color;	
			mc.transform.colorTransform = colorTransform;
		}
		
		public static function randomNumber(limit:int):int
		{
			var randomNumber:int = Math.floor(Math.random() * (limit + 1));
			return randomNumber;
		}		
		
		public static function createRectangle(width:int, height:int, xx:Number, yy:Number):Shape
		{
			var rect:Shape = new Shape(); 
			rect.graphics.beginFill(0x000000);
			rect.graphics.drawRect(0, 0, width, height);
			rect.graphics.endFill();
			rect.x = xx;
			rect.y = yy;
			return rect;
		}
		
		public static function addSimpleButtonListeners(moviebutton:MovieClip):void
		{
			moviebutton.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) { e.currentTarget.gotoAndStop(2); } );
			moviebutton.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) { e.currentTarget.gotoAndStop(1); } );
			moviebutton.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) { e.currentTarget.gotoAndStop(3); } );
		}
		
		public static function delayCallback(func:Function, delay:int):void
		{
			var timer:Timer = new Timer(delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{
				func();
				timer = null;
			});
			timer.start();
		}
	}
}