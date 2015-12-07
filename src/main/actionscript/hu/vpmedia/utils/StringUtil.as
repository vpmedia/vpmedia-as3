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
import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for String manipulation.
 *
 * @see String
 */
public final class StringUtil {
    /**
     * TBD
     */
    public static const ZIP_CODE:RegExp = /^[0-9]$/;

    /**
     * TBD
     */
    public static const WEB_ADDRESS:RegExp = /^(https?:\/\/|ftp:\/\/)??([a-z0-9.-]{2,})\.([a-z]{2,6})$/i;

    /**
     * TBD
     */
    public static const PHONE_NUMBER:RegExp = /^[0-9]$/;

    /**
     * TBD
     */
    public static const NON_BLANK:RegExp = /\S/;

    /**
     * TBD
     */
    public static const INTEGER:RegExp = /^\s*(\+|-)?\d+\s*$/i;

    /**
     * TBD
     */
    public static const EMAIL:RegExp = /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/i;

    //const eMail:RegExp = new RegExp(/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/);
    //const validationRegExp:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;

    /**
     * TBD
     */
    public static const DECIMAL:RegExp = /^\s*(\+|-)?((\d+(\.\d+)?)|(\.\d+))\s*$/i;

    /**
     * TBD
     */
    public static const DATE:RegExp = /^((\d{2}(([02468][048])|([13579][26]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|([1-2][0-9])))))|(\d{2}(([02468][1235679])|([13579][01345789]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\s(((0?[1-9])|(1[0-2]))\:([0-5][0-9])((\s)|(\:([0-5][0-9])\s))([AM|PM|am|pm]{2,2})))?$/;

    /**
     * TBD
     */
    public static const CREDIT_CARD:RegExp = /^\s*(\+|-)?((\d+(\.\d+)?)|(\.\d+))\s*$/i;

    /**
     * TBD
     */
    public static const DECIMAL_DIGITS:String = "01234567890";

    /**
     * TBD
     */
    public static const LC_ROMAN_LETTERS:String = "abcdefghijklmnopqrstuvwxyz";

    /**
     * TBD
     */
    public static const UC_ROMAN_LETTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    /**
     * TBD
     */
    public static const LC_HUN_LETTERS:String = "éáűőúöüóí";

    /**
     * TBD
     */
    public static const UC_HUN_LETTERS:String = "ÉÁŰŐÚÖÜÓÍ";

    /**
     * @private
     */
    public function StringUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Manipulation Methods
    //----------------------------------

    /**
     *    Formats a number to include a leading zero if it is a single digit
     *    between -1 and 10.
     *
     *    @param number The number that will be formatted
     *    @param minWidth The minimum width of returned string
     *
     *    @return A string with single digits between -1 and 10 padded with a
     *    leading zero.
     */
    public static function addLeadingZero(number:int, minWidth:int = 2):String {
        var result:String = "" + number.toString();
        while (result.length < minWidth) {
            result = "0" + result;
        }
        return result;
    }

    /**
     *  Substitutes "{n}" tokens within the specified string
     *  with the respective arguments passed in.
     *
     *  @param str The string to make substitutions in.
     *  This string can contain special tokens of the form
     *  <code>{n}</code>, where <code>n</code> is a zero based index,
     *  that will be replaced with the additional parameters
     *  found at that index if specified.
     *
     *  @param rest Additional parameters that can be substituted
     *  in the <code>str</code> parameter at each <code>{n}</code>
     *  location, where <code>n</code> is an integer (zero based)
     *  index value into the array of values specified.
     *  If the first parameter is an array this array will be used as
     *  a parameter list.
     *  This allows reuse of this routine in other methods that want to
     *  use the ... rest signature.
     *  For example <pre>
     *     public function myTracer(str:String, ... rest):void
     *     {
     *         label.text += StringUtil.substitute(str, rest) + "\n";
     *     } </pre>
     *
     *  @return New string with all of the <code>{n}</code> tokens
     *  replaced with the respective arguments specified.
     *
     *  @example
     *
     *  var str:String = "here is some info '{0}' and {1}";
     *  trace(StringUtil.substitute(str, 15.4, true));
     *
     *  // this will output the following string:
     *  // "here is some info '15.4' and true"
     */
    public static function substitute(source:String, ...rest):String {
        if (!source)
            return "";

        // Replace all of the parameters in the message string.
        var n:uint = rest.length;
        var args:Array;
        if (n == 1 && rest[0] is Array) {
            args = rest[0] as Array;
            n = args.length;
        }
        else {
            args = rest;
        }

        for (var i:uint = 0; i < n; i++) {
            source = source.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
        }

        return source;
    }

    /**
     *    Replaces all instances of the replace string in the input string
     *    with the replaceWith string.
     *
     *    @param input The string that instances of replace string will be
     *    replaces with removeWith string.
     *
     *    @param replace The string that will be replaced by instances of
     *    the replaceWith string.
     *
     *    @param replaceWith The string that will replace instances of replace
     *    string.
     *
     *    @returns A new String with the replace string replaced with the
     *    replaceWith string.
     */
    public static function replace(input:String, replace:String, replaceWith:String):String {
        return input.split(replace).join(replaceWith);
    }

    /**
     * TBD
     */
    public static function normalize(value:String):String {
        return value.replace(/\s*/gim, '');
    }

    /**
     * TBD
     */
    public static function trim(value:String):String {
        return value.replace(/^\s+|\s+$/gs, '');
    }

    /**
     * TBD
     */
    public static function trimLeft(value:String):String {
        return value.replace(/^\s+/, '');
    }

    /**
     * TBD
     */
    public static function trimRight(value:String):String {
        return value.replace(/\s+$/, '');
    }

    /**
     * TBD
     */
    public static function stripTags(value:String):String {
        return value.replace(/<\/?[^>]+>/igm, '');
    }

    //----------------------------------
    //  Validation Methods
    //----------------------------------

    /**
     * TBD
     */
    public static function validate(regexp:RegExp, value:String):Boolean {
        const result:Boolean = value.search(regexp) != -1;
        return result;
    }

    /**
     * TBD
     */
    public static function beginsWith(value:String, p_begin:String):Boolean {
        return value.indexOf(p_begin) == 0;
    }

    /**
     * TBD
     */
    public static function endsWith(value:String, p_end:String):Boolean {
        return value.lastIndexOf(p_end) == value.length - p_end.length;
    }

    /**
     * TBD
     */
    public static function contains(value:String, p_char:String):Boolean {
        return value.indexOf(p_char) != -1;
    }


}
}