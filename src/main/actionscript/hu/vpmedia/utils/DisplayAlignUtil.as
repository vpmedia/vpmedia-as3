/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
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
import flash.display.DisplayObject;
import flash.geom.Rectangle;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for Dictionary manipulation.
 */
public final class DisplayAlignUtil {

    //----------------------------------
    //  Constructor (private)
    //----------------------------------

    /**
     * @private
     */
    public function DisplayAlignUtil() {
        throw new StaticClassError();
    }


    //--------------------------------------------------------------------------
    //
    //  Display Alignment Utils
    //
    //--------------------------------------------------------------------------

    /**
     Aligns a DisplayObject to the left side of the bounding Rectangle.

     @param displayObject The DisplayObject to align.
     @param bounds The area in which to align the DisplayObject.
     @param snapToPixel Force the position to whole pixels {@code true}, or to let the DisplayObject be positioned on sub-pixels {@code false}.
     */
    public static function alignLeft(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = false):void {
        displayObject.x = snapToPixel ? Math.round(bounds.x) : bounds.x;
    }

    /**
     Aligns a DisplayObject to the right side of the bounding Rectangle.

     @param displayObject The DisplayObject to align.
     @param bounds The area in which to align the DisplayObject.
     @param snapToPixel Force the position to whole pixels {@code true}, or to let the DisplayObject be positioned on sub-pixels {@code false}.
     */
    public static function alignRight(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = false):void {
        var rightX:Number = bounds.width - displayObject.width + bounds.x;
        displayObject.x = snapToPixel ? Math.round(rightX) : rightX;
    }

    /**
     Aligns a DisplayObject to the top of the bounding Rectangle.

     @param displayObject The DisplayObject to align.
     @param bounds The area in which to align the DisplayObject.
     @param snapToPixel Force the position to whole pixels {@code true}, or to let the DisplayObject be positioned on sub-pixels {@code false}.
     */
    public static function alignTop(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = false):void {
        displayObject.y = snapToPixel ? Math.round(bounds.y) : bounds.y;
    }

    /**
     Aligns a DisplayObject to the bottom of the bounding Rectangle.

     @param displayObject The DisplayObject to align.
     @param bounds The area in which to align the DisplayObject.
     @param snapToPixel Force the position to whole pixels {@code true}, or to let the DisplayObject be positioned on sub-pixels {@code false}.
     */
    public static function alignBottom(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = false):void {
        var bottomY:Number = bounds.height - displayObject.height + bounds.y;
        displayObject.y = snapToPixel ? Math.round(bottomY) : bottomY;
    }

    /**
     Aligns a DisplayObject to the horizontal center of the bounding Rectangle.

     @param displayObject The DisplayObject to align.
     @param bounds The area in which to align the DisplayObject.
     @param snapToPixel Force the position to whole pixels {@code true}, or to let the DisplayObject be positioned on sub-pixels {@code false}.
     */
    public static function alignCenter(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = false):void {
        var centerX:Number = bounds.width * 0.5 - displayObject.width * 0.5 + bounds.x;
        displayObject.x = snapToPixel ? Math.round(centerX) : centerX;
    }

    /**
     Aligns a DisplayObject to the vertical middle of the bounding Rectangle.

     @param displayObject The DisplayObject to align.
     @param bounds The area in which to align the DisplayObject.
     @param snapToPixel Force the position to whole pixels {@code true}, or to let the DisplayObject be positioned on sub-pixels {@code false}.
     */
    public static function alignMiddle(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = false):void {
        var centerY:Number = bounds.height * 0.5 - displayObject.height * 0.5 + bounds.y;
        displayObject.y = snapToPixel ? Math.round(centerY) : centerY;
    }

    /**
     Aligns a DisplayObject to the horizontal center and vertical middle of the bounding Rectangle.

     @param displayObject The DisplayObject to align.
     @param bounds The area in which to align the DisplayObject.
     @param snapToPixel Force the position to whole pixels {@code true}, or to let the DisplayObject be positioned on sub-pixels {@code false}.
     */
    public static function alignCenterMiddle(displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = false):void {
        alignCenter(displayObject, bounds, snapToPixel);
        alignMiddle(displayObject, bounds, snapToPixel);
    }


}
}
