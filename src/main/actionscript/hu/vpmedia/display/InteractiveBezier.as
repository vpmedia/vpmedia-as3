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
import flash.events.MouseEvent;
import flash.geom.Point;

import hu.vpmedia.math.CubicBezier;

public class InteractiveBezier extends Sprite {
    private var coordinates:Array;

    private var anchorItems:Array;

    private var anchorContainer:Sprite;

    private var curves:Shape;

    private var selectedAnchor:Sprite;

    private var numAnchors:int;

    private var lineThickness:Number;

    private var lineColor:int;

    private var lineAlpha:Number;

    public function InteractiveBezier(thickness:Number = 1, color:int = 0xFFFFFF, alpha:Number = 1):void {
        lineThickness = thickness;
        lineColor = color;
        lineAlpha = alpha;
        initialize();
    }

    private function initialize():void {
        anchorItems = [];
        coordinates = [];
        numAnchors = 0;
        curves = new Shape();
        addChild(curves);
        anchorContainer = new Sprite();
        addChild(anchorContainer);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
    }

    public function addPoint(data:Point):void {
        var anchor:Sprite = new Sprite();
        anchor.graphics.beginFill(0xFF0000, 1);
        anchor.graphics.drawCircle(0, 0, 6);
        anchor.graphics.endFill();
        anchor.buttonMode = true;
        anchor.x = data.x;
        anchor.y = data.y;
        anchor.name = "anchor" + anchorItems.length;
        anchorContainer.addChild(anchor);
        if (anchorItems.length > 0) {
            var prevAnchor:Sprite = Sprite(anchorItems[anchorItems.length - 1]);
            prevAnchor.visible = true;
        }
        anchor.visible = false;
        numAnchors++;
        anchorItems.push(anchor);
        coordinates.push(data);
    }

    public function update():void {
        curves.graphics.clear();
        curves.graphics.lineStyle(lineThickness, lineColor, lineAlpha);
        CubicBezier.curveThroughPoints(curves.graphics, coordinates, .5, .75);
    }

    // EVENT HANDLERS
    private function mouseDownHandler(e:MouseEvent):void {
        if (e.target is Sprite && Sprite(e.target).name.indexOf("anchor") > -1) {
            selectedAnchor = Sprite(e.target);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, moveDot, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, releaseDot, false, 0, true);
        }
    }

    private function moveDot(e:MouseEvent):void {
        var index:int = anchorItems.indexOf(selectedAnchor);
        var nY:int = curves.mouseY;
        var nX:int = curves.mouseX;
        coordinates[index].x = selectedAnchor.x = nX;
        coordinates[index].y = selectedAnchor.y = nY;
        if (index == 0) {
            coordinates[numAnchors - 1].x = selectedAnchor.x = nX;
            coordinates[numAnchors - 1].y = selectedAnchor.y = nY;
        }
        update();
    }

    private function releaseDot(e:MouseEvent):void {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveDot);
        stage.removeEventListener(MouseEvent.MOUSE_UP, releaseDot);
    }
}
}
