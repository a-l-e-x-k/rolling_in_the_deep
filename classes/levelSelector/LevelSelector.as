package levelSelector
{
import caurina.transitions.Tweener;

import events.RequestEvent;

import flash.display.Sprite;

/**
 * ...
 * @author Alexey Kuznetsov
 */
public class LevelSelector extends Sprite
{
	public static const GROUPS_COUNT:int = 5;
	private var groupsContainer:Sprite = new Sprite();
	private var groups:Array = [];
	private var progressShower:ProgressShower;

	public function LevelSelector()
	{
		progressShower = new ProgressShower();
		addChild(progressShower);

		groupsContainer.mask = Misc.createRectangle(Misc.APP_WIDTH - 30, Misc.APP_HEIGHT, 15, 0);
		addChild(groupsContainer);

		for (var i:int = 1; i < GROUPS_COUNT + 1; i++)
		{
			var levelGroup:LevelGroup = new LevelGroup(i);
			levelGroup.cacheAsBitmap = true;
			groupsContainer.addChild(levelGroup);
			groups[i] = levelGroup;
		}

		var navigationMenu:NavigationMenu = new NavigationMenu();
		navigationMenu.x = 300;
		navigationMenu.y = 570;
		navigationMenu.addEventListener(RequestEvent.GOTO_LEVEL_GROUP, showLevelGroup);
		addChild(navigationMenu);

		var currentGroupID:int = Math.ceil(UserData.currentLevel / 20);
		if (UserData.currentLevel > 100)
			currentGroupID = GROUPS_COUNT;
		showLevelGroup(new RequestEvent(RequestEvent.GOTO_LEVEL_GROUP, { groupID:currentGroupID, insta:true }))
		navigationMenu.setGroup(currentGroupID);
	}

	private function showLevelGroup(e:RequestEvent):void
	{
		var insta:Boolean = e.stuff.insta != null;
		var targetX:Number = -Misc.APP_WIDTH * (e.stuff.groupID - 1);
		if (targetX < groupsContainer.x) //do alpha tween for all groups at the left side when going to the right
		{
			for (var i:int = 1; i < e.stuff.groupID; i++)
			{
				groups[i].alpha = 1;
				Tweener.addTween(groups[i], { alpha:0, time:insta ? 0 : 0.3, transition:"easeOutSine" });
			}
		}
		else if (targetX > groupsContainer.x) //do alpha tween for all groups at the right side when going to the left
		{
			for (i = GROUPS_COUNT; i > e.stuff.groupID; i--)
			{
				groups[i].alpha = 1;
				Tweener.addTween(groups[i], { alpha:0, time:insta ? 0 : 0.3, transition:"easeOutSine" });
			}
		}

		Tweener.addTween(groups[e.stuff.groupID], { alpha:1, time:insta ? 0 : 0.3, transition:"easeOutSine" });
		Tweener.addTween(groupsContainer, { x:targetX, time:insta ? 0 : 0.5, transition:"easeOutSine" });
	}

	public function clean():void
	{
		progressShower.clean();
	}
}

}