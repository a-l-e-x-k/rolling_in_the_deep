package levelSelector 
{
	import caurina.transitions.Tweener;
	import events.RequestEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class NavigationMenu extends Sprite 
	{
		private const SPACE_BETWEEN_TINY_SELECTORS:int = 10;
		private const SPACE_BETWEEN_TINY_SELECTORS_AND_ARROWS:int = 15;
		private const OVER_RESISE:Number = 1.1; //by what number item resizes on mouse over
		private const RESIZE_TIME:Number = 0.15; //length of tween

		private var currentLevelGroup:int = 1;
		private var btnwidth:Number = 0;
		private var btnheight:Number = 0;

		public function NavigationMenu() 
		{
			var leftButton:MovieClip = new leftbtn();
			leftButton.buttonMode = true;
			leftButton.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			leftButton.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			leftButton.addEventListener(MouseEvent.CLICK, gotoPrevGroup);
			addChild(leftButton);					
			
			for (var i:int = 1; i < LevelSelector.GROUPS_COUNT + 1; i++) 
			{
				var tinySelector:TinySelector = new TinySelector(i);
				tinySelector.addEventListener(MouseEvent.CLICK, selectGroup);
				tinySelector.x = leftButton.x + SPACE_BETWEEN_TINY_SELECTORS_AND_ARROWS + (tinySelector.width + SPACE_BETWEEN_TINY_SELECTORS) * i;
				tinySelector.y = leftButton.y - tinySelector.height / 2;
				tinySelector.name = "group_" + i;
				tinySelector.buttonMode = true;
				addChild(tinySelector);
				
				if (i > 1) tinySelector.goPassive(); //active by default
			}

			var rightButton:MovieClip = new rightbtn();
			rightButton.x = 214;
			rightButton.buttonMode = true;
			rightButton.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			rightButton.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			rightButton.addEventListener(MouseEvent.CLICK, gotoNextGroup);
			addChild(rightButton);

			btnwidth = rightButton.width;
			btnheight = rightButton.height;
		}
		
		private function onArrowOver(e:MouseEvent):void 
		{
			Tweener.addTween(e.currentTarget as MovieClip, { width:btnwidth * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine" } );
			Tweener.addTween(e.currentTarget as MovieClip, { height:btnheight * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine" } );
		}
		
		private function onArrowOut(e:MouseEvent):void 
		{
			Tweener.addTween(e.currentTarget as MovieClip, { width:btnwidth, time:RESIZE_TIME, transition:"easeOutSine" } );
			Tweener.addTween(e.currentTarget as MovieClip, { height:btnheight, time:RESIZE_TIME, transition:"easeOutSine" } );
		}
		
		private function gotoPrevGroup(e:MouseEvent):void 
		{
			if (currentLevelGroup > 1)
			{
				currentLevelGroup--;
				dispatchGotoGroup();
				updateTinySelectors();
			}
		}
		
		private function gotoNextGroup(e:MouseEvent):void 
		{
			if (currentLevelGroup < LevelSelector.GROUPS_COUNT)
			{
				currentLevelGroup++;
				dispatchGotoGroup();
				updateTinySelectors();
			}
		}

		public function setGroup(groupID:int):void
		{
			currentLevelGroup = groupID;
			updateTinySelectors();
			dispatchGotoGroup();
		}

		private function selectGroup(e:MouseEvent):void
		{
			setGroup(int(e.currentTarget.name.charAt(e.currentTarget.name.length - 1)));
		}

		private function updateTinySelectors():void
		{
			for (var i:int = 1; i < LevelSelector.GROUPS_COUNT + 1; i++) 
			{
				var tinySelector:TinySelector = getChildByName("group_" + i) as TinySelector;
				if (tinySelector.id != currentLevelGroup) tinySelector.goPassive();
				else tinySelector.goActive();
			}
		}
		
		private function dispatchGotoGroup():void 
		{			
			dispatchEvent(new RequestEvent(RequestEvent.GOTO_LEVEL_GROUP, { groupID:currentLevelGroup } ));
		}
		
	}

}