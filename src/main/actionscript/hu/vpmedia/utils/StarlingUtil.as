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
import com.docmet.core.StarlingApplication;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import hu.vpmedia.errors.StaticClassError;

import starling.animation.DelayedCall;
import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Stage;
import starling.textures.Texture;

/**
 * Contains reusable methods for Starling framework.
 */
public class StarlingUtil {

    /**
     * @private
     */
    private static const POINT:Point = new Point();

    /**
     * @private
     */
    private static var support:RenderSupport;

    /**
     * @private
     */
    public function StarlingUtil() {
        throw new StaticClassError();
    }

    /**
     * Clears a dictionary of DelayedCall objects
     * and optionally completes them triggering their observers.
     *
     * @param delayedCalls The source dictionary
     * @param isComplete The completion flag
     *
     * @return The number of killed calls
     */
    public static function killDelayedCalls(delayedCalls:Dictionary, isComplete:Boolean = false):uint {
        var result:uint = 0;
        if (!delayedCalls)
            return result;
        for (var p:Object in delayedCalls) {
            if (p) {
                var dc:DelayedCall = DelayedCall(p);
                if (isComplete) {
                    //dc.advanceTime(dc.totalTime);
                    dc.complete();
                }
                Starling.juggler.remove(dc);
                result++;
            }
            delayedCalls[p] = null;
            delete delayedCalls[p];
        }
        return result;
    }

    /**
     * TBD
     */
    public static function snapshot(offsetX:int = 0, offsetY:int = 0):BitmapData {
        // get screen size
        const w:uint = Starling.current.stage.stageWidth;
        const h:uint = Starling.current.stage.stageHeight;
        const vp:Rectangle = Starling.current.viewPort;
        // create or get render support
        if (!support)
            support = new RenderSupport();
        else
            support.nextFrame();
        support.clear(0x0, 1.0);
        support.setProjectionMatrix(offsetX, offsetY, vp.width, vp.height, w, h);
        // render screen
        Starling.current.stage.render(support, 1);
        support.finishQuadBatch();
        // render screen
        const result:BitmapData = new BitmapData(w, h, true);
        Starling.context.drawToBitmapData(result);
        // return result
        return result;
    }

    /**
     * TBD
     *
     * @see http://blog.flexwiz.net/tip-how-to-take-a-screenshot-in-starling/
     */
    public static function copyToBitmap(target:DisplayObject, scale:Number = 1.0):BitmapData {
        var bounds:Rectangle = new Rectangle();
        target.getBounds(target, bounds);
        const stage:Stage = Starling.current.stage;
        const renderSupport:RenderSupport = new RenderSupport();
        renderSupport.clear();
        renderSupport.scaleMatrix(scale, scale);
        renderSupport.setProjectionMatrix(0, 0, stage.stageWidth, stage.stageHeight);
        renderSupport.translateMatrix(-bounds.x, -bounds.y); // move to 0,0
        target.render(renderSupport, 1.0);
        renderSupport.finishQuadBatch();
        const result:BitmapData = new BitmapData(bounds.width * scale, bounds.height * scale, true);
        Starling.context.drawToBitmapData(result);
        return result;
    }

    /**
     * TBD
     */
    public static function tileImage(target:Image, vTiles:Number, hTiles:Number):void {
        POINT.setTo(hTiles, 0);
        target.setTexCoords(1, POINT);
        POINT.setTo(0, vTiles);
        target.setTexCoords(2, POINT);
        POINT.setTo(hTiles, vTiles);
        target.setTexCoords(3, POINT);
        target.pivotX = target.width / 2;
        target.pivotY = target.height / 2;
        target.width *= hTiles;
        target.height *= vTiles;
    }

    /**
     * TBD
     */
    public static function offsetImage(image:Image, x:Number, y:Number, hRatio:Number = 1, vRatio:Number = 1):void {
        image.setTexCoordsTo(0, x, y);
        image.setTexCoordsTo(1, x + hRatio, y);
        image.setTexCoordsTo(2, x, y + vRatio);
        image.setTexCoordsTo(3, x + hRatio, y + vRatio);
    }

    /**
     * TBD
     */
    /*public static function reflect(target:DisplayObject):void {
     var offset:Number = 0;
     var scale:Number = Starling.contentScaleFactor;
     var width:int = target.width * scale;
     var height:int = target.height * scale;
     var perlinData:BitmapData = new BitmapData(width, height, false);
     perlinData.perlinNoise(200 * scale, 20 * scale, 2, 5, true, true, 0, true);
     var dispMap:BitmapData = new BitmapData(width, height * 2, false);
     dispMap.copyPixels(perlinData, perlinData.rect, new Point(0, 0));
     dispMap.copyPixels(perlinData, perlinData.rect, new Point(0, perlinData.height));
     var texture:Texture = Texture.fromBitmapData(dispMap);
     var filter:DisplacementMapFilter = new DisplacementMapFilter(texture, null,
     BitmapDataChannel.RED, BitmapDataChannel.RED, 40, 5);
     target.filter = filter;
     target.addEventListener(EnterFrameEvent.ENTER_FRAME, function (event:EnterFrameEvent):void {
     if (offset > height) offset = 0;
     else offset += event.passedTime * scale * 20;
     filter.mapPoint.y = offset - height;
     });
     } */

    /**
     * TBD
     */
    public static function createButton(target:DisplayObjectContainer, x:Number, y:Number, upState:Texture, text:String = "", downState:Texture = null):Button {
        var component:Button = new Button(upState, text, downState);
        component.x = x;
        component.y = y;
        if (target)
            target.addChild(component);
        return component;
    }

}
}
