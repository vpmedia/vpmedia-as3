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
import hu.vpmedia.errors.StaticClassError;

/**
 * The BaseViewSignalTypes class contains static properties for the various IBaseView signals.
 *
 * @see BaseViewSignalSet
 */
public class BaseViewSignalTypes {

    /**
     * @private
     */
    public function BaseViewSignalTypes() {
        throw new StaticClassError();
    }

    /**
     * Dispatched when the object content has been created
     */
    public static const CONTENT_CREATION_COMPLETE:String = "contentCreationComplete";

    /**
     * Dispatched when the IBaseView object content has starts to destroy
     */
    public static const CONTENT_DISPOSE_START:String = "contentDisposeStart";

    /**
     * Dispatched when the object starts to transition in
     */
    public static const TRANSITION_IN_START:String = "transitionInStart";

    /**
     * Dispatched when the object ends with transition in
     */
    public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";

    /**
     * Dispatched when the object starts to transition out
     */
    public static const TRANSITION_OUT_START:String = "transitionOutStart";

    /**
     * Dispatched when the object ends with transition out
     */
    public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
}
}
