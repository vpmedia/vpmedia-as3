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
package hu.vpmedia.signals {
import flash.utils.Dictionary;

/**
 * TBD
 */
public class SimpleSignal {
    /**
     * @private
     */
    private var dataProvider:Dictionary;

    /**
     * @private
     */
    private var weakKeys:Boolean;

    /**
     * @private
     */
    private static const DEFAULT_SIGNAL:uint = 0x01;

    /**
     * @private
     */
    private static const ONCE_SIGNAL:uint = 0x02;

    /**
     * TBD
     */
    public function SimpleSignal(weakKeys:Boolean = true) {
        this.weakKeys = weakKeys;
        dataProvider = new Dictionary(weakKeys);
    }

    /**
     * TBD
     */
    public function add(listener:Function, isOnce:Boolean = false):void {
        dataProvider[listener] = isOnce ? ONCE_SIGNAL : DEFAULT_SIGNAL;
    }

    /**
     * TBD
     */
    public function remove(listener:Function):void {
        dataProvider[listener] = null;
        delete dataProvider[listener];
    }

    /**
     * TBD
     */
    public function has(listener:Function):Boolean {
        return dataProvider[listener] != null;
    }

    /**
     * TBD
     */
    public function removeAll():void {
        var listener:Function;
        for (var key:Object in dataProvider) {
            listener = key as Function;
            remove(listener);
        }
        listener = null;
        dataProvider = new Dictionary(weakKeys);
    }

    /**
     * TBD
     */
    public function dispatch(...args):void {
        var listener:Function;
        for (var key:Object in dataProvider) {
            listener = key as Function;
            listener.apply(null, args);
            if (dataProvider[listener] == ONCE_SIGNAL)
                remove(listener);
        }
        listener = null;
    }

    /**
     * TBD
     */
    public function numListeners():uint {
        var result:uint;
        for (var key:Object in dataProvider) {
            result++;
        }
        return result;
    }
}
}
