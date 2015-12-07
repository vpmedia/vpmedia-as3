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
package hu.vpmedia.utils {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.UncaughtErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.system.Capabilities;
import flash.system.Security;

import hu.vpmedia.analytics.core.ITracker;
import hu.vpmedia.errors.RuntimeErrorCode;
import hu.vpmedia.errors.StaticClassError;

import org.as3commons.logging.api.ILogger;

/**
 * Contains reusable methods for Error / Exception reporting.
 *
 * @see flash.text.StageText
 */
public final class ExceptionUtil {

    /**
     * @private
     */
    private static var urlLoader:URLLoader;

    /**
     * @private
     */
    public static var exceptionCount:int;

    /**
     * @private
     */
    public function ExceptionUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Native Text Field Helpers
    //----------------------------------

    /**
     * Helper
     */
    public static function reportError(event:UncaughtErrorEvent, url:String, tracker:ITracker, logger:ILogger, vars:URLVariables):String {
        exceptionCount++;
        // get error message
        var message:String;
        var stackTrace:String;
        var error:Error;
        var reason:String;
        if (event.error && event.error is Error) {
            try {
                error = Error(event.error);
                stackTrace = error.getStackTrace();
                message = error.toString();
            } catch (error:Error) {
                // swallow
            }
        }
        if (!message) {
            message = event.toString();
        }
        if (message.indexOf("#") > -1) {
            reason = RuntimeErrorCode.getErrorMessage(message);
        }
        // send message to logging target
        if (logger) {
            logger.error("onUncaughtError: " + message);
        }
        // send to traditional trace log
        trace("ExceptionUtil::reportError: " + message);
        // log to analytics
        if (tracker) {
            tracker.exception(message, true);
        }
        // log to php
        if (url) {
            trace("Sending error report to: " + url);
            if (!vars) {
                vars = new URLVariables();
            }
            // create verbose message for logging
            if (message) {
                vars.errorMessage = message;
            }
            if (reason) {
                vars.errorReason = reason;
            }
            if (stackTrace) {
                vars.stackTrace = stackTrace;
            }
            // Windows 8.1 - WIN 16,0,0,305 - PlugIn - remote
            vars.systemDescription = Capabilities.os
            + " - " + Capabilities.version
            + " - " + Capabilities.playerType
            + " - " + Security.sandboxType;
            // http://*
            vars.pageDomain = Security.pageDomain;
            // create loader
            if (!urlLoader) {
                urlLoader = new URLLoader();
                urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
            }
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoggerEvent, false, 0, true);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoggerEvent, false, 0, true);
            urlLoader.addEventListener(Event.COMPLETE, onLoggerEvent, false, 0, true);
            // send request to loader
            try {
                var request:URLRequest = new URLRequest();
                request.method = URLRequestMethod.POST;
                request.url = url;
                request.data = vars;
                urlLoader.load(request);
            } catch (error:Error) {
                if (logger) {
                    logger.error(error.toString());
                }
            }
        }
        // prevent error pop-up
        event.preventDefault();
        // return full log message
        return message;
    }

    /**
     * @private
     */
    private static function onLoggerEvent(event:Event):void {
        trace("ExceptionUtil::onLoggerEvent: " + event);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoggerEvent);
        urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoggerEvent);
        urlLoader.removeEventListener(Event.COMPLETE, onLoggerEvent);
    }

}
}