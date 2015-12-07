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
package hu.vpmedia.display {
import com.greensock.TimelineMax;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.display.MovieClip;

public class FlippingCard {
    private var flipper:MovieClip;
    private var tl:TimelineMax;

    public function FlippingCard(context:MovieClip):void {
        flipper = context;
        flipper.back.rotationY = -90;
        flipper.back.alpha = 0;
        tl = new TimelineMax({paused: true});
        tl.append(TweenMax.to(flipper.front, .4, {rotationY: 90, visible: false, ease: Linear.easeNone}))
        tl.append(TweenMax.to(flipper.back, 0, {alpha: 1, immediateRender: false}))
        tl.append(TweenMax.to(flipper.back, .2, {rotationY: 0, ease: Linear.easeNone}));
    }

    public function flip():void {
        if (tl.totalProgress() <= 0) {
            flip2();
        }
        else {
            flip1();
        }
    }

    public function isFlipped():Boolean {
        return tl.totalProgress() > 0;
    }

    public function isFlopped():Boolean {
        return tl.totalProgress() <= 0;
    }

    public function flip1():void {
        tl.tweenTo(0);
    }

    public function flip2():void {
        tl.tweenTo(tl.duration);
    }
}
}
