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

import starling.display.Sprite;

/**
 * @copy hu.vpmedia.mvc.BaseContext
 */
public class BaseContext extends Sprite implements IBaseContext {
    /**
     * @private
     */
    protected var _view:IBaseView;

    /**
     * @private
     */
    protected var _controller:IBaseController;

    /**
     * @private
     */
    protected var _model:BaseModel;

    /**
     * @private
     */
    protected var _mediator:BaseMediator;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function BaseContext() {
        // No params
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * @private
     */
    protected function initialize():void {
        // Abstract template
    }

    /**
     * @private
     */
    override public function dispose():void {
        super.dispose();
        _view = null;
        _controller = null;
        _mediator = null;
        _model = null;
    }

    //----------------------------------
    //  Getters / setters
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
    public function set view(view:IBaseView):void {
        _view = view;
    }

    /**
     * @inheritDoc
     */
    public function get view():IBaseView {
        return _view;
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
    public function set mediator(mediator:BaseMediator):void {
        _mediator = mediator;
    }

    /**
     * @inheritDoc
     */
    public function get mediator():BaseMediator {
        return _mediator;
    }
}
}
