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
import flash.utils.Dictionary;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for Dictionary manipulation.
 *
 * @see flash.utils.Dictionary
 */
public final class DictionaryUtil {

    //----------------------------------
    //  Constructor (private)
    //----------------------------------

    /**
     * @private
     */
    public function DictionaryUtil() {
        throw new StaticClassError();
    }

    /**
     * Return an Array of all keys in the dictionary.
     * TODO: Check whether we are better with vector*
     *
     * @param dict A dictionary who's keys will be returned.
     * @return The array containing the keys
     */
    public static function keys(dict:Dictionary):Array {
        var a:Array = [];
        var key:Object;
        for (key in dict)
            a.push(key);
        return a;
    }

    /**
     * Return an Array of all values in the dictionary.
     * TODO: Check whether we are better with vector*
     *
     * @param dict A dictionary who's values will be returned.
     * @return The array containing the values
     */
    public static function values(dict:Dictionary):Array {
        var a:Array = [];
        var value:Object;
        for each (value in dict)
            a.push(value);
        return a;
    }

    /**
     * TBD
     */
    public static function clear(dict:Dictionary):uint {
        var result:uint = 0;
        for (var p:Object in dict) {
            dict[p] = null;
            delete dict[p];
            result++;
        }
        return result;
    }

    /**
     * TBD
     */
    public static function length(dict:Dictionary):uint {
        var result:uint = 0;
        for (var p:Object in dict)
            p != null ? result++ : result;
        return result;
    }

}
}
