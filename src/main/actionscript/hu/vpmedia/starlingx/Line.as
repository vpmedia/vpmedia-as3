/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2014 Docmet Systems
 *  http://www.docmet.com
 *
 *  For information about the licensing and copyright please
 *  contact us at info@docmet.com
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

import starling.display.Quad;
import starling.display.Sprite;

public class Line extends Sprite {

    private var baseQuad:Quad;
    private var _thickness:Number;
    private var _color:uint;

    public function Line(color:uint = 0x000000, thickness:Number = 1) {
        _color = color;
        _thickness = thickness;
        baseQuad = new Quad(1, _thickness, _color);
        addChild(baseQuad);
    }

    public function lineTo(toX:int, toY:int):void {
        baseQuad.width = Math.round(Math.sqrt((toX * toX) + (toY * toY)));
        baseQuad.rotation = Math.atan2(toY, toX);
    }

    public function set thickness(t:Number):void {
        var currentRotation:Number = baseQuad.rotation;
        baseQuad.rotation = 0;
        baseQuad.height = _thickness = t;
        baseQuad.rotation = currentRotation;
    }

    public function get thickness():Number {
        return _thickness;
    }

    public function set color(c:uint):void {
        baseQuad.color = _color = c;
    }

    public function get color():uint {
        return _color;
    }
}
}
