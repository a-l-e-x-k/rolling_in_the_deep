<?php 
// echo "string";
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<link rel="stylesheet" href="css/style.css" type="text/css"/>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
<script type="text/javascript" src="js/fb.js"></script>
</head>
<body>
<div id="fb-root"></div>

<script type="text/javascript" language="javascript">
    application_id = 383868958337114;
    access_token = "";
    user_id = "";

    onFacebookAvailable[onFacebookAvailable.length] = makeRequestCheck;
    onFacebookAvailable[onFacebookAvailable.length] = createSWF;

    window.fbAsyncInit = function () {
        FB.init({
            appId:application_id, // App ID
            frictionlessRequests:true,
            status:true, // check login status
            cookie:true, // enable cookies to allow the server to access the session
            xfbml:true // parse XFBML
        });

        FB.Canvas.setAutoGrow();

        FB.getLoginStatus(function (response) {
            if (response.authResponse) {
                access_token = response.authResponse.accessToken;
                user_id = response.authResponse.userID;
                runOnFacebookAvailable();
            }
            else
            {
                //user has not login somehow
            }
        });
    };

    (function (d) {
        var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
        if (d.getElementById(id)) {
            return;
        }
        js = d.createElement('script');
        js.id = id;
        js.async = true;
        js.src = "//connect.facebook.net/en_US/all.js";
        ref.parentNode.insertBefore(js, ref);
    }(document));
</script>
<div id="pageContent">
    <br>
    <center>
        <div>
            <div class="fb-like" data-href="http://www.facebook.com/RollingInTheDeepPage" data-send="false" data-width="450"
                 data-show-faces="false"></div>
        </div>
    </center>
    <div id="flashContent"></div>
    <br>
</div>
</body>
</html>