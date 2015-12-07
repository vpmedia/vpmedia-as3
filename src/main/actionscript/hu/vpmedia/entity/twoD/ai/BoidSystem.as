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
package hu.vpmedia.entity.twoD.ai {
import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.math.Vector2D;

/**
 * TBD
 */
public class BoidSystem extends BaseEntityStepSystem {

    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    public function BoidSystem(world:BaseEntityWorld) {
        super(world, BoidNode, onStep, onAdded, onRemoved);
    }

    private function onAdded(node:BoidNode):void {
        //trace(this, "onAdded", node);
        node.steering.position.x = node.display.x;
        node.steering.position.y = node.display.y;
        node.steering.velocity.angle = node.display.rotation * DEG_TO_RAD;
    }

    private function onRemoved(node:BoidNode):void {
    }

    private function onStep(node:BoidNode, timeDelta:Number):void {
        //
        // UPDATE BOID
        //
        node.steering.update();
        //
        // TEST BEHAVIORS!
        //
        node.steering.arrive(new Vector2D(400, 300));
        node.steering.wander();
        //
        // UPDATE SKIN
        //
        node.display.x = node.steering.position.x;
        node.display.y = node.steering.position.y;
        node.display.rotation = node.steering.velocity.angle * RAD_TO_DEG;
    }
}
}
