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
import hu.vpmedia.framework.*;

/**
 * Define an object that encapsulates how a set of objects interact. Mediator promotes loose coupling by keeping objects from referring to each other explicitly, and it lets you vary their interaction independently.
 * Varying: how and which objects interact with each other.
 *
 * http://www.as3dp.com/wp-content/uploads/2008/07/mediatordiagram.png
 */
public class BaseMediator implements IBaseDisposable {
    /**
     * @private
     */
    protected var _view:IBaseView;

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

    /**
     * Initializer
     */
    protected function initialize():void {
        // abstract template
    }

    /**
     * @inheritDoc
     */
    public function dispose():void {
        // abstract template
    }
}
}
