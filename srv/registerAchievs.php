<?php
/**
 * Created by JetBrains PhpStorm.
 * User: Alexey
 * Date: 6/25/12
 * Time: 12:33 AM
 * To change this template use File | Settings | File Templates.
 */
/**
 * To register achievements do:
 *
 * 1. https://graph.facebook.com/oauth/access_token?
client_id=YOUR_APP_ID
&client_secret=YOUR_APP_SECRET
&grant_type=client_credentials
 *      to get ACCESS_TOKEN
 *
 * 2. Issue POST requests as said here (for each achievement)
 * https://developers.facebook.com/blog/post/539/
 */
ini_set("display_errors", 1);

$APP_ID = 383868958337114;
$access_token = "YOUR_ACCESS_TOKEN"; //it'll change if app secret will change

$url = 'https://graph.facebook.com/' . $APP_ID .  '/achievements';
// The submitted form data, encoded as query-string-style
// name-value pairs

for ($i = 20; $i < 101; $i += 5) //achievs a10, a15, a20, etc
{
    $achievementURL = "http://boomboomb.herokuapp.com/achievs/a" . $i . ".html";
    $body = 'achievement=' . $achievementURL . "&display_order=" . $i . "&access_token=" . $access_token;
    $c = curl_init ($url);
    curl_setopt ($c, CURLOPT_POST, true);
    curl_setopt ($c, CURLOPT_POSTFIELDS, $body);
    curl_setopt ($c, CURLOPT_RETURNTRANSFER, true);
    curl_exec ($c);
    curl_close ($c);
}
