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
import flash.crypto.generateRandomBytes;
import flash.utils.ByteArray;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for randomization.
 *
 * @see Number
 */
public final class RandomUtil {
    /**
     * @private
     */
    public static const CHARS:String = "01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    //----------------------------------
    //  Constructor (private)
    //----------------------------------

    /**
     * @private
     */
    public function RandomUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * TBD
     */
    public static function bit(chance:Number = 0.5):int {
        return (Math.random() < chance) ? 1 : 0;
    }

    /**
     * TBD
     */
    public static function bool(chance:Number = 0.5):Boolean {
        return (Math.random() < chance);
    }

    /**
     * TBD
     */
    public static function bytes(length:uint):ByteArray {
        return generateRandomBytes(length);
    }

    /**
     * TBD
     */
    public static function char(source:String = null):String {
        if (!source)
            source = CHARS;
        return source.charAt(integer(0, source.length - 1));
    }

    /**
     * TBD
     */
    public static function float(min:Number, max:Number = NaN):Number {
        if (isNaN(max)) {
            max = min;
            min = 0;
        }
        return Math.random() * (max - min) + min;
    }

    /**
     * TBD
     */
    public static function integer(min:Number, max:Number = NaN):int {
        if (isNaN(max)) {
            max = min;
            min = 0;
        }
        // we need Math.round() because int(8.9) returns 8.
        var result:int = Math.round(float(min, max));
        return result;
    }

    /**
     * TBD
     */
    public static function sign(chance:Number = 0.5):int {
        return (Math.random() < chance) ? 1 : -1;
    }

    /**
     * TBD
     */
    public static function string(length:uint, source:String = null):String {
        var result:String = "";
        while (result.length < length)
            result += char(source);
        return result;
    }

}
}
