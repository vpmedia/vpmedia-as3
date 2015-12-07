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

package hu.vpmedia.utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.utils.ByteArray;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for BitmapData manipulation.
 *
 * @see flash.display.BitmapData
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html
 */
public final class BitmapDataUtil {

    /**
     * @private
     */
    public function BitmapDataUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Native BitmapData Helpers
    //----------------------------------


    /**
     * Will return a scaled clone of source BitmapData
     *
     * @param bitmapData The source BitmapData
     * @param scale The scale ratio
     *
     * @return The scaled BitmapData
     */
    public static function scale(bitmapData:BitmapData, scale:Number):BitmapData {
        scale = Math.abs(scale);
        var width:int = (bitmapData.width * scale) || 1;
        var height:int = (bitmapData.height * scale) || 1;
        var result:BitmapData = new BitmapData(width, height, true, 0x00000000);
        var matrix:Matrix = new Matrix();
        matrix.scale(scale, scale);
        bitmapData.lock();
        result.draw(bitmapData, matrix, null, null, null, true);
        bitmapData.unlock();
        return result;
    }


    /**
     * TBD
     */
    public static function copyBitmap(value:Bitmap):Bitmap {
        return new Bitmap(value.bitmapData);
    }

    /**
     * TBD
     */
    public static function bitmapDataToByteArray(bitmapData:BitmapData):ByteArray {
        bitmapData.lock();
        var result:ByteArray = bitmapData.getPixels(bitmapData.rect);
        result.position = 0;
        bitmapData.unlock();
        return result;
    }

    /**
     * TBD
     */
    public static function getBitmapDataInstance(bitmap:Object):BitmapData {
        var bitmapData:BitmapData;
        var bitmapObject:Bitmap;
        if (bitmap is Class) {
            bitmapObject = new bitmap() as Bitmap;
            if (!bitmapObject)
                bitmapData = new bitmap() as BitmapData;
        }
        else {
            bitmapObject = Bitmap(bitmap);
        }
        if (!bitmapData)
            bitmapData = bitmapObject.bitmapData;
        return bitmapData;
    }


}
}