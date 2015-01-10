package game.level
{
import events.RequestEvent;

import flash.display.DisplayObject;
import flash.display.Sprite;

import game.Directions;
import game.level.brick.CubePair;
import game.level.brick.SmartBrick;

/**
 * ...
 * @author Alexey Kuznetsov
 */
public class Level extends Sprite
{
	public static var currentLevelStepsCount:int = 0; //amount of steps it takes user to complete level is written here
	public static var stepsHistory:String = ""; //for development only. Steps for current level

	protected var _brick:SmartBrick;
	protected var _cubesPair:CubePair;
	protected var _id:int;
	protected var _field:Field;

	public function Level(level:int, playCellsAnim:Boolean = true)
	{
		currentLevelStepsCount = 0;
		stepsHistory = "";

		_id = level;

		createField(playCellsAnim);
		createBrick();
	}

	protected function createField(playCellsAnim:Boolean):void
	{
		_field = new Field(_id, playCellsAnim);
		addChild(_field);
	}

	protected function createBrick():void
	{
		_brick = new SmartBrick(_id);
		_brick.addEventListener(RequestEvent.STARTED_DYING, onStartedDying);
		_brick.addEventListener(RequestEvent.SPLITTED, createCubes);
		_brick.addEventListener(RequestEvent.LEVEL_COMPLETED, reDispatch);
		_brick.addEventListener(RequestEvent.RESTART_LEVEL, reDispatch);
		_brick.updatePosition();
		addChild(_brick);
	}

	/**
	 * This func is overriden in Tutorialish level, so no restart / completed events get dispatched
	 * @param event
	 */
	protected function reDispatch(event:RequestEvent):void
	{
		EventHub.dispatch(new RequestEvent(event.type));
	}

	protected function createCubes(event:RequestEvent):void
	{
		_cubesPair = new CubePair(event.stuff, this);
		_cubesPair.addEventListener(RequestEvent.CUBES_UNITED, onCubesUnited);
		_cubesPair.addEventListener(RequestEvent.RESTART_LEVEL, reDispatch);
	}

	protected function onCubesUnited(event:RequestEvent):void
	{
		_cubesPair.clear();
		_brick.unite(event.stuff);
		_cubesPair = null;
	}

	protected function onStartedDying(event:RequestEvent):void
	{
		event.target.parent.setChildIndex(event.target as DisplayObject, 0); //brick or cube is being moved behind the field
		Misc.delayCallback(Field.playCellDyingAnim, 500);
	}

	public function doRight():void
	{
		_brick.nextDirection = Directions.DIR_RIGHT;
		if (_cubesPair)
			_cubesPair.currentCube.nextDirection = Directions.DIR_RIGHT;
	}

	public function doLeft():void
	{
		_brick.nextDirection = Directions.DIR_LEFT;
		if (_cubesPair)
			_cubesPair.currentCube.nextDirection = Directions.DIR_LEFT;
	}

	public function doUp():void
	{
		_brick.nextDirection = Directions.DIR_UP;
		if (_cubesPair)
			_cubesPair.currentCube.nextDirection = Directions.DIR_UP;
	}

	public function doDown():void
	{
		_brick.nextDirection = Directions.DIR_DOWN;
		if (_cubesPair)
			_cubesPair.currentCube.nextDirection = Directions.DIR_DOWN;
	}

	public function trySwitchCubes():void
	{
		if (_cubesPair)
			_cubesPair.selectCube();

		stepsHistory += "s";
	}

	public function get id():int
	{
		return _id;
	}

	public function hideField():void
	{
		_field.visible = false;
	}

	public function showField():void
	{
		_field.visible = true;
	}
}

}