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
package hu.vpmedia.analytics.google {
import flash.display.Screen;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.system.Capabilities;

import hu.vpmedia.analytics.core.ITracker;
import hu.vpmedia.analytics.core.TrackerTag;
import hu.vpmedia.analytics.core.TrackerType;

/**
 * Google Analytics Desktop/Mobile Tracker implementation
 *
 * The Google Analytics Measurement Protocol allows developers to make HTTP requests to send raw user interaction data
 * directly to Google Analytics servers.
 * This allows developers to measure how users interact with their business from almost any environment.
 * Developers can then use the Measurement Protocol to:
 *
 * @see https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
 */
public class DesktopTracker implements ITracker {

    //----------------------------------
    //  Private Constants
    //----------------------------------

    /**
     * @private
     */
    private static const URL:String = "https://ssl.google-analytics.com/collect";

    /**
     * @private
     */
    private static const VERSION:String = "1";

    /**
     * @private
     */
    private static const ENCODING:String = "UTF-8";

    /**
     * @private
     */
    private static const LANGUAGE:String = "en-us";

    /**
     * @private
     */
    private static const DEL:String = "&";

    /**
     * @private
     */
    private static const IS:String = "=";

    //----------------------------------
    //  Private Variables
    //----------------------------------

    /**
     * @private
     */
    private var loader:URLLoader;

    /**
     * @private
     */
    private var trackingID:String;

    /**
     * @private
     */
    private var clientID:String;

    /**
     * @private
     */
    private var viewPortSize:String;

    /**
     * @private
     */
    private var screenColors:String;

    /**
     * @private
     */
    private var userLanguage:String;

    /**
     * @private
     */
    private var commonData:Object;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function DesktopTracker() {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function initialize(trackingID:String, clientID:String):void {
        this.trackingID = encodeURIComponent(trackingID);
        this.clientID = encodeURIComponent(clientID);
        screenColors = Screen.mainScreen.colorDepth + "-bit";
        viewPortSize = Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
        userLanguage = LANGUAGE;
        if (!loader) {
            loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
        }
    }

    /**
     * @inheritDoc
     */
    public function pageView(page:String, location:String = null, title:String = null):void {
        var payload:String = getCommand(TrackerType.PAGE_VIEW);
        if (page) {
            payload += DEL + TrackerTag.DOCUMENT_PATH + IS + page;
        }
        if (location) {
            payload += DEL + TrackerTag.DOCUMENT_HOST + IS + location;
        }
        if (title) {
            payload += DEL + TrackerTag.DOCUMENT_TITLE + IS + title;
        }
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function event(category:String, action:String, label:String, value:int):void {
        var payload:String = getCommand(TrackerType.EVENT);
        payload += DEL + TrackerTag.EVENT_CATEGORY + IS + category;
        payload += DEL + TrackerTag.EVENT_ACTION + IS + action;
        payload += DEL + TrackerTag.EVENT_LABEL + IS + label;
        payload += DEL + TrackerTag.EVENT_VALUE + IS + value;
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function social(network:String, action:String, target:String):void {
        var payload:String = getCommand(TrackerType.SOCIAL);
        payload += DEL + TrackerTag.SOCIAL_ACTION + IS + action;
        payload += DEL + TrackerTag.SOCIAL_NETWORK + IS + network;
        payload += DEL + TrackerTag.SOCIAL_TARGET + IS + target;
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function exception(description:String, isFatal:Boolean):void {
        var payload:String = getCommand(TrackerType.EXCEPTION);
        payload += DEL + TrackerTag.EXCEPTION_DESCRIPTION + IS + description;
        payload += DEL + TrackerTag.EXCEPTION_IS_FATAL + IS + int(isFatal);
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function appView(name:String, version:String, id:String, installerId:String):void {
        var payload:String = getCommand(TrackerType.SCREEN_VIEW);
        payload += DEL + TrackerTag.APP_NAME + IS + name;
        payload += DEL + TrackerTag.APP_VERSION + IS + version;
        payload += DEL + TrackerTag.APP_ID + IS + id;
        payload += DEL + TrackerTag.APP_INSTALLER_ID + IS + installerId;
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function screenView(name:String):void {
        var payload:String = getCommand(TrackerType.SCREEN_VIEW);
        payload += DEL + TrackerTag.SCREEN_NAME + IS + name;
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function timing(category:String, key:String, value:int, label:String = null):void {
        var payload:String = getCommand(TrackerType.TIMING);
        payload += DEL + "utc" + IS + category;
        payload += DEL + "utv" + IS + key;
        payload += DEL + "utt" + IS + value;
        if (label) {
            payload += DEL + "utl" + IS + label;
        }
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function transaction(id:String):void {
        var payload:String = getCommand(TrackerType.TRANSACTION);
        sendData(payload);
    }

    /**
     * @inheritDoc
     */
    public function setData(kv:Object):void {
        commonData = kv;
    }

    //----------------------------------
    //  Private Methods
    //----------------------------------

    /**
     * @private
     */
    private function getCommand(hitType:String):String {
        var params:String = "";
        params += TrackerTag.VERSION + IS + VERSION;
        params += DEL + TrackerTag.TRACKING_ID + IS + trackingID;
        params += DEL + TrackerTag.CLIENT_ID + IS + clientID;
        params += DEL + TrackerTag.HIT_TYPE + IS + hitType;
        params += DEL + TrackerTag.USER_LANGUAGE + IS + userLanguage;
        params += DEL + TrackerTag.DOCUMENT_ENCODING + IS + ENCODING;
        params += DEL + TrackerTag.SYSTEM_RESOLUTION + IS + viewPortSize;
        params += DEL + TrackerTag.VIEW_PORT_SIZE + IS + viewPortSize;
        params += DEL + TrackerTag.JAVA_ENABLED + IS + "0";
        params += DEL + TrackerTag.SCREEN_COLORS + IS + screenColors;
        if (commonData) {
            for (var p:String in commonData) {
                params += DEL + p + IS + encodeURIComponent(commonData[p]);
            }
        }
        return params;

    }

    /**
     * @private
     */
    private function sendData(payload:String):void {
        if (!this.trackingID) {
            return;
        }
        const request:URLRequest = new URLRequest();
        request.method = URLRequestMethod.POST;
        request.url = URL;
        request.data = payload;
        try {
            loader.load(request);
        } catch (error:Error) {
        }
    }

    /**
     * @private
     */
    private function onComplete(event:Event):void {
        // swallow
    }

    /**
     * @private
     */
    private function onError(event:Event):void {
        // swallow
    }
}
}
