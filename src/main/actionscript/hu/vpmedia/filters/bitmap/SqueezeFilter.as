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
package hu.vpmedia.filters.bitmap {
import flash.display.*;
import flash.filters.*;
import flash.geom.*;

public class SqueezeFilter extends BaseFilter {
    /**
     * Generate the DisplacementMapFilter for squeeze effect.
     * Dent effect is wrapper of pinchFilter method.
     *
     * @params source   BitmapData  The input bitmap data to apply the effect.
     * @params region   Rectangle   The region to apply the bulge effect
     * @params amount   Number      Amount of squeeze. (0 <= x <= 1)
     */
    public static function render(source:BitmapData, region:Rectangle = null, amount:Number = 0.5):DisplacementMapFilter {
        // wrapper method of bulge filter
        return PinchFilter.render(source, region, amount);
    }
}
}
