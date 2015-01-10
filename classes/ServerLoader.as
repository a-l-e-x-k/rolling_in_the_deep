package
{
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.utils.getTimer;
import flash.utils.setTimeout;

public class ServerLoader
{
	private static var _requestCount:int = 0;
	private static var _badRequestCount:int = 0;

	private static var _requests:Array = [];

	private var _loader:URLLoader;
	private var _request:URLRequest;
	private var _callBack:Function;
	private var _callbackParams:Array;
	private var _params:Object;
	private var _startTime:uint;

	private var _tries:int = 0;

	public function ServerLoader(url:String, callBack:Function, params:* = null, method:String = "post", callbackParams:Array = null)
	{
		_request = new URLRequest(url);
		_loader = new URLLoader();
		_callBack = callBack;
		_callbackParams = callbackParams;
		_params = params;

		_request.method = method;
		_request.data = new URLVariables();

		for (var param:String in params)
		{
			_request.data[param] = params[param];
		}

		_loader.addEventListener(Event.COMPLETE, onComplite);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onError);

	}

	public function load(force:Boolean = false):void
	{
		if (_requestCount > 0 && !force)
		{
			_requests.push(this)
		}
		else
		{
			trace("[Loading]", _params.req);

			_startTime = getTimer();
			_loader.load(_request);

			if (!force)
				_requestCount++;
		}
	}

	public function endRequest(data:String):void
	{
		if (_callBack != null)
		{
			try
			{
				if (_callbackParams)
				{
					_callbackParams.unshift(data);
					_callBack.apply(null, _callbackParams);
				}
				else
				{
					_callBack(data);
				}
			}
			catch (error:Error)
			{
				trace(error.getStackTrace());
			}
		}

		_requestCount--;

		if (_requests.length > 0)
		{
			_requests.shift().load();
		}
	}

	private function onComplite(event:Event):void
	{
		var time:Number = (getTimer() - _startTime) / 1000;
		trace("[Response (" + time + " sec)]", event.target.data);
		endRequest(event.target.data);
	}

	private function onError(event:Event):void
	{
		_badRequestCount++;

		_tries++;
		if (_tries < 3)
		{
			setTimeout(load, 1000, true);
		}
		else
		{
			endRequest("error");
		}
	}
}
}