package  
{
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public final class UserData 
	{
		public static var currentLevel:int = 54;
		public static var levelsCompleted:int = 54;
		public static var id:String = "";
		public static var friends:Array; //frieds SocialPersons
		public static var name:String = "";
		public static var photoURL:String = "";

		public static function saveUserData($name:String, $photoURL:String):void
		{
			name = $name;
			photoURL = $photoURL;
		}
	}
}