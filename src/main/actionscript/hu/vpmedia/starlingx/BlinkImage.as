/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2015 Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package hu.vpmedia.starlingx {
import flash.events.TimerEvent;
import flash.utils.Timer;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/**
 * @inheritDoc
 */
public class BlinkImage extends Sprite {

    /**
     * @private
     */
    private var image:Image;

    /**
     * @private
     */
    private var baseTexture:Texture;

    /**
     * @private
     */
    private var downTexture:Texture;

    /**
     * @private
     */
    private var _enabled:Boolean;

    /**
     * @private
     */
    private static var blinkTimer:Timer;

    /**
     * @private
     */
    public static var BLINK_INTERVAL:uint = 1000;

    /**
     * Constructor
     */
    public function BlinkImage(baseTexture:Texture, downTexture:Texture) {
        super();
        this.baseTexture = baseTexture;
        this.downTexture = downTexture;
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        image = new Image(baseTexture);
        addChild(image);
        if (!blinkTimer) {
            blinkTimer = new Timer(BLINK_INTERVAL);
            blinkTimer.start();
        }
        //enabled = true;
    }

    /**
     * @inheritDoc
     */
    public override function dispose():void {
        enabled = false;
        image = null;
        baseTexture = null;
        downTexture = null;
        super.dispose();
    }

    /**
     * @private
     */
    private function onTimerTick(event:TimerEvent):void {
        if (image && _enabled) {
            image.texture = (image.texture == baseTexture) ? downTexture : baseTexture;
        }
    }

    public function get enabled():Boolean {
        return _enabled;
    }

    public function set enabled(value:Boolean):void {
        if(_enabled == value) {
            return;
        }
        _enabled = value;
        if (!blinkTimer) {
            return;
        }
        if (_enabled) {
            blinkTimer.addEventListener(TimerEvent.TIMER, onTimerTick, false, 0, true);
        } else {
            blinkTimer.removeEventListener(TimerEvent.TIMER, onTimerTick);
        }
    }
}
}
