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
import hu.vpmedia.mvc.BaseModel;

/**
 * @copy hu.vpmedia.mvc.IBaseContext
 */
public interface IBaseContext extends IBaseDisposable {

    //----------------------------------
    //  Model
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseContext.model
     */
    function set model(model:BaseModel):void;

    /**
     * @private
     */
    function get model():BaseModel;

    //----------------------------------
    //  View
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseContext.view
     */
    function set view(view:IBaseView):void;

    /**
     * @private
     */
    function get view():IBaseView;

    //----------------------------------
    //  Controller
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseContext.controller
     */
    function set controller(controller:IBaseController):void;

    /**
     * @private
     */
    function get controller():IBaseController;

    //----------------------------------
    //  Mediator
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseContext.mediator
     */
    function set mediator(controller:BaseMediator):void;

    /**
     * @private
     */
    function get mediator():BaseMediator;
}
}
