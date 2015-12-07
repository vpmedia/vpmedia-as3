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
package hu.vpmedia.assets.parsers {
import flash.utils.ByteArray;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The BaseAsyncAssetParser is the abstract template class for all asynchronous parsers.
 */
public class BaseAsyncAssetParser extends BaseAssetParser {

    //----------------------------------
    //  Public properties
    //----------------------------------

    /**
     * The Signal dispatched when the parsing operation is completed.
     */
    public var completed:ISignal;

    /**
     * The Signal dispatched when the parsing operation is progressed.
     */
    public var progressed:ISignal;

    /**
     * The Signal dispatched when the parsing operation is failed.
     */
    public var failed:ISignal;

    //----------------------------------
    //  Protected properties
    //----------------------------------

    /**
     * @private
     */
    protected var _progress:Number;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function BaseAsyncAssetParser() {
        completed = new Signal(BaseAsyncAssetParser);
        progressed = new Signal(BaseAsyncAssetParser);
        failed = new Signal(BaseAsyncAssetParser);
        _progress = 0;
        super();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Parses an object asynchronously.
     */
    public function parseAsync(value:ByteArray, params:Object):void {
        throw new Error("Not implemented: parseAsync()");
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        super.dispose();

        if (completed)
            completed.removeAll();
        completed = null;

        if (progressed)
            progressed.removeAll();
        progressed = null;

        if (failed)
            failed.removeAll();
        failed = null;
    }

    //----------------------------------
    //  Getters / setters
    //----------------------------------

    /**
     * TBD
     */
    public function get progress():Number {
        return _progress;
    }

}
}
