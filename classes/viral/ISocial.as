package viral 
{
	
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public interface ISocial 
	{
		function init(flashVars:Object):void;
		
		///These may be united in 1 more complicated method///
		/**
		 * Gets name & photo of user who launched the app
		 */
		function getUserData():void;
		
		/**
		 * Gets friends (including inApp friends) of user who launched the app
		 */
		function getUserFriends():void;
		
		/**
		 * Gets names & photos for a bunch of users (for TOP100 likes)
		 */
		function getUsersNamesAndPhotos(usersIDS:Array):void;

		/**
		 * Gets coint amount, price in Social Network Currency
		 */
		function showPayDialog(orderInfo:Object):void;
		
		/**
		 * Show multi-friend invite popup of social network
		 */
		function showSocialInvitePopup():void;

		function invokePublishDialog(message:String, pictureURL:String):void;

		function  publishAchievement():void

		function get coreLink():String;
	}
}