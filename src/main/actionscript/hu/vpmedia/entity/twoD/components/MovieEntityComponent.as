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
package hu.vpmedia.entity.twoD.components {
import hu.vpmedia.entity.commons.AlignTypes;
import hu.vpmedia.entity.core.BaseEntityComponent;

/**
 * TBD
 */
public class MovieEntityComponent extends BaseEntityComponent {

    /**
     * TBD
     */
    public var animation:String;

    /**
     * TBD
     */
    public var inverted:Boolean;

    /**
     * TBD
     */
    public var registration:String;

    /**
     * TBD
     */
    public var visible:Boolean;

    /**
     * TBD
     */
    public var skin:Object;

    /**
     * TBD
     */
    public var skinClass:Object;

    /**
     * TBD
     */
    public var layerIndex:int;

    /**
     * TBD
     */
    public var zIndex:int;

    /**
     * TBD
     */
    public var offsetX:Number;

    /**
     * TBD
     */
    public var offsetY:Number;

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
    public function MovieEntityComponent(parameters:Object = null) {
        super(parameters);
    }

    /**
     * TBD
     */
    override protected function setupDefaults():void {
        visible = true;
        registration = AlignTypes.TOP_LEFT;

        parallaxFactorX = 1;
        parallaxFactorY = 1;
        offsetX = 0;
        offsetY = 0;
    }
}
}
