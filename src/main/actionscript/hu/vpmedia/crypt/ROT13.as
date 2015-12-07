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

import hu.vpmedia.errors.StaticClassError;

/**
 * ROT13 Encoding implementation
 *
 * @see http://www.php.net/manual/en/function.str-rot13.php
 *
 */
public class ROT13 {
    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function ROT13() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * Encode chars in input string
     * @param data The input data to encode
     * @return The encoded result string
     */
    public static function calculateUTF(data:String):String {
        var dataBA:ByteArray = new ByteArray();
        dataBA.writeUTFBytes(data);
        dataBA.position = 0;
        var resultBA:ByteArray = calculate(dataBA);
        var result:String = resultBA.readUTFBytes(resultBA.length);
        return result;
    }

    /**
     * Encode chars in input byte array
     * @param data The input data to encode
     * @return The encoded result byte array
     */
    public static function calculate(data:ByteArray):ByteArray {
        var result:ByteArray = new ByteArray();
        var n:uint = data.length;
        for (var i:int = 0; i < n; i++) {
            var outByte:int = calculateInt(data[i]);
            result.writeByte(outByte);
        }
        result.position = 0;
        return result;
    }

    /**
     * Encode chars in input integer
     * @param c The input data to encode
     * @return The encoded result integer
     *
     */
    public static function calculateInt(c:int):int {
        var a:int = 97, m:int = 109, n:int = 110, z:int = 122, A:int = 65, M:int = 77, N:int = 78, Z:int = 90;
        if ((a <= c && c <= m) || (A <= c && c <= M)) {
            return c + 13;
        }
        else if ((n <= c && c <= z) || (N <= c && c <= Z)) {
            return c - 13;
        }
        return c;
    }
}
}
