package game.level.brick
{
import events.RequestEvent;

import game.level.*;
import game.level.cells.Bridge;

/**
 * ...
 * @author Alexey Kuznetsov
 */
public class SmartBrick extends AnimatedBrick
{
	public function SmartBrick(level:int)
	{
		var coordsArray:Array = Levels.getLevel(level)[Field.fieldSize];
		super(coordsArray[0], coordsArray[1]);
	}

	override protected function checkCell():void
	{
		if (!cellIsHere(positionY, positionX)) //off the field
		{
			die();
			return;
		}

		checkForSplit();
		checkForWeak();
		checkForExit();
		checkForBridges();
		checkForDeath();

		dispatchEvent(new RequestEvent(RequestEvent.STEP));
		dispatchEvent(new RequestEvent(RequestEvent.UPDATE_TUTORIAL));
	}

	public function unite(uniteData:Object):void
	{
		splitted = false;
		positionX = uniteData.x;
		positionY = uniteData.y;
		currentState = uniteData.type;
		nextDirection = "";
		_mc.gotoAndStop(currentState);
		updatePosition(false);
	}

	private function checkForDeath():void
	{
		if (currentState == UP_STATE && !cellIsHere(positionY, positionX)) //Gonna vertical die
			die();
		else if (currentState == LONG_STATE && !cellIsHere(positionY, positionX)) //Gonna fall because under far left cell there is no ground (going left)
			die();
		else if (currentState == FAR_STATE && !cellIsHere(positionY - 1, positionX))  //Gonna fall because under close cell there is no ground (going up)
			die();
		else if (currentDirection == FAR_STATE && !cellIsHere(positionY, positionX)) //Gonna fall because under far cell there is no ground (going down)
			die();
		else if (currentState == LONG_STATE && !cellIsHere(positionY, positionX + 1)) //Gonna fall because under far right cell there is no ground (going right)
			die();
		else if (!cellIsHere(positionY, positionX)) //Gonna fall because under main cell there is no ground
			die();
	}

	/**
	 * Shows how brick is dying
	 */
	private function die():void
	{
		_mc.gotoAndPlay("fall" + currentState + currentDirection);
		dispatchEvent(new RequestEvent(RequestEvent.STARTED_DYING));
		alive = false;
	}

	private function checkForBridges():void
	{
		var positionX3:int = positionX;
		var positionY3:int = positionY;

		for (var h:int = 0; h < 2; h++)
		{
			if (h == 1)
			{
				if (currentState == LONG_STATE)
					positionX3++;
				else if(currentState == FAR_STATE)
					positionY3--;
				else if(currentState == UP_STATE)
					break;
			}

			if (!cellIsHere(positionY3, positionX3))
				continue;

			if (Levels.EASY_SWITCH_TILE == Field.fieldData[positionY3][positionX3] || (Field.fieldData[positionY3][positionX3] == Levels.HARD_SWITCH_TILE && currentState == UP_STATE)) //if on switch
			{
				if (Field.switchData)
				{
					var bridgeSide:Array = []; //i, j, type
					var rowNumber:int = 0;
					var columnNumber:int = 0;
					var bridgeOn:Boolean;
					var switchType:String = "";
					var targetBridge:Bridge;
					for (var g:int = 0; g < Field.switchData["sw" + positionX3.toString() + positionY3.toString()].length; g++) //go through bridges which are activated by this switch
					{
						bridgeSide = Field.switchData["sw" + positionX3 + "" + positionY3][g];
						rowNumber = bridgeSide[0];
						columnNumber = bridgeSide[1];
						switchType = bridgeSide[2];
						targetBridge = Field.tiles[columnNumber][rowNumber];
						bridgeOn = targetBridge.on;

						if ((switchType == "off" || switchType == "onoff") && bridgeOn)
							targetBridge.turnOff();
						else if ((switchType == "on" || switchType == "onoff") && !bridgeOn)
							targetBridge.turnOn();
					}
				}
			}
		}
	}

	private function checkForExit():void
	{
		if (Field.fieldData[positionY][positionX] == Levels.EXIT_CELL && currentState == UP_STATE)
		{
			_mc.gotoAndPlay("end");
			Misc.delayCallback(function ():void
			{
				dispatchEvent(new RequestEvent(RequestEvent.LEVEL_COMPLETED));
			}, 350);
		}
	}

	private function checkForSplit():void
	{
		if (Field.fieldData[positionY][positionX] == Levels.SPLITTER_TILE && currentState == UP_STATE)
		{
			if (Field.splitData && Field.splitData["sw" + positionX + "" + positionY])
			{
				splitted = true;
				_mc.gotoAndPlay("split");
				_nextDirection = "";
				dispatchEvent(new RequestEvent(RequestEvent.SPLITTED, {

					x1:Field.splitData["sw" + positionX + "" + positionY][0],
					y1:Field.splitData["sw" + positionX + "" + positionY][1],
					x2:Field.splitData["sw" + positionX + "" + positionY][2],
					y2:Field.splitData["sw" + positionX + "" + positionY][3]
				}));
			}
		}
	}

	private function checkForWeak():void
	{
		if (Field.fieldData[positionY][positionX] == Levels.WEAK_TILE && currentState == UP_STATE)
		{
			_mc.gotoAndPlay("fallsquare");
			Field.tiles[positionY][positionX].mc.play();
			die();
		}
	}

	private static function cellIsHere(y:int, x:int):Boolean
	{
		return Field.fieldSize > y && Field.fieldData[y] && Field.fieldData[y][x] && Field.fieldData[y][x] != Levels.EMPTY_CELL && !(Field.tiles[y][x] is Bridge && !(Field.tiles[y][x] as Bridge).on);
	}
}
}