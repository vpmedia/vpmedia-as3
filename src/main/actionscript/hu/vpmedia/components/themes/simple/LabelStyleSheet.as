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
import hu.vpmedia.utils.TextFieldConfig;

/**
 * TBD
 */
public class LabelStyleSheet extends BaseStyleSheet {

    /**
     * TBD
     */
    public var labelDefault:TextFieldConfig;

    /**
     * TBD
     */
    public function LabelStyleSheet() {
        super();
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        labelDefault = new TextFieldConfig();
        labelDefault.textFormat = new TextFormat(ThemeConfig.FONT_NAME, ThemeConfig.FONT_SIZE, ThemeConfig.FONT_DEFAULT_COLOR, null, null, null, null, null, null, null, null, null, null);
    }
}
}
