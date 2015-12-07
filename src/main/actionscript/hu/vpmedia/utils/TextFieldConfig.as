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

package hu.vpmedia.utils {
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import hu.vpmedia.framework.BaseConfig;

/**
 * The TextFieldConfig class provides typed configuration parameters for various TextField factories.
 *
 * @see hu.vpmedia.starlingx.TextFieldFactory.createFromConfig
 * @see hu.vpmedia.utils.TextFieldUtil.createFromConfig
 * @see hu.vpmedia.utils.StageTextUtil.createFromConfig
 */
public class TextFieldConfig extends BaseConfig {

    /**
     * @see flash.text.TextField.defaultTextFormat
     */
    public var textFormat:TextFormat;

    /**
     * @see flash.text.TextField.selectable
     */
    public var selectable:Boolean = false;

    /**
     * @see flash.text.TextField.multiline
     */
    public var multiline:Boolean = false;

    /**
     * @see flash.text.TextField.wordWrap
     */
    public var wordWrap:Boolean = false;

    /**
     * @see flash.text.TextField.autoSize
     */
    public var autoSize:String = TextFieldAutoSize.LEFT;

    /**
     * @see flash.text.TextField.embedFonts
     */
    public var embedFonts:Boolean = false;

    /**
     * @see flash.text.TextField.type
     */
    public var type:String = TextFieldType.DYNAMIC;

    /**
     * @see flash.text.TextField.antiAliasType
     */
    public var antiAliasType:String = AntiAliasType.ADVANCED;

    /**
     * @see flash.text.TextField.gridFitType
     */
    public var gridFitType:String = GridFitType.SUBPIXEL;

    /**
     * @see flash.text.TextField.sharpness
     */
    public var sharpness:uint = 0;

    /**
     * TBD
     */
    public var width:uint;

    /**
     * TBD
     */
    public var height:uint;

    /**
     * TBD
     */
    public var text:String;

    /**
     * TBD
     */
    public var fontName:String;

    /**
     * TBD
     */
    public var fontSize:uint;

    /**
     * TBD
     */
    public var fontColor:uint;

    /**
     * TBD
     */
    public var backgroundColor:uint;

    /**
     * TBD
     */
    public var borderColor:uint;

    /**
     * TBD
     */
    public var bold:Boolean;

    /**
     * TBD
     */
    public var italic:Boolean;

    /**
     * TBD
     */
    public var border:Boolean;

    /**
     * TBD
     */
    public var hidden:Boolean;

    /**
     * TBD
     */
    public var x:int;

    /**
     * TBD
     */
    public var y:int;

    /**
     * TBD
     */
    public var kerning:int;

    /**
     * TBD
     */
    public var leading:int;

    /**
     * TBD
     */
    public var hAlign:String;

    /**
     * TBD
     */
    public var vAlign:String;

    /**
     * TBD
     */
    public var filters:Array;

    /**
     * TBD
     */
    public function TextFieldConfig(parameters:Object = null) {
        super(parameters);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Set as rectangle
     */
    public function set rectangle(value:Rectangle):void {
        x = value.x;
        y = value.y;
        width = value.width;
        height = value.height;
    }

    /**
     * Get as rectangle
     */
    public function get rectangle():Rectangle {
        return null;
    }

    /**
     * Apply properties to a TextField instance.
     */
    public function applyTo(textField:TextField):void {
        textField.selectable = this.selectable;
        textField.multiline = this.multiline;
        textField.wordWrap = this.wordWrap;
        textField.autoSize = this.autoSize;
        textField.embedFonts = this.embedFonts;
        textField.type = this.type;
        textField.antiAliasType = this.antiAliasType;
        textField.gridFitType = this.gridFitType;
        textField.sharpness = this.sharpness;
        if (!this.textFormat)
            this.textFormat = new TextFormat(this.fontName, this.fontSize, this.fontColor, this.bold, this.italic);
        textField.defaultTextFormat = this.textFormat;
        textField.setTextFormat(this.textFormat);
    }

    /**
     * @inheritDoc
     */
    override public function copyProperties(source:Object):void {
        for (var key:String in source) {
            if (this.hasOwnProperty(key)) {
                if (key == "filters")
                    this[key] = SerializerUtil.decodeList(source[key]);
                else
                    this[key] = source[key];
            }
        }
    }

    /**
     * @inheritDoc
     */
    override public function setupDefaults():void {
        text = "";
        hAlign = vAlign = "center";
        backgroundColor = 0x000000;
        borderColor = 0x333333;
        fontColor = 0xFFFFFF;
    }


    /**
     * @inheritDoc
     */
    public function toString():String {
        return "[TextFieldConfig"
                + " textFormat=" + (textFormat ? textFormatToString() : null)
                + " fontName=" + fontName
                + " fontSize=" + fontSize
                + " fontColor=" + fontColor
                + " bold=" + bold
                + "]";

    }

    /**
     * @inheritDoc
     */
    public function textFormatToString():String {
        return "[TextFormat"
                + " font=" + textFormat.font
                + " size=" + textFormat.size
                + " color=" + textFormat.color
                + " bold=" + textFormat.bold
                + "]";
    }
}
}
