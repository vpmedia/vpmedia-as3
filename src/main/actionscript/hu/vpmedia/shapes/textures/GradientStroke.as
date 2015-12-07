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
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.geom.Matrix;

import hu.vpmedia.shapes.core.GraphicsTextureType;

/**
 * TBD
 */
public class GradientStroke extends GradientFill {

    /**
     * TBD
     */
    public var thickness:Number;

    /**
     * TBD
     */
    public var hinting:Boolean;

    /**
     * TBD
     */
    public var scaleMode:String;

    /**
     * TBD
     */
    public var caps:String;

    /**
     * TBD
     */
    public var joints:String;

    /**
     * TBD
     */
    public var miterLimit:Number;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function GradientStroke(parameters:Object = null) {
        colorType = GraphicsTextureType.GRADIENT;
        thickness = 1;
        hinting = false;
        scaleMode = LineScaleMode.NONE;
        caps = CapsStyle.NONE;
        joints = JointStyle.MITER;
        miterLimit = 3;
        super(parameters);
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
        graphics.lineStyle(thickness, 0, 1, hinting, scaleMode, caps, joints, miterLimit);
        graphics.lineGradientStyle(type, gradientColors, gradientAlphas, gradientRatios, _matrix, spreadMethod, interpolationMethod, focalPtRatio);
    }
}
}
