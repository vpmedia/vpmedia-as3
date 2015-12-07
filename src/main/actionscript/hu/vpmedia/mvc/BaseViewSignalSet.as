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

import org.osflash.signals.ISignal;

/**
 * The BaseViewSignalSet class encapsulates signals supporting the IBaseView based classes.
 *
 * @see BaseViewSignalTypes
 */
public class BaseViewSignalSet extends BaseSignalSet {

    /**
     * Constructor
     */
    public function BaseViewSignalSet() {
        super();
    }

    /**
     * Dispatched when the object starts to transition in
     *
     * @return ISignal
     */
    public function get transitionInStart():ISignal {
        return getSignal(BaseViewSignalTypes.TRANSITION_IN_START);
    }

    /**
     * Dispatched when the object ends with transition in
     *
     * @return ISignal
     */
    public function get transitionInComplete():ISignal {
        return getSignal(BaseViewSignalTypes.TRANSITION_IN_COMPLETE);
    }

    /**
     * Dispatched when the object starts to transition out
     *
     * @return ISignal
     */
    public function get transitionOutStart():ISignal {
        return getSignal(BaseViewSignalTypes.TRANSITION_OUT_START);
    }

    /**
     * Dispatched when the object end with transition out
     *
     * @return ISignal
     */
    public function get transitionOutComplete():ISignal {
        return getSignal(BaseViewSignalTypes.TRANSITION_OUT_COMPLETE);
    }

    /**
     * Dispatched when the object content has been created
     *
     * @return ISignal
     */
    public function get contentCreationComplete():ISignal {
        return getSignal(BaseViewSignalTypes.CONTENT_CREATION_COMPLETE);
    }

    /**
     * Dispatched when the object content has starts to destroy
     *
     * @return ISignal
     */
    public function get contentDisposeStart():ISignal {
        return getSignal(BaseViewSignalTypes.CONTENT_DISPOSE_START);
    }
}
}
