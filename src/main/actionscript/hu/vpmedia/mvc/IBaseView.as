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

import hu.vpmedia.framework.IBaseDisposable;

/**
 * IBaseView display list interface
 *
 * The view is responsible for mapping graphics onto a device. A viewport typically
 * has a one to one correspondence with a display surface and knows how to render
 * to it. A viewport attaches to a model and renders its contents to the display
 * surface. In addition, when the model changes, the viewport automatically redraws
 * the affected part of the image to reflect those changes. There can be multiple
 * viewports onto the same model and each of these viewports can render the
 * contents of the model to a different display surface.
 */
public interface IBaseView extends IBaseDisposable {
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
    //  Controller
    //----------------------------------

    /**
     * Set the controller object
     */
    function set controller(controller:IBaseController):void;

    /**
     * Get the controller object
     */
    function get controller():IBaseController;

    //----------------------------------
    //  Display list
    //----------------------------------

    /**
     * Set the parent view object
     */
    function set parentView(value:IBaseView):void;

    /**
     * Get the parent view object
     */
    function get parentView():IBaseView;

    /**
     * Get the root view object
     */
    function get rootView():IBaseView;

    /**
     * Get the display list container object
     */
    function get content():Sprite;

    //----------------------------------
    //  Events
    //----------------------------------

    /**
     * Get the signal set object
     */
    function get signalSet():BaseViewSignalSet;

    //----------------------------------
    //  Animation
    //----------------------------------

    /**
     * Starts the transition in animation
     */
    function transitionIn():void;

    /**
     * Starts the transition out animation
     */
    function transitionOut():void;
}
}
