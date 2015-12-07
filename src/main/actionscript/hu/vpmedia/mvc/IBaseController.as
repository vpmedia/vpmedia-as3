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
import hu.vpmedia.framework.IBaseDisposable;

/**
 * IBaseController
 *
 * The controller is the subsystem that is responsible for taking input
 * (user input, for example) and updating the model and view as necessary.
 * For example, if the model needs to update data, the controller is responsible for that action.
 *
 */
public interface IBaseController extends IBaseDisposable {

    //----------------------------------
    //  Model
    //----------------------------------

    /**
     * Set the model object
     */
    function set model(model:BaseModel):void;

    /**
     * Get the model object
     */
    function get model():BaseModel;

    //----------------------------------
    //  View
    //----------------------------------

    /**
     * Set the view object
     */
    function set view(view:IBaseView):void;

    /**
     * Get the view object
     */
    function get view():IBaseView;
}
}
