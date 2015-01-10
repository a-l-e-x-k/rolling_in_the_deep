/**
 * Author: Alexey
 * Date: 6/12/12
 * Time: 3:27 PM
 */
package
{
import events.RequestEvent;

import viral.SocialPerson;

public class ServerTalker
{
	private static const SERVER_URL:String = "http://boomboomb.herokuapp.com/";

	public function ServerTalker()
	{
	}

	public static function init():void
	{
		var params:Object = {req:"init", uid:UserData.id};
		var loader:ServerLoader = new ServerLoader(SERVER_URL, onInit, params);
		loader.load();
	}

	/**
	 * Receives number of levels completed by user
	 * @param response
	 */
	private static function onInit(response:String):void
	{
		UserData.levelsCompleted = int(response);
		UserData.currentLevel = int(response) + 1;
		EventHub.dispatch(new RequestEvent(RequestEvent.DATA_LOADED));
	}

	public static function sendStart(levelID:int):void
	{
		var params:Object = {req:"start", uid:UserData.id, lvl:levelID};
		var loader:ServerLoader = new ServerLoader(SERVER_URL, onStartComplete, params);
		loader.load();
	}

	public static function sendRestart(stepsCount:int):void
	{
		var params:Object = {req:"restart", uid:UserData.id, st:stepsCount};
		var loader:ServerLoader = new ServerLoader(SERVER_URL, onRestartComplete, params);
		loader.load();
	}

	public static function sendComplete(stepsCount:int, skippedViaCredits:Boolean):void
	{
		var params:Object = {req:"finish", uid:UserData.id, st:stepsCount};

		if (skippedViaCredits)
			params.skc = 1; //skc = skipped via credits

		var loader:ServerLoader = new ServerLoader(SERVER_URL, onCompleteComplete, params);
		loader.load();
	}

	private static function onCompleteComplete(response:String):void
	{
		var res:Array = response.split("@");
		if (res[0] == "ok")
		{
			EventHub.dispatch(new RequestEvent(RequestEvent.LEVEL_COMPLETE_OK, {lvl:res[1], lvlc:res[2]}));
			trace("Server ok complete");
		}
	}

	private static function onRestartComplete(response:String):void
	{
		trace("Server ok restart: " + response);
	}

	private static function onStartComplete(response:String):void
	{
		trace("Server ok start: " + response);
	}

	public static function loadFriendsLevels(levelRequest:String):void
	{
		var params:Object = {req:"getFriendsLevels", uid:UserData.id, uids:levelRequest};
		var loader:ServerLoader = new ServerLoader(SERVER_URL, onUidsLoaded, params);
		loader.load();
	}

	private static function onUidsLoaded(response:String):void
	{
		var result:Array = [];
		var guys:Array = response.split("!");
		var guyData:Array;

		for (var i:int = 0; i < guys.length; i++)
		{
			guyData = guys[i].split(",");

			var resultGuyData:SocialPerson = new SocialPerson();
			resultGuyData.uid = guyData[0];
			resultGuyData.levelsCompleted = guyData[1];
			result.push(resultGuyData);
		}

		EventHub.dispatch(new RequestEvent(RequestEvent.FRIENDS_LEVELS_LOADED, {guys:result}));
	}
}
}
