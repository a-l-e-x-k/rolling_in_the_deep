/**
 * Author: Alexey
 * Date: 6/22/12
 * Time: 4:48 PM
 */
package popup
{
    import caurina.transitions.Tweener;

    import events.RequestEvent;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class CongratsPopup extends MovieClipContainer
{
	private var levelsToShow:int = 0;
	public function CongratsPopup(levelsToShow:int)
	{
		var darkener:Sprite = new Sprite();
		darkener.graphics.beginFill(0x000000, 0.4);
		darkener.graphics.drawRect(0, 0, Misc.APP_WIDTH, Misc.APP_HEIGHT + 100);
		darkener.x = -403;
		darkener.y = -374;
		addChild(darkener);

		super(new popa(), 403, 344);

		this.levelsToShow = levelsToShow;

		_mc.level_count_txt.text = levelsToShow;
		_mc.tell_btn.addEventListener(MouseEvent.CLICK, goTellFriends);
		_mc.close_btn.addEventListener(MouseEvent.CLICK, closePopup);
		_mc.close_btn.buttonMode = true;
		_mc.tell_btn.buttonMode = true;

		_mc.close_btn.visible = false;
		Misc.delayCallback(function():void{_mc.close_btn.visible = true;}, 3000);

		Misc.addSimpleButtonListeners(_mc.tell_btn);

		_mc.scaleX = _mc.scaleY = 0;
		Tweener.addTween(_mc, {scaleX:1, time:1, transition:"easeOutExpo"});
		Tweener.addTween(_mc, {scaleY:1, time:1, transition:"easeOutExpo"});
	}

	private function closePopup(event:Event):void
	{
		dispatchEvent(new RequestEvent(RequestEvent.IMREADY));
		this.parent.removeChild(this);
	}

	private function goTellFriends(event:MouseEvent):void
	{
		EventHub.addEventListener(RequestEvent.PUBLISH_COMPLETE, closePopup);
		Networking.socialNetworker.invokePublishDialog("I've completed " + levelsToShow + " challenging levels! Can you do better?", "http://pic.png");
	}
}
}
