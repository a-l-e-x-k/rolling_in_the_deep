<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Alexey
 * Date: 6/9/12
 * Time: 12:32 AM
 * To change this template use File | Settings | File Templates.
 */
ini_set("display_errors", 1);
include ("Config.php");
include ("DB.inc.php");
$db = DB::getInstance();

switch ($_REQUEST['req'])
{
    case "init":
        initUser($_REQUEST['uid']);
        break;
    case "start":
        startLevel($_REQUEST['uid'], $_REQUEST['lvl']);
        break;
    case "restart":
        restartLevel($_REQUEST['uid'], $_REQUEST['st']);
        break;
    case "finish":
        finishLevel($_REQUEST['uid'], $_REQUEST['st']);
        break;
    case "getFriendsLevels":
        getFriendsLevels($_REQUEST['uids']);
        break;
}

function initUser($uid)
{
    global $db;

    $levelsCompleted = 0;
    $result = $db->query("SELECT * FROM users WHERE id = $uid");

    if (mysqli_num_rows($result) == 0) {
        $db->query("INSERT INTO users (`id`, `registrationDate`) VALUES (" . $uid . "," . "'" . date('Y-m-d H:i:s') . "')");
        insertNewLevel($uid, 1);
    }
    else
    {
        $user = mysqli_fetch_assoc($result);
        $levelsCompleted = $user['levelsCompleted'];
    }

    echo $levelsCompleted;
}

/**
 * Triggered whenever user starts a level to update his current level and stats
 * @param $uid
 * @param $levelID
 */
function startLevel($uid, $levelID)
{
    global $db;
    $result = $db->query("SELECT * FROM levelStats WHERE uid = $uid AND levelNumber = $levelID");
    if (mysqli_num_rows($result) == 0) {
        insertNewLevel($uid, $levelID);
    }
    else
    {
        $db->query("UPDATE levelStats SET attemptsCount = attemptsCount + 1, lastAttemptStartedAt = '" . date('Y-m-d H:i:s') . "' WHERE (uid = $uid AND levelNumber = $levelID)");
    }

    $db->query("UPDATE users SET currentLevel = $levelID WHERE id = $uid");
}

/**
 * Inserts new level for stats
 * @param $uid
 * @param $levelID
 */
function insertNewLevel($uid, $levelID)
{
    global $db;
    $db->query("INSERT INTO levelStats (`uid`, `levelNumber`, `startedAt`, `lastAttemptStartedAt`) VALUES (" . $uid . "," . $levelID . ",'" . date('Y-m-d H:i:s') . "','" . date('Y-m-d H:i:s') . "')");
}

/**
 * @param $uid
 * @param $stepsCount amount of steps at the previous attempt
 */
function restartLevel($uid, $stepsCount)
{
    global $db;
    $result = $db->query("SELECT * FROM users WHERE id = $uid");
    $user = mysqli_fetch_assoc($result);
    $userLvl = $user['currentLevel'];
    $db->query("UPDATE levelStats SET attemptsCount = attemptsCount + 1, stepsCount = stepsCount + $stepsCount, lastAttemptStartedAt = '" . date('Y-m-d H:i:s') . "' WHERE (uid = $uid AND levelNumber = $userLvl)");
}

/**
 * Triggered when client says it finished level
 * @param $uid
 * @param $stepsCount
 */
function finishLevel($uid, $stepsCount)
{
    global $db;
    $result = $db->query("SELECT * FROM users WHERE id = $uid");
    $user = mysqli_fetch_assoc($result);
    $currentLevel = $user['currentLevel'];
    $levelsCompletedBefore = $user['levelsCompleted'];
    $levelsCompleted = $user['levelsCompleted'];

    if ($currentLevel == $levelsCompleted + 1) //level-up only if user was playing last opened level
        $levelsCompleted++;

    $currentLevelData = $db->query("SELECT levelNumber, lastAttemptStartedAt FROM levelStats WHERE uid = $uid AND levelNumber = $currentLevel");
    $currentLevelArr = mysqli_fetch_assoc($currentLevelData);
    $lastAttemptStartedAt = strtotime($currentLevelArr['lastAttemptStartedAt']);
    $timePassed = time() - $lastAttemptStartedAt;

    //TODO: do chack based on time passed (anti-cheat)

    $skippedViaCredits = (isset($_REQUEST['skc']) ? 1 : 0);
    $db->query("UPDATE levelStats SET attemptsCount = attemptsCount + 1, stepsCount = stepsCount + $stepsCount, completedInSteps = $stepsCount, skippedViaCredits = $skippedViaCredits, finishedAt = '" . date('Y-m-d H:i:s') . "' WHERE (uid = $uid AND levelNumber = $currentLevel)");
    $db->query("UPDATE users SET currentLevel = currentLevel + 1, levelsCompleted = $levelsCompleted WHERE id = $uid");

    if ($currentLevel < 100) {
        $currentLevel++;
        startLevel($uid, $currentLevel);
    }

    if (($levelsCompleted == 1 && $levelsCompletedBefore == 0) ||
        (($levelsCompleted % 5 == 0) && (($levelsCompletedBefore + 1) % 5 == 0))) //1st level or other levels which number is devisible by 5 (e.g. 5, 10, 20, 45)
        postAchievement("http://boomboomb.herokuapp.com/achievs/a" . $levelsCompleted . ".html", $uid);

    echo "ok@" . $currentLevel . "@" . $levelsCompleted . "@seconds passed: " . $timePassed;
}

function postAchievement($achievementURL, $uid)
{
    $access_token = "YOUR_ACCESS_TOKEN"; //it'll change if app secret will change

    $url = 'https://graph.facebook.com/' . $uid .  '/achievements';
    // The submitted form data, encoded as query-string-style
    // name-value pairs
    $body = 'achievement=' . $achievementURL . "&access_token=" . $access_token;
    $c = curl_init ($url);
    curl_setopt ($c, CURLOPT_POST, true);
    curl_setopt ($c, CURLOPT_POSTFIELDS, $body);
    curl_setopt ($c, CURLOPT_RETURNTRANSFER, true);
    $page = curl_exec ($c);
    curl_close ($c);
}

function getFriendsLevels($uids)
{
    global $db;

    $uidsarr = explode(",", $uids);
    foreach ($uidsarr as $key => $value) //remove empty ids
    {
        if ($value == "")
           unset($uidsarr[$key]);
    }

    $result = $db->query("SELECT id, levelsCompleted FROM users WHERE id IN (" . join(",", $uidsarr) . ")");

    $resultstr = "";
    while ($dude = mysqli_fetch_assoc($result))
    {
        $resultstr .= "!" . $dude['id'] . "," . $dude['levelsCompleted'];
    }

    echo $resultstr;
}