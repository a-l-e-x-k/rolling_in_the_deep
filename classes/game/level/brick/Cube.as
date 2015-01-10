/**
 * Author: Alexey
 * Date: 6/11/12
 * Time: 9:47 PM
 */
package game.level.brick
{
import events.RequestEvent;

import flash.events.Event;

import game.Directions;
import game.level.Field;
import game.level.Level;
import game.level.cells.Bridge;

public class Cube extends MovieClipContainer
{
	private static const GRAVITY:int = 2;
	private static const MAX_Y:int = 1400;

	public var positionX:int = 0;
	public var positionY:int = 0;
	private var currentDirection:String = ""; //where brick is going (up, left, right...)
	private var _nextDirection:String = "";
	private var alive:Boolean = true;
	private var yVelocty:Number = 0;

	public function Cube(x:int, y:int)
	{
		super(new cube());

		positionX = x;
		positionY = y;

		reposition();

		_mc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(event:Event):void
	{
		if (alive)
		{
			if (_mc.currentFrame % 10 == 0 && _mc.currentFrame < 70)
				updatePosition();

			tryDoNextTask();
		}
		else
		{
			if (y > MAX_Y)
			{
				_mc.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				dispatchEvent(new RequestEvent(RequestEvent.RESTART_LEVEL));
			}
			else
			{
				yVelocty += GRAVITY;
				y += yVelocty;
			}
		}
	}

	private function tryDoNextTask():void
	{
		if (_nextDirection == "" || _mc.currentFrame != 1)
			return;

		Level.stepsHistory += _nextDirection.charAt(0);

		_mc.gotoAndPlay(_nextDirection);
		currentDirection = _nextDirection;
		_nextDirection = "";
	}

	private function updatePosition():void
	{
		if (_mc.currentLabel == Directions.DIR_LEFT)
			positionX--;
		else if (_mc.currentLabel == Directions.DIR_UP)
			positionY--;
		else if (_mc.currentLabel == Directions.DIR_RIGHT)
			positionX++;
		else if (_mc.currentLabel == Directions.DIR_DOWN)
			positionY++;

		Level.currentLevelStepsCount++;
		_mc.gotoAndStop(1);
		processStepCube();
		reposition();
	}

	private function reposition():void
	{
		this.x = Field.xStart + positionX * Field.X_GAP + positionY * Field.X_SHIFT - 1.5;
		this.y = Field.yStart - positionX * Field.Y_SHIFT + positionY * Field.Y_GAP - .5;

		if (positionY == -1 || positionY == Field.fieldSize)
			die();
	}

	private function processStepCube():void
	{
		if (positionY != -1 && positionY != Field.fieldSize)
		{
			var gonnaFall:Boolean = Field.fieldData[positionY][positionX] == Levels.EMPTY_CELL;

			if (Field.tiles[positionY][positionX] is Bridge && !(Field.tiles[positionY][positionX] as Bridge).on)
				gonnaFall = true;

			if (gonnaFall)
				die();
			else
				gotoAndStop(1);

			if (Field.fieldData[positionY][positionX] == Levels.EASY_SWITCH_TILE)
			{
				if (Field.switchData)
				{
					var bridgeSide:Array;
					var targetBridge:Bridge;

					for (var g:int = 0; g < Field.switchData["sw" + positionX + "" + positionY].length; g++)
					{
						bridgeSide = Field.switchData["sw" + positionX + "" + positionY][g];
						targetBridge = Field.tiles[bridgeSide[1]][bridgeSide[0]];

						if ((!targetBridge.on) && bridgeSide[2] != "off")
							targetBridge.turnOn();
						else if (targetBridge.on && bridgeSide[2] != "on")
							targetBridge.turnOff();

					}
				}
			}
		}

		dispatchEvent(new RequestEvent(RequestEvent.STEP));
	}

	private function die():void
	{
		_mc.gotoAndPlay("fall" + currentDirection);
		alive = false;
		dispatchEvent(new RequestEvent(RequestEvent.STARTED_DYING));
	}

	public function set nextDirection(value:String):void
	{
		_nextDirection = value;
	}
}
}
