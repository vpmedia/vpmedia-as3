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
import flash.display.Stage;
import flash.geom.Rectangle;
import flash.text.StageText;
import flash.text.StageTextInitOptions;
import flash.text.engine.FontWeight;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for StageText manipulation.
 *
 * @see flash.text.StageText
 */
public final class StageTextUtil {

    /**
     * @private
     */
    public function StageTextUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Native Text Field Helpers
    //----------------------------------

    /**
     * Helper
     */
    public static function createFromConfig(config:TextFieldConfig, scope:Stage):StageText {
        const initOptions:StageTextInitOptions = new StageTextInitOptions();
        var result:StageText = new StageText(initOptions);
        result.viewPort = new Rectangle(config.x, config.y, config.width, config.height);
        result.color = config.fontColor;
        result.fontSize = config.fontSize;
        result.fontFamily = config.fontName;
        result.fontWeight = config.bold ? FontWeight.BOLD : FontWeight.NORMAL;
        result.text = config.text;
        if (scope)
            result.stage = scope;
        return result;
    }

}
}