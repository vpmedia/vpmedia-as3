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
/**
 * The BaseController class is responsible for handling events and signals.
 */
public class BaseController implements IBaseController {
    /**
     *
     * @private
     */
    protected var _view:IBaseView;

    /**
     *
     * @private
     */
    protected var _model:BaseModel;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function BaseController(view:IBaseView, model:BaseModel = null) {
        _view = view;
        _model = model;
        initialize();
    }

    //----------------------------------
    //  Bootstrap
    //----------------------------------

    /**
     * Initializer
     */
    protected function initialize():void {
        // abstract template
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Destroyer
     */
    public function dispose():void {
        // abstract template
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
    public function set view(view:IBaseView):void {
        _view = view;
    }

    /**
     * @inheritDoc
     */
    public function get view():IBaseView {
        return _view;
    }
}
}
