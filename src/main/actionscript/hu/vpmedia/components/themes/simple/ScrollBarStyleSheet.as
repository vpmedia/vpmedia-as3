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
import hu.vpmedia.components.core.BaseStyleSheet;
import hu.vpmedia.shapes.PixelIconTypes;
import hu.vpmedia.shapes.core.ShapeConfig;
import hu.vpmedia.shapes.textures.SolidFill;
import hu.vpmedia.shapes.textures.SolidStroke;

/**
 * @inheritDoc
 */
public class ScrollBarStyleSheet extends BaseStyleSheet {
    public var backgroundDefault:ShapeConfig;
    public var backgroundOver:ShapeConfig;
    public var backgroundDown:ShapeConfig;
    public var backgroundDisabled:ShapeConfig;
    public var iconDefault:ShapeConfig;
    public var iconOver:ShapeConfig;
    public var iconDown:ShapeConfig;
    public var iconDisabled:ShapeConfig;
    public var upIconDefault:ShapeConfig;
    public var upIconOver:ShapeConfig;
    public var upIconDown:ShapeConfig;
    public var upIconDisabled:ShapeConfig;
    public var downIconDefault:ShapeConfig;
    public var downIconOver:ShapeConfig;
    public var downIconDown:ShapeConfig;
    public var downIconDisabled:ShapeConfig;

    public function ScrollBarStyleSheet() {
        super();
    }

    override protected function initialize():void {
        var iconFill:SolidFill = new SolidFill();
        iconFill.color = ThemeConfig.ICON_DEFAULT_COLOR;
        iconDefault = new ShapeConfig();
        iconDefault.data = {data: PixelIconTypes.SCROLL_GRIP};
        iconDefault.width = iconDefault.data.data[0].length;
        iconDefault.height = iconDefault.data.data.length;
        iconDefault.fill = iconFill;
        iconOver = iconDown = iconDisabled = iconDefault;
        upIconDefault = new ShapeConfig();
        upIconDefault.data = {data: PixelIconTypes.ARROW_1_UP};
        upIconDefault.width = upIconDefault.data.data[0].length;
        upIconDefault.height = upIconDefault.data.data.length;
        upIconDefault.fill = iconFill;
        upIconOver = upIconDown = upIconDisabled = upIconDefault;
        downIconDefault = new ShapeConfig();
        downIconDefault.data = {data: PixelIconTypes.ARROW_1_DOWN};
        downIconDefault.width = downIconDefault.data.data[0].length;
        downIconDefault.height = downIconDefault.data.data.length;
        downIconDefault.fill = iconFill;
        downIconOver = downIconDown = downIconDisabled = downIconDefault;
        backgroundDefault = new ShapeConfig();
        var fill:SolidFill = new SolidFill();
        fill.color = ThemeConfig.FILL_DEFAULT_COLOR;
        backgroundDefault.fill = fill;
        var stroke:SolidStroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_DEFAULT_COLOR;
        backgroundDefault.stroke = stroke;
        backgroundOver = new ShapeConfig();
        fill = new SolidFill();
        fill.color = ThemeConfig.FILL_OVER_COLOR;
        backgroundOver.fill = fill;
        stroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_OVER_COLOR;
        backgroundOver.stroke = stroke;
        backgroundDown = new ShapeConfig();
        fill = new SolidFill();
        fill.color = ThemeConfig.FILL_DOWN_COLOR;
        backgroundDown.fill = fill;
        stroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_DOWN_COLOR;
        backgroundDown.stroke = stroke;
        backgroundDisabled = new ShapeConfig();
        fill = new SolidFill();
        fill.color = ThemeConfig.FILL_DISABLED_COLOR;
        backgroundDisabled.fill = fill;
        stroke = new SolidStroke();
        stroke.color = ThemeConfig.STROKE_DISABLED_COLOR;
        backgroundDisabled.stroke = stroke;
    }
}
}
