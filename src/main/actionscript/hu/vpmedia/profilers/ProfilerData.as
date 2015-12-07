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

package hu.vpmedia.profilers {
import flash.utils.getTimer;

/**
 * TBD
 */
public class ProfilerData {

    /**
     * TBD
     */
    public var peak:int = 0;

    /**
     * TBD
     */
    public var prev:int = 0;

    /**
     * TBD
     */
    public var cur:int = 0;

    /**
     * TBD
     */
    public var diff:int = 0;

    /**
     * TBD
     */
    public var decreaseCount:int = 0;

    /**
     * TBD
     */
    public var increaseCount:int = 0;

    /**
     * TBD
     */
    public var accumIncrease:int = 0;

    /**
     * TBD
     */
    public var accumDecrease:int = 0;

    /**
     * TBD
     */
    public var maxIncrease:int = 0;

    /**
     * TBD
     */
    public var maxDecrease:int = 0;

    /**
     * TBD
     */
    public var initTime:Number = 0;

    /**
     * TBD
     */
    public var elapsed:Number = 0;

    /**
     * TBD
     */
    public function ProfilerData() {
        initTime = getTimer();
    }

    /**
     * TBD
     *
     * sampleData: System.totalMemory >> 12 || Stage.currentFps..
     */
    public function step(sampleData:Number):void {
        cur = sampleData;

        elapsed = (getTimer() - initTime) / 1000;

        if (cur == prev) {
            return;
        }

        if (cur > peak) {
            peak = cur;
        }

        if (cur > prev && prev > 0) {
            diff = cur - prev;
            if (diff > maxIncrease) {
                maxIncrease = diff;
            }
            accumIncrease += diff;
            increaseCount++;
        }
        else if (cur < prev) {
            diff = prev - cur;
            if (diff > maxDecrease) {
                maxDecrease = diff;
            }
            accumDecrease += diff;
            diff = -diff;
            decreaseCount++;
        }

        //show("time running: " + elapsed + "\n" + "current: " + cur + "\n" + "previous: " + prev + "\n" + "diff: " + diff + "\n" + "peak: " + peak + "\n" + "increaseCount: " + increaseCount + "\n" + "decreaseCount: " + decreaseCount + "\n" + "accumIncrease: " + accumIncrease + "\n" + "accumDecrease: " + accumDecrease + "\n" + "maxIncrease:   " + maxIncrease + "\n" + "maxDecrease:   " + maxDecrease);

        prev = cur;

    }

    /*public function show(value:String)
     {
     // TODO
     }*/
}
}
