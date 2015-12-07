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
package hu.vpmedia.components.themes {
import hu.vpmedia.components.core.BaseTheme;
import hu.vpmedia.components.core.ComponentName;
import hu.vpmedia.components.themes.simple.AccordionStyleSheet;
import hu.vpmedia.components.themes.simple.ButtonStyleSheet;
import hu.vpmedia.components.themes.simple.CheckBoxStyleSheet;
import hu.vpmedia.components.themes.simple.ColorPickerStyleSheet;
import hu.vpmedia.components.themes.simple.ComboBoxStyleSheet;
import hu.vpmedia.components.themes.simple.ImageStyleSheet;
import hu.vpmedia.components.themes.simple.LabelStyleSheet;
import hu.vpmedia.components.themes.simple.ListItemStyleSheet;
import hu.vpmedia.components.themes.simple.ListStyleSheet;
import hu.vpmedia.components.themes.simple.NumericStepperStyleSheet;
import hu.vpmedia.components.themes.simple.ProgressBarStyleSheet;
import hu.vpmedia.components.themes.simple.RadioButtonStyleSheet;
import hu.vpmedia.components.themes.simple.ScrollAreaStyleSheet;
import hu.vpmedia.components.themes.simple.ScrollBarStyleSheet;
import hu.vpmedia.components.themes.simple.SliderStyleSheet;
import hu.vpmedia.components.themes.simple.TextAreaStyleSheet;
import hu.vpmedia.components.themes.simple.TextInputStyleSheet;
import hu.vpmedia.components.themes.simple.ThemeConfig;
import hu.vpmedia.components.themes.simple.ToggleSwitchStyleSheet;
import hu.vpmedia.components.themes.simple.WindowStyleSheet;

/**
 * @inheritDoc
 */
public class SimpleTheme extends BaseTheme {

    /**
     * Dark theme
     */
    public static const DARK:uint = 1;

    /**
     * Light theme
     */
    public static const LIGHT:uint = 2;

    /**
     * Custom theme
     */
    public static const CUSTOM:uint = 3;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * @inheritDoc
     */
    public function SimpleTheme(type:uint) {
        switch (type) {
            case DARK:
                ThemeConfig.setDarkTheme();
                break;
            case LIGHT:
                ThemeConfig.setLightTheme();
                break;
            case CUSTOM:
                break;
        }
        super();
    }

    //--------------------------------------
    //  API
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        model[ComponentName.ACCORDION] = new AccordionStyleSheet();
        model[ComponentName.BUTTON] = new ButtonStyleSheet();
        model[ComponentName.LABEL] = new LabelStyleSheet();
        model[ComponentName.TEXT_INPUT] = new TextInputStyleSheet();
        model[ComponentName.TEXT_AREA] = new TextAreaStyleSheet();
        model[ComponentName.CHECK_BOX] = new CheckBoxStyleSheet();
        model[ComponentName.RADIO_BUTTON] = new RadioButtonStyleSheet();
        model[ComponentName.LIST] = new ListStyleSheet();
        model[ComponentName.LIST_ITEM] = new ListItemStyleSheet();
        model[ComponentName.SCROLL_AREA] = new ScrollAreaStyleSheet();
        model[ComponentName.SCROLL_BAR] = new ScrollBarStyleSheet();
        model[ComponentName.SCROLL_BAR_SLIDER] = new SliderStyleSheet();
        model[ComponentName.SLIDER] = new SliderStyleSheet();
        model[ComponentName.COMBO_BOX] = new ComboBoxStyleSheet();
        model[ComponentName.COLOR_PICKER] = new ColorPickerStyleSheet();
        model[ComponentName.NUMERIC_STEPPER] = new NumericStepperStyleSheet();
        model[ComponentName.WINDOW] = new WindowStyleSheet();
        model[ComponentName.PROGRESS_BAR] = new ProgressBarStyleSheet();
        model[ComponentName.IMAGE] = new ImageStyleSheet();
        model[ComponentName.TOGGLE_SWITCH] = new ToggleSwitchStyleSheet();
        model[ComponentName.MENU] = new ToggleSwitchStyleSheet();
        model[ComponentName.MENU_ITEM] = new ToggleSwitchStyleSheet();
        model[ComponentName.SEARCH_INPUT] = new TextInputStyleSheet();
    }
}
}
