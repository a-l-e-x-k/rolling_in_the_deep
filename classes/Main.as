package
{
    import com.demonsters.debugger.MonsterDebugger;

    import events.RequestEvent;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.system.Security;
    import flash.ui.ContextMenu;

    /**
 * ...
 * @author Alexey Kuznetsov
 */
[SWF(width="807", height="782", backgroundColor="#000000", frameRate="30")]
public final class Main extends MovieClip
{
	private var _friendsLoaded:Boolean = false;  //list of in app dudes loaded
	private var _dataLoaded:Boolean = false;     //current level, etc (from DB)
	private var _loadingThing:LoadingShower;
	private var _userInfoLoaded:Boolean = false; //avatar & name of user

	public function Main()
	{
		Security.allowInsecureDomain("*");
		Security.allowDomain("*");

		MonsterDebugger.initialize(this);
		var cm:ContextMenu = new ContextMenu();
		cm.hideBuiltInItems();

		_loadingThing = new LoadingShower();
		addChild(_loadingThing);

		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}

	private function onAdded(event:Event):void
	{
		Networking.parseFlashvars(stage.loaderInfo.parameters);
		Networking.eventDispatcher.addEventListener(RequestEvent.IN_APP_FRIENDS_LOADED, onFriendsLoaded);
		Networking.eventDispatcher.addEventListener(RequestEvent.USER_INFO_LOADED, onUserInfoLoaded);
		Networking.socialNetworker.getUserData();
		Networking.socialNetworker.getUserFriends();
		EventHub.addEventListener(RequestEvent.DATA_LOADED, onDataLoaded);
		ServerTalker.init();
	}

	private function onUserInfoLoaded(event:RequestEvent):void
	{
		_userInfoLoaded = true;
		tryCreateVisual();
	}

	private function onFriendsLoaded(event:RequestEvent):void
	{
		_friendsLoaded = true;
		tryCreateVisual();
	}

	private function onDataLoaded(e:Event):void
	{
		_dataLoaded = true;
		tryCreateVisual();
	}

	private function tryCreateVisual():void
	{
		if (_dataLoaded && _friendsLoaded && _userInfoLoaded)
		{
			removeChild(_loadingThing);
			var visual:Visual = new Visual();
			addChild(visual);
		}
	}
}
}