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
import flash.text.TextFormat;

import hu.vpmedia.components.core.BaseStyleSheet;
import hu.vpmedia.shapes.core.ShapeConfig;
import hu.vpmedia.shapes.textures.SolidFill;
import hu.vpmedia.shapes.textures.SolidStroke;
import hu.vpmedia.utils.TextFieldConfig;

/**
 * @inheritDoc
 */
public class ButtonStyleSheet extends BaseStyleSheet {
    public var backgroundDefault:ShapeConfig;
    public var backgroundOver:ShapeConfig;
    public var backgroundDown:ShapeConfig;
    public var backgroundDisabled:ShapeConfig;
    public var labelDefault:TextFieldConfig;
    public var labelOver:TextFieldConfig;
    public var labelDown:TextFieldConfig;
    public var labelDisabled:TextFieldConfig;

    public function ButtonStyleSheet() {
        super();
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        // Default
        backgroundDefault = new ShapeConfig();
        var fill:SolidFill = new SolidFill();
        fill.color = ThemeConfig.FILL_DEFAULT_COLOR;
        backgroundDefault.fill = fill;
        //backgroundDefault.data = { ellipse : ThemeConfig.ELLIPSE };
        var stroke:SolidStroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_DEFAULT_COLOR;
        backgroundDefault.stroke = stroke;
        // Over
        backgroundOver = new ShapeConfig();
        fill = new SolidFill();
        fill.color = ThemeConfig.FILL_OVER_COLOR;
        backgroundOver.fill = fill;
        stroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_OVER_COLOR;
        backgroundOver.stroke = stroke;
        // Down
        backgroundDown = new ShapeConfig();
        fill = new SolidFill();
        fill.color = ThemeConfig.FILL_DOWN_COLOR;
        backgroundDown.fill = fill;
        stroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_DOWN_COLOR;
        backgroundDown.stroke = stroke;
        // Disabled
        backgroundDisabled = new ShapeConfig();
        fill = new SolidFill();
        fill.color = ThemeConfig.FILL_DISABLED_COLOR;
        backgroundDisabled.fill = fill;
        stroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_DISABLED_COLOR;
        backgroundDisabled.stroke = stroke;
        // Default
        labelDefault = new TextFieldConfig();
        labelDefault.textFormat = new TextFormat(ThemeConfig.FONT_NAME, ThemeConfig.FONT_SIZE, ThemeConfig.FONT_DEFAULT_COLOR, true, null, null, null, null, null, null, null, null, null);
        // Down
        labelDown = new TextFieldConfig();
        labelDown.textFormat = new TextFormat(ThemeConfig.FONT_NAME, ThemeConfig.FONT_SIZE, ThemeConfig.FONT_DOWN_COLOR, true, null, null, null, null, null, null, null, null, null);
        // Disabled
        labelDisabled = new TextFieldConfig();
        labelDisabled.textFormat = new TextFormat(ThemeConfig.FONT_NAME, ThemeConfig.FONT_SIZE, ThemeConfig.FONT_DISABLED_COLOR, true, null, null, null, null, null, null, null, null, null);
        // Over
        labelOver = new TextFieldConfig();
        labelOver.textFormat = new TextFormat(ThemeConfig.FONT_NAME, ThemeConfig.FONT_SIZE, ThemeConfig.FONT_OVER_COLOR, true, null, null, null, null, null, null, null, null, null);
    }
}
}
