package game.level
{
    import caurina.transitions.Tweener;

    import flash.display.Sprite;

    import game.level.cells.Bridge;
    import game.level.cells.EasySwitch;
    import game.level.cells.ExitCell;
    import game.level.cells.GlassCell;
    import game.level.cells.HardSwitch;
    import game.level.cells.OrangeCell;
    import game.level.cells.PurpleCell;
    import game.level.cells.RegularCell;
    import game.level.cells.SplitterCell;
    import game.level.cells.WhiteCell;

    /**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class Field extends Sprite
	{
		public static const X_GAP:int = 31;
		public static const Y_GAP:int = 15;
		public static const X_SHIFT:Number = 9.5;
		public static const Y_SHIFT:int = 5;
		private static const ANIM_TIME:Number = 1.5; //in seconds, amount of time cell's alpha may be increasing / decreasing
		private static var MAX_DELAY:Number = 0.5; //max delay before cell animation wil start playing (in seconds)

		public static var xStart:int;
		public static var yStart:int = 250;
		public static var fieldSize:int;
		public static var fieldData:Array;
		public static var switchData:Object;
		public static var splitData:Object;
		public static var tiles:Array = [];

		public function Field(level:int, playCellsAnim:Boolean)
		{
			fieldData = Levels.getLevel(level);
			fieldSize = level >= 81 ? 20 : 15;
			switchData = fieldData.length > fieldSize ? fieldData[fieldSize + 1] : null;
			splitData = fieldData.length > fieldSize + 1 ? fieldData[fieldSize + 2] : null;

			xStart = level >= 81 ? 0 : 110;
			
			var cellType:String = "";
			for (var i:int = 0; i < fieldSize; i++) //go in a line
			{
				tiles[i] = [];

				if (fieldData[i] is String)
					fieldData[i] = fieldData[i].split(""); //turn string into array

				for (var j:int = fieldSize - 1; j >= 0; j--) //go in a row
				{
					cellType = fieldData[i][j];
					if (cellType != Levels.EMPTY_CELL)
					{
						var tile:MovieClipContainer;
						switch (cellType) 
						{
							case Levels.REGULAR_CELL:
								tile = new RegularCell();
								break;		
							case Levels.EXIT_CELL:
								tile = new ExitCell();
								break;	
							case Levels.WEAK_TILE:
								tile = new GlassCell();
								break;
							case Levels.SPLITTER_TILE:
								tile = new SplitterCell();
								break;
							case Levels.REGULAR_WHITE_CELL:
								tile = new WhiteCell();
								break;
							case Levels.EASY_SWITCH_TILE:
								tile = new EasySwitch();
								break;
							case Levels.HARD_SWITCH_TILE:
								tile = new HardSwitch();
								break;
							case Levels.REGULAR_PURPLE_CELL:
								tile = new PurpleCell();
								break;
							case Levels.REGULAR_ORANGE_CELL:
								tile = new OrangeCell();
								break;
							case Levels.BRIDGE_DOWN:
								tile = new Bridge(Bridge.DIR_DOWN);
								break;
							case Levels.BRIDGE_UP:
								tile = new Bridge(Bridge.DIR_UP);
								break;
							case Levels.BRIDGE_LEFT:
								tile = new Bridge(Bridge.DIR_LEFT);
								break;
							case Levels.BRIDGE_RIGHT:
								tile = new Bridge(Bridge.DIR_RIGHT);
								break;
							case Levels.BRIDGE_DOWN_P:
								tile = new Bridge(Bridge.DIR_DOWN, true);
								break;
							case Levels.BRIDGE_UP_P:
								tile = new Bridge(Bridge.DIR_UP, true);
								break;
							case Levels.BRIDGE_LEFT_P:
								tile = new Bridge(Bridge.DIR_LEFT, true);
								break;
							case Levels.BRIDGE_RIGHT_P:
								tile = new Bridge(Bridge.DIR_RIGHT, true);
								break;
						}

						tile.x = xStart + j * X_GAP + i * X_SHIFT;
						tile.y = yStart - j * Y_SHIFT + i * Y_GAP;
						tiles[i][j] = tile;
						addChild(tile);
					}
				}
			}

			if (playCellsAnim)
				playCellBornAnim();

			Misc.delayCallback(function():void{cacheAsBitmap = true;}, ANIM_TIME + MAX_DELAY); //all fiedld gets cahed
		}

	public static function playCellBornAnim():void
	{
		for (var i:int = 0; i < tiles.length; i++)
		{
			for each (var cell:MovieClipContainer in tiles[i])
			{
				cell.alpha = 0;
				Tweener.addTween(cell, {alpha:1, time:ANIM_TIME, delay:Misc.randomNumber(MAX_DELAY * 1000) / 1000, transition:"easeOutExpo"});
			}
		}
	}

	public static function playCellDyingAnim():void
	{
		for (var i:int = 0; i < tiles.length; i++)
		{
			for each (var cell:MovieClipContainer in tiles[i])
			{
				Tweener.addTween(cell, {alpha:0, time:ANIM_TIME, delay:Misc.randomNumber(MAX_DELAY * 1000) / 1000, transition:"easeOutExpo"});
			}
		}
	}
}

}