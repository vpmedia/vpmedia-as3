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
import flash.display.*;
import flash.geom.*;

public class CirclePreloader extends Sprite {
    private var circleHolder:Sprite;
    private var degreesPerSegment:Number;
    private var color:uint;
    private var innerRadius:int;
    private var outerRadius:int;
    private var segments:int;

    public function CirclePreloader(color:Number = 0xFFFFFF, innerRadius:int = 6, outerRadius:int = 12, segments:int = 12) {
        this.color = color;
        this.innerRadius = innerRadius;
        this.outerRadius = outerRadius;
        this.segments = segments;
        draw();
    }

    public function update():void {
        circleHolder.rotation += degreesPerSegment;
    }

    private function draw():void {
        //create a sprite that will hold our segmented circle:
        circleHolder = new Sprite();
        addChild(circleHolder);
        circleHolder.x = circleHolder.y = 6;
        degreesPerSegment = 360 / segments;
        var center:Point = new Point(0, 0);
        //store a reference to the correct graphics object (inside circleHolder sprite)
        var g:Graphics = circleHolder.graphics;
        //move the line to the correct starting point:
        var startPos:Point = new Point();
        startPos.x = center.x + innerRadius * Math.cos(deg2rad(360));
        startPos.y = center.y + innerRadius * Math.sin(deg2rad(360));
        g.moveTo(startPos.x, startPos.y);
        //draw the segmented circle inside circleHolder:
        for (var deg:Number = 360; deg >= 0; deg -= degreesPerSegment) {
            var innerPos:Point = new Point();
            innerPos.x = center.x + innerRadius * Math.cos(deg2rad(deg));
            innerPos.y = center.y + innerRadius * Math.sin(deg2rad(deg));
            var outerPos:Point = new Point();
            outerPos.x = center.x + outerRadius * Math.cos(deg2rad(deg));
            outerPos.y = center.y + outerRadius * Math.sin(deg2rad(deg));
            g.lineStyle(2, color, (deg / 360));
            g.moveTo(innerPos.x, innerPos.y);
            g.lineTo(outerPos.x, outerPos.y);
        }
    }

    private function deg2rad(deg:Number):Number {
        var rad:Number = deg * (Math.PI / 180);
        return rad;
    }

}
}
