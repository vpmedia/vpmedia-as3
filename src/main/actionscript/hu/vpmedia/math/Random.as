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

package hu.vpmedia.math {
import flash.utils.getTimer;

/**
 * Seeded random class
 */
public class Random {

    /**
     * @private
     */
    private const MAX_RATIO:Number = 1 / uint.MAX_VALUE;

    /**
     * @private
     */
    private var seed:uint;

    /**
     * Constructor
     */
    public function Random(seed:uint = 0) {
        this.seed = seed || getTimer();
    }

    /**
     * Returns a random Number from 0 – 1
     */
    public function getSeed():Number {
        seed ^= (seed << 21);
        seed ^= (seed >>> 35);
        seed ^= (seed << 4);
        return (seed * MAX_RATIO);
    }

}
}
