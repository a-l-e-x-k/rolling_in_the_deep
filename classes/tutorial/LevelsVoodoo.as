/**
 * Author: Alexey
 * Date: 6/14/12
 * Time: 10:49 PM
 */
package tutorial
{
import flash.utils.Dictionary;

/**
 * When user skips level he sees walkthrough
 * which shows him that level is really possible to complete and gives pleasing "a-ha" moment.
 *
 * Plus used for tutorials.
 */
public class LevelsVoodoo
{
	public static var stepsToComplete:Dictionary;
	public static const tutorialLevels:Array = [1, 16, 26, 28, 51]; //ids of levels for which tutorial should be shown: 1st level, weak tiles, ease switches, hard switches, spolitters

	public function LevelsVoodoo()
	{
	}

	/**
	 * Checks if passed level is tutorial level (tutorial shown for everybody) and returns it's data if true
	 * @param levelID
	 * @return
	 */
	public static function tryGetTutorial(levelID:int):Array
	{
		if (tutorialLevels.indexOf(levelID) == -1)
			return null;

		return getLevelWalkthrough(levelID);
	}

	/**
	 * Gets level walkthrough
	 * @param levelID
	 * @return
	 */
	public static function getLevelWalkthrough(levelID:int):Array
	{
		if (!stepsToComplete)
			initDict();

		return stepsToComplete[levelID].split("");
	}

	private static function initDict():void
	{
		stepsToComplete = new Dictionary();
		stepsToComplete[1] = "uurrddrruu";
		stepsToComplete[2] = "rruuuurrrrddllddrrrr";
		stepsToComplete[3] = "urrrrurrdrrrrd";
		stepsToComplete[4] = "urrruurrru";
		stepsToComplete[5] = "urrdrddldlld";
		stepsToComplete[6] = "ddldrrrrrrruull";
		stepsToComplete[7] = "lluurrrruuuurrrrdddd";
		stepsToComplete[8] = "drdrddlddrrddll";
		stepsToComplete[9] = "ddllddddllddll";
		stepsToComplete[10] = "uurrdluuurrrrdddlurrrr";
		stepsToComplete[11] = "rrrddlurrdluurdlldddrruldddrruururuuldruuuu";
		stepsToComplete[12] = "lddrrrurdddlulllddrdlddrrururrruuruuldrrr";
		stepsToComplete[13] = "ddddddddldluruuullddddllulluuuullluuurr";
		stepsToComplete[14] = "urulluururululllllldrullldrdddddddrurrrrruluuuulldd";
		stepsToComplete[15] = "ddrruuuluuurrdrulllllllldddrddlldddrdrrrrrrrurdlur";
		stepsToComplete[16] = "rrdrruuruulllldll";
		stepsToComplete[17] = "ruululurrurdrr";
		stepsToComplete[18] = "llulldllluuururrrruulllllllluurrrurrdrrrdrruu";
		stepsToComplete[19] = "uuurdlurrrurrdrr";
		stepsToComplete[20] = "drulddrulddddlurrrrdluuuuldrruurdrdd";
		stepsToComplete[21] = "rdlurrdlurrrruldrruldrrrrddluru";
		stepsToComplete[22] = "urrrrrrrdrddlulddlllddd";
		stepsToComplete[23] = "urrrrrdruuuuuuuuur";
		stepsToComplete[24] = "urdluurdluuuuldrrrulddrrruuuurululldluuurdrrurrrdld";
		stepsToComplete[25] = "uldrurrrurrrrdruuuululdluluulllddddluluuurrrurrdrdrrru";
		stepsToComplete[26] = "uuruddrrrrrrr";
		stepsToComplete[27] = "ulrrdlurrruuuurdrrudrdddlruuullllll";
		stepsToComplete[28] = "uurrrurdllurruuuu";
		stepsToComplete[29] = "uldrurrrdruuuuldruuldruuudddlurddlurddddlulllluuuu";
		stepsToComplete[30] = "uuurdluurdlddddduuuuurulddruldddlllrrrrr";
		stepsToComplete[31] = "uuuruulurdrrurulullludrrrdrdldlluldrddlddrdluurrrrdrurrdrrllulldluluurrruurdluuurruu";
		stepsToComplete[32] = "ddrddrluurdldddurdlurrrruldrrudllurdllllurdluuurrrdurrrrdlurrdlulllllluldrddldrurrrrrrdrlulllllldluruurulluurrrdrulldrullllurdllurdrrr";
		stepsToComplete[33] = "ddrdluldllrrurddddddrullllldluruuuulurdlruldrddddldrurrrrrdluuuuulldd";
		stepsToComplete[34] = "rruuuurdlldldlluluuurururururdlur";
		stepsToComplete[35] = "urruuruuruuuldrrrddddrdldru";
		stepsToComplete[36] = "uurdlldluuurruulurrdddrrrrrrrruuululllurdrul";
		stepsToComplete[37] = "luruururddrrrdruulluuurrullllddllulldruldru";
		stepsToComplete[38] = "dluldldlurdllldruuulldddlddrrdrururdrdruurrdldrdlurdddllulldlluldrul";
		stepsToComplete[39] = "uuuuurdlurrrrlllllldlrurrurdllurdrrurdllurlrdllluuuu";
		stepsToComplete[40] = "uurrlllluluulluuurruldrdrdrrururrul";
		stepsToComplete[41] = "uluuulurrruuldrdudluulu";
		stepsToComplete[42] = "uurrrrrrrruululdllulludululdl";
		stepsToComplete[43] = "ddrrurddrurruullurdrruulululldllulddd";
		stepsToComplete[44] = "urdluuruuuurrllddrrddrruurdluuuruldrdlu";
		stepsToComplete[45] = "rrrrdrurruullldlurrurruuuludludllldlluldldrdd";
		stepsToComplete[46] = "lllllllluurdrrrrrruruuuuurullllllllldddddddrruuuuurrrrdrdldll";
		stepsToComplete[47] = "uldruuldrlruuurrrddrdrrudlulluruullluurrrrrrrd";
		stepsToComplete[48] = "uldrurrruudulrlluruuullddddulduuuuuurrrdrrddrddlddrrdrulddd";
		stepsToComplete[49] = "luruuddldruldlluurulllrruulluullulllu";
		stepsToComplete[50] = "uurrrruluruullururululll";
		stepsToComplete[51] = "rrrurururrurrrruusrrurururuululuuu";
		stepsToComplete[52] = "drurdrsldsllldldldlldddlrrrruursddsddldllulllldddlrrrrrrur";
		stepsToComplete[53] = "ddsdddlsrrdddrrrrrurrrrrrrrrdddrdddsrrruuurrrrrrdddrdduu";
		stepsToComplete[54] = "urrdluursrrdrrusdrrdrrdrrulluluulluusdllluluulluuuluurrrsdrddllllllr";
		stepsToComplete[55] = "rdlurrdlurrrurrdrddrdrullurdrddlddluruldsrrurrrddsurrrurrrdd";
		stepsToComplete[56] = "rrruldruuururururusurrdddlllluuuuuulluluddrrrusuurrruddrdsdllldu";
		stepsToComplete[57] = "uulsllrrdrrsrurlsldrdddrdsdldu";
		stepsToComplete[58] = "druldrrruldllllddrruruslldrrrruuuuldrrdluuruuluurusuuld";
		stepsToComplete[59] = "luruulurdddlllllluuuuruusuuuludlldluruurruulurdluurrrrdlrdrsrul";
		stepsToComplete[60] = "llddsdddsdddddddsdddlrrrsuudddrslldddrrrdsluulr";
		stepsToComplete[61] = "urdlururuullldrururrslululrdllddddddruldldd";
		stepsToComplete[62] = "dlurdlrrrllrduddlurrrdldlddrdrullurdrddrruurdddlllldurrddldsldlluulllud";
		stepsToComplete[63] = "urdrruulurddrruuurrrdsuuudldrulurdddsddddllluulllluuluuruuusurrddrddddddllluulllluuluuruuu";
		stepsToComplete[64] = "ddldrurrrurrrddsddrslllddrrrrrruuuuldddu";
		stepsToComplete[65] = "urdluurrdrdlsddlulllldlurrdlurlrrrruldrrdddrdlurrdulluuulduurdllurlrddullldddrrdulldruululuuuurrrrrddddsrddddrsrrddddrd";
		stepsToComplete[66] = "ldllulldllullddrdluuldrddrrdrrurdruldllluuddrrrurdldllldlluldrdrrrrrulurdrdlllllddrrrrrdlulluurrrrrruurrdddddluruld";
		stepsToComplete[67] = "drrururdluuldlulurrrrrrldrddsursurrl";
		stepsToComplete[68] = "dddldllrrurdruldddrrrrdrrsrrurrrrdsurrrrrsusrrd";
		stepsToComplete[69] = "dlurddlurdsddrrulsllllldurdluurdlddldrrrddrulldsuullrdddddrldruluurulddruldllldrldrulddduuurdluurdlddddd";
		stepsToComplete[70] = "lurdruldlldlrurrurdluldrulullsdsddusrusllsllllrrururruldruulsldsrddu";
		stepsToComplete[71] = "urdruldrruuuuululurddrrrudlluluurrrllsuullrrrdlruldlulllllllllldddrrdddrrrrrrdrddsuullllllllddddrrddrrrrrrdrdd";
		stepsToComplete[72] = "ddddlllululrdrdrrrrusldldlddllrurdlluddldldlldlsldldldddddrrrdrlulllulllluuusrurrruuuuururusululu";
		stepsToComplete[73] = "ruluururuldlldrddrrurrsullsuuruuuuddddrrrurdllluuuuulluurrruldllllulddd";
		stepsToComplete[74] = "urdlurururdrullludllldddrluuurruuruslluurrllddrrrrdddruldruldrrddldl";
		stepsToComplete[75] = "llulululululuusurururururuulululllruudulululldldldldrrllldlsdsdldurusururudururuusrdrdrrruururururlrurudulduuluulluluuuurururururursrurururlruuuululululululrdlruurrruusddlllululuurrruu";
		stepsToComplete[76] = "lluurrrulllddllurdrrddldruurdluluurrrrruduuululdlluluurdluldrlurdrulddrdrrurrddddddrr";
		stepsToComplete[77] = "uurdddddrrrddsdddlllldddduslud";
		stepsToComplete[78] = "urdluurdlluulluuudddrrdrddluulluruurrdrdrdrrrrrdluurdluldrlurdrulddrulllllululullddldrrddruuldrrulddruldrulrdlululluruurrdrdrdrrrrrdrruluullulullulullurddlurrdluurdllurrrrdrdrur";
		stepsToComplete[79] = "urdluurdlusruurrddsruduuurrddluulsluuurllddsdddrsrdudddlrruussdddllrsdlrlddrlluudlsullrrsdrsruldsldsrdu";
		stepsToComplete[80] = "ddrrdluuurrddddduuuuullllllddlurdrdrdluululllddrdddrrrdlullddlurrrurduldrrurrdddrruldllll";
		stepsToComplete[81] = "uurdluslrsldssulsursldslusdrslddsdlu";
		stepsToComplete[82] = "dldldruldddrululdrrddsrurusrruurudldlddddddrurdrdddrulldruuldrdllldlldlsrrusrrrduldrdrslduuuuddddlsuluu";
		stepsToComplete[83] = "lldddrulddddddddrudluuuuuuuurdudluuurruurrurudrrduduudrududrruluurdlrudulddldllldllddrrdddduuldrdddlduruuurldlurrrdddddddrulduldurdurduduldurdudlrluuuuuuullddluruuulluuuuullllllllddddd";
		stepsToComplete[84] = "uuulldrdllllluruurruulull";
		stepsToComplete[85] = "rrrrrrrrrrdddddddrrulddllllluuldrrrdddddrrulddrurrrrd";
		stepsToComplete[86] = "ruurdlluruuuuuuuuulrdrrdulldlurrururuldllllldlrurrrrrdddllddddddddddddsuusrrruuuuddddrrrrrruruuuddlurdllulllrduuusulllllllldddsuulllllllddu";
		stepsToComplete[87] = "uuuusuullldlllulllulllllulslullullsllluuuururrrrrrrrrrsulllllllluuururuurrrrrrrrrrlluuuusuullldlllulllullllllllluuuuururrrrrrrrrsululullllllllluuluuururrrrrrrrrsusuuuurusuld";
		stepsToComplete[88] = "ssdddddduuuuuuuuuuuuuururrrrrrrsuuuuuuuululllllllllrrrrrrdrlrddsllllludrrrrrrrrruruuuuuudrrdrddddsrrrrrrrrruruuuuuuuudlsulrsursdrrl";
		stepsToComplete[89] = "uuuulldlurdldlddrdrdrrrrrruulurddruluuruuluuulllulldlllurrrruldllllldldruurrrrrdrrrdldrdrlulurulllulllllddlldlddrddldrdrdrdrurrrrdrulldrullllllululudrdrdrrrrrrrrr";
		stepsToComplete[90] = "dlurdlddlllurdllldurrruldrrruldddddrrrrdruldrlullllurdluuuuurdrrrrulddrrrrrsuullllldddddrrddddddd";
		stepsToComplete[91] = "lddldruurdldruldrrrrrurrdrrrrdrulldruuldruuuuuldrddddllllrrrruuuulurlruruulluuruulllllldlurrulrrrrduldrddldlruruulurllldllllullldldlururduldldrlurddddslsrduluuurdlddrdluuurrrrrrrrddddrdlllldruuuruldrruldruld";
		stepsToComplete[92] = "urdruluuruldddrrrrrrrululuulusldddduuuuuurruullrrrddlurdrrddllddlddrrdruldrullluldurdrrrdlrluruuuuullurdluurrrrrdddrrurruurrddddlulllllddrdluullrrddruluurrrrrdrdddlluldlurulldldddlddrdrullururdrrrdddrdruuldruldr";
		stepsToComplete[93] = "uuuuuuuuddlddddrrdrsddrdddldlldddddurururusulululdddddddllddddrdluuulururrrllldldrddrdrurruruludrdldlldluldruruu";
		stepsToComplete[94] = "rddrdruldddddddddddddrullluulululurrrrrrrrrrrrrrrdluuuuuulurdrursursruur";
		stepsToComplete[95] = "urrdlurddrrrrddsddlllllduddlllldrdldddrrruurrdddsulrddrrrrrrddsddlllduddrrrurddlllddrdluuldrrrrdrruuludsulrddrrrrruusddlllluduuuulldlulurururrrrddddrruurdrrusuuld";
		stepsToComplete[96] = "lldlluldrrdlulllldllluldlurdruldlddddrdrrurdlldrurrurrrrdrulurdlrdlldrurrrrddllldllllddllululldlurrrddllddrrrrrrrddrulldruullrdrulllulrdrrrdruldurdllurdrrrurdlllluuurdrruuuuuuuru";
		stepsToComplete[97] = "rruurruurruuuullddlllllllluuuuururrrrrrrddrdldll";
		stepsToComplete[98] = "uullrrddlldluuurruulllulddrrdrudlulluurdrrrddlldddurrrrrruuddrrruldruuurdllllurdluuurrudruluuddrdruruuuuulllldruldrdduulurrldlurrrrddldruldllrrurdlurdddldlllllurulurrlldrdlluuuuldrdddlllllulluuuurrdd";
		stepsToComplete[99] = "uuuuulllllldrulurrrrruuurrrrrrrr";
		stepsToComplete[100] = "uudrdrururrrururdrururruruululdrululluululluldrrdlulllullrdddrruldrruuldldddrrrrurdrulldldllullddrrruurrdduurruuuuuululuulluurrrrdllulllldduullrrrrrrrdldru";
	}
}
}
