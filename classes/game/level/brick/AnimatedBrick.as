/**
 * Author: Alexey
 * Date: 6/10/12
 * Time: 7:33 PM
 */
package game.level.brick
{
import events.RequestEvent;

import flash.events.Event;

import game.Directions;
import game.level.Field;
import game.level.Level;

public class AnimatedBrick extends MovieClipContainer
{

	public static const LONG_STATE:String = "long";
	public static const UP_STATE:String = "up";
	public static const FAR_STATE:String = "far";

	private static const GRAVITY:int = 2;
	private static const MAX_Y:int = 1400;

	protected var positionX:int = 0;
	protected var positionY:int = 0;
	protected var currentState:String = "";
	protected var currentDirection:String = ""; //where brick is going (up, left, right...)
	protected var _nextDirection:String = "";
	protected var alive:Boolean = true;
	protected var splitted:Boolean = false;

	private var yVelocty:int = 0;

	public function AnimatedBrick(posX:int, posY:int)
	{
		super(new block());
		positionX = posX;
		positionY = posY;

		_mc.width = 40;
		_mc.height = 78;
		_mc.addEventListener(Event.ENTER_FRAME, tryUpdatePosition);
		_mc.gotoAndPlay("land");

		currentState = UP_STATE;
	}

	/**
	 * If on keyboard key down animation finished playing then update positionX & positionY vars which are used for fail check.
	 * @param    e
	 */
	private function tryUpdatePosition(e:Event):void
	{
		if (splitted)
			return;

		if (alive)
		{
			if (_mc.currentFrame % 10 == 0 && _mc.currentFrame < 121)
			{
				_mc.gotoAndStop(currentState);
				updatePosition();
				Level.currentLevelStepsCount++;
			}

			tryDoNextTask();
		}
		else
		{
			if (y > MAX_Y)
			{
				_mc.removeEventListener(Event.ENTER_FRAME, tryUpdatePosition);
				dispatchEvent(new RequestEvent(RequestEvent.RESTART_LEVEL));
			}
			else
			{
				yVelocty += GRAVITY;
				y += yVelocty;
			}
		}
	}

	protected function tryDoNextTask():void
	{
		if (_nextDirection == "" || !isReady)
			return;

		if (_nextDirection == Directions.DIR_RIGHT)
			goRight();
		else if (_nextDirection == Directions.DIR_LEFT)
			goLeft();
		else if (_nextDirection == Directions.DIR_UP)
			goUp();
		else if (_nextDirection == Directions.DIR_DOWN)
			goDown();

		Level.stepsHistory += _nextDirection.charAt(0);

		currentDirection = _nextDirection;
		_nextDirection = "";
	}

	public function updatePosition(checkCellNeeded:Boolean = true):void
	{
		_mc.x = Field.xStart + positionX * Field.X_GAP + positionY * Field.X_SHIFT;
		_mc.y = Field.yStart - positionX * Field.Y_SHIFT + positionY * Field.Y_GAP;

		if(checkCellNeeded)
			checkCell();
	}

	private function get isReady():Boolean
	{
		return _mc.currentFrameLabel == UP_STATE || _mc.currentFrameLabel == FAR_STATE || _mc.currentFrameLabel == LONG_STATE || splitted;
	}

	private function goRight():void
	{
		switch (currentState)
		{
			case UP_STATE:
				fallRightFromUpState();
				break;
			case LONG_STATE:
				fallRightFromLongState();
				break;
			case FAR_STATE:
				fallRightFromFarState();
				break;
		}
	}

	private function goLeft():void
	{
		switch (currentState)
		{
			case UP_STATE:
				fallLeftFromUpState();
				break;
			case LONG_STATE:
				fallLeftFromLongState();
				break;
			case FAR_STATE:
				fallLeftFromFarState();
				break;
		}
	}

	private function goDown():void
	{
		switch (currentState)
		{
			case UP_STATE:
				fallInFromUpState();
				break;
			case LONG_STATE:
				fallInFromLongState();
				break;
			case FAR_STATE:
				fallInFromFarState();
				break;
		}
	}

	private function goUp():void
	{
		switch (currentState)
		{
			case UP_STATE:
				fallOutFromUpState();
				break;
			case LONG_STATE:
				fallOutFromLongState();
				break;
			case FAR_STATE:
				fallOutFromFarState();
				break;
		}
	}

	/**
	 * Brick animations
	 */

	private function fallLeftFromUpState():void
	{
		_mc.gotoAndPlay(1);
		positionX -= 2;
		currentState = LONG_STATE;
	}

	private function fallOutFromUpState():void
	{
		_mc.gotoAndPlay(11);
		positionY--;
		currentState = FAR_STATE;
	}

	private function fallRightFromUpState():void
	{
		_mc.gotoAndPlay(21);
		positionX++;
		currentState = LONG_STATE;
	}

	private function fallInFromUpState():void
	{
		_mc.gotoAndPlay(31);
		positionY += 2;
		currentState = FAR_STATE;
	}

	private function fallLeftFromFarState():void
	{
		_mc.gotoAndPlay(41);
		positionX--;
	}

	private function fallOutFromFarState():void
	{
		_mc.gotoAndPlay(51);
		positionY -= 2;
		currentState = UP_STATE;
	}

	private function fallRightFromFarState():void
	{
		_mc.gotoAndPlay(61);
		positionX++;
	}

	private function fallInFromFarState():void
	{
		_mc.gotoAndPlay(71);
		positionY++;
		currentState = UP_STATE;
	}

	private function fallLeftFromLongState():void
	{
		_mc.gotoAndPlay(81);
		positionX--;
		currentState = UP_STATE;
	}

	private function fallOutFromLongState():void
	{
		_mc.gotoAndPlay(91);
		positionY--;
	}

	private function fallRightFromLongState():void
	{
		_mc.gotoAndPlay(101);
		positionX += 2;
		currentState = UP_STATE;
	}

	private function fallInFromLongState():void
	{
		_mc.gotoAndPlay(111);
		positionY++;
	}

	/**
	 * Overriden in SmartBrick. Does all the check related to underlying cell
	 */
	protected function checkCell():void
	{

	}

	public function set nextDirection(value:String):void
	{
		if (!splitted)
			_nextDirection = value;
	}
}
}
