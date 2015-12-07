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
import flash.display.DisplayObject;

public class ViewStackProxy {
    protected var _list:Vector.<DisplayObject>;
    protected var _selectedIndex:int;
    public var onChange:Function;
    public var onFirst:Function;
    public var onLast:Function;
    public var onSelected:Function;
    public var onDeselected:Function;

    public function ViewStackProxy() {
        _list = new Vector.<DisplayObject>();
        _selectedIndex = -1;
    }

    public function add(target:DisplayObject):void {
        _list.push(target);
    }

    public function setSelectedIndex(value:int):void {
        if (value != _selectedIndex && hasIndex(value)) {
            if (_selectedIndex != -1 && onDeselected != null) {
                onDeselected.call(null, _list[_selectedIndex]);
            }
            _selectedIndex = value;
            if (onSelected != null) {
                onSelected.call(null, _list[_selectedIndex]);
            }
        }
    }

    public function setSelectedItem(value:DisplayObject):void {
        var nextIndex:int = _list.indexOf(value);
        setSelectedIndex(nextIndex);
    }

    public function hasIndex(value:int):Boolean {
        return value >= 0 && value < _list.length;
    }

    public function getSelectedIndex():int {
        return _selectedIndex;
    }

    public function hasNext():Boolean {
        return hasIndex(_selectedIndex + 1);
    }

    public function hasPrevious():Boolean {
        return hasIndex(_selectedIndex - 1);
    }

    public function next():void {
        setSelectedIndex(_selectedIndex++);
    }

    public function previous():void {
        setSelectedIndex(_selectedIndex--);
    }
}
}
