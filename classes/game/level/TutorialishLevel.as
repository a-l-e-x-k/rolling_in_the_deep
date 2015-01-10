/**
 * Author: Alexey
 * Date: 6/14/12
 * Time: 11:06 PM
 */
package game.level
{
    import events.RequestEvent;

    import game.Game;
    import game.level.brick.CubePair;
    import game.level.brick.SmartBrick;

    import tutorial.LevelsVoodoo;

    public class TutorialishLevel extends Level
{
	private const BRICKY_ALPHA:Number = 0.5;

	private var _levelData:Array;
	private var _currentStep:int = 0;
	private var _keyboardSim:KeyboardSim;
	private var _gameLink:Game;

	public function TutorialishLevel(level:int, showCellsAnim:Boolean, $gameLink:Game)
	{
		_gameLink = $gameLink;
		_levelData = LevelsVoodoo.getLevelWalkthrough(level);

		_keyboardSim = new KeyboardSim(_levelData.indexOf("s") != -1);
		addChild(_keyboardSim);

		super(level, showCellsAnim);
	}

	override protected function createField(playCellsAnim:Boolean):void
	{
		_field = new Field(_id, playCellsAnim);
		_gameLink.addChild(_field);
	}

	override protected function reDispatch(event:RequestEvent):void
	{
		//no dispatching of restart & completed events
	}

	override protected function createBrick():void
	{
		_brick = new SmartBrick(_id);
		_brick.alpha = BRICKY_ALPHA;
		_brick.addEventListener(RequestEvent.STARTED_DYING, onStartedDying);
		_brick.addEventListener(RequestEvent.SPLITTED, createCubes);
		_brick.addEventListener(RequestEvent.UPDATE_TUTORIAL, tryDoNextStep);
		_brick.updatePosition();
		_gameLink.addChild(_brick);

		if (_levelData[0] == "l" || _levelData[0] == "d")
		{
			Misc.delayCallback(repositionBrick, 50);
		}
	}

	private function repositionBrick():void
	{
		_gameLink.setChildIndex(_brick, _gameLink.numChildren - 1); //it'll make brick from this level on Top of Brick from usual level
	}

	override protected function createCubes(event:RequestEvent):void
	{
		_cubesPair = new CubePair(event.stuff, this, BRICKY_ALPHA);
		_cubesPair.addEventListener(RequestEvent.CUBES_UNITED, onCubesUnited);
		_cubesPair.addEventListener(RequestEvent.UPDATE_TUTORIAL, tryDoNextStep);
	}

	private function tryDoNextStep(event:RequestEvent = null):void
	{
		if (_levelData.length == _currentStep)  //tutorial finished already
		{
			clean();
			_keyboardSim.die();
			Misc.delayCallback(function():void{dispatchEvent(new RequestEvent(RequestEvent.TUTORIAL_SHOWN))}, 600); //let the animation play
			return;
		}

		var switched:Boolean = false;

		if (_levelData[_currentStep] == "u")
		{
			_keyboardSim.doUp();
			doUp();
		}
		else if (_levelData[_currentStep] == "d")
		{
			_keyboardSim.doDown();
			doDown();
		}
		else if (_levelData[_currentStep] == "l")
		{
			_keyboardSim.doLeft();
			doLeft();
		}
		else if (_levelData[_currentStep] == "r")
		{
			_keyboardSim.doRight();
			doRight();
		}
		else if (_levelData[_currentStep] == "s")
		{
			_keyboardSim.doSpace();
			trySwitchCubes();
			switched = true;
		}

		_currentStep++;

		if (switched)        //force next move
			tryDoNextStep();
	}

	public function prepareForAnimation():void
	{
		_gameLink.removeChild(_field);
		_gameLink.removeChild(_brick);

		addChild(_field);
		addChild(_brick);
	}

	private function clean():void
	{
		_brick.removeEventListener(RequestEvent.UPDATE_TUTORIAL, tryDoNextStep);
		if (_cubesPair && _cubesPair.hasEventListener(RequestEvent.STEP))
			_brick.removeEventListener(RequestEvent.UPDATE_TUTORIAL, tryDoNextStep);
	}

	public function die():void
	{
		clean();
	}
}
}
