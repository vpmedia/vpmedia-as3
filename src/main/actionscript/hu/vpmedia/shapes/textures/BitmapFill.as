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
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;

import hu.vpmedia.shapes.core.BaseGraphicsTexture;
import hu.vpmedia.shapes.core.GraphicsTextureType;

/**
 * TBD
 */
public class BitmapFill extends BaseGraphicsTexture {

    /**
     * TBD
     */
    public var bitmapData:BitmapData;

    /**
     * TBD
     */
    public var matrix:Matrix;

    /**
     * TBD
     */
    public var repeat:Boolean;

    /**
     * TBD
     */
    public var smooth:Boolean;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function BitmapFill() {
        matrix = new Matrix();
        colorType = GraphicsTextureType.BITMAP;
        super();
    }

    //--------------------------------------
    //  Public
    //--------------------------------------

    /**
     * TBD
     */
    override public function draw(graphics:Graphics):void {
        graphics.beginBitmapFill(bitmapData, matrix, repeat, smooth);
    }
}
}
