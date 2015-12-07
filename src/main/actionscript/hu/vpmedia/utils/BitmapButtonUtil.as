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
import com.docmet.core.CacheUtil;

import flash.display.Bitmap;
import flash.display.SimpleButton;
import flash.display.Sprite;

import hu.vpmedia.errors.StaticClassError;

/**
 * Utility class for Bitmap Button manipulation
 */
public class BitmapButtonUtil {
    public static var suffix:String = ".png";

    /**
     * @private
     */
    public function BitmapButtonUtil() {
        throw new StaticClassError();
    }

    /**
     * SimpleButton factory helper method
     */
    public static function create(target:Sprite, x:int, y:int, id:String):SimpleButton {
        var baseBitmap:Bitmap = CacheUtil.getBitmap(id + "_base" + suffix);
        var overBitmap:Bitmap = CacheUtil.getBitmap(id + "_over" + suffix);
        var downBitmap:Bitmap = CacheUtil.getBitmap(id + "_down" + suffix);
        var result:SimpleButton = ButtonUtil.createSimpleButton(target, x, y, baseBitmap, overBitmap, downBitmap);
        return result;
    }

}
}
