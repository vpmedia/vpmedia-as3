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

public class TwirlFilter extends BaseFilter {
    /**
     * Generate the DisplacementMapFilter for twirling effect.
     *
     * You can apply the filter is as follows:
     *
     *    var bmd:BitmapData = new BitmapData(width, height, false);
     *    var filter:DisplacementMapFilter = Filter.twirlFilter(bmd);
     *    bmd.draw(video);
     *    bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), filter);
     *
     * You can also apply the filter specified region:
     *
     *    var region:Rectangle = new Rectangle(100, 100, 100, 100);
     *    var filter:DisplacementMapFilter = Filter.twirlFilter(bmd, rect);
     *
     * @params source     BitmapData  The input bitmap data to apply the twirling effect.
     * @params region     Rectangle   The region to apply the twirling effect.
     * @params rotation   Number      The max amount to rotate, in radius.
     *                                Default is Math.PI / 2.
     *
     * @return DisplacementMapFilter    Filter to apply twirl effect
     */
    public static function render(source:BitmapData, region:Rectangle = null, rotation:Number = 0):DisplacementMapFilter {
        var width:int = source.width;
        var height:int = source.height;
        region ||= new Rectangle(0, 0, width, height);
        rotation ||= Math.PI / 2;
        var dbmd:BitmapData = new BitmapData(width, height, false, 0x8080);
        var radius:Number = Math.min(region.width, region.height) / 2;
        var centerX:int = region.x + region.width / 2;
        var centerY:int = region.y + region.height / 2;
        for (var y:int = 0; y < height; ++y) {
            var ycoord:int = y - centerY;
            for (var x:int = 0; x < width; ++x) {
                var xcoord:int = x - centerX;
                var dr:Number = radius - Math.sqrt(xcoord * xcoord + ycoord * ycoord);
                if (dr > 0) {
                    var angle:Number = dr / radius * rotation;
                    var dx:Number = xcoord * Math.cos(angle) - ycoord * Math.sin(angle) - xcoord;
                    var dy:Number = xcoord * Math.sin(angle) + ycoord * Math.cos(angle) - ycoord;
                    var blue:int = 0x80 + Math.round(dx / width * 0xff);
                    var green:int = 0x80 + Math.round(dy / height * 0xff);
                    dbmd.setPixel(x, y, green << 8 | blue);
                }
            }
        }
        return new DisplacementMapFilter(dbmd, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.GREEN, width, height, DisplacementMapFilterMode.IGNORE);
    }
}
}
