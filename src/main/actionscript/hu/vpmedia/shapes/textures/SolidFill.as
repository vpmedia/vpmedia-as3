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
import flash.display.Graphics;

import hu.vpmedia.shapes.core.BaseGraphicsTexture;
import hu.vpmedia.shapes.core.GraphicsTextureType;

/**
 * TBD
 */
public class SolidFill extends BaseGraphicsTexture {

    /**
     * TBD
     */
    public var alpha:Number;

    /**
     * TBD
     */
    public var color:uint;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function SolidFill(parameters:Object = null) {
        this.alpha = 1;
        this.color = 0x000000;
        colorType = GraphicsTextureType.SOLID;
        super(parameters);
    }

    /**
     * TBD
     */
    override public function draw(graphics:Graphics):void {
        graphics.beginFill(color, alpha);
    }
}
}
