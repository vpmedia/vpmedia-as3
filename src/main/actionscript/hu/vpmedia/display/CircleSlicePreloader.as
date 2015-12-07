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
import flash.display.Shape;
import flash.display.Sprite;

public class CircleSlicePreloader extends Sprite {
    private var slices:int;
    private var radius:int;
    public var direction:int;
    public var color:uint;

    public function CircleSlicePreloader(slices:int = 12, radius:int = 6, color:uint = 0xFFFFFF) {
        super();
        this.slices = slices;
        this.radius = radius;
        this.color = color;
        draw();
    }

    public function step():void {
        if (direction == 0)
            rotation = (rotation + (360 / slices)) % 360;
        else
            rotation = (rotation - (360 / slices)) % 360;
    }

    private function draw():void {
        var i:int = slices;
        var degrees:int = 360 / slices;
        while (i--) {
            var slice:Shape = getSlice();
            slice.alpha = Math.max(0.2, 1 - (0.1 * i));
            var radianAngle:Number = (degrees * i) * Math.PI / 180;
            slice.rotation = -degrees * i;
            slice.x = Math.sin(radianAngle) * radius;
            slice.y = Math.cos(radianAngle) * radius;
            addChild(slice);
        }
    }

    private function getSlice():Shape {
        var slice:Shape = new Shape();
        slice.graphics.beginFill(color);
        slice.graphics.drawRoundRect(-1, 0, 2, 6, 12, 12);
        slice.graphics.endFill();
        return slice;
    }
}
}
