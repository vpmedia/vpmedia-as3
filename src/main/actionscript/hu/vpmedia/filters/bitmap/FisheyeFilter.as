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

public class FisheyeFilter extends BaseFilter {
    /**
     * Generate the DisplacementMapFilter for fisheye effect.
     *
     * @params source   BitmapData  The input bitmap data to apply the twirling effect.
     * @params amount   Number      Amount of fisheye (0 <= x <= 1)
     * @return DisplacementMapFilter  The filter to apply the fisheye effect.
     */
    public static function render(source:BitmapData, amount:Number = 0.8):DisplacementMapFilter {
        var width:int = source.width;
        var height:int = source.height;
        var dbmd:BitmapData = new BitmapData(width, height, false, 0x8080);
        var centerX:int = width / 2;
        var centerY:int = height / 2;
        var radius:Number = Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2));
        for (var y:int = 0; y < height; ++y) {
            var ycoord:int = y - centerY;
            for (var x:int = 0; x < width; ++x) {
                var xcoord:int = x - centerX;
                var d:Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
                if (d < radius) {
                    var t:Number = d == 0 ? 0 : Math.pow(Math.sin(Math.PI / 2 * d / radius), amount);
                    var dx:Number = xcoord * (t - 1) / width;
                    var dy:Number = ycoord * (t - 1) / height;
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
