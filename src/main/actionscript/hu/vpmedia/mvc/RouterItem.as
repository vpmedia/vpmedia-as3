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
import hu.vpmedia.framework.BaseConfig;

/**
 * The RouterItem class provides configuration for the MVC contexts controlled by the Router.
 */
public final class RouterItem extends BaseConfig {
    /**
     * Model Class
     */
    public var model:Class;

    /**
     * View Class
     */
    public var view:Class;

    /**
     * Controller Class
     */
    public var controller:Class;

    /**
     * Mediator Class
     */
    public var mediator:Class;

    /**
     * Route Id
     */
    public var url:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * RouterItem
     *
     * @param parameters Class instance parameters
     */
    public function RouterItem(parameters:Object = null) {
        super(parameters);
    }

    /**
     * Will return object information in string format
     */
    public function toString():String {
        return "[RouterItem "
                + " url=" + url
                + " model=" + model
                + " view=" + view
                + " controller=" + controller
                + " mediator=" + mediator
                + "]";
    }
}
}
