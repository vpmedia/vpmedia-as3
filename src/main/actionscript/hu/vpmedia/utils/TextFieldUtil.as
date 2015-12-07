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
import flash.display.DisplayObjectContainer;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for TextField manipulation.
 *
 * @see flash.text.TextField
 */
public final class TextFieldUtil {

    /**
     * @private
     */
    public function TextFieldUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Native Text Field Helpers
    //----------------------------------

    /**
     * Helper
     */
    public static function createFromConfig(config:TextFieldConfig, scope:DisplayObjectContainer):TextField {
        var result:TextField = new TextField();
        result.width = config.width;
        result.height = config.height;
        result.x = config.x;
        result.y = config.y;
        result.autoSize = TextFieldAutoSize.NONE;
        var textFormat:TextFormat = new TextFormat(config.fontName, config.fontSize, config.fontColor, config.bold);
        result.defaultTextFormat = textFormat;
        result.text = config.text;
        if (scope)
            scope.addChild(result);
        return result;
    }

    /**
     * Factory method
     */
    public static function create(name:String, x:Number, y:Number, w:Number, h:Number, selectable:Boolean = false, multiline:Boolean = false, border:Boolean = false, embedFonts:Boolean = false, autoSize:String = 'left', textFormat:TextFormat = null):TextField {
        var tf:TextField = new TextField();
        tf.name = name;
        tf.x = x;
        tf.y = y;
        tf.width = w;
        tf.height = h;
        tf.selectable = selectable;
        tf.multiline = multiline;
        tf.border = border;
        tf.embedFonts = embedFonts;
        tf.autoSize = autoSize;
        if (textFormat) {
            tf.defaultTextFormat = textFormat;
        }
        return tf;
    }

    /**
     * Set the text of a <code>TextField</code> while preserving the formatting (leading, kerning, etc).
     * Note: htmlText and styles can break the formatting: no known fix as of yet.
     */
    public static function setFormattedText(tf:TextField, s:String, autoSize:Boolean = true):void {
        var textFormat:TextFormat = tf.getTextFormat();
        if (autoSize) {
            tf.autoSize = TextFieldAutoSize.LEFT;
        }
        if (tf.type == TextFieldType.INPUT) {
            tf.text = s;
        }
        else {
            tf.htmlText = s;
        }
        tf.setTextFormat(textFormat);
    }

    /**
     * Set the <code>TextField</code> space width formatting.
     */
    public static function setSpacesWidth(tf:TextField, space:Number = 1):void {
        var fmt:TextFormat = new TextFormat();
        fmt.letterSpacing = space;
        var i:int = 0;
        while (tf.text.indexOf(" ", i) > -1) {
            var index:int = tf.text.indexOf(" ", i);
            tf.setTextFormat(fmt, index, index + 1);
            i = index + 1;
        }
    }

    /**
     * Set the <code>TextField</code> leading formatting.
     */
    public static function setLeading(tf:TextField, space:Number = 0):void {
        var fmt:TextFormat = tf.getTextFormat();
        fmt.leading = space;
        tf.setTextFormat(fmt);
    }

    /**
     * Ellipse a single-line TextField to a specific width.
     */
    public static function ellipseLine(tf:TextField, width:Number, param:String = "..."):void {
        tf.autoSize = TextFieldAutoSize.LEFT;
        var n:uint = param.length + 1;
        while (tf.textWidth > width) {
            if (tf.textWidth > width * 2) {
                tf.htmlText = tf.htmlText.substr(0, tf.htmlText.length * 0.66 >> 0) + param;
            }
            tf.htmlText = tf.htmlText.substr(0, tf.htmlText.length - n) + param;
        }
    }

}
}