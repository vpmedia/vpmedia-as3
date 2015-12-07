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
package hu.vpmedia.entity.twoD.renderers {
import flash.geom.Point;
import flash.geom.Rectangle;

import hu.vpmedia.entity.core.BaseEntitySystem;

/**
 * TBD
 */
public class BaseCamera2D extends BaseEntitySystem {

    /**
     * TBD
     */
    public var x:Number;

    /**
     * TBD
     */
    public var y:Number;

    /**
     * TBD
     */
    public var width:Number;

    /**
     * TBD
     */
    public var height:Number;

    /**
     * TBD
     */
    public var rotation:Number;

    /**
     * TBD
     */
    public var zoom:Number;

    /**
     * TBD
     */
    public var offset:Point;

    /**
     * TBD
     */
    public var easing:Point;

    /**
     * TBD
     */
    public var bounds:Rectangle;

    /**
     * TBD
     */
    public var target:Object;

    /**
     * Constructor
     */
    public function BaseCamera2D(width:int, height:int) {
        this.bounds = new Rectangle(0, 0, width, height);
        this.width = width;
        this.height = height;
        this.x = 0;
        this.y = 0;
        this.rotation = 0;
        this.zoom = 1;
        this.offset = new Point(bounds.width / 2, bounds.height);
        this.easing = new Point(0.25, 0.05);
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        target = null;
        bounds = null;
    }

    /**
     * @inheritDoc
     */
    override public function step(timeDelta:Number):void {
        if (target) {
            const diffX:Number = (-target.x + offset.x) - x;
            const diffY:Number = (-target.y + offset.y) - y;
            const velocityX:Number = diffX * easing.x;
            const velocityY:Number = diffY * easing.y;
            x += velocityX;
            y += velocityY;
            if (bounds) {
                if (-x <= bounds.left)
                    x = -bounds.left;
                else if (-x + width >= bounds.right)
                    x = -bounds.right + width;
                if (-y <= bounds.top)
                    y = -bounds.top;
                else if (-y + height >= bounds.bottom)
                    y = -bounds.bottom + height;
            }
        }
    }
}
}
