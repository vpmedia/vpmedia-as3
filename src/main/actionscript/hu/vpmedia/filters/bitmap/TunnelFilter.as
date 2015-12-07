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

public class TunnelFilter extends BaseFilter {
    /**
     * Generate the DisplacementMapFilter for photic tunnel effect.
     * Photic tunnel effect is as same as effect of Photo Booth application in Mac OS.
     *
     * You can apply the filter is as follows:
     *
     *    var bmd:BitmapData = new BitmapData(width, height, false);
     *    var filter:DisplacementMapFilter = Filter.pinchFilter(bmd);
     *    bmd.draw(video);
     *    bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), filter);
     *
     * @params source     BitmapData  The input bitmap data to apply the twirling effect.
     * @params region     Rectangle   The region to apply the twirling effect.
     * @return DisplacementMapFilter  Filter to apply photic tunnel effect.
     */
    public static function render(source:BitmapData, region:Rectangle = null):DisplacementMapFilter {
        var width:int = source.width;
        var height:int = source.height;
        region ||= new Rectangle(0, 0, width, height);
        var centerX:int = region.x + region.width / 2;
        var centerY:int = region.y + region.height / 2;
        var dbmd:BitmapData = new BitmapData(width, height, false, 0x8080);
        var radius:Number = Math.min(region.width, region.height) / 2;
        for (var y:int = 0; y < height; ++y) {
            var ycoord:int = y - centerY;
            for (var x:int = 0; x < width; ++x) {
                var xcoord:int = x - centerX;
                var d:Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
                if (radius < d) {
                    var angle:Number = Math.atan2(Math.abs(ycoord), Math.abs(xcoord));
                    var dx:Number = (xcoord > 0 ? -1 : 1) * (d - radius) * Math.cos(angle) / width;
                    var dy:Number = (ycoord > 0 ? -1 : 1) * (d - radius) * Math.sin(angle) / height;
                    var blue:int = 0x80 + dx * 0xff;
                    var green:int = 0x80 + dy * 0xff;
                    dbmd.setPixel(x, y, green << 8 | blue);
                }
            }
        }
        return new DisplacementMapFilter(dbmd, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.GREEN, width, height, DisplacementMapFilterMode.CLAMP);
    }
}
}
