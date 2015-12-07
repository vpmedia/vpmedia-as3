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
package hu.vpmedia.shapes.textures {
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.geom.Matrix;

import hu.vpmedia.shapes.core.BaseGraphicsTexture;
import hu.vpmedia.shapes.core.GraphicsTextureType;

/**
 * TBD
 */
public class GradientFill extends BaseGraphicsTexture {

    /**
     * TBD
     */
    protected var _colors:Array;

    /**
     * TBD
     */
    protected var _matrix:Matrix;

    /**
     * TBD
     */
    protected var _rotation:Number;

    /**
     * TBD
     */
    public var type:String;

    /**
     * TBD
     */
    public var spreadMethod:String;

    /**
     * TBD
     */
    public var interpolationMethod:String;

    /**
     * TBD
     */
    public var focalPtRatio:Number;

    /**
     * TBD
     */
    protected var gradientColors:Array;

    /**
     * TBD
     */
    protected var gradientAlphas:Array;

    /**
     * TBD
     */
    protected var gradientRatios:Array;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function GradientFill(parameters:Object = null) {
        _rotation = 0;
        focalPtRatio = 0;
        type = GradientType.LINEAR;
        spreadMethod = SpreadMethod.PAD;
        interpolationMethod = InterpolationMethod.RGB;
        colorType = GraphicsTextureType.GRADIENT;
        super(parameters);
    }

    /**
     * TBD
     */
    public function set colors(value:Array):void {
        _colors = value;
        gradientColors = [];
        gradientAlphas = [];
        gradientRatios = [];
        var item:GradientItem;
        for (var i:int = 0; i < value.length; i++) {
            item = GradientItem(value[i]);
            gradientColors.push(item.color);
            gradientAlphas.push(item.alpha);
            gradientRatios.push(item.ratio);
        }
    }

    /**
     * TBD
     */
    public function get colors():Array {
        return _colors;
    }

    /**
     * TBD
     */
    public function set matrix(value:Matrix):void {
        _matrix = value;
    }

    /**
     * TBD
     */
    public function get matrix():Matrix {
        return _matrix;
    }

    /**
     * gradient rotation in degress
     */
    public function set rotation(value:Number):void {
        _rotation = value;
    }

    /**
     * TBD
     */
    public function get rotation():Number {
        return _rotation
    }

    /**
     * TBD
     */
    override public function draw(graphics:Graphics):void {
        if (!_matrix) {
            _matrix = new Matrix();
        }
        //convert rotation to radians
        var r:Number = _rotation * (Math.PI / 180);
        _matrix.createGradientBox(_width, _height, r);
        graphics.beginGradientFill(type, gradientColors, gradientAlphas, gradientRatios, _matrix, spreadMethod, interpolationMethod, focalPtRatio);
    }
}
}
