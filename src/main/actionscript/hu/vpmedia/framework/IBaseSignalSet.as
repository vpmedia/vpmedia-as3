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
import org.osflash.signals.ISignal;

/**
 * The IBaseSignalSet declares the interface for the various signal set classes.
 * A signal set encapsulates a group of signals.
 */
public interface IBaseSignalSet {
    /**
     * Will return the total number of listeners.
     */
    function get numListeners():int;

    /**
     * Will return an array of signal
     */
    function get signals():Vector.<ISignal>;

    /**
     * Will remove all signal handlers.
     */
    function removeAll():void;

    /**
     * Will return a signal by a string identifier.
     */
    function getSignal(code:String):ISignal;
}
}
