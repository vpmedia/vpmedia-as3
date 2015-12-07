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
import flash.utils.ByteArray;

import hu.vpmedia.errors.StaticClassError;

/**
 * Utility class for ByteArray manipulation
 *
 * @see flash.utils.ByteArray
 */
public final class ByteArrayUtil {

    public static const SWF:String = "swf";
    public static const PNG:String = "png";
    public static const JPG:String = "jpg";
    public static const ATF:String = "atf";
    public static const ZIP:String = "zip";

    /**
     * @private
     */
    public function ByteArrayArrayUtil():void {
        throw new StaticClassError();
    }

    public static function getType(bytes:ByteArray):String {
        var type:String;
        const b1:uint = bytes[0];
        const b2:uint = bytes[1];
        const b3:uint = bytes[2];
        const b4:uint = bytes[3];
        if ((b1 == 0x46 || b1 == 0x43 || b1 == 0x5A) && b2 == 0x57 && b3 == 0x53) {
            //CWS FWS ZWS
            type = SWF;
        }
        else if (b1 == 0x89 && b2 == 0x50 && b3 == 0x4E && b4 == 0x47) {
            //89 50 4e 47 0d 0a 1a 0a
            type = PNG;
        }
        else if (b1 == 0xFF) {
            type = JPG;
        }
        else if (b1 == 0x41 && b2 == 0x54 && b3 == 0x46) {
            type = ATF;
        }
        else if (b1 == 0x50 && b2 == 0x4B) {
            type = ZIP;
        }
        return type;
    }

    /**
     * Clones a byte array
     * @param source *
     * @return *
     */
    public static function clone(source:*):* {
        var copier:ByteArray = new ByteArray;
        copier.writeObject(source);
        copier.position = 0;
        return (copier.readObject());
    }

    /**
     * Splits a byte array
     * @param ba ByteArray
     * @param startPos int
     * @param splitLength int
     * @return ByteArray
     */
    public static function split(ba:ByteArray, startPos:uint, splitLength:uint):ByteArray {
        var resultBA:ByteArray = new ByteArray();
        ba.position = startPos;
        ba.readBytes(resultBA, 0, splitLength);
        ba.position = 0;
        return resultBA;
    }

    /**
     * Output the contents of a ByteArray as a string
     * @param bytes ByteArray
     * @param asHex
     * @return String
     */
    public static function dump(ba:ByteArray, asHex:Boolean = true):String {
        // TODO: filter last space from result
        var output:String = "";
        ba.position = 0;
        const n:uint = ba.length;
        for (var i:int = 0; i < n; i++) {
            // Append the byte with a space for some separation
            if (asHex) {
                output += ba.readByte().toString(16).toUpperCase() + " ";
            }
            else {
                output += ba.readByte() + " ";
            }
        }
        ba.position = 0;
        return output;
    }

    /**
     * Compares two byte array by content
     */
    public static function equals(a1:ByteArray, a2:ByteArray):Boolean {
        if (a1.length != a2.length)
            return false;
        const n:int = a1.length;
        for (var i:int = 0; i < n; i++) {
            if (a1[i] != a2[i])
                return false;
        }
        return true;
    }

    /**
     * TBD
     */
    public function asString(array:ByteArray):String { // for debug
        var out:String = '';
        var pos:uint = array.position;
        var i:uint = 0;
        array.position = 0;

        while (array.bytesAvailable) {
            var str:String = array.readUnsignedByte().toString(16).toUpperCase();
            str = str.length < 2 ? '0' + str : str;
            out += str + ' ';
        }

        array.position = pos;
        return out;
    }
}
// EOC
} // EOP
