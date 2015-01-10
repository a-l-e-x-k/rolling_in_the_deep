package levelSelector
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
 * ...
 * @author Alexey Kuznetsov
 */
public class ProgressShower extends Sprite
{
	private static const BAR_WIDTH:int = 423; //px width of bar
	private var bar:MovieClip;

	public function ProgressShower()
	{
		x = 192;
		y = 40;

		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}

	private function onAdded(event:Event):void
	{
		bar = new pbar();
		bar.mc.em.mask_mc.width = (UserData.levelsCompleted / 100) * BAR_WIDTH;
		bar.mc.em.ca.setRenderer(bar.mc.em.emitter.renderer);
		bar.mc.em.emitter.renderer.resize(bar.mc.em.mask_mc.width + 5, bar.mc.em.mask_mc.height);
		bar.mc.em.emitter.stop();
		bar.mc.em.emitter.start(20, true);
		bar.mc.progress_txt.htmlText = "<b>" + UserData.levelsCompleted.toString() + "/" + "100";
		bar.cacheAsBitmap = true;
		addChild(bar);
	}

	public function clean():void
	{
		bar.mc.em.emitter.stop();
		removeChild(bar);
	}
}

}