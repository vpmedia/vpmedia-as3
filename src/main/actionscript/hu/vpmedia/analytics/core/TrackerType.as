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
package hu.vpmedia.analytics.core {
import hu.vpmedia.errors.StaticClassError;

/**
 * @private
 */
public class TrackerType {

    /**
     * TBD
     */
    public static const PAGE_VIEW:String = "pageview";

    /**
     * TBD
     */
    public static const EVENT:String = "event";

    /**
     * TBD
     */
    public static const SOCIAL:String = "social";

    /**
     * TBD
     */
    public static const EXCEPTION:String = "exception";

    /**
     * TBD
     */
    public static const SCREEN_VIEW:String = "screenview";

    /**
     * TBD
     */
    public static const TIMING:String = "timing";

    /**
     * TBD
     */
    public static const TRANSACTION:String = "transaction";

    /**
     * @private
     */
    public function TrackerType() {
        throw new StaticClassError();
    }
}
}
