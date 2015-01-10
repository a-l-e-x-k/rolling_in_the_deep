/**
 * Author: Alexey
 * Date: 6/10/12
 * Time: 6:13 PM
 */
package game.level.cells
{
    public class Bridge extends MovieClipContainer
{
	public static const DIR_UP:uint = 0;
	public static const DIR_DOWN:uint = 1;
	public static const DIR_RIGHT:uint = 2;
	public static const DIR_LEFT:uint = 3;

	private var _direction:uint;
	private var _on:Boolean;

	public function Bridge(direction:uint, power:Boolean = false)
	{
		super();

		_direction = direction;

		removeChild(_mc);
		if (_direction == DIR_UP)
			_mc = new upbridge();
		else if (_direction == DIR_DOWN)
			_mc = new downbridge();
		else if (_direction == DIR_RIGHT)
			_mc = new bridgeright();
		else if (_direction == DIR_LEFT)
			_mc = new bridgeleft();

		addChild(_mc);

		if (power) //goes at frame where bridge is opened
		{
			_on = true;
			_mc.gotoAndStop("off");
			_mc.gotoAndStop(_mc.currentFrame - 1); //"off" labes is set on frame where bridge is already switching off
		}
	}

	public function turnOn():void
	{
		_mc.gotoAndPlay("on");
		_on = true;
	}

	public function turnOff():void
	{
		_mc.gotoAndPlay("off");
		_on = false;
	}

	public function get on():Boolean
	{
		return _on;
	}
}
}
