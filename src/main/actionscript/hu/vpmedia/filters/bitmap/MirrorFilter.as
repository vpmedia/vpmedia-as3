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
import flash.geom.*;

public class MirrorFilter extends BaseFilter {
    /**
     * Generate the BitmapData which applied mirror effect.
     *
     * You can create the mirrored BitmapData is as follows:
     *
     *   var bmd = new BitmapData(video.width, video.height, false);
     *   bmd.draw(video);
     *   var mirroredBmd = Filter.mirror(bmd);
     *
     * @params source BitmapData  The input bitmap data to apply the mirror effect.
     * @params region Rectangle   The region to apply the twirling effect. Default is entire region.
     * @return BitmapData         BitmapData which applied the mirror effect
     */
    public static function render(source:BitmapData):BitmapData {
        var bmd:BitmapData = new BitmapData(source.width, source.height, false);
        var halfWidth:int = Math.round(source.width / 2);
        source.lock();
        bmd.copyPixels(source, new Rectangle(0, 0, halfWidth, source.height), new Point(0, 0));
        for (var i:int = 0; i < source.height; ++i) {
            for (var j:int = 0; j < halfWidth; ++j) {
                bmd.setPixel32(halfWidth + j, i, source.getPixel32(halfWidth - j, i));
            }
        }
        source.unlock();
        return bmd;
    }
}
}
