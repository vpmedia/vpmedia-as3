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
package hu.vpmedia.crypt {
import flash.utils.ByteArray;

import hu.vpmedia.framework.IBaseDisposable;

/**
 * RC4 encryption implementation
 *
 * @see http://en.wikipedia.org/wiki/RC4
 */
public class ARC4 implements IBaseDisposable {
    /**
     * @private
     */
    private var i:int;

    /**
     * @private
     */
    private var j:int;

    /**
     * @private
     */
    private var t:int;

    /**
     * @private
     */
    private var dp:Vector.<uint>;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function ARC4(key:ByteArray = null) {
        if (key)
            setKey(key);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * (Re) Initialize with a key
     */
    public function setKey(key:ByteArray):void {
        // create dp if necessary
        if (!dp)
            dp = new Vector.<uint>();
        // fill with default values
        for (i = 0; i < 256; ++i) {
            dp[i] = i;
        }
        // save key
        j = 0;
        for (i = 0; i < 256; ++i) {
            j = (j + dp[i] + key[i % key.length]) & 255;
            t = dp[i];
            dp[i] = dp[j];
            dp[j] = t;
        }
        // set indexes to start
        i = 0;
        j = 0;
    }

    /**
     * Encrypts a byte array data
     */
    public function encrypt(block:ByteArray):void {
        // get data size
        const n:uint = block.length;
        // do xor operation
        for (var pt:uint = 0; pt < n; pt++)
            block[pt] ^= next();
    }

    /**
     * Decrypts a byte array data
     */
    public function decrypt(block:ByteArray):void {
        // the beauty of XOR.
        encrypt(block);
    }

    /**
     * Disposes the object
     */
    public function dispose():void {
        if (dp)
            dp.length = 0;
        i = 0;
        j = 0;
    }

    /**
     * Step encrypt to next block
     */
    public function next():uint {
        i = (i + 1) & 255;
        j = (j + dp[i]) & 255;
        t = dp[i];
        dp[i] = dp[j];
        dp[j] = t;
        return dp[(t + dp[i]) & 255];
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * Encrypt/Decrypt ByteArray to ByteArray
     *
     * @param key The encryption key
     * @param content The encrypted content ByteArray
     *
     * @return Decrypted ByteArray
     *
     * Tip: To use string as content: Hex.toArray(Hex.fromString(contentStr))
     */
    public static function encrypt(key:String, content:ByteArray):ByteArray {
        const keyHex:String = Hex.fromString(key);
        const keyByteArray:ByteArray = Hex.toArray(keyHex);
        const result:ByteArray = content;
        const rc4:ARC4 = new ARC4(keyByteArray);
        rc4.decrypt(result);
        return result;
    }
}
}