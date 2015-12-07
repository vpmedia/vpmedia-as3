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
package hu.vpmedia.framework {
import flash.utils.Dictionary;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * @inheritDoc
 */
public class BaseSignalSet implements IBaseSignalSet {
    /**
     * @private
     */
    protected var _signals:Dictionary;

    /**
     * Constructor
     */
    public function BaseSignalSet() {
        _signals = new Dictionary(true);
    }

    /**
     * Lazily instantiates a NativeSignal
     */
    public function getSignal(code:String):ISignal {
        if (_signals[code] == null) {
            _signals[code] = new Signal();
        }
        return _signals[code];
    }

    /**
     * The current number of listeners for the signal.
     */
    public function get numListeners():int {
        var result:int = 0;
        for each (var signal:ISignal in _signals) {
            result += signal.numListeners;
        }
        return result;
    }

    /**
     * The signals in the SignalSet as an Vector ISignal.
     */
    public function get signals():Vector.<ISignal> {
        var result:Vector.<ISignal> = new Vector.<ISignal>();
        for each (var signal:ISignal in _signals) {
            result.push(signal);
        }
        return result;
    }

    /**
     * Removes all listeners from all signals in the set.
     */
    public function removeAll():void {
        for each (var signal:ISignal in _signals) {
            signal.removeAll();
        }
        _signals = new Dictionary(true);
    }
}
}
