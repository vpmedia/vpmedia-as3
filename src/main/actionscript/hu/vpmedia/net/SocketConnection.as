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
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.system.Security;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import hu.vpmedia.utils.ObjectUtil;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * TBD
 */
public class SocketConnection {

    //----------------------------------
    //  Public Variables
    //----------------------------------

    /**
     * Dispatched when the client connecting to the server
     */
    public var connecting:ISignal = new Signal();

    /**
     * Dispatched when the client connected to the server
     */
    public var connected:ISignal = new Signal();

    /**
     * Dispatched when the client disconnected from the server
     */
    public var disconnected:ISignal = new Signal();

    /**
     * Dispatched when the client communicated fails with the server
     */
    public var failed:ISignal = new Signal(String);

    //----------------------------------
    //  Private Variables
    //----------------------------------

    /**
     * @private
     */
    protected var connection:Socket;

    /**
     * The last server message. Used to debug exceptions.
     */
    protected var lastMessage:String;

    /**
     * Connection reconnect counter
     */
    protected var config:SocketConnectionVars;

    /**
     * Connection reconnect counter
     */
    protected var reconnectCount:uint;

    /**
     * Connection reconnect counter
     */
    protected var reconnectTimeout:uint;

    //----------------------------------
    //  Private Static Variables
    //----------------------------------

    /**
     * @private
     */
    protected static const NIL:String = String.fromCharCode(0);

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * TBD
     */
    public function SocketConnection() {
        super();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will add a new server configuration
     */
    public function initialize(config:SocketConnectionVars):void {
        if (this.config) {
            return;
        }
        this.config = config;
        // create connection
        connection = new Socket();
        connection.timeout = config.timeout;
        // attach connection event handlers
        createListeners();
    }

    /**
     * TBD
     */
    public function dispose():void {
        if (!connection) {
            return;
        }
        disconnect();
        removeListeners();
        ObjectUtil.dispose(this);
        config = null;
        connection = null;
    }


    /**
     * TBD
     */
    public function connect(host:String = null, port:uint = 0):void {
        if (host) {
            config.host = host;
            config.port = port;
        }
        if (!connection.connected) {
            connecting.dispatch();
            connection.connect(config.host, config.port);
        }
    }

    /**
     * Disconnect from the server
     */
    public function disconnect(isReconnectAllowed:Boolean = true):void {
        if(!isReconnectAllowed) {
            getConfig().reconnectMax = -1;
        }
        if (isConnected()) {
            connection.close();
            onConnectionClose(null);
        }
    }

    /**
     * Sets server and connects immediately
     */
    public function setServer(host:String, port:int):void {
        // safe load cross-domain policy file
        try {
            Security.loadPolicyFile("xmlsocket://" + host + ":" + port);
        } catch (error:Error) {
            // swallow
        }
        // start to connect
        connect(host, port);
    }

    /**
     * TBD
     */
    public function send(message:String):void {
        // guarding
        if (!connection || !connection.connected) {
            return;
        }
        // operation
        connection.writeUTFBytes(message + NIL);
        connection.flush();
    }

    /**
     * Returns whether the connection is active
     */
    public function isConnected():Boolean {
        return connection != null && connection.connected;
    }

    /**
     * Returns the service configuration object
     *
     * @return hu.vpmedia.net.SocketConnectionVars
     */
    public function getConfig():SocketConnectionVars {
        return config;
    }

    /**
     * Returns the last server message
     *
     * @return String
     */
    public function getLastMessage():String {
        return lastMessage;
    }

    /**
     * Returns the number of reconnects since the last reset
     *
     * @return uint
     */
    public function getReconnectCount():uint {
        return reconnectCount;
    }

    //----------------------------------
    //  Helpers
    //----------------------------------

    /**
     * @private
     */
    private function createListeners():void {
        connection.addEventListener(Event.CONNECT, onConnectionConnect, false, 0, true);
        connection.addEventListener(Event.CLOSE, onConnectionClose, false, 0, true);
        connection.addEventListener(IOErrorEvent.IO_ERROR, onConnectionError, false, 0, true);
        connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectionError, false, 0, true);
        connection.addEventListener(ProgressEvent.SOCKET_DATA, onLowLevelData, false, 0, true);
    }

    /**
     * @private
     */
    private function removeListeners():void {
        connection.removeEventListener(Event.CONNECT, onConnectionConnect);
        connection.removeEventListener(Event.CLOSE, onConnectionClose);
        connection.removeEventListener(IOErrorEvent.IO_ERROR, onConnectionError);
        connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectionError);
        connection.removeEventListener(ProgressEvent.SOCKET_DATA, onLowLevelData);
    }

    /**
     * @private
     */
    private function reconnect():void {
        clearTimeout(reconnectTimeout);
        if (reconnectCount <= config.reconnectMax) {
            reconnectCount++;
            reconnectTimeout = setTimeout(connect, config.reconnectDelay);
        }
    }

    //----------------------------------
    //  Connection Event Handlers
    //----------------------------------

    /**
     * @private
     */
    protected function onConnectionConnect(event:Event):void {
        connected.dispatch();
    }

    /**
     * @private
     */
    protected function onConnectionClose(event:Event):void {
        disconnected.dispatch();
        reconnect();
    }

    /**
     * @private
     */
    protected function onConnectionError(event:ErrorEvent):void {
        failed.dispatch(event.text);
        reconnect();
    }

    /**
     * @private
     */
    protected function onLowLevelData(event:ProgressEvent):void {
        if (!connection || !connection.connected || !connection.bytesAvailable) {
            return;
        }
        // message element counter
        var counter:uint = 0;
        // message element buffer
        var message:String = "";
        // message element char
        var char:String;
        // iterate char by char with NIL separator
        while (connection.connected && connection.bytesAvailable > 0) {
            char = connection.readUTFBytes(1);
            if (!char.length) {
                // handle message element
                onConnectionMessage(message, counter);
                // increment counter
                counter++;
                // new message of batch
                message = "";
            }
            // new char
            message += char;
        }
    }

    /**
     * @private
     */
    protected function onConnectionMessage(message:String, counter:uint):void {
        lastMessage = message;
    }
}
}
