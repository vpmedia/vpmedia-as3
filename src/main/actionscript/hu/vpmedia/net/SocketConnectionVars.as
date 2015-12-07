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
import hu.vpmedia.framework.BaseConfig;

/**
 * A class that provides properties for the SocketConnection configuration.
 */
public final class SocketConnectionVars extends BaseConfig {

    //----------------------------------
    //  Server
    //----------------------------------

    /**
     * Connection host
     */
    public var host:String;

    /**
     * Connection port
     */
    public var port:int;

    /**
     * Connection timeout
     */
    public var timeout:int;

    /**
     * Connection reconnect counter
     */
    public var reconnectMax:int;

    /**
     * Connection reconnect counter
     */
    public var reconnectDelay:int;

    /**
     * Keep alive interval
     */
    public var keepAliveInterval:int;

    //----------------------------------
    //  Encryption
    //----------------------------------

    /**
     * Encryption flag
     */
    public var useEncryption:Boolean;

    /**
     * Encryption key
     */
    public var encryptionKey:String;

    /**
     * Encryption fingerprint
     */
    public var encryptionFingerprint:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     *
     * @param parameters Optional object to serialize
     */
    public function SocketConnectionVars(parameters:Object = null) {
        super(parameters);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    override public function setupDefaults():void {
        timeout = 5000;
        reconnectMax = int.MAX_VALUE;
        reconnectDelay = 10000;
        keepAliveInterval = 10000; // server waits 15sec until disconnect
    }

    /**
     * Returns the url with port
     */
    public function getURL():String {
        return host + ":" + port;
    }

    /**
     * Will return the description of the object including property information.
     */
    public function toString():String {
        return "[SocketConnectionConfig"
                + " host=" + host
                + " port=" + port
                + " timeout=" + timeout
                + " reconnectMax=" + reconnectMax
                + " reconnectDelay=" + reconnectDelay
                + " keepAliveInterval=" + keepAliveInterval
                + "]";
    }
}
}
