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
import flash.globalization.LocaleID;
import flash.utils.Dictionary;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for globalization.
 *
 * @see flash.globalization.LocaleID
 */
public final class LocaleUtil {

    //----------------------------------
    //  Private properties
    //----------------------------------

    /**
     *  @private
     */
    private static const LOCALE_DP:Dictionary = new Dictionary();

    /**
     * @private
     */
    private static const DEFAULT_LANG:String = "en";

    /**
     * @private
     */
    private static var LOCALE_ID:LocaleID = new LocaleID(DEFAULT_LANG);

    //----------------------------------
    //  Constructor (private)
    //----------------------------------

    /**
     * @private
     */
    public function LocaleUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * Get current locale object.
     *
     * @see LocaleID
     */
    public static function getCurrentLocale():LocaleID {
        return LOCALE_ID;
    }

    /**
     * Sets the current locale object.
     *
     * @see LocaleID
     */
    public static function setCurrentLocale(value:String):void {
        LOCALE_ID = new LocaleID(value);
    }

    /**
     * Get current language identifier.
     *
     * @see LocaleID.getLanguage()
     */
    public static function getCurrentLanguage():String {
        return LOCALE_ID.getLanguage().toUpperCase();
    }

    /**
     * Retrieve localized string
     *
     * @param key
     */
    public static function getLocale(key:String):String {
        const langKey:String = getCurrentLanguage();
        if (!LOCALE_DP[langKey])
            return key;
        var result:String = LOCALE_DP[langKey][key];
        if (!result || result == "") {
            result = key;
        }
        return result;
    }

    /**
     * Register localized string
     *
     * @param key
     * @param value
     * @param lang
     */
    public static function setLocale(key:String, value:String, lang:String = DEFAULT_LANG):void {
        const langKey:String = lang.toUpperCase();
        if (!LOCALE_DP[langKey])
            LOCALE_DP[langKey] = new Dictionary();
        LOCALE_DP[langKey][key] = value;
    }
}
}
