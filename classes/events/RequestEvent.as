package events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public final class RequestEvent extends Event
	{
		private var _stuff:Object;
		
		public static const AVATARS_LINKS_LOADED:String = "avatarLinksLoaded";
		public static const AVATARS_WITH_SEX_LOADED:String = "avatarsWithSexLoaded";
		public static const AVATAR_WITH_NAME_LOADED:String = "avatarsWithNameLoaded";
		public static const FRIENDS_LOADED:String = "friendsLoaded";
		public static const GOTO_GAME:String = "gotoGame";
		public static const GOTO_LEVEL_SELECT:String = "gotoLevelSelect";
		public static const GOTO_LEVEL_GROUP:String = "gotoLevelGroup";
		public static const IMREADY:String = "imReady";	
		public static const USERS_INFO_LOADED:String = "usersInfoLoaded";
		public static const RESTART_LEVEL:String = "imdead";
		public static const STARTED_DYING:String = "startedDying";
		public static const LEVEL_COMPLETED:String = "levelCompleted";
		public static const SPLITTED:String = "splitted";
		public static const SKIP_LEVEL:String = "skipLevel";
		public static const CUBES_UNITED:String = "cubesUnited";
		public static const STEP:String = "step";
		public static const DATA_LOADED:String = "dataLoaded";
		public static const LEVEL_COMPLETE_OK:String = "levelCompleteOk";
		public static const TUTORIAL_SHOWN:String = "tutorialShown";
		public static const UPDATE_TUTORIAL:String = "updateTurorial";
		public static const PUBLISH_COMPLETE:String = "publishComplete";
		public static const USER_INFO_LOADED:String = "userInfoLoaded";
		public static const IN_APP_FRIENDS_LOADED:String = "inappFriendsLoaded";
		public static const USER_LEVEL_UPDATED:String = "userLevelUpdated";
		public static const FRIENDS_LEVELS_LOADED:String = "friendLevelsLoaded";
		public static const ON_PURCHASE_SUCCESS:String = "onPurchaseSuccess";
		public static const ON_PURCHASE_FAIL:String = "onPurchaseFail";

		public function RequestEvent(eventType:String, stuff:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{		
			super(eventType, bubbles, cancelable);
			_stuff = stuff;
		}		
		
		public function get stuff():Object {return _stuff;}
	}
}