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
package hu.vpmedia.mvc {
import flash.display.Sprite;
import flash.events.Event;

/**
 * The BaseView class is the template class for all traditional display list based views.
 */
public class BaseView extends Sprite implements IBaseView {
    /**
     * @private
     */
    protected var _signals:BaseViewSignalSet;

    /**
     * @private
     */
    protected var _model:BaseModel;

    /**
     * @private
     */
    protected var _controller:IBaseController;

    /**
     * @private
     */
    protected var _parent:IBaseView;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     *
     * @param model TBD
     * @param controller TBD
     */
    function BaseView(model:BaseModel = null, controller:IBaseController = null) {
        //LOG.debug("created");
        _model = model;
        _controller = controller;
        super();
        // _parameters=parameters;, parameters:*=null
        addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);
    }

    //----------------------------------
    //  Event handlers
    //----------------------------------

    /**
     * @private
     */
    private final function addedHandler(event:Event):void {
        addEventListener(Event.REMOVED_FROM_STAGE, removedHandler, false, 0, true);
        removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
        initialize();
    }

    /**
     * @private
     */
    private final function removedHandler(event:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
        dispose();
    }

    //----------------------------------
    //  Liecycle
    //----------------------------------

    /**
     * @private
     */
    protected function initialize():void {
        createChildren();
        createListeners();
        signalSet.contentCreationComplete.dispatch();
    }

    /**
     * @private
     */
    protected function createChildren():void {
        // abstract prototype
    }

    /**
     * @private
     */
    protected function createListeners():void {
        // abstract prototype
    }

    /**
     * @private
     */
    protected function removeListeners():void {
        // abstract prototype
    }

    //----------------------------------
    //  Getters/setters
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function set model(model:BaseModel):void {
        _model = model;
    }

    /**
     * model
     * @return hu.vpmedia.mvc.BaseModel
     */
    public function get model():BaseModel {
        return _model;
    }

    /**
     * @inheritDoc
     */
    public function set controller(controller:IBaseController):void {
        _controller = controller;
    }

    /**
     * @inheritDoc
     */
    public function get controller():IBaseController {
        return _controller;
    }

    /**
     * @inheritDoc
     */
    public function get content():Sprite {
        return this;
    }

    /**
     * @inheritDoc
     */
    public function set parentView(value:IBaseView):void {
        _parent = value;
    }

    /**
     * @inheritDoc
     */
    public function get parentView():IBaseView {
        return _parent;
    }

    /**
     * @inheritDoc
     */
    public function get rootView():IBaseView {
        var parentView:IBaseView = _parent;
        if (parentView) {
            while (parentView.parentView) {
                parentView = parentView.parentView;
            }
        }
        return parentView;
    }

    /**
     * @inheritDoc
     */
    public function get signalSet():BaseViewSignalSet {
        if (!_signals)
            _signals = new BaseViewSignalSet();
        return _signals;
    }

    /**
     * @inheritDoc
     */
    public function transitionIn():void {
        signalSet.transitionInStart.dispatch();
        signalSet.transitionInComplete.dispatch();
    }

    /**
     * @inheritDoc
     */
    public function transitionOut():void {
        signalSet.transitionOutStart.dispatch();
        signalSet.transitionOutComplete.dispatch();
    }

    /**
     * @inheritDoc
     */
    public function dispose():void {
        signalSet.contentDisposeStart.dispatch();
        removeListeners();
        removeChildren();
        //signalSet.contentDisposeComplete.dispatch();
        signalSet.removeAll();
        if (_controller) {
            _controller.dispose();
        }
        _parent = null;
        //LOG.debug("disposed");
    }
}
}
