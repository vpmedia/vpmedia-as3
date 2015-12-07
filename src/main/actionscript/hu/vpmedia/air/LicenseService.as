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
package hu.vpmedia.air {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequestMethod;

import hu.vpmedia.net.BaseTransmission;
import hu.vpmedia.net.HTTPConnection;
import hu.vpmedia.net.HTTPConnectionVars;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The LicenseService provides Licensing API for the Terminal machine licensing
 */
public final class LicenseService {
    //----------------------------------
    //  Public properties
    //----------------------------------

    /**
     * @private
     */
    public var failed:ISignal = new Signal(String);

    /**
     * @private
     */
    public var completed:ISignal = new Signal(int, String);

    //----------------------------------
    //  Private properties
    //----------------------------------

    /**
     * @private
     */
    private var connection:HTTPConnection;

    //----------------------------------
    //  Private static properties
    //----------------------------------

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("LicenseService");

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * TBD
     */
    public function LicenseService() {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @private
     */
    public function initialize(url:String):void {
        LOG.debug("initialize");
        if (!url || url == "") {
            return;
        }
        const config:HTTPConnectionVars = new HTTPConnectionVars();
        config.resultFormat = URLLoaderDataFormat.TEXT;
        config.method = URLRequestMethod.POST;
        config.url = url;
        connection = new HTTPConnection(config);
        connection.signal.add(onConnectionChanged);
    }

    /**
     * Will register a machine license
     */
    public function licenseTerminal(hash:String, licence:String):void {
        LOG.debug("licenseTerminal");
        const params:Object = {};
        params.cmd = "register_terminal";
        params.old_hash = hash;
        params.new_hash = hash;
        params.licence_id = licence;
        connection.send(params);
    }

    /**
     * @private
     */
    public function get isInitialized():Boolean {
        return connection != null;
    }

    //----------------------------------
    //  Helpers
    //----------------------------------

    /**
     * @private
     */
    private function onConnectionChanged(event:BaseTransmission):void {
        //LOG.debug(event);
        if (event.code == Event.COMPLETE) {
            //LOG.debug("onConnectionChanged: " + event.data);
            var result:String = event.data ? String(event.data) : "001 server error";
            // TEST for Success answer
            //result = "000 ok 1175 140901001";
            if (result.indexOf("000") == 0) {
                var resultList:Array = result.split(" ");
                // 000 ok 1175 140901001
                completed.dispatch(int(resultList[2]), resultList[3]);
            } else if (result.indexOf("001") == 0) {
                failed.dispatch(result.substr(4));
            } else {
                failed.dispatch(result);
            }

        } else if (event.code == IOErrorEvent.IO_ERROR || event.code == SecurityErrorEvent.SECURITY_ERROR) {
            failed.dispatch("001 server error");
        }
    }
}
}
