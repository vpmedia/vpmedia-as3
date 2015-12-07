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
import hu.vpmedia.framework.IBaseDisposable;

/**
 * @copy hu.vpmedia.mvc.BaseMediator
 */
public class BaseMediator implements IBaseDisposable {
    /**
     * @private
     */
    protected var _view:IBaseView;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function BaseMediator(view:IBaseView) {
        _view = view;
        super();
        if (_view && _view is BaseView) {
            BaseView(_view).signalSet.contentCreationComplete.addOnce(initialize);
            BaseView(_view).signalSet.contentDisposeStart.addOnce(dispose);
        }
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * Will initialize the mediator object
     */
    protected function initialize():void {
        // Abstract template
    }

    /**
     * @inheritDoc
     */
    public function dispose():void {
        // Abstract template
        _view = null;
    }
}
}
