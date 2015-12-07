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
import hu.vpmedia.entity.core.BaseEntityComponent;

/**
 * TBD
 */
public class DisplayEntityComponent extends BaseEntityComponent {
    /**
     * TBD
     */
    public var x:Number;

    /**
     * TBD
     */
    public var y:Number;

    /**
     * TBD
     */
    public var width:Number;

    /**
     * TBD
     */
    public var height:Number;

    /**
     * TBD
     */
    public var rotation:Number;

    /**
     * TBD
     */
    //public var isInvalid:Boolean;

    /**
     * TBD
     */
    public function DisplayEntityComponent(parameters:Object = null) {
        super(parameters);
    }

    /**
     * TBD
     */
    override protected function setupDefaults():void {
        x = 0;
        y = 0;
        width = 10;
        height = 10;
        rotation = 0;
    }
}
}
