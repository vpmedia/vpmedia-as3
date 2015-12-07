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
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.utils.ByteArray;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for Network manipulation.
 *
 * @see flash.net.URLRequest
 */
public final class NetUtil {

    /**
     * @private
     */
    private static const evilWords:Vector.<String> = Vector.<String>([
        'about:',
        'chrome:',
        'mailto:',
        'callto:',
        'hcp:',
        'shell:',
        'file:',
        'irc:',
        'mms:',
        'ftp:',
        'tftp:',
        'sftp:',
        'jar:',
        'asfunction:',
        'javascript:',
        'jdbc:',
        'vbscript:',
        'event:'
    ]);

    /**
     * @private
     */
    private static const controlWords:Vector.<String> = Vector.<String>([ '\t', '\n', '\r' ]);

    /**
     * @private
     */
    public function NetUtil():void {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static function getRequest(params:Object, config:Object):URLRequest {
        var result:URLRequest = new URLRequest();
        if (config.url) {
            result.url = config.url;
        }
        if (config.method) {
            result.method = config.method;
        }
        if (params) {
            if (params is ByteArray || params is URLVariables || params is String || params is Number || params is XML) {
                result.data = params;
            }
            else {
                var _params:URLVariables = new URLVariables();
                for (var p:String in params) {
                    _params[p] = params[p];
                }
                result.data = _params;
            }
        }
        if (config.contentType) {
            result.contentType = config.contentType;
        }
        if (config.requestHeaders && config.requestHeaders.length > 0) {
            result.requestHeaders = config.requestHeaders;
        }
        return result;
    }

    /**
     * TBD
     */
    public static function getAuthHeader(data:String):URLRequestHeader {
        return new URLRequestHeader("Authorization", "Basic " + data);
    }

    /**
     * TBD
     */
    public static function openWindow(url:String, target:String = "_blank", features:String = ""):void {
        var WINDOW_OPEN_FUNCTION:String = "window.open";
        if (ExternalInterface.available) {
            ExternalInterface.call(WINDOW_OPEN_FUNCTION, url, target, features);
        }
        else {
            getURL(url, target);
        }
    }

    /**
     * Closes the browser window if available
     */
    public static function closeWindow():void {
        if (ExternalInterface.available) {
            try {
                ExternalInterface.call("self.close");
            } catch (error:Error) {
                NetUtil.getURL("javascript:self.close();", "_self");
            }
        } else {
            NetUtil.getURL("javascript:self.close();", "_self");
        }
    }

    /**
     * Refreshes the current window
     */
    public static function refreshWindow():void {
        if (ExternalInterface.available) {
            try {
                ExternalInterface.call("document.location.reload", true);
            } catch (error:Error) {
                NetUtil.getURL("javascript:document.location.reload(true);", "_self");
            }
        } else {
            NetUtil.getURL("javascript:document.location.reload(true);", "_self");
        }
    }

    /**
     * Move back browser history
     */
    public static function historyBack():void {
        if (ExternalInterface.available) {
            try {
                ExternalInterface.call("document.history.back");
            } catch (error:Error) {
                NetUtil.getURL("javascript:document.history.back();", "_self");
            }
        } else {
            NetUtil.getURL("javascript:document.history.back();", "_self");
        }
    }

    /**
     * TBD
     */
    public static function getURL(url:String, target:String = null):void {
        var request:URLRequest = new URLRequest(url);
        navigateToURL(request, target);
    }

    /**
     * TBD
     */
    public static function filterURL(str:String):String {
        if (!str)
            return null;
        else if (str == "")
            return "";
        var result:String = str.substr(0, 2048);
        result = filter(result, controlWords);
        result = filter(result, evilWords);
        return result;
    }

    /**
     * TBD
     */
    public static function buildQuery(args:Object, separator:String = "&"):String {
        var key:String;
        var val:Object;
        var tmp_arr:Array = [];
        for (key in args) {
            key = encodeURIComponent(key);
            val = encodeURIComponent(args[key].toString());
            tmp_arr.push(key + '=' + val);
        }
        return tmp_arr.join(separator);
    }

    /**
     * Object to URLVariables helper
     */
    public static function objectToURLVariables(parameters:Object):URLVariables {
        var result:URLVariables = new URLVariables();
        for (var p:String in parameters) {
            if (p != null) {
                if (parameters[p] is Array) {
                    result[p] = parameters[p];
                } else {
                    result[p] = parameters[p].toString();
                }
            }
        }
        return result;
    }

    // FILTER HELPERS

    /**
     * @private
     */
    private static function filter(str:String, arr:Vector.<String>):String {
        var result:String = unescape(str);
        const n:uint = arr.length;
        for (var i:uint = 0; i < n; i++) {
            var pattern:RegExp = new RegExp(arr[i], 'gi');
            result = result.replace(pattern, '');
        }
        return result;
    }

    // QUERY

    /**
     * TBD
     */
    public static function getQueryString():String {
        var result:String;
        if (ExternalInterface.available) {
            try {
                result = ExternalInterface.call("window.location.href.toString");
            } catch (error:Error) {
            }
        }
        return result;
    }

    /**
     * TBD
     */
    public static function getSearchString():String {
        var result:String;
        if (ExternalInterface.available) {
            try {
                result = ExternalInterface.call("window.location.search.substring", 1);
            } catch (error:Error) {
            }
        }
        return result;
    }

    // SOCIAL

    /**
     * TBD
     */
    public static function shareFacebook(url:String, title:String):void {
        var baseURL:String = "//www.facebook.com/sharer.php?u=";
        NetUtil.getURL(baseURL + url + "&t=" + title);
    }

    /**
     * TBD
     */
    public static function shareAddThis(url:String, title:String):void {
        var baseURL:String = "//api.addthis.com/oexchange/0.8/offer?url=";
        NetUtil.getURL(baseURL + url);
    }

    /**
     * TBD
     */
    public static function bookmarkAddThis(type:String, url:String, title:String, id:String):void {
        var baseURL:String = "//addthis.com/bookmark.php?s=";
        NetUtil.getURL(baseURL + type + "&pub=" + id + "&url=" + url + "&title=" + title);
    }
}
}
