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
import flash.utils.Dictionary;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.core.BaseStyleSheet;
import hu.vpmedia.components.core.BaseTheme;
import hu.vpmedia.framework.BaseConfig;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

/**
 * Manager class
 */
public class ThemeManager {

    /**
     * TBD
     */
    private static var registeredInstances:Dictionary = new Dictionary(true);

    /**
     * TBD
     */
    private static var componentStyleSheets:Dictionary = new Dictionary(true);

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("ThemeManager");

    /**
     * TBD
     */
    private static var theme:BaseTheme;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ThemeManager() {
    }

    //--------------------------------------
    //  Public
    //--------------------------------------

    /**
     * TBD
     */
    public static function setTheme(value:BaseTheme):void {
        LOG.debug("setTheme: " + value);
        theme = value;
    }

    /**
     * TBD
     */
    public static function hasStyle(value:String):Boolean {
        return theme.getStyle(value) != null;
    }

    /**
     * TBD
     */
    public static function register(value:BaseComponent):void {
        var classDef:Class = value.toClass();
        if (!componentStyleSheets[classDef]) {
            //LOG.debug("register: " + classDef);
            var className:String = value.toString();
            var defaultStyles:BaseStyleSheet = theme.getStyle(className);
            if (defaultStyles) {
                componentStyleSheets[classDef] = defaultStyles;
            }
        }
        if (!registeredInstances[classDef]) {
            registeredInstances[classDef] = new Dictionary(true);
        }
        if (!registeredInstances[classDef][value]) {
            registeredInstances[classDef][value] = true;
        }
    }

    /**
     * TBD
     */
    public static function setStyleByClass(classDef:Class, name:String, value:BaseConfig):void {
        componentStyleSheets[classDef][name] = value;
        invalidateStyle(classDef);
    }

    /**
     * TBD
     */
    public static function getStyleByClass(classDef:Class, name:String):BaseConfig {
        if (!classDef || !name)
            return null;
        if (!componentStyleSheets[classDef])
            LOG.debug("StyleSheet Class not defined: " + classDef);
        if (componentStyleSheets[classDef] && componentStyleSheets[classDef].hasOwnProperty(name))
            return componentStyleSheets[classDef][name];
        return null;
    }

    /**
     * TBD
     */
    public static function getStyleByName(value:String, name:String):BaseConfig {
        if (!value || !name) {
            return null;
        }
        var styleSheet:BaseStyleSheet = theme.getStyle(value);
        if (styleSheet && styleSheet.hasOwnProperty(name)) {
            return styleSheet[name];
        }
        return null;
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * TBD
     */
    private static function invalidateStyle(componentClass:Class):void {
        var instances:Dictionary = registeredInstances[componentClass];
        for (var p:Object in instances) {
            BaseComponent(p).draw();
        }
    }
}
}
