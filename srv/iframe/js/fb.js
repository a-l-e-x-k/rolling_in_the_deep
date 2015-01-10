// this array will contain a list of functions that will be called when facebook is fully loaded and user is logged in.
var onFacebookAvailable = [];
// will execute all queued up methods.
function runOnFacebookAvailable()
{
	console.log(onFacebookAvailable.length);
	for (var i = 0; i != onFacebookAvailable.length; i++) 
	{
		var cb = onFacebookAvailable[i];
		cb();
	}
}

function makeRequestCheck()
{
  if (document.location.href.indexOf("request_ids") != -1) //user came via request. deleting requests
  {
	  var finishIndex = document.location.href.indexOf("&") == -1 ? document.location.href.length : document.location.href.indexOf("&");
	  var requestIDs = document.location.href.substring(document.location.href.indexOf("=") + 1, finishIndex); //extract all the request string, beginning from requests ids start
	  var idsArray = requestIDs.split("%2C"); //%2c = ","
	  for (var i = 0; i < idsArray.length; i++) //ask FB to remove IDs
	  {
		  var id = new Number();
		  id = idsArray[i];
		  FB.api(id, 'delete', function(response) {
		  });
	  }
  };			
}

function createSWF()
{
    var joinme = "";
    var numbers = "0123456789"; //id can be numeric only
    if (document.location.href.indexOf("join") != -1)  //user came via friend invite
    {
        var counter = document.location.href.indexOf("join") + 5;
        do
        {
            joinme += document.location.href.charAt(counter);
            counter++;
        }
        while (counter < document.location.href.length && numbers.indexOf(document.location.href.charAt(counter)) != -1)
    }

    var flashvars={
        "fb_access_token":access_token,
        "fb_user_id":user_id,
        "fb_application_id":application_id
    };

    var params = {
        menu: "false",
        "allowscriptaccess":"always",
        "wmode":"transparent"
    };
    var args={
        "allowscriptaccess":"always",
        "allowfullscreen":"true",
        "allownetworking":"all",
        "name":'flashContent'
    }

    var antiCache = new Date().getTime();

    swfobject.embedSWF("https://s3.amazonaws.com/rid_swf/application.swf?" + antiCache, "flashContent", "807", "760", "11.0", null, flashvars, params, args);
}

function showFriendInviter (levelsCount)
{
    if (levelsCount == 0)
        levelsCount = 1;

	FB.ui({method: 'apprequests',
		message: "I've completed " + levelsCount + ((levelsCount - 1) % 10 == 0 ? " level" : " levels" ) + " in this game! Can you beat me?",
		filters:["app_non_users"],
		title:"Invite friends"					
	}, requestCallback);
	
	function requestCallback()
	{
	};
};