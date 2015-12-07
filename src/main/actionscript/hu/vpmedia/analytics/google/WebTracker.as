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
import flash.external.ExternalInterface;

import hu.vpmedia.analytics.core.ITracker;
import hu.vpmedia.analytics.core.TrackerType;

/**
 * Google Analytics Web Tracker implementation
 */
public class WebTracker implements ITracker {

    //----------------------------------
    //  Private Constants
    //----------------------------------

    /**
     * @private
     */
    private static const GA:String = "ga";

    /**
     * @private
     */
    private static const SEND:String = "send";

    /**
     * @private
     */
    private static const SET:String = "set";

    //----------------------------------
    //  Private Variables
    //----------------------------------

    /**
     * @private
     */
    private var trackingID:String;

    /**
     * @private
     */
    private var clientID:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function WebTracker() {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function initialize(trackingID:String, clientID:String):void {
        this.trackingID = trackingID;
        this.clientID = clientID;
    }

    /**
     * @inheritDoc
     */
    public function pageView(page:String, location:String = null, title:String = null):void {
        sendData([SEND, TrackerType.PAGE_VIEW, page]);
    }

    /**
     * @inheritDoc
     */
    public function event(category:String, action:String, label:String, value:int):void {
        sendData([SEND, TrackerType.EVENT, category, action, label, value]);
    }

    /**
     * @inheritDoc
     */
    public function social(network:String, action:String, target:String):void {
        sendData([SEND, TrackerType.SOCIAL, network, action, target]);
    }

    /**
     * @inheritDoc
     */
    public function exception(description:String, isFatal:Boolean):void {
        sendData([SEND, TrackerType.EXCEPTION, {exDescription: description, exFatal: isFatal}]);
    }

    /**
     * @inheritDoc
     */
    public function screenView(name:String):void {
        sendData([SEND, TrackerType.SCREEN_VIEW, {screenName: name}]);
    }

    /**
     * @inheritDoc
     */
    public function appView(name:String, version:String, id:String, installerId:String):void {
        sendData([SEND, TrackerType.SCREEN_VIEW, {appName: name, appVersion: version, appId: id, appInstallerId: installerId}]);
    }

    /**
     * @inheritDoc
     */
    public function timing(category:String, key:String, value:int, label:String = null):void {
        sendData([SEND, TrackerType.TIMING, category, key, value]);
    }

    /**
     * @inheritDoc
     */
    public function transaction(id:String):void {
        sendData([SEND, TrackerType.TRANSACTION, id]);
    }

    /**
     * @inheritDoc
     */
    public function setData(kv:Object):void {
        sendData([SET, kv]);
    }

    //----------------------------------
    //  Private Methods
    //----------------------------------

    /**
     * @private
     */
    private function sendData(argv:Array):void {
        if (argv && argv.length) {
            argv.unshift(GA);
            const n:uint = argv.length;
            for (var i:uint = 0; i < n; i++) {
                if (argv[i] is String) {
                    argv[i] = encodeURIComponent(argv[i]);
                }
            }
        }
        if (ExternalInterface.available) {
            try {
                ExternalInterface.call.apply(null, argv);
            } catch (error:Error) {
                // swallow
            }
        }
    }

}
}
