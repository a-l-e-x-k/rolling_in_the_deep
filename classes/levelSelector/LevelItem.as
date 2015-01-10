package levelSelector 
{
    import caurina.transitions.Tweener;

    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.utils.getDefinitionByName;

    /**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class LevelItem extends MovieClipContainer
	{
		private const SPACE:int = 25;
		private const WIDTH:int = 110;
		private const HEIGHT:int = 85;
		private const OVER_RESISE:Number = 1.1; //by what number item resizes on mouse over
		private const RESIZE_TIME:Number = 0.2; //length of tween
		private var resultWidth:Number; //saved for using tweens
		private var resultHeight:Number;
		private var _index:int;
		//saved for using tweens

		public function LevelItem(i:int, j:int, opened:Boolean, index:int) 
		{
			super(new lvl_btn());

			_index = index;

			x = 130 + i * (WIDTH + SPACE);
			y = 150 + j * (HEIGHT + SPACE);

			_mc.play_mc.visible = _index == UserData.levelsCompleted + 1;

			if (opened)
			{
				if (_index != UserData.levelsCompleted + 1)
				{
					var picData:Class = getDefinitionByName("l" + _index) as Class;
					var pic:Bitmap = new Bitmap(new picData());
					pic.width = WIDTH;
					pic.height = HEIGHT;
					pic.smoothing = true;
					_mc.pic_mc.addChild(pic);
				}
			}
			else
			{
				var lock:MovieClip = new lockicon();
				lock.x = -15;
				lock.y = -18;
				_mc.addChild(lock);
			}

			addEventListener(MouseEvent.MOUSE_OVER, playOver);
			addEventListener(MouseEvent.MOUSE_OUT, playOut);

			resultWidth = width;
			resultHeight = height;
		}

		private function playOver(e:MouseEvent):void
		{
			Tweener.addTween(this, { width:resultWidth * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine" } );
			Tweener.addTween(this, { height:resultHeight * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine" } );
		}
		
		private function playOut(e:MouseEvent):void 
		{
			Tweener.addTween(this, { width:resultWidth, time:RESIZE_TIME, transition:"easeOutSine" } );
			Tweener.addTween(this, { height:resultHeight, time:RESIZE_TIME, transition:"easeOutSine" } );
		}
		
	}

}