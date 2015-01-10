/**
 * Author: Alexey
 * Date: 6/11/12
 * Time: 9:51 PM
 */
package game.level.brick
{
import caurina.transitions.Tweener;

import events.RequestEvent;

import flash.display.Sprite;

import game.level.Field;
import game.level.Level;

public class CubePair extends Sprite
{
	public var currentCube:Cube;

	private var firstCube:Cube;
	private var secondCube:Cube;

	private var pointX:int;
	private var pointY:int;
	private var levelLink:Level;

	private var dying:Boolean = false;
	private var united:Boolean = false;

	public function CubePair(cubesData:Object, levelLink:Level, bricksAlpha:Number = 1)
	{
		this.levelLink = levelLink;
		firstCube = new Cube(cubesData.x1, cubesData.y1);
		firstCube.mc.gotoAndPlay("appear");
		firstCube.addEventListener(RequestEvent.STARTED_DYING, onStartedDying);
		firstCube.addEventListener(RequestEvent.STEP, checkForJoining);
		firstCube.addEventListener(RequestEvent.RESTART_LEVEL, redispatch);
		firstCube.alpha = bricksAlpha;
		levelLink.addChild(firstCube);

		secondCube = new Cube(cubesData.x2, cubesData.y2);
		secondCube.mc.gotoAndPlay("appear1");
		secondCube.addEventListener(RequestEvent.STARTED_DYING, onStartedDying);
		secondCube.addEventListener(RequestEvent.STEP, checkForJoining);
		secondCube.addEventListener(RequestEvent.RESTART_LEVEL, redispatch);
		secondCube.alpha = bricksAlpha;
		levelLink.addChild(secondCube);

		selectCube(true);
		doRelativePositioning();
	}

	private function redispatch(event:RequestEvent):void
	{
		 dispatchEvent(new RequestEvent(event.type));
	}

	private function onStartedDying(event:RequestEvent):void
	{
		/*
		 * For some reason when cube is added to Level as a child
		 * Level ain't picking up either event or event with bubbles=true.
		 */

		dying = true;

		levelLink.setChildIndex(event.currentTarget as Cube, 0);
		levelLink.setChildIndex(getOtherCube(event.currentTarget as Cube), levelLink.numChildren - 1);

		Misc.delayCallback(Field.playCellDyingAnim, 500);

		Tweener.addTween(getOtherCube(event.currentTarget as Cube), {alpha:0, time:1, transition:"easeOutSine", delay:0.5});
	}

	public function selectCube(firstForce:Boolean = false):void
	{
		currentCube = firstForce ? firstCube : (currentCube != firstCube ? firstCube : secondCube);
		currentCube.mc.selectcube.play(); //one cube goes to left on start.
	}

	private function checkForJoining(e:RequestEvent):void
	{
		if (dying || united)
			return;

		pointX = firstCube.positionX;
		pointY = firstCube.positionY;

		doRelativePositioning();

		if (firstCube.positionX + 1 == secondCube.positionX && firstCube.positionY == secondCube.positionY)
		{
			joinBlocks("long", true);
		}
		else if (firstCube.positionX - 1 == secondCube.positionX && firstCube.positionY == secondCube.positionY)
		{
			joinBlocks("long", false);
		}
		else if (firstCube.positionX == secondCube.positionX && firstCube.positionY - 1 == secondCube.positionY)
		{
			joinBlocks("far", true);
		}
		else if (firstCube.positionX == secondCube.positionX && firstCube.positionY + 1 == secondCube.positionY)
		{
			joinBlocks("far", false);
		}

		dispatchEvent(new RequestEvent(RequestEvent.UPDATE_TUTORIAL));
	}

	private function doRelativePositioning():void
	{
		var upperCube:Cube;

		if (firstCube.positionY > secondCube.positionY || (firstCube.positionY == secondCube.positionY && firstCube.positionX > secondCube.positionX))
			upperCube = firstCube;
		else
			upperCube = secondCube;

		if (levelLink.getChildIndex(upperCube) < levelLink.getChildIndex(upperCube == firstCube ? secondCube : firstCube))
		{
			levelLink.swapChildren(firstCube, secondCube);
		}
	}

	private function joinBlocks(type:String, slip:Boolean):void
	{
		trace("joinBlocks!");

		united = true;

		firstCube.visible = false;
		secondCube.visible = false;

		var targetX:int = pointX;
		var targetY:int = pointY;

		if (type == "long")
		{
			if (!slip)
				targetX--;
		}
		if (type == "far")
		{
			if (!slip)
				targetY++;
		}

		dispatchEvent(new RequestEvent(RequestEvent.CUBES_UNITED, {x:targetX, y:targetY, type:type}));
	}

	public function clear():void
	{
		levelLink.removeChild(firstCube);
		levelLink.removeChild(secondCube);

		firstCube = null;
		secondCube = null;
	}

	private function getOtherCube(cube:Cube):Cube
	{
		return cube == firstCube ? secondCube : firstCube;
	}
}
}
