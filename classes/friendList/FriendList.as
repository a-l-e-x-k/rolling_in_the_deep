/**
 * Author: Alexey
 * Date: 6/22/12
 * Time: 11:40 PM
 */
package friendList
{
import flash.display.MovieClip;
import flash.display.Sprite;

import viral.SocialPerson;

public class FriendList extends Sprite
{
	private const FRIEND_ITEM_WIDTH:int = 95;
	private var _items:Array = [];

	public function FriendList(friendData:Array)
	{
		var bg:MovieClip = new friendsbg();
		bg.x = 15;
		bg.y = 630;
		addChild(bg);

		update(friendData);
	}

	public function update(friendData:Array):void
	{
		var count:int = _items.length;
		if (count > 0)
		{
			for (var i:int = 0; i < count; i++)
			{
				removeChild(_items[0]);
				_items.splice(0, 1);
			}
		}

		var newStuff:Array = friendData.slice(); //so we won't be pushing in UserData.friends below

		var me:SocialPerson = new SocialPerson();
		me.firstName = UserData.name;
		me.photoURL = UserData.photoURL;
		me.levelsCompleted = UserData.levelsCompleted;
		me.inAppFriend = true;
		newStuff.push(me);

		newStuff.sortOn(["inAppFriend", "levelsCompleted"], [Array.DESCENDING, Array.DESCENDING | Array.NUMERIC]);

		for (i = 0; i < 8; i++)
		{
			var friendItem:FriendItem = new FriendItem(i < newStuff.length ? newStuff[i] : null);
			friendItem.x = 27 + (FRIEND_ITEM_WIDTH * i);
			friendItem.y = 638;
			_items.push(friendItem);
			addChild(friendItem);
		}
	}
}
}
