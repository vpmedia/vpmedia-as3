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
import flash.ui.Keyboard;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.math.Vector2D;
import hu.vpmedia.utils.KeyboardUtil;

/**
 * TBD
 */
public class SimplePhysicsControlSystem extends BaseEntityStepSystem {

    /**
     * TBD
     */
    private var acceleration:Number = 4;

    /**
     * TBD
     */
    private var maxVelocity:Number = 24;

    /**
     * TBD
     */
    public function SimplePhysicsControlSystem(world:BaseEntityWorld, params:Object = null) {
        super(world, SimplePhysicsControlNode, onStep, onAdded, onRemoved);
        initialize();
    }

    /**
     * TBD
     */
    protected function initialize():void {
    }

    /**
     * TBD
     */
    private function onAdded(node:SimplePhysicsControlNode):void {
    }

    /**
     * TBD
     */
    private function onRemoved(node:SimplePhysicsControlNode):void {
    }

    /**
     * TBD
     */
    private function onStep(node:SimplePhysicsControlNode, timeDelta:Number):void {
        if (node.control.allowKeyboard) {
            var velocity:Vector2D = node.physics.velocity.clone();
            if (KeyboardUtil.isDown(Keyboard.RIGHT)) {
                velocity.x += (acceleration);
            }
            if (KeyboardUtil.isDown(Keyboard.LEFT)) {
                velocity.x -= (acceleration);
            }
            //Cap velocities
            if (velocity.x > (maxVelocity))
                velocity.x = maxVelocity;
            else if (velocity.x < (-maxVelocity))
                velocity.x = -maxVelocity;
            //update physics with new velocity
            // trace(_isDucking, _isMovePressed, _isMoving, _isOnGround);
            node.physics.velocity = velocity;
        }
    }
}
}
