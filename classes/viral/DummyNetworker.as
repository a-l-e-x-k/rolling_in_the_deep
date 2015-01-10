package viral
{
    import events.RequestEvent;

    /**
 * ...
 * @author Alexey Kuznetsov
 */
public final class DummyNetworker implements ISocial
{
	public var offers:Array = [];

	public function DummyNetworker()
	{
		offers[0] = { coins:300, price:3 };
		offers[1] = { coins:600, price:5 }; //+50 free
		offers[2] = { coins:1250, price:10 }; //+50 free
		offers[3] = { coins:2600, price:20 }; //+70 free
		offers[4] = { coins:6600, price:50 }; //+100 free
		offers[5] = { coins:14000, price:100 }; //+300 free
	}

	public function init(flashVars:Object):void
	{
		UserData.id = "1308033905";//Misc.randomNumber(99999).toString();//"73920149";//
	}

	public function getUserData():void
	{
		UserData.name = "Jonh";
		UserData.photoURL = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/161755_1555514477_2640658_n.jpg";
		Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.USER_INFO_LOADED));
	}

	public function getUserFriends():void
	{
		var all:Array = [];

		var friend1:SocialPerson = new SocialPerson();
		friend1.firstName = "Peter";
		friend1.uid = "54";
		friend1.photoURL = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/48985_100000462592304_8211_n.jpg";
		friend1.levelsCompleted = 55;
		all.push(friend1);

		var friend2:SocialPerson = new SocialPerson();
		friend2.uid = "1456663208";
		friend2.firstName = "Patrick";
		friend2.photoURL = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/372314_548075494_722296450_n.jpg";
		friend2.levelsCompleted = 12;
		all.push(friend2);

		var friend3:SocialPerson = new SocialPerson();
		friend3.firstName = "Susy";
		friend3.photoURL = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/48985_100000462592304_8211_n.jpg";
		friend3.levelsCompleted = 33;
		all.push(friend3);

		var friend4:SocialPerson = new SocialPerson();
		friend4.firstName = "Paranchita";
		friend4.photoURL = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/174448_100001731476934_6304158_n.jpg";
		friend4.levelsCompleted = 68;
		all.push(friend4);

		var levelRequest:String = "1456663208,100003075196063"; //simulating multiple friends in the app

		EventHub.addEventListener(RequestEvent.FRIENDS_LEVELS_LOADED, function (e:RequestEvent)
		{
			for each (var sp:SocialPerson in all)
			{
				for each (var levelData:SocialPerson in e.stuff.guys)
				{
					if (sp.uid == levelData.uid)
					{
						sp.levelsCompleted = levelData.levelsCompleted;
					}
				}
			}

			finishFriends(all);
		});
		ServerTalker.loadFriendsLevels(levelRequest);
	}

	private static function finishFriends(allFriends:Array):void
	{
		UserData.friends = allFriends;
		Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.IN_APP_FRIENDS_LOADED));
	}

	public function getUsersNamesAndPhotos(usersIDS:Array):void
	{
	}

	public function showPayDialog(orderInfo:Object):void
	{
		Networking.eventDispatcher.dispatchEvent(new RequestEvent(RequestEvent.ON_PURCHASE_SUCCESS));
	}

	public function showSocialInvitePopup():void
	{
		trace("showing popup");
	}

	public function invokePublishDialog(message:String, pictureURL:String):void
	{

	}

	public function publishAchievement():void
	{

	}

	public function get coreLink():String
	{
		return "";
	}
}
}