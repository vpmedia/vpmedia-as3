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
import flash.display.BitmapData;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;

/**
 * Contains reusable methods for Mouse manipulation.
 *
 * @see flash.ui.Mouse
 */
public class MouseUtil {

    public static function registerAndSetCursor(name:String, bitmapData:BitmapData):void {
        if(!Mouse.supportsCursor && !Mouse.supportsNativeCursor) {
            return;
        }
        //MouseCursorData allows us to set the appearance of the Mouse Cursor
        var cursorData:MouseCursorData = new MouseCursorData();
        //Vector to hold the bitmapData of our image (the CrossHair)
        var crossHairData:Vector.<BitmapData> = new Vector.<BitmapData>();
        //Set the vector to the bitmapData of the crossHair
        crossHairData[0] = bitmapData;
        // Specify the hotspot
        cursorData.hotSpot = new Point(0, 0)
        //set the cursorData to the vector which holds the crossHairs bitmapData
        cursorData.data = crossHairData;

        Mouse.registerCursor(name, cursorData)
        Mouse.cursor = name;
    }

    public static function unregisterCursor(name:String):void {
        if(!Mouse.supportsCursor && !Mouse.supportsNativeCursor) {
            return;
        }
        Mouse.unregisterCursor(name);
    }
}
}
