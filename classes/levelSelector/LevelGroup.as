package levelSelector 
{
    import events.RequestEvent;

    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class LevelGroup extends Sprite 
	{
		
		public function LevelGroup(id:int) 
		{
			var currentIndex:int = (id - 1) * 20 + 1;			
			for (var j:int = 0; j < 4; j++) 
			{
				for (var i:int = 0; i < 5; i++) 
				{
					var levelItem:LevelItem = new LevelItem(i, j, currentIndex <= UserData.levelsCompleted + 1, currentIndex);
					levelItem.name = currentIndex.toString();
					levelItem.buttonMode = true;
					if (currentIndex <= UserData.levelsCompleted + 1)
						levelItem.addEventListener(MouseEvent.CLICK, dispatchGotoLevel);
					addChild(levelItem);
					currentIndex++;
				}
			}	
			
			x = Misc.APP_WIDTH * (id - 1);
		}
		
		private function dispatchGotoLevel(e:MouseEvent):void 
		{
			dispatchEvent(new RequestEvent(RequestEvent.GOTO_GAME, { lvl:int(e.currentTarget.name) }, true));
		}
		
	}

}