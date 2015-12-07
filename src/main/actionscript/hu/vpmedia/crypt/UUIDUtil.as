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
import hu.vpmedia.errors.StaticClassError;
import hu.vpmedia.utils.RandomUtil;

/**
 * UUID generator util
 */
public class UUIDUtil {

    /**
     * @private
     */
    private static const SPEC_CHARS:Vector.<String> = Vector.<String>(["8", "9", "A", "B"]);

    /**
     * @private
     */
    private static const ALL_CHARS:Vector.<String> = Vector.<String>(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]);

    /**
     * @private
     */
    public function UUIDUtil() {
        throw new StaticClassError();
    }

    /**
     * Generates a new unique user identifier
     */
    public static function generate():String {
        return rid(8, 15) + "-" + rid(4, 15) + "-4" + rid(3, 15) + "-" + SPEC_CHARS[RandomUtil.integer(0, 3)] + rid(3, 15) + "-" + rid(12, 15);
    }

    /**
     * @private
     */
    private static function rid(length:uint, radix:uint = 61):String {
        const id:Vector.<String> = new Vector.<String>();
        radix = (radix > 61) ? 61 : radix;
        while (length--) {
            id.push(ALL_CHARS[RandomUtil.integer(0, radix)]);
        }
        return id.join("");
    }
}
}
