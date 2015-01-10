/**
 * Author: Alexey
 * Date: 6/22/12
 * Time: 11:40 PM
 */
package friendList
{
import fl.containers.UILoader;

import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import viral.SocialPerson;

public class FriendItem extends MovieClipContainer
{
	private var avatar:UILoader = new UILoader();
	private var _friendData:SocialPerson;

	public function FriendItem(friendData:SocialPerson = null)
	{
		super(new friendi());

		if (friendData && friendData.inAppFriend)
		{
			_friendData = friendData;

			Networking.fillAvatar(friendData.photoURL, avatar, 50, 50);
			_mc.item_mc.avatar_mc.buttonMode = true;
			_mc.item_mc.avatar_mc.addEventListener(MouseEvent.CLICK, gotoDude);

			_mc.item_mc.avatar_mc.ex_mc.removeChild(_mc.item_mc.avatar_mc.ex_mc.tetka_mc);
			_mc.item_mc.avatar_mc.ex_mc.addChild(avatar);
			_mc.item_mc.name_txt.text = friendData.firstName;
			_mc.level_mc.text_txt.htmlText = "<b>" + friendData.levelsCompleted + "</b>";
		}
		else
		{
			_mc.gotoAndStop(2);
			_mc.buttonMode = true;
			_mc.addEventListener(MouseEvent.CLICK, onInviteClick);
		}
	}

	private function gotoDude(event:MouseEvent):void
	{
		navigateToURL(new URLRequest(Networking.socialNetworker.coreLink + _friendData.uid), "_blank");
	}

	private static function onInviteClick(event:MouseEvent):void
	{
		Networking.socialNetworker.showSocialInvitePopup();
	}
}
}
