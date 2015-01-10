package viral
{
    import com.facebook.graph.Facebook;

    import events.RequestEvent;

    import flash.external.ExternalInterface;

    /**
 * ...
 * @author Alexey Kuznetsov
 */
public final class FacebookNetworker implements ISocial
{
	public var offers:Array = [];
	private var _coreLink:String = "https://www.facebook.com/"; //link that is used to navigate to profile pages after clicking on avatar

	public function FacebookNetworker() //1 powerup ~ 9-10 cents
	{
		offers[0] = { coins:300, price:10 };
		offers[1] = { coins:650, price:20 };
		offers[2] = { coins:1650, price:50 };
		offers[3] = { coins:3400, price:100 };
		offers[4] = { coins:6900, price:200 };
		offers[5] = { coins:17500, price:500 };
	}

	public function init(flashVars:Object):void
	{
		trace("initialising with: " + flashVars.fb_application_id);
		UserData.id = flashVars.fb_user_id;
		Facebook.init(flashVars.fb_application_id, null, null, flashVars.fb_access_token);
		t.obj(flashVars);
	}

	public function getUserData():void
	{
		Facebook.api("/" + UserData.id + "?fields=first_name&", receiveDataFromSocial);
	}

	private function receiveDataFromSocial(...params):void
	{
		t.obj(params)
		if (params[0])
		{
			UserData.saveUserData(params[0].first_name, getPhotoURLByID(params[0].id));
			Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.USER_INFO_LOADED));
		}
		else
		{
			trace("Error while getting social data");
			getUserData();
		}
	}

	public function getUserFriends():void //get friends & the ones who installed will have "installed" property = true
	{
		trace("getting friends for: " + UserData.id);
		Facebook.api("/" + UserData.id + "/friends?fields=installed&", receiveFriends);
	}

	private function receiveFriends(...params):void
	{
		trace("receiveFriends");
		var toLoad:Array = []; //ids of guys whose names should be loaded (loading names of only those friends who installed the app)
		for each (var friend:Object in params[0])
		{
			if (friend.installed)
				toLoad.push(friend.id);
		}
		if (toLoad.length > 0) //if there are inApp friends
		{
			Networking.eventDispatcher.addEventListener(RequestEvent.FRIENDS_LOADED, function (e:RequestEvent):void
			{
				onInAppLoaded(e.stuff.users, params[0]);
			});
			getUsersNamesAndPhotos(toLoad);
		}
		else onInAppLoaded(toLoad, params[0]); //pass empty InApp array & all friends
	}

	private static function onInAppLoaded(inApp:Array, allFriends:Array):void
	{
		var levelRequest:String = "";

		for (var i:int = 0; i < allFriends.length; i++) //substitute id-only friends with new objects with name, id, photoUrl & inApp
		{
			for (var j:int = 0; j < inApp.length; j++)
			{
				if (((allFriends[i] is SocialPerson) && allFriends[i].uid == inApp[j].uid) ||
						((!(allFriends[i] is SocialPerson)) && allFriends[i].id && allFriends[i].id == inApp[j].uid))
				{
					allFriends[i] = inApp[j];
					levelRequest += inApp[j].uid + ",";
				} //app user whose name was loaded
			}
		}

		var socPerson:SocialPerson;
		for (i = 0; i < allFriends.length; i++)
		{
			if (!(allFriends[i] is SocialPerson))
			{
				socPerson = new SocialPerson();
				socPerson.uid = allFriends[i].id;
				socPerson.firstName = "noname";
				socPerson.photoURL = getPhotoURLByID(allFriends[i].id);
				allFriends[i] = socPerson; //insert default obj
			}
		}

		if (levelRequest.length > 0)
		{
			EventHub.addEventListener(RequestEvent.FRIENDS_LEVELS_LOADED, function(e:RequestEvent){
				for each (var sp:SocialPerson in allFriends)
				{
					for each (var levelData:SocialPerson in e.stuff.guys)
					{
						if (sp.uid == levelData.uid)
						{
							sp.levelsCompleted = levelData.levelsCompleted;
						}
					}
				}

				finishFriends(allFriends);
			});
			ServerTalker.loadFriendsLevels(levelRequest);
		}
		else
			finishFriends(allFriends);
	}

	private static function finishFriends(allFriends:Array):void
	{
		UserData.friends = allFriends;
		Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.IN_APP_FRIENDS_LOADED));
	}

	public function getUsersNamesAndPhotos(usersIDS:Array):void
	{
		trace("getUsersInfo");
		var resultArray:Array = [];
		var deletedCount:int = 0; //if guys do not exist counter is incremented
		t.obj(usersIDS);

		var socPerson:SocialPerson;
		for (var i:int = 0; i < usersIDS.length; i++)
		{
			Facebook.api("/" + usersIDS[i].toString() + "?fields=first_name&", function (...params):void //need only name & id
			{
				if (params != null && params[0])
				{
					socPerson = new SocialPerson();
					socPerson.uid = params[0].id;
					socPerson.firstName = params[0].first_name;
					socPerson.photoURL = getPhotoURLByID(params[0].id);
					socPerson.inAppFriend = true;
					resultArray.unshift(socPerson);
				}
				else
				{
					trace("Error while getting social data");
					deletedCount++;
				}
				if ((resultArray.length + deletedCount) == usersIDS.length)
				{
					Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.USERS_INFO_LOADED, { users:resultArray })); //for other classes
					Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.FRIENDS_LOADED, { users:resultArray })); //for onInAppLoaded function
				}
			});
		}
	}

	private static function getPhotoURLByID(id:String):String
	{
		return "https://graph.facebook.com/" + id + "/picture";
	}

	public function showPayDialog(orderInfo:Object):void
	{
		var newInfo:Object = {
			order_info:orderInfo,
            action: 'purchaseitem',
            product: 'http://boomboomb.herokuapp.com/walkthrough_product.html',
			dev_purchase_params:{ 'oscif':true } }; //adding dev_purchase_params & removing "method" property

		Facebook.ui('pay', newInfo, onPaymentComplete);
	}

	private static function onPaymentComplete(data:Object):void
	{
		if (data.payment_id)
		{
			Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.ON_PURCHASE_SUCCESS));
		}
		else
			Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.ON_PURCHASE_FAIL));
	}

	public function showSocialInvitePopup():void
	{
		ExternalInterface.call("showFriendInviter", UserData.levelsCompleted);
	}

	public function invokePublishDialog(message:String, pictureURL:String):void
	{
		var values:Object = new Object();
		values.picture = "https://s3.amazonaws.com/rid_swf/Logo5.jpg";
		values.link = "https://www.facebook.com/RollingInTheDeepPage";
		values.caption = message;
		Facebook.ui('feed', values, onPostPosted);
	}

	private static function onPostPosted(...params):void
	{
		EventHub.dispatch(new RequestEvent(RequestEvent.PUBLISH_COMPLETE));
	}

	public function publishAchievement():void
	{

	}

	public function get coreLink():String
	{
		return _coreLink;
	}
}
}