/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
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
import flash.data.EncryptedLocalStore;
import flash.utils.ByteArray;

/**
 * Encrypted local store wrapper class.
 */
public class EncryptedStorage {

    /**
     * @private
     */
    public var encryptionHandler:Function;

    /**
     * Constructor
     */
    public function EncryptedStorage() {
        if (!EncryptedLocalStore.isSupported) {
            throw new Error("Not supported");
        }
        encryptionHandler = _encryptionHandler;
    }

    /**
     * Initializes the service
     */
    public function setHandler(encryptionHandler:Function = null):void {
        if (encryptionHandler != null) {
            encryptionHandler = encryptionHandler;
        }
    }

    /**
     * Adds byte array typed value into storage
     */
    public function addBytes(key:String, bytes:ByteArray):void {
        bytes.position = 0;
        if (encryptionHandler != null) {
            encryptionHandler(bytes, true);
        }
        EncryptedLocalStore.setItem(key, bytes, false);
    }

    /**
     * Adds string typed value into storage
     */
    public function addString(key:String, data:String):void {
        const bytes:ByteArray = new ByteArray();
        bytes.writeUTF(data);
        addBytes(key, bytes);
    }

    /**
     * Adds integer typed value into storage
     */
    public function addInt(key:String, data:int):void {
        const bytes:ByteArray = new ByteArray();
        bytes.writeInt(data);
        addBytes(key, bytes);
    }

    /**
     * Adds object typed value into storage
     */
    public function addObject(key:String, data:*):void {
        const bytes:ByteArray = new ByteArray();
        bytes.writeObject(data);
        addBytes(key, bytes);
    }

    /**
     * Get value from storage
     */
    public function getBytes(key:String):ByteArray {
        var resultBA:ByteArray = EncryptedLocalStore.getItem(key);
        if (encryptionHandler != null) {
            encryptionHandler(resultBA, false);
        }
        return resultBA;
    }

    /**
     * Gets value from storage
     */
    public function getString(key:String):String {
        var result:String = null;
        var resultBA:ByteArray = getBytes(key);
        if (resultBA) {
            resultBA.position = 0;
            result = resultBA.readUTF();
        }
        return result;
    }

    /**
     * Gets value from storage
     */
    public function getInt(key:String):int {
        var result:* = null;
        var resultBA:ByteArray = getBytes(key);
        if (resultBA) {
            resultBA.position = 0;
            result = resultBA.readInt();
        }
        return result;
    }

    /**
     * Gets value from storage
     */
    public function getObject(key:String):* {
        var result:* = null;
        var resultBA:ByteArray = getBytes(key);
        if (resultBA) {
            resultBA.position = 0;
            result = resultBA.readObject();
        }
        return result;
    }

    /**
     * Removes value from storage
     */
    public function remove(key:String):void {
        EncryptedLocalStore.removeItem(key);
    }

    /**
     * Clears local storage
     */
    public function clear():void {
        EncryptedLocalStore.reset();
    }

    /**
     * @private
     */
    private function _encryptionHandler(target:ByteArray, isEncrypt:Boolean):void {
        if (!target) {
            return;
        }
        var i:int = target.length;
        if (i > 1024) {
            i = 1024;
        }
        while (i--) {
            target[i] += 128;
        }
    }
}
}
