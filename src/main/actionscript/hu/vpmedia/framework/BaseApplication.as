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
package hu.vpmedia.framework {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;

import hu.vpmedia.mvc.BaseContext;
import hu.vpmedia.mvc.IBaseContext;

/**
 * TBD
 */
public class BaseApplication extends BaseContext implements IBaseContext {
    /**
     * TBD
     */
    public static var stage:Stage;

    /**
     * TBD
     */
    public static var root:DisplayObject; // contextView

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * BaseApplication
     * @param    baseStage
     * @param    baseRoot
     */
    public function BaseApplication(baseStage:Stage, baseRoot:DisplayObject) {
        super();
        if (!BaseApplication.stage && baseStage) {
            BaseApplication.stage = baseStage;
        }
        if (!BaseApplication.root && baseRoot) {
            BaseApplication.root = baseRoot;
        }
        addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);
    }

    /**
     * @private
     */
    private function addedHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedHandler, false, 0, true);
        initialize();
    }

    /**
     * @private
     */
    private function removedHandler(event:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
        dispose();
    }
}
}
