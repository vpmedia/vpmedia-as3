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
package hu.vpmedia.entity.twoD.physics {
import hu.vpmedia.entity.core.BaseEntityComponent;
import hu.vpmedia.math.Vector2D;

/**
 * TBD
 */
public class SimplePhysicsComponent extends BaseEntityComponent {

    /**
     * TBD
     */
    public var velocity:Vector2D;

    /**
     * TBD
     */
    public var angularVelocity:Number;

    //public var friction:Number;

    /**
     * TBD
     */
    public var damping:Number;

    /**
     * TBD
     */
    public var bodyType:int;

    /**
     * TBD
     */
    public function SimplePhysicsComponent(parameters:Object = null) {
        super(parameters);
    }

    /**
     * TBD
     */
    override protected function setupDefaults():void {
        //friction=1;
        damping = 0;
        angularVelocity = 0;
        velocity = new Vector2D();
        bodyType = BasePhysics2DBodyTypes.DYNAMIC;
    }
}
}
