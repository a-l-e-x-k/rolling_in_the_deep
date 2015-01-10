package game
{
import caurina.transitions.Tweener;

import events.RequestEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import game.level.Level;
import game.level.TutorialishLevel;

import popup.CongratsPopup;

import tutorial.LevelsVoodoo;

/**
 * ...
 * @author Alexey Kuznetsov
 */
public class Game extends Sprite
{
	private var _currentLevel:Level;
	private var _tutorialishLevel:TutorialishLevel;
	private var _skippedViaCredits:Boolean = false;

	public function Game(level:int)
	{
		var antiUglyMask:Sprite = new Sprite();  //when levels get moved to the left, at FB they are seen off the game borders
		antiUglyMask.graphics.beginFill(0, 1);
		antiUglyMask.graphics.drawRect(14, 14, 779, 600);
		addChild(antiUglyMask);

		this.mask = antiUglyMask;

		EventHub.addEventListener(RequestEvent.RESTART_LEVEL, restartLevel);
		EventHub.addEventListener(RequestEvent.LEVEL_COMPLETED, onLevelCompleted);
		EventHub.addEventListener(RequestEvent.SKIP_LEVEL, skipLevelPurchase);

		createLevel(level);

		var gameButtons:GameButtons = new GameButtons();
		addChild(gameButtons);

		addEventListener(Event.ADDED_TO_STAGE, addKeyDownListener);
	}

	private function addKeyDownListener(e:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, addKeyDownListener);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	private function skipLevelPurchase(event:RequestEvent):void
	{
		if (_tutorialishLevel) //if tutorial is being shown now
			return;

		Networking.eventDispatcher.addEventListener(RequestEvent.ON_PURCHASE_SUCCESS, skipLevel);
		Networking.socialNetworker.showPayDialog({item_id:"lac", lid:UserData.currentLevel}); //lac = level auto complete
	}

	private function skipLevel(e:RequestEvent):void
	{
		if (e)
			Networking.eventDispatcher.removeEventListener(RequestEvent.ON_PURCHASE_SUCCESS, skipLevel);

		createTutorialLevel(_currentLevel.id, false);
		_skippedViaCredits = true;
		setChildIndex(_currentLevel, numChildren - 1);
	}

	private function createLevel(id:int):void
	{
		trace("createLevel: " + id);
		ServerTalker.sendStart(id);
		_currentLevel = new Level(id);
		_tutorialishLevel = null;
		tryShowTutorial(id);
		addChild(_currentLevel);
	}

	private function tryShowTutorial(id:int):void
	{
		if (LevelsVoodoo.tryGetTutorial(id))
			createTutorialLevel(id);
	}

	private function createTutorialLevel(id:int, showCellsAnim:Boolean = true):void
	{
		_tutorialishLevel = new TutorialishLevel(id, showCellsAnim, this);
		_tutorialishLevel.addEventListener(RequestEvent.TUTORIAL_SHOWN, onTutorialComplete);
		_currentLevel.hideField();
		addChild(_tutorialishLevel);
	}

	private function onTutorialComplete(event:RequestEvent):void
	{
		if (_skippedViaCredits)
		{
			onLevelCompleted();
			_skippedViaCredits = false;
		}
		else
		{
			_currentLevel.showField();
			_tutorialishLevel.prepareForAnimation();
			removeTutorialLevel(_tutorialishLevel);
		}
	}

	private function onLevelCompleted(event:RequestEvent = null):void
	{
		EventHub.addEventListener(RequestEvent.LEVEL_COMPLETE_OK, onLevelCompleteOk);
		ServerTalker.sendComplete(Level.currentLevelStepsCount, _skippedViaCredits);
	}

	/**
	 * Received response from server
	 * @param event
	 */
	private function onLevelCompleteOk(event:RequestEvent):void
	{
		EventHub.removeEventListener(RequestEvent.LEVEL_COMPLETE_OK, onLevelCompleteOk);

		var levelsBefore:int = UserData.levelsCompleted;
		UserData.currentLevel = event.stuff.lvl;
		UserData.levelsCompleted = event.stuff.lvlc;

		EventHub.dispatch(new RequestEvent(RequestEvent.USER_LEVEL_UPDATED));

		if ((levelsBefore + 1) % 5 == 0 && UserData.levelsCompleted % 5 == 0) //e.g. if before 44 levels were completed and now 45
		{
			showCongratulationsPopup();
			Networking.socialNetworker.publishAchievement();
		}
		else
		    tryGoToNextLevel();
	}

	private function showCongratulationsPopup():void
	{
		var popupa:CongratsPopup = new CongratsPopup(UserData.levelsCompleted);
		popupa.addEventListener(RequestEvent.IMREADY, tryGoToNextLevel);
		addChild(popupa);
	}

	private function tryGoToNextLevel(e:RequestEvent = null):void
	{
		if (UserData.currentLevel < 100) //either game not completed or game is completed but user is playing some other levels againW
			gotoNextLevel();
		else
		{
			if (e) //got event only if game was completed 1st time (event from congrats dialog)
			{
				EventHub.dispatch(new RequestEvent(RequestEvent.GOTO_LEVEL_SELECT));
				trace("Game completed!");
			}
		}
	}

	private function gotoNextLevel():void
	{
		var previousLevel:Level = _currentLevel;
		var previousTutorialishLevel:TutorialishLevel = _tutorialishLevel;

		createLevel(previousLevel.id + 1);
		fadeOut(previousLevel);

		if (previousTutorialishLevel) //if prev level was skipped, animate it as well
		{
			previousTutorialishLevel.prepareForAnimation();
			fadeOut(previousTutorialishLevel);
		}

		_currentLevel.x = Misc.APP_WIDTH;
		Tweener.addTween(_currentLevel, {x:0, time:1.2, transition:"easeOutExpo" });

		if (_tutorialishLevel) //animate next tutorialish level
		{
			_tutorialishLevel.x = Misc.APP_WIDTH;
			Tweener.addTween(_tutorialishLevel, {x:0, time:1.2, transition:"easeOutExpo" });
		}
	}

	private function fadeOut(level:Level):void
	{
		Tweener.addTween(level, {alpha:0, time:1.21, transition:"easeOutExpo"});
		Tweener.addTween(level, {x:-Misc.APP_WIDTH, time:1.21, transition:"easeOutExpo", onComplete:function ():void
		{
			if (level is TutorialishLevel)
			{
				removeTutorialLevel(level as TutorialishLevel);
			}
			else
				removeChild(level);
		} });
	}

	private function restartLevel(event:RequestEvent):void
	{
		var lid:int = _currentLevel.id;
		ServerTalker.sendRestart(Level.currentLevelStepsCount);
		removeChild(_currentLevel);
		createLevel(lid);
	}

	private function onKeyDown(e:KeyboardEvent):void
	{
		if (e.keyCode == Keyboard.RIGHT)
			_currentLevel.doRight();
		else if (e.keyCode == Keyboard.DOWN)
			_currentLevel.doDown();
		else if (e.keyCode == Keyboard.LEFT)
			_currentLevel.doLeft();
		else if (e.keyCode == Keyboard.UP)
			_currentLevel.doUp();
		else if (e.keyCode == Keyboard.SPACE)
			_currentLevel.trySwitchCubes();
	}

	public function clean():void
	{
		if (_currentLevel && contains(_currentLevel))
			removeChild(_currentLevel);

		_currentLevel = null;

		removeTutorialLevel(_tutorialishLevel);

		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		EventHub.removeEventListener(RequestEvent.RESTART_LEVEL, restartLevel);
		EventHub.removeEventListener(RequestEvent.LEVEL_COMPLETED, onLevelCompleted);
		EventHub.removeEventListener(RequestEvent.SKIP_LEVEL, skipLevelPurchase);
	}

	private function removeTutorialLevel(lvl:TutorialishLevel):void
	{
		if (lvl && contains(lvl))
		{
			lvl.die();
			removeChild(lvl);
		}

		if (lvl == _tutorialishLevel)
			_tutorialishLevel = null;
	}
}
}