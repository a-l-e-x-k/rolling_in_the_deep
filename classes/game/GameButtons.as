/**
 * Author: Alexey
 * Date: 6/11/12
 * Time: 9:12 PM
 */
package game
{
import events.RequestEvent;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class GameButtons extends Sprite
{
	public function GameButtons()
	{
		var backToLobby:MovieClip = new backbtn();
		backToLobby.x = 36;
		backToLobby.y = 32;
		backToLobby.addEventListener(MouseEvent.MOUSE_OVER, onOver);
		backToLobby.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		backToLobby.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		backToLobby.addEventListener(MouseEvent.CLICK, onClick);
		addChild(backToLobby);

		var skipBtn:MovieClip = new skipbtn();
		skipBtn.x = 716;
		skipBtn.y = 32;
		skipBtn.addEventListener(MouseEvent.MOUSE_OVER, onOver);
		skipBtn.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		skipBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		skipBtn.addEventListener(MouseEvent.CLICK, onClick);
		addChild(skipBtn);
	}

	private static function onClick(event:MouseEvent):void
	{
		event.currentTarget.gotoAndStop(1);
		if (event.currentTarget is backbtn)
			EventHub.dispatch(new RequestEvent(RequestEvent.GOTO_LEVEL_SELECT));
		else if (event.currentTarget is skipbtn)
			EventHub.dispatch(new RequestEvent(RequestEvent.SKIP_LEVEL));
	}

	private static function onDown(event:MouseEvent):void
	{
		event.currentTarget.gotoAndStop(3);
	}

	private static function onOut(event:MouseEvent):void
	{
		event.currentTarget.gotoAndStop(1);
	}

	private static function onOver(event:MouseEvent):void
	{
		if (event.currentTarget.currentFrame == 1)
			event.currentTarget.gotoAndStop(2);
	}
}
}
