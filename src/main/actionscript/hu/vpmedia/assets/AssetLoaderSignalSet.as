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
package hu.vpmedia.assets {
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The AssetLoaderSignalSet provides signals for the AssetLoader class.
 */
public final class AssetLoaderSignalSet {
    /**
     * Will dispatch load started signals
     */
    public var started:ISignal = new Signal(AssetLoader);

    /**
     * Will dispatch load completed signals
     */
    public var completed:ISignal = new Signal(AssetLoader);

    /**
     * Will dispatch load progressed signals
     */
    public var progressed:ISignal = new Signal(AssetLoader);

    /**
     * Will dispatch load failed signals
     */
    public var failed:ISignal = new Signal(AssetLoader);

    /**
     * Constructor
     */
    public function AssetLoaderSignalSet() {
        // construct
    }

    /**
     * Will destroy all child objects and free up memory.
     */
    public function dispose():void {
        started.removeAll();
        completed.removeAll();
        progressed.removeAll();
        failed.removeAll();
        started = null;
        completed = null;
        progressed = null;
        failed = null;
    }
}
}
