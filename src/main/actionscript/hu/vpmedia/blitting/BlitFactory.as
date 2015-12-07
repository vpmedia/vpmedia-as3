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

package hu.vpmedia.blitting {
import flash.display.BitmapData;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * TBD
 */
public class BlitFactory {

    /**
     * @private
     */
    private static const point:Point = new Point(0, 0);

    /**
     * @private
     */
    private static const smoothing:Boolean = true;

    /**
     * @private
     */
    private static const noRGBA:int = 0x00000000;

    /**
     * TBD
     */
    public function BlitFactory() {
    }

    /**
     * TBD
     */
    public static function parse(xml:XML, atlas:BlitAtlas):void {
        trace("BlitSparrow::parse", xml);
        for each (var subTexture:XML in xml.SubTexture) {
            var name:String = subTexture.attribute("name");
            var x:Number = parseFloat(subTexture.attribute("x"));
            var y:Number = parseFloat(subTexture.attribute("y"));
            var width:Number = parseFloat(subTexture.attribute("width"));
            var height:Number = parseFloat(subTexture.attribute("height"));
            var frameX:Number = parseFloat(subTexture.attribute("frameX"));
            var frameY:Number = parseFloat(subTexture.attribute("frameY"));
            var frameWidth:Number = parseFloat(subTexture.attribute("frameWidth"));
            var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight"));
            var region:Rectangle = new Rectangle(x, y, width, height);
            var frame:Rectangle = frameWidth > 0 && frameHeight > 0 ? new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
            atlas.addArea(name, region, frame);
        }
    }

    /**
     * TBD
     */
    public static function createRotationListFromBitmapData(source:BitmapData, inc:int, offset:int = 0):Array {
        var tileList:Array = [];
        var rotation:int = offset;
        while (rotation < (360 + offset)) {
            var angleInRadians:Number = Math.PI * 2 * (rotation / 360);
            var rotationMatrix:Matrix = new Matrix();
            rotationMatrix.translate(-source.width * .5, -source.height * .5);
            rotationMatrix.rotate(angleInRadians);
            rotationMatrix.translate(source.width * .5, source.height * .5);
            var bitmapData:BitmapData = new BitmapData(source.width, source.height, smoothing, noRGBA);
            bitmapData.draw(source, rotationMatrix);
            tileList.push(bitmapData.clone());
            rotation += inc;
            bitmapData.dispose();
            bitmapData = null;
            rotationMatrix = null;
        }
        return (tileList);
    }

    /**
     * TBD
     */
    public static function createFadeOutListFromBitmapData(source:BitmapData, steps:int):Array {
        var tileList:Array = [];
        var stepAmount:Number = 1 / steps;
        var i:int;
        for (i = 0; i <= steps; i++) {
            var alpha:Number = 1 - (i * stepAmount)
            var alphaMatrix:ColorMatrixFilter = new ColorMatrixFilter([ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, alpha, 0 ]);
            var bitmapData:BitmapData = new BitmapData(source.width, source.height, smoothing, noRGBA);
            bitmapData.applyFilter(source, bitmapData.rect, point, alphaMatrix);
            tileList.push(bitmapData.clone());
            bitmapData.dispose();
            bitmapData = null;
            alphaMatrix = null;
        }
        return (tileList);
    }
}
}
