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
package hu.vpmedia.shapes.core {
/**
 * TBD
 */
public class ShapeConfig extends DisplayObjectConfig {

    /**
     * TBD
     */
    public var fill:IBaseGraphicsTexture;

    /**
     * TBD
     */
    public var stroke:IBaseGraphicsTexture;

    /**
     * TBD
     */
    public var data:Object;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function ShapeConfig(config:Object = null) {
        super(config)
    }

    /**
     * TBD
     */
    public function hasStroke():Boolean {
        return stroke != null;
    }

    /**
     * TBD
     */
    public function hasSolidStroke():Boolean {
        return hasStroke() && stroke.colorType == GraphicsTextureType.SOLID;
    }

    /**
     * TBD
     */
    public function hasGradientStroke():Boolean {
        return hasStroke() && stroke.colorType == GraphicsTextureType.GRADIENT;
    }

    /**
     * TBD
     */
    public function hasFill():Boolean {
        return fill != null;
    }

    /**
     * TBD
     */
    public function hasSolidFill():Boolean {
        return hasFill() && fill.colorType == GraphicsTextureType.SOLID;
    }

    /**
     * TBD
     */
    public function hasGradientFill():Boolean {
        return hasFill() && fill.colorType == GraphicsTextureType.GRADIENT;
    }

    /**
     * TBD
     */
    public function hasBitmapFill():Boolean {
        return hasFill() && fill.colorType == GraphicsTextureType.BITMAP;
    }

    /**
     * TBD
     */
    public function hasData():Boolean {
        return data != null;
    }
}
}
