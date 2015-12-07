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
package hu.vpmedia.net {
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * TBD
 */
public class BaseTransmitter {
    //----------------------------------
    //  Variables
    //----------------------------------

    /**
     * TBD
     */
    protected var _signal:ISignal;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * TBD
     */
    public function BaseTransmitter() {
        super();
        initialize();
    }

    //----------------------------------
    //  Core
    //----------------------------------

    /**
     * Initializer
     */
    protected function initialize():void {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * TBD
     */
    public function dispose():void {
        if (_signal) {
            _signal.removeAll();
            _signal = null;
        }
    }

    //----------------------------------
    //  Getter/setter
    //----------------------------------

    /**
     * TBD
     */
    public function sendTransmission(code:String, data:Object = null, level:String = null, source:Object = null):void {
        var medium:BaseTransmission = new BaseTransmission(code, data, level, source);
        signal.dispatch(medium);
    }

    /**
     * TBD
     */
    public function get signal():ISignal {
        if (!_signal)
            _signal = new Signal(BaseTransmission);
        return _signal;
    }

    /**
     * TBD
     */
    public function set signal(value:ISignal):void {
        _signal = value;
    }
}
}
