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
package hu.vpmedia.timers {
import flash.utils.getTimer;

/**
 * Stopwatch helper class
 */
public class Stopwatch {
    /**
     * @private
     */
    private var startTime:int;

    /**
     * @private
     */
    private var totalTime:int;

    /**
     * @private
     */
    private var isRunning:Boolean;

    /**
     * Constructor
     */
    public function Stopwatch() {
    }

    /**
     * Starts the watch.
     */
    public function start():void {
        if (isRunning) {
            return;
        }
        isRunning = true;
        startTime = getTimer();
    }

    /**
     * Stops the watch.
     */
    public function stop():void {
        if (!isRunning) {
            return;
        }
        totalTime += (getTimer() - startTime);
        isRunning = false;
    }

    /**
     * Resets the watch.
     */
    public function reset():void {
        totalTime = 0;
    }

    /**
     * Returns the total run time
     */
    public function getTotalTime():int {
        if (isRunning) {
            return getTimer() - startTime + totalTime;
        }
        return totalTime;
    }


    /**
     * Will return the description of the object including property information.
     */
    public function toString():String {
        return "[Stopwatch"
                + " isRunning=" + isRunning
                + " startTime=" + startTime
                + " totalTime=" + totalTime
                + "]";
    }
}
}