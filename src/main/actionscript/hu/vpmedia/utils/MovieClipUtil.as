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
import flash.display.FrameLabel;
import flash.display.MovieClip;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for MovieClip manipulation.
 *
 * @see flash.display.MovieClip
 */
public final class MovieClipUtil {

    //----------------------------------
    //  Constructor (private)
    //----------------------------------

    /**
     * @private
     */
    public function MovieClipUtil() {
        throw new StaticClassError();
    }

//--------------------------------------------------------------------------
    //
    //  Movie Clip Utils
    //
    //--------------------------------------------------------------------------


    /**
     * TBD
     */
    public static function saveProperties(target:MovieClip):void {
        target.a0 = target.alpha;
        target.x0 = target.x;
        target.y0 = target.y;
        target.sx0 = target.scaleX;
        target.sy0 = target.scaleY;
        target.r0 = target.rotation;
    }

    /**
     * TBD
     */
    public static function loadProperties(target:MovieClip):void {
        target.alpha = target.a0;
        target.x = target.x0;
        target.y = target.y0;
        target.scaleX = target.sx0;
        target.scaleY = target.sy0;
        target.rotation = target.r0;
    }

    /**
     * TBD
     */
    public static function isLastFrame(target:MovieClip):Boolean {
        return target.currentFrame == target.totalFrames;
    }

    /**
     * TBD
     */
    public static function canChangeToFrameLabel(target:MovieClip, value:String):Boolean {
        if (target.currentFrameLabel == value) {
            return false;
        }
        return hasFrameLabel(target, value);
    }

    /**
     * TBD
     */
    public static function hasFrameLabel(target:MovieClip, value:String):Boolean {
        // simple query
        if (target.currentLabel == value) {
            return true;
        }
        // list query
        var currentLabels:Array = target.currentLabels;
        // iterates through the values of currentLabels array.
        for each (var anim:FrameLabel in currentLabels) {
            if (anim.name == value)
                return true;
        }
        return false;
    }

    /**
     * TBD
     */
    public static function getFrameLabelLength(target:MovieClip, frameLabelIdx:int = 0):int {
        var result:int = target.totalFrames;
        if (target.currentLabels.length >= (frameLabelIdx + 2)) {
            result = FrameLabel(target.currentLabels[frameLabelIdx + 1]).frame - 1;
        }
        return result;
    }

    /**
     * TBD
     */
    public static function getFrameLabelNames(target:MovieClip):Vector.<String> {
        var result:Vector.<String> = new Vector.<String>();
        if (target) {
            var n:int = target.currentLabels.length;
            for (var i:int = 0; i < n; i++) {
                result.push(target.currentLabels[i].name);
            }
        }
        return result;
    }

    /**
     * TBD
     */
    public static function stepMovie(target:MovieClip):void {
        if (target.currentFrame == target.totalFrames) {
            target.gotoAndStop(1);
        }
        else {
            target.nextFrame();
        }
    }

    /**
     * TBD
     */
    public static function stopChildsAt(target:MovieClip, frame:int = 0):void {
        var n:int = target.numChildren;
        for (var i:int = 0; i < n; i++) {
            var t:DisplayObject = target.getChildAt(i);
            if (t is MovieClip) {
                if (frame <= 0)
                    MovieClip(t).stop();
                else
                    MovieClip(t).gotoAndStop(frame);
            }
        }
    }

    /**
     * TBD
     */
    public static function isValidFrameLabel(target:MovieClip, animation:String):Boolean {
        if (animation == "") {
            return false;
        }
        if (target.currentFrameLabel == animation) {
            return false;
        }
        var currentLabels:Array = target.currentLabels;
        for each (var anim:FrameLabel in currentLabels) {
            if (anim.name == animation)
                return true;
        }
        return false;
    }

}
}
