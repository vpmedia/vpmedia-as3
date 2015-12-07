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
import hu.vpmedia.utils.DrawUtil;

/**
 * TBD
 */
public class PixelIcon extends BaseShape {

    /**
     * TBD
     */
    protected var _data:Array;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function PixelIcon(config:ShapeConfig = null) {
        super(config);
    }

    /**
     * TBD
     */
    override public function draw():void {
        super.draw();
        if (_style && _style.data && _style.data.data) {
            DrawUtil.drawPixelIcon(graphics, _style.data.data);
        }
    }
}
}
