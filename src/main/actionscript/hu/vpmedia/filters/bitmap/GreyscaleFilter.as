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

public class GreyscaleFilter extends BaseFilter {
    public static function render(src:BitmapData):BitmapData {
        var p:Number = 1 / 3;
        /*var kernel:Array = [    0, 0, 0, 0, 0,
         0, 0, 0, 0, 0,
         p, p, p, 0, 0,
         0, 0, 0, 1, 0 ];*/
        var r:Number = 0.212671;
        var g:Number = 0.715160;
        var b:Number = 0.072169;
        var kernel:Array = [r, g, b, 0, 0, r, g, b, 0, 0, r, g, b, 0, 0, 0, 0, 0, 1, 0];
        var cf:ColorMatrixFilter = new ColorMatrixFilter(kernel);
        var output:BitmapData = new BitmapData(src.width, src.height, src.transparent, 0x00000000);
        output.applyFilter(src, src.rect, new Point(), cf);
        return output;
    }
}
}
