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

public class StrechFilter extends BaseFilter {
    /**
     * Generate the DisplacementMapFilter for strech effect.
     *
     * @params source   BitmapData    The input bitmap data to apply the twirling effect.
     * @params amount   Number        Amount of strech (0 <= x <= 1), default is 0.6;
     * @return DisplacementMapFilter  The filter to apply the strech effect.
     */
    public static function render(source:BitmapData, amount:Number = 0.6):DisplacementMapFilter {
        var width:int = source.width;
        var height:int = source.height;
        var dbmd:BitmapData = new BitmapData(width, height, false, 0x8080);
        var centerX:int = width / 2;
        var centerY:int = height / 2;
        var vregion:Rectangle = new Rectangle(0, 0, width / 3, height);
        var hregion:Rectangle = new Rectangle(0, 0, width, height / 3);
        var blue:int;
        var green:int;
        for (var y:int = 0; y < height; ++y) {
            var ycoord:int = y - centerY;
            for (var x:int = 0; x < width; ++x) {
                var xcoord:int = x - centerX;
                var dx:int = (Math.abs(xcoord) < vregion.width) ? xcoord * (Math.pow(Math.abs(xcoord) / vregion.width, amount) - 1) : 0x0;
                var dy:int = (Math.abs(ycoord) < hregion.height) ? ycoord * (Math.pow(Math.abs(ycoord) / hregion.height, amount) - 1) : 0x0;
                blue = 0x80 + 0xff * dx / width;
                green = 0x80 + 0xff * dy / height;
                dbmd.setPixel(x, y, green << 8 | blue);
            }
        }
        return new DisplacementMapFilter(dbmd, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.GREEN, width, height, DisplacementMapFilterMode.CLAMP);
    }
}
}
