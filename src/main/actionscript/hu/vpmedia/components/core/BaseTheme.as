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
package hu.vpmedia.components.core {
import flash.utils.Dictionary;

/**
 * TBD
 */
public class BaseTheme {

    /**
     * TBD
     */
    protected var model:Dictionary;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function BaseTheme() {
        model = new Dictionary(true);
        initialize();
    }

    //--------------------------------------
    //  Private (protected)
    //--------------------------------------

    /**
     * Abstract
     */
    protected function initialize():void {
        // override with own stylesheets
    }

    //--------------------------------------
    //  Public
    //--------------------------------------

    /**
     * Gets a stylesheet
     */
    public function getStyle(value:String):BaseStyleSheet {
        return model[value];
    }

    /**
     * Sets a stylesheet
     */
    public function setStyle(name:String, value:BaseStyleSheet):void {
        model[name] = value;
    }
}
}
