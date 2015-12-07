/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013 Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package com.docmet.core {
import hu.vpmedia.utils.RandomUtil;


    import org.as3commons.logging.api.ILogger;
    import org.as3commons.logging.api.getLogger;


/**
 * XOR Cipher implementation
 */
public class XORCipher implements ICipher {

    /**
     * @private
     */
    private var _key:String;

    /**
     * @private
     */
    private var _fingerPrint:String;

    /**
     * @private
     */
    private var _hasZeroChar:Boolean;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     * @param defaultKey The primary key
     * @param defaultFingerPrint The default secondary key
     */
    public function XORCipher(defaultKey:String, defaultFingerPrint:String) {
        _key = defaultKey;
        _fingerPrint = defaultFingerPrint;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will encrypt the given data
     *
     * @param value TBD
     *
     * @return String
     */
    public function encrypt(value:String):String {
        var numCycles:uint = 0;
        var result:String = "";
        do {
            var randomKey:String = RandomUtil.string(4);
            var encryptedData:String = xor(value + _fingerPrint, randomKey);
            result = xor(encryptedData + randomKey, _key, true);
            numCycles++;
        } while (_hasZeroChar);

        if (numCycles > 1) {
            trace("XORCipher::encrypt cycles: " + String(numCycles));
        }

        return result;
    }

    /**
     * Decrypt string data
     *
     * @param value String to decrypt
     *
     * @return Str Decrypted string
     */
    public function decrypt(value:String):String {
        if (value.length >= 4 + _fingerPrint.length) {
            var decryptedData:String = xor(value, _key);
            var originalData:String = xor(decryptedData.substr(0, -4), decryptedData.substr(-4));
            if (originalData.substr(-(_fingerPrint.length)) == _fingerPrint) {
                return originalData.substr(0, -(_fingerPrint.length));
            }
            else {
                trace("XORCipher::decrypt, fingerprint error! (" + value + ")");
            }
        } else {
            trace("XORCipher::decrypt, too short msg! (" + value + ")");
        }
        return value;
    }

    //----------------------------------
    //  Helpers
    //----------------------------------

    /**
     * @private
     */
    private function xor(value:String, key:String, doBreakOnZeroChar:Boolean = false):String {
        _hasZeroChar = doBreakOnZeroChar;

        var result:Vector.<String> = new <String>[];
        var keySize:int = key.length;

        for (var i:uint = 0; i < value.length; ++i) {
            var _iCharCode:Number = value.charCodeAt(i) ^ key.charCodeAt(i % keySize);
            if (doBreakOnZeroChar && _iCharCode == 0) {
                return "";
            }
            result.push(String.fromCharCode(_iCharCode));
        }

        _hasZeroChar = false;

        return result.join("");
    }
}
}