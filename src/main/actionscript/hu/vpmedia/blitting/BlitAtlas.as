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

package hu.vpmedia.blitting {
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

/**
 * TBD
 */
public class BlitAtlas {

    /**
     * @private
     */
    private var _bitmapData:BitmapData;

    /**
     * @private
     */
    private var _regions:Dictionary;

    /**
     * @private
     */
    private var _frames:Dictionary;

    /**
     * TBD
     */
    public function BlitAtlas(spriteSheet:BitmapData) {
        _regions = new Dictionary();
        _frames = new Dictionary();
        _bitmapData = spriteSheet;
        addArea("", new Rectangle(0, 0, spriteSheet.width, spriteSheet.height), new Rectangle());
    }

    /**
     * TBD
     */
    public function addArea(name:String, region:Rectangle, frame:Rectangle = null):void {
        _regions[name] = region;
        if (frame)
            _frames[name] = frame;
    }

    /**
     * TBD
     */
    public function removeArea(name:String):void {
        delete _regions[name];
        if (_frames[name])
            delete _frames[name];
    }

    /**
     * TBD
     */
    public function getArea(name:String):BlitArea {
        var region:Rectangle = _regions[name];
        if (region == null)
            return null;
        return new BlitArea(region, _frames[name]);
    }

    /**
     * TBD
     */
    public function getAreas(prefix:String = ""):Vector.<BlitArea> {
        var areas:Vector.<BlitArea> = new <BlitArea>[];
        var names:Vector.<String> = new <String>[];
        var name:String;
        for (name in _regions)
            if (name.indexOf(prefix) == 0)
                names.push(name);
        names.sort(Array.CASEINSENSITIVE);
        for each (name in names)
            areas.push(getArea(name));
        return areas;
    }

    /**
     * TBD
     */
    public function getBitmapData():BitmapData {
        return _bitmapData;
    }

    /**
     * TBD
     */
    public function dispose():void {
        _bitmapData.dispose();
    }
}
}
