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

/**
 * @copy hu.vpmedia.mvc.IBaseView
 */
public interface IBaseView {

    //----------------------------------
    //  Model
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseView.model
     */
    function set model(model:BaseModel):void;

    /**
     * @private
     */
    function get model():BaseModel;

    //----------------------------------
    //  Controller
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseView.controller
     */
    function set controller(controller:IBaseController):void;

    /**
     * @private
     */
    function get controller():IBaseController;

    //----------------------------------
    //  Display list
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseView.parentView
     */
    function set parentView(value:IBaseView):void;

    /**
     * @private
     */
    function get parentView():IBaseView;

    /**
     * @copy hu.vpmedia.mvc.IBaseView.rootView
     */
    function get rootView():IBaseView;

    /**
     * @copy hu.vpmedia.mvc.IBaseView.content
     */
    function get content():Sprite;

    //----------------------------------
    //  Signals
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseView.signalSet
     */
    function get signalSet():BaseViewSignalSet;

    //----------------------------------
    //  Animation
    //----------------------------------

    /**
     * @copy hu.vpmedia.mvc.IBaseView.transitionIn
     */
    function transitionIn():void;

    /**
     * @copy hu.vpmedia.mvc.IBaseView.transitionOut
     */
    function transitionOut():void;
}
}
