/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013-2014. Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package hu.vpmedia.starlingx {
import flash.errors.IllegalOperationError;

import hu.vpmedia.errors.StaticClassError;
import hu.vpmedia.utils.TextFieldConfig;

import starling.display.DisplayObjectContainer;
import starling.text.TextField;

/**
 * Contains a static factory method helping TextField creation.
 *
 * @see TextField
 */
public final class TextFieldFactory {

    /**
     * @private
     */
    public function TextFieldFactory() {
        throw new StaticClassError();
    }

    /**
     * Will create a new Starling TextField
     * @param width
     * @param height
     * @param text
     * @param fontName
     * @param fontSize
     * @param color
     * @param bold
     * @param scope
     * @param x
     * @param y
     * @param hAlign
     * @param vAlign
     *
     * @see starling.text.TextField
     */
    public static function create(width:int, height:int, text:String, fontName:String, fontSize:Number, color:uint, bold:Boolean, scope:DisplayObjectContainer, x:int, y:int, hAlign:String = "center", vAlign:String = "center"):TextField {
        if (!width || !height)
            throw new IllegalOperationError("Size cannot be null.");

        var result:TextField = new TextField(width, height, text, fontName, fontSize, color, bold);
        result.hAlign = hAlign;
        result.vAlign = vAlign;
        result.x = x;
        result.y = y;
        result.touchable = false;
        if (scope)
            scope.addChild(result);
        return result;
    }

    /**
     * Creates a TextField from a TextFieldConfig object.
     * @param parameters
     * @param scope
     *
     * @see starling.text.TextField
     * @see hu.vpmedia.utils.TextFieldConfig
     */
    public static function createFromConfig(parameters:TextFieldConfig, scope:DisplayObjectContainer):TextField {
        if (!parameters) {
            return null;
        }
        var result:TextField = new TextField(parameters.width, parameters.height, parameters.text, parameters.fontName, parameters.fontSize, parameters.fontColor, parameters.bold);
        result.hAlign = parameters.hAlign;
        result.vAlign = parameters.vAlign;
        result.x = parameters.x;
        result.y = parameters.y;
        result.italic = parameters.italic;
        result.border = parameters.border;
        result.touchable = false;
        result.visible = !parameters.hidden;
        //result.leading = parameters.leading;
        if (parameters.filters)
            result.nativeFilters = parameters.filters;
        if (scope)
            scope.addChild(result);
        return result;
    }
}
}
