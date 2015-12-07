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
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import hu.vpmedia.components.core.BaseStyleSheet;
import hu.vpmedia.shapes.core.ShapeConfig;
import hu.vpmedia.shapes.textures.SolidFill;
import hu.vpmedia.shapes.textures.SolidStroke;
import hu.vpmedia.utils.TextFieldConfig;

/**
 * @inheritDoc
 */
public class TextInputStyleSheet extends BaseStyleSheet {
    public var backgroundDefault:ShapeConfig;
    public var backgroundDisabled:ShapeConfig;
    public var labelDefault:TextFieldConfig;
    public var labelDisabled:TextFieldConfig;

    public function TextInputStyleSheet() {
        super();
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        backgroundDefault = new ShapeConfig();
        var fill:SolidFill = new SolidFill();
        fill.color = ThemeConfig.FILL_DEFAULT_COLOR;
        backgroundDefault.fill = fill;
        var stroke:SolidStroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_DEFAULT_COLOR;
        backgroundDefault.stroke = stroke;
        backgroundDisabled = backgroundDefault;
        //
        labelDefault = new TextFieldConfig();
        labelDefault.textFormat = new TextFormat(ThemeConfig.FONT_NAME, ThemeConfig.FONT_SIZE, ThemeConfig.FONT_DEFAULT_COLOR, false, null, null, null, null, null, null, null, null, null);
        labelDefault.autoSize = TextFieldAutoSize.NONE;
        labelDefault.selectable = true;
        labelDefault.type = TextFieldType.INPUT;
        labelDisabled = labelDefault;
    }
}
}
