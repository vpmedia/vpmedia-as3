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
package hu.vpmedia.components.themes.simple {
import hu.vpmedia.errors.StaticClassError;

/**
 * TBD
 */
public class ThemeConfig {

    /**
     * TBD
     */
    public static var FONT_NAME:String = "Arial";

    /**
     * TBD
     */
    public static var FONT_SIZE:uint = 11;

    /**
     * TBD
     */
    public static var ELLIPSE:Number = 0;

    /**
     * TBD
     */
    public static var ICON_DEFAULT_COLOR:uint;

    /**
     * TBD
     */
    public static var FONT_DEFAULT_COLOR:uint;

    /**
     * TBD
     */
    public static var FONT_OVER_COLOR:uint;

    /**
     * TBD
     */
    public static var FONT_DOWN_COLOR:uint;

    /**
     * TBD
     */
    public static var FONT_DISABLED_COLOR:uint;

    /**
     * TBD
     */
    public static var FILL_DEFAULT_COLOR:uint;

    /**
     * TBD
     */
    public static var FILL_OVER_COLOR:uint;

    /**
     * TBD
     */
    public static var FILL_DOWN_COLOR:uint;

    /**
     * TBD
     */
    public static var FILL_DISABLED_COLOR:uint;

    /**
     * TBD
     */
    public static var STROKE_DEFAULT_COLOR:uint;

    /**
     * TBD
     */
    public static var STROKE_OVER_COLOR:uint;

    /**
     * TBD
     */
    public static var STROKE_DOWN_COLOR:uint;

    /**
     * TBD
     */
    public static var STROKE_DISABLED_COLOR:uint;

    /**
     * TBD
     */
    public function ThemeConfig() {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static function setLightTheme():void {
        ICON_DEFAULT_COLOR = 0x999999;

        FONT_DEFAULT_COLOR = 0x000000;
        FONT_OVER_COLOR = 0x333333;
        FONT_DOWN_COLOR = 0x666666;
        FONT_DISABLED_COLOR = 0x999999;

        FILL_DEFAULT_COLOR = 0xFFFFFF;
        FILL_OVER_COLOR = 0xEEEEEE;
        FILL_DOWN_COLOR = 0xDDDDDD;
        FILL_DISABLED_COLOR = 0xAAAAAA;

        STROKE_DEFAULT_COLOR = 0xDDDDDD;
        STROKE_OVER_COLOR = 0xAAAAAA;
        STROKE_DOWN_COLOR = 0x777777;
        STROKE_DISABLED_COLOR = 0x444444;
    }

    /**
     * TBD
     */
    public static function setDarkTheme():void {
        ICON_DEFAULT_COLOR = 0xFEFEFE;

        FONT_DEFAULT_COLOR = 0xFFFFFF;
        FONT_OVER_COLOR = 0xEEEEEE;
        FONT_DOWN_COLOR = 0xDDDDDD;
        FONT_DISABLED_COLOR = 0xAAAAAA;

        FILL_DEFAULT_COLOR = 0x000000;
        FILL_OVER_COLOR = 0x333333;
        FILL_DOWN_COLOR = 0x666666;
        FILL_DISABLED_COLOR = 0x999999;

        STROKE_DEFAULT_COLOR = 0x333333;
        STROKE_OVER_COLOR = 0x666666;
        STROKE_DOWN_COLOR = 0x999999;
        STROKE_DISABLED_COLOR = 0xCCCCCC;
    }
}
}
