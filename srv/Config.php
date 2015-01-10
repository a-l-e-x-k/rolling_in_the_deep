<?php
$url=parse_url(getenv("CLEARDB_DATABASE_URL"));

$server = $url["host"];
$username = $url["user"];
$password = $url["pass"];
$db = substr($url["path"],1);


define('DB_HOST', $server);
define('DB_USER', $username);
define('DB_PASSWORD', $password);
define('DB_NAME', $db);