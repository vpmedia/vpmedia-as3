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
import hu.vpmedia.framework.BaseConfig;

/**
 * TBD
 */
public class BasePhysics2DVars extends BaseConfig {
    /**
     * Because Box2D works with MKS scale, 1 pixel should not map directly to 1 Box2D Unit, that is why we use a physics scale.
     */
    public var scale:Number;

    /**
     * TBD
     */
    public var timeStep:Number;

    /**
     * TBD
     */
    public var velocityIterations:int;

    /**
     * TBD
     */
    public var positionIterations:int;

    /**
     * TBD
     */
    public var gravityX:Number;

    /**
     * TBD
     */
    public var gravityY:Number;

    /**
     * TBD
     */
    public var allowSleep:Boolean;

    /**
     * TBD
     */
    public function BasePhysics2DVars(parameters:Object = null) {
        super(parameters);
    }

    /**
     * TBD
     */
    override public function setupDefaults():void {
        scale = 30; //1mt = 30 pixels
        timeStep = 0.035; // 1/30    -> 1/fps
        velocityIterations = 8;
        positionIterations = 4;
        gravityX = 0;
        gravityY = 0;
        allowSleep = true;
    }
}
}
