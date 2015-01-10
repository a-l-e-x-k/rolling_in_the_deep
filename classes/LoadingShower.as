/**
 * Author: Alexey
 * Date: 6/22/12
 * Time: 11:57 PM
 */
package
{
public class LoadingShower extends MovieClipContainer
{
	public function LoadingShower()
	{
		super(new loadingAnim());
		x = Misc.APP_HEIGHT / 2 - _mc.height / 2;
		y = Misc.APP_WIDTH / 2 - _mc.width / 2;
	}
}
}
