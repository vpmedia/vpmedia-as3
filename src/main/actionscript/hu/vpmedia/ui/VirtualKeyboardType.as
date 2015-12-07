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
package hu.vpmedia.ui {
/**
 * VirtualKeyboardType provides enumeration values for any VirtualKeyboard implementation.
 */
public final class VirtualKeyboardType {

    /**
     * A keypad designed for entering a person's name or phone number.
     */
    public static const CONTACT:String = "contact";

    /**
     * Default keyboard for the current input method.
     */
    public static const DEFAULT:String = "default";

    /**
     * A keyboard optimized for specifying email addresses. This type features the "&", "." and space characters prominently.
     */
    public static const EMAIL:String = "email";

    /**
     * A numeric keypad designed for PIN entry. This type features the numbers 0 through 9 prominently. This keyboard type does not support auto-capitalization.
     */
    public static const NUMBER:String = "number";

    /**
     * A keyboard optimized for entering punctuation.
     */
    public static const PUNCTUATION:String = "punctuation";

    /**
     * A keyboard optimized for entering URLs. This type features ".", "/", and ".com" prominently.
     */
    public static const URL:String = "url";

    /**
     * @private
     */
    private static const DP_DEFAULT:Vector.<Vector.<String>> = getDPDefault();

    /**
     * @private
     */
    private static const DP_NUMBER:Vector.<Vector.<String>> = getDPNumber();

    /**
     * @private
     */
    private static const DP_URL:Vector.<Vector.<String>> = getDPURL();

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function VirtualKeyboardType() {
    }

    /**
     * @private
     */
    private static function getDPDefault():Vector.<Vector.<String>> {
        return Vector.<Vector.<String>>(
                [
                    Vector.<String>(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]),
                    Vector.<String>(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]),
                    Vector.<String>(["a", "s", "d", "f", "g", "h", "j", "k", "l"]),
                    Vector.<String>(["z", "x", "c", "v", "b", "n", "m"])
                ]);
    }

    /**
     * @private
     */
    private static function getDPURL():Vector.<Vector.<String>> {
        return Vector.<Vector.<String>>(
                [
                    Vector.<String>(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]),
                    Vector.<String>(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]),
                    Vector.<String>(["a", "s", "d", "f", "g", "h", "j", "k", "l"]),
                    Vector.<String>(["z", "x", "c", "v", "b", "n", "m", ".", "/"])
                ]);
    }

    /**
     * @private
     */
    private static function getDPNumber():Vector.<Vector.<String>> {
        return Vector.<Vector.<String>>(
                [
                    Vector.<String>(["1", "2", "3"]),
                    Vector.<String>(["4", "5", "6"]),
                    Vector.<String>(["7", "8", "9"]),
                    Vector.<String>(["0", "-", "."])
                ]);
    }

    /**
     * @private
     */
    public static function getLayoutByType(value:String):Vector.<Vector.<String>> {
        switch (value) {
            case CONTACT:
                return DP_DEFAULT;
                break;
            case EMAIL:
                return DP_DEFAULT;
                break;
            case NUMBER:
                return DP_NUMBER;
                break;
            case PUNCTUATION:
                return DP_DEFAULT;
                break;
            case URL:
                return DP_URL;
                break;
            case DEFAULT:
            default :
                return DP_DEFAULT;
                break;
        }
    }
}
}
