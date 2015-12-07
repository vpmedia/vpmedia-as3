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
import flash.display.MovieClip;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class CurvedText extends MovieClip {
    public static const DIRECTION_UP:String = "up";
    public static const DIRECTION_DOWN:String = "down";
    public var showLetterBorder:Boolean = false;
    public var showCurve:Boolean = false;
    private var _letterHolder:MovieClip;
    private var _text:String;
    private var _radius:Number;
    private var _letters:Array;
    private var _widthOfText:Number = 0;
    private var _startAngle:Number = 0;
    private var _endAngle:Number = 360;
    private var _totalAngle:Number = 0;
    private var _textFormat:TextFormat;
    private var _direction:String;

    public function CurvedText(text:String, radius:Number = 200, startAngle:Number = 0, endAngle:Number = 360, direction:String = "up", textFormat:TextFormat = null) {
        _text = text;
        _radius = radius;
        _startAngle = startAngle;
        _endAngle = endAngle;
        _direction = direction;
        _textFormat = textFormat;
        _letters = [];
        _totalAngle = Math.abs(_startAngle) + Math.abs(_endAngle);
    }

    public function set text(value:String):void {
        _text = value;
        draw();
    }

    public function draw():void {
        // checking if there is any text set
        if (_text == "") {
            return;
        }
        // clearing the letters' holder
        if (_letterHolder && contains(_letterHolder)) {
            removeChild(_letterHolder);
        }
        _letterHolder = new MovieClip();
        addChild(_letterHolder);
        // adding letters
        var numOfLetters:int = _text.length;
        for (var i:int = 0; i < numOfLetters; i++) {
            var letter:Object = getLetterObject(_text.charAt(i));
            letter.stepDegrees = _totalAngle / numOfLetters;
            _letters.push(letter);
            _widthOfText += letter.fieldWidth;
            _letterHolder.addChild(letter.movie);
        }
        // positioning
        position();
        // draw the curve
        if (showCurve) {
            _letterHolder.graphics.lineStyle(1, 0xFF0000, 1);
            _letterHolder.graphics.drawCircle(0, 0, _radius);
        }
    }

    private function getLetterObject(letter:String):Object {
        // setting default text format
        if (!_textFormat) {
            _textFormat = new TextFormat();
            _textFormat.align = TextFormatAlign.CENTER;
            _textFormat.font = "Verdana";
            _textFormat.size = 12;
            _textFormat.color = 0x000000;
        }
        // creating the field
        var movie:MovieClip = new MovieClip();
        var field:TextField = new TextField();
        field.width = 10;
        field.defaultTextFormat = _textFormat;
        field.embedFonts = true;
        field.multiline = false;
        field.autoSize = TextFieldAutoSize.CENTER;
        field.text = letter;
        field.x = -field.width / 2;
        field.y = -field.height / 2;
        if (showLetterBorder) {
            field.border = true;
        }
        movie.addChild(field);
        return {movie: movie, field: field, widthInDegrees: 0, fieldWidth: field.width, fieldHeight: field.height};
    }

    private function position():void {
        // position the letters
        var numOfLetters:int = _letters.length;
        var degrees:Number = _startAngle;
        for (var i:int = 0; i < numOfLetters; i++) {
            var angle:Number = _letters[i].stepDegrees + degrees;
            if (_direction == DIRECTION_DOWN) {
                angle -= 180;
                _letters[i].movie.scaleY = -1;
            }
            else {
                xValue = _radius * Math.cos((angle - 90) / 180 * Math.PI);
                yValue = _radius * Math.sin((angle - 90) / 180 * Math.PI);
            }
            var xValue:int = _radius * Math.cos((angle - 90) / 180 * Math.PI);
            var yValue:int = _radius * Math.sin((angle - 90) / 180 * Math.PI);
            _letters[i].movie.x = xValue;
            _letters[i].movie.y = yValue;
            _letters[i].movie.rotation = angle;
            degrees += _letters[i].stepDegrees;
        }
        // position the holder
        var bounds:Rectangle = _letterHolder.getBounds(this);
        _letterHolder.x = -bounds.x;
        _letterHolder.y = -bounds.y;
        if (_direction == DIRECTION_DOWN) {
            _letterHolder.scaleX = -1;
        }
    }
}
}
