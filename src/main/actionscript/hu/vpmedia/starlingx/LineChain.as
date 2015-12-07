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

import starling.display.Sprite;

public class LineChain extends Sprite {

    private var _thickness:Number;
    private var _color:uint;
    private var _currentLine:Line;
    private var _currentX:int;
    private var _currentY:int;

    public function LineChain(color:uint = 0x000000, thickness:Number = 1) {
        _color = color;
        _thickness = thickness;
    }

    public function moveTo(toX:int, toY:int):void {
        _currentX = toX;
        _currentY = toY;
    }

    public function lineTo(toX:int, toY:int):void {
        var line:Line = new Line(_color, _thickness);
        addChild(line);
        /*if(_currentLine && Math.atan2(toY - _currentX, toX - _currentY) != _currentLine.getChildAt(0).rotation) {
            toX += thickness * 0.5;
            _currentX -= thickness * 0.5;
        }*/
        line.x = _currentX;
        line.y = _currentY;
        line.lineTo(toX - _currentX, toY - _currentY);
        moveTo(toX, toY);
        _currentLine = line;
    }

    public function set thickness(t:Number):void {
        // TODO: iterate over children
    }

    public function get thickness():Number {
        return _thickness;
    }

    public function set color(c:uint):void {
        // TODO: iterate over children
    }

    public function get color():uint {
        return _color;
    }
}
}
