/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013-2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * For information about the licensing and copyright please
 * contact Andras Csizmadia at andras@vpmedia.eu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */
package hu.vpmedia.net {
import flash.errors.IllegalOperationError;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import hu.vpmedia.net.utils.ConcurrencyTypes;
import hu.vpmedia.utils.NetUtil;

/**
 * TBD
 */
public class HTTPConnection extends BaseTransmitter {

    //----------------------------------
    //  Variables
    //----------------------------------

    /**
     * TBD
     */
    private var _connection:URLLoader;

    /**
     * TBD
     */
    private var _config:HTTPConnectionVars;

    /**
     * TBD
     */
    private var _busy:Boolean;

    /**
     * TBD
     */
    private var _lastResult:*;

    /**
     * TBD
     */
    private var _lastError:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * TBD
     */
    public function HTTPConnection(params:HTTPConnectionVars) {
        _config = params;
        super();
    }

    //----------------------------------
    //  URLLoader
    //----------------------------------

    /**
     * TBD
     */
    override protected function initialize():void {
        _connection = new URLLoader();
        _connection.dataFormat = _config.resultFormat;
        _connection.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
        _connection.addEventListener(Event.OPEN, openHandler, false, 0, true);
        _connection.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
        _connection.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
        _connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
        _connection.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * TBD
     */
    public function send(params:Object = null):void {
        checkConnection();
        setState(true);
        var request:URLRequest;
        try {
            if (params && params is URLRequest) {
                request = URLRequest(params);
            }
            else {
                request = NetUtil.getRequest(params, _config);
            }
            _connection.load(request);
        }
        catch (error:Error) {
            setState(false);
            sendTransmission(ErrorEvent.ERROR, error.message, _config.name, this);
        }
    }

    /**
     * TBD
     */
    public function cancel():void {
        try {
            _connection.close();
        }
        catch (error:Error) {
        }
        setState(false);
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        _connection.removeEventListener(Event.COMPLETE, completeHandler);
        _connection.removeEventListener(Event.OPEN, openHandler);
        _connection.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        _connection.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        _connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
        _connection.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        if (_connection) {
            cancel();
            _connection = null;
        }
    }

    //----------------------------------
    //  Getters/Setters
    //----------------------------------

    /**
     * TBD
     */
    public function get connection():URLLoader {
        return _connection;
    }

    /**
     * TBD
     */
    public function get config():HTTPConnectionVars {
        return _config;
    }

    /**
     * TBD
     */
    public function get lastResult():* {
        var result:* = _lastResult;
        return result;
    }

    //----------------------------------
    //  Event Handlers
    //----------------------------------

    /**
     * TBD
     */
    private function completeHandler(event:Event):void {
        var loader:URLLoader = URLLoader(event.target);
        _lastResult = loader.data;
        setState(false);
        sendTransmission(event.type, loader.data, _config.name, this);
    }

    /**
     * TBD
     */
    private function openHandler(event:Event):void {
        sendTransmission(event.type, null, _config.name, this);
    }

    /**
     * TBD
     */
    private function progressHandler(event:ProgressEvent):void {
        var perc:Number = event.bytesLoaded / event.bytesTotal;
        sendTransmission(event.type, perc, _config.name, this);
    }

    /**
     * TBD
     */
    private function httpStatusHandler(event:HTTPStatusEvent):void {
        sendTransmission(event.type, event.status, _config.name, this);
    }

    /**
     * TBD
     */
    private function errorHandler(event:ErrorEvent):void {
        setState(false);
        _lastError = event.text;
        sendTransmission(event.type, _lastError, _config.name, this);
    }

    //----------------------------------
    //  Helpers
    //----------------------------------

    /**
     * TBD
     */
    private function setState(busy:Boolean):void {
        _busy = busy;
    }

    /**
     * TBD
     */
    private function checkConnection():void {
        if (_busy) {
            if (_config.concurrency == ConcurrencyTypes.CONCURRENCY_SINGLE) {
                throw new IllegalOperationError("Concurrency error: " + _config.name);
            }
            else if (_config.concurrency == ConcurrencyTypes.CONCURRENCY_LAST) {
                cancel();
            }
        }
    }
}
}
