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
package hu.vpmedia.entity.twoD.renderers {
import starling.display.Sprite;

/**
 * TBD
 */
public class StarlingLayer extends Sprite {

    /**
     * TBD
     */
    public var parallaxFactorX:Number;

    /**
     * TBD
     */
    public var parallaxFactorY:Number;

    /**
     * TBD
     */
    private var _id:int;

    /**
     * TBD
     */
    public function StarlingLayer(id:int) {
        parallaxFactorX = 1;
        parallaxFactorY = 1;
        _id = id;
        super();
    }

    /**
     * TBD
     */
    public function getId():int {
        return _id;
    }
}
}
