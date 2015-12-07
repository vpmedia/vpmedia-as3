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
package hu.vpmedia.starlingmvc {
import hu.vpmedia.mvc.BaseModel;
import hu.vpmedia.mvc.BaseViewSignalSet;

import starling.display.Sprite;
import starling.events.Event;

/**
 * @copy hu.vpmedia.mvc.BaseView
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
     * @param    model
     * @param    controller
     */
    function BaseView(model:BaseModel = null, controller:IBaseController = null) {
        _model = model;
        _controller = controller;
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    //----------------------------------
    //  Bootstrap
    //----------------------------------

    /**
     * @private
     */
    private final function onAdded(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        initialize();
    }

    /**
     * @private
     */
    protected function initialize():void {
        createChildren();
        signalSet.contentCreationComplete.dispatch();
    }

    /**
     * @private
     */
    protected function createChildren():void {
        // abstract prototype
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        if(_signals) {
            _signals.contentDisposeStart.dispatch();
            _signals.removeAll();
        }
        if (_controller) {
            _controller.dispose();
        }
        _signals = null;
        _controller = null;
        _model = null;
        _parent = null;
        super.dispose();
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
     * @inheritDoc
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

    //----------------------------------
    //  Getters
    //----------------------------------
    /**
     * @inheritDoc
     */
    public function get content():Sprite {
        return this;
    }

    //----------------------------------
    //  Leaf
    //----------------------------------

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

    //----------------------------------
    //  Mouse Stuff
    //----------------------------------

    /**
     * Determines whether or not the children of the object are mouse or user input device enabled.
     */
    public function get mouseChildren():Boolean {
        return this.touchable;
    }

    /**
     * Determines whether or not the children of the object are mouse or user input device enabled.
     */
    public function set mouseChildren(value:Boolean):void {
        this.touchable = value;
    }

    //----------------------------------
    //  Signal
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function get signalSet():BaseViewSignalSet {
        if (!_signals) {
            _signals = new BaseViewSignalSet();
        }
        return _signals;
    }

    //----------------------------------
    //  Signal
    //----------------------------------

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
}
}
