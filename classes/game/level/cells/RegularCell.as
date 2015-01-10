package game.level.cells 
{
	import caurina.transitions.Tweener;
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class RegularCell extends MovieClipContainer 
	{
		
		public function RegularCell() 
		{
			super(new regularTile());
			playStartAnimation();
		}
		
		protected function playStartAnimation():void
		{
			Tweener.addTween(_mc, { alpha:1, time:(0.5 + Math.random() / 2), transition:"easeOutSine" } );
		}
		
	}

}