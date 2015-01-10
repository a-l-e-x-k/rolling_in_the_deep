/**
 * Author: Alexey
 * Date: 6/22/12
 * Time: 2:37 PM
 */
package game.level
{
import caurina.transitions.Tweener;

public class KeyboardSim extends MovieClipContainer
{
	private const COLOR:uint = 0x00CCFF;
	private const WHITE:uint = 0xFFFFFF;
	private var _spacebarActivated:Boolean = false;

	public function KeyboardSim(withSpacebar:Boolean)
	{
		super(new tutomc(), 35, 555);
		if (withSpacebar)
			_mc.gotoAndStop(2);

		alpha = 0;
		Tweener.addTween(this, {alpha:1, time:1.2, delay:1.2, transition:"easeOutSine"});
	}

	public function doUp():void
	{
		clearSelection();
		Misc.applyColorTransform(_mc.keys_mc.up_mc, COLOR);
	}

	public function doDown():void
	{
		clearSelection();
		Misc.applyColorTransform(_mc.keys_mc.down_mc, COLOR);
	}

	public function doLeft():void
	{
		clearSelection();
		Misc.applyColorTransform(_mc.keys_mc.left_mc, COLOR);
	}

	public function doRight():void
	{
		clearSelection();
		Misc.applyColorTransform(_mc.keys_mc.right_mc, COLOR);
	}

	public function doSpace():void
	{
		clearSelection();
		_spacebarActivated = true;
		Misc.applyColorTransform(_mc.bar_mc.bar_mc, COLOR);
	}

	public function die():void
	{
		Tweener.addTween(this, {alpha:0, time:1, transition:"easeOutExpo", delay:0.3});
	}

	private function clearSelection():void
	{
		if (_spacebarActivated)
		{
			Misc.delayCallback(function():void{
				_spacebarActivated = false;
				Misc.applyColorTransform(_mc.bar_mc.bar_mc, WHITE);}, 450)
		}
		Misc.applyColorTransform(_mc.keys_mc.right_mc, WHITE);
		Misc.applyColorTransform(_mc.keys_mc.left_mc, WHITE);
		Misc.applyColorTransform(_mc.keys_mc.down_mc, WHITE);
		Misc.applyColorTransform(_mc.keys_mc.up_mc, WHITE);
	}
}
}
