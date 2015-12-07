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
import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;

/**
 * TBD
 */
public class SimplePhysicsSystem extends BaseEntityStepSystem {
    public function SimplePhysicsSystem(world:BaseEntityWorld) {
        super(world, SimplePhysicsNode, onStep, onAdded, onRemoved);
    }

    /**
     * TBD
     */
    private function onAdded(node:SimplePhysicsNode):void {
        // trace(this, "onAdded", node);
    }

    /**
     * TBD
     */
    private function onRemoved(node:SimplePhysicsNode):void {
        // trace(this, "onRemoved", node);
    }

    /**
     * TBD
     */
    private function onStep(node:SimplePhysicsNode, timeDelta:Number):void {
        if(node.physics.bodyType == BasePhysics2DBodyTypes.STATIC)
            return;
        //timeDelta=timeDelta * 100;
        // apply velocity
        node.display.x += node.physics.velocity.x;
        node.display.y += node.physics.velocity.y;
        node.display.rotation += node.physics.angularVelocity;
        // trace(node.display.rotation);
        // apply damping
        if (node.physics.damping > 0) {
            var xDamp:Number = Math.abs(Math.cos(node.display.rotation) * node.physics.damping);
            var yDamp:Number = Math.abs(Math.sin(node.display.rotation) * node.physics.damping);
            if (node.physics.velocity.x > xDamp) {
                node.physics.velocity.x -= xDamp;
            }
            else if (node.physics.velocity.x < -xDamp) {
                node.physics.velocity.x += xDamp;
            }
            else {
                node.physics.velocity.x = 0;
            }
            if (node.physics.velocity.y > yDamp) {
                node.physics.velocity.y -= yDamp;
            }
            else if (node.physics.velocity.y < -yDamp) {
                node.physics.velocity.y += yDamp;
            }
            else {
                node.physics.velocity.y = 0;
            }
        }
        if (node.display.x > _world.camera.bounds.width - node.display.width * 2) {
            node.display.x = _world.camera.bounds.width - node.display.width * 2;
        }
        else if (node.display.x < node.display.width * 2) {
            node.display.x = node.display.width * 2;
        }
        if (node.display.y > _world.camera.bounds.height) {
            node.display.y = _world.camera.bounds.height;
        }
        else if (node.display.y < 0) {
            node.display.y = 0;
        }
    }
}
}
