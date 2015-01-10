package  
{
	import events.RequestEvent;

import friendList.FriendList;

import game.Game;
	import levelSelector.LevelSelector;
	
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class Visual extends MovieClipContainer 
	{
		private var _levelSelector:LevelSelector;
		private var _friendList:FriendList;
		private var _game:Game;
		
		public function Visual() 
		{
			super(new bg(), 404, 224, true);
			_mc.cacheAsBitmap = true;

			if (UserData.levelsCompleted == 0)
				createGame(new RequestEvent(RequestEvent.GOTO_GAME, {lvl:1}));
			else
				createLevelSelector();

			_friendList = new FriendList(UserData.friends);
			addChild(_friendList);

			EventHub.addEventListener(RequestEvent.USER_LEVEL_UPDATED, onLevelComplete);
		}

		private function onLevelComplete(event:RequestEvent):void
		{
			_friendList.update(UserData.friends);
		}
		
		private function createLevelSelector(e:RequestEvent = null):void 
		{
			cleanUp();
			_levelSelector = new LevelSelector();
			_levelSelector.addEventListener(RequestEvent.GOTO_GAME, createGame);
			addChild(_levelSelector);
		}
		
		private function createGame(e:RequestEvent):void 
		{
			cleanUp();
			_game = new Game(e.stuff.lvl);
			EventHub.addEventListener(RequestEvent.GOTO_LEVEL_SELECT, createLevelSelector);
			addChild(_game);
		}
		
		private function cleanUp():void 
		{
			if (_levelSelector != null && contains(_levelSelector))
			{
				_levelSelector.clean();
				removeChild(_levelSelector);
			}

			_levelSelector = null;

			if (_game != null && contains(_game))
			{
				_game.clean();
				removeChild(_game);
			}

			_game = null;
		}
	}

}