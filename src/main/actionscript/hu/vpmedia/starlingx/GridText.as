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

import hu.vpmedia.utils.TextFieldConfig;

import starling.display.Sprite;
import starling.text.TextField;

public class GridText extends Sprite {

    private var config:TextFieldConfig;
    private var numColumns:uint;

    public function GridText(config:TextFieldConfig, numColumns:uint) {
        this.config = config;
        this.numColumns = numColumns;
        initialize();
    }

    private function initialize():void {
        x = config.x;
        y = config.y;
        config.x = config.y = 0;
        const labelWidth:uint = config.width / numColumns;
        config.width = labelWidth;
        var label:TextField;
        for (var i:uint = 0; i < numColumns; i++) {
            label = TextFieldFactory.createFromConfig(config, this);
            label.x = i * label.width;
        }
    }

    public function update(data:Vector.<String>):void {
        if (!data) {
            return;
        }
        for (var i:uint = 0; i < numColumns; i++) {
            updateAt(i, data[i]);
        }
    }

    public function updateInts(data:Vector.<int>):void {
        if (!data) {
            return;
        }
        for (var i:uint = 0; i < numColumns; i++) {
            updateAt(i, String(data[i]));
        }
    }

    public function updateAt(index:uint, data:String):void {
        var label:TextField = TextField(getChildAt(index));
        label.text = data;
    }
}
}
