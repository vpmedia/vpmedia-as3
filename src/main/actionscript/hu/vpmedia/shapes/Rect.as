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
package hu.vpmedia.shapes {
import hu.vpmedia.shapes.core.BaseShape;
import hu.vpmedia.shapes.core.ShapeConfig;

/**
 * TBD
 */
public class Rect extends BaseShape {

    /**
     * TBD
     */
    protected var _ellipseWidth:Number;

    /**
     * TBD
     */
    protected var _ellipseHeight:Number;

    /**
     * TBD
     */
    protected var _bottomLeftRadius:Number;

    /**
     * TBD
     */
    protected var _bottomRightRadius:Number;

    /**
     * TBD
     */
    protected var _topLeftRadius:Number;

    /**
     * TBD
     */
    protected var _topRightRadius:Number;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function Rect(config:ShapeConfig = null) {
        _ellipseWidth = _ellipseHeight = 0;
        _bottomLeftRadius = _bottomRightRadius = 0;
        _topLeftRadius = _topRightRadius = 0;
        super(config);
    }

    /**
     * TBD
     */
    override public function setStyle(value:ShapeConfig, drawAfter:Boolean = true):void {
        if (value && value.data) {
            if (value.data.hasOwnProperty("ellipse")) {
                _ellipseWidth = value.data.ellipse;
                _ellipseHeight = value.data.ellipse;
            } else {
                if (value.data.hasOwnProperty("bottomLeftRadius"))
                    _bottomLeftRadius = value.data.bottomLeftRadius;
                if (value.data.hasOwnProperty("bottomRightRadius"))
                    _bottomRightRadius = value.data.bottomRightRadius;
                if (value.data.hasOwnProperty("topLeftRadius"))
                    _topLeftRadius = value.data.topLeftRadius;
                if (value.data.hasOwnProperty("topRightRadius"))
                    _topRightRadius = value.data.topRightRadius;
            }
        }
        super.setStyle(value, drawAfter);
    }

    /**
     * TBD
     */
    override public function draw():void {
        super.draw();
        if (_ellipseWidth != 0 || _ellipseHeight != 0) {
            graphics.drawRoundRect(0, 0, _currentWidth, _currentHeight, _ellipseWidth, _ellipseHeight);
        }
        else if (_bottomLeftRadius != 0 || _bottomRightRadius != 0 || _topLeftRadius != 0 || _topRightRadius != 0) {
            graphics.drawRoundRectComplex(0, 0, _currentWidth, _currentHeight, _topLeftRadius, _topRightRadius, _bottomLeftRadius, _bottomRightRadius);
        }
        else {
            graphics.drawRect(0, 0, _currentWidth, _currentHeight);
        }
    }

    /**
     * TBD
     */
    /*  public function set ellipse(value:Number):void {
     _ellipseWidth = _ellipseHeight = value;
     }*/

    /**
     * TBD
     */
    /*  public function get ellipse():Number {
     return Math.max(_ellipseWidth, _ellipseHeight);
     } */
}
}
