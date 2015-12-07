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
import Box2DAS.Common.V2;
import Box2DAS.Dynamics.b2Body;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASGravitySystem extends BaseEntityStepSystem {
    public function Box2DASGravitySystem(world:BaseEntityWorld, params:Object = null) {
        super(world, Box2DASGravityNode, onStep, onAdded, onRemoved);
        initialize();
    }

    protected function initialize():void {
    }

    private function onAdded(node:Box2DASGravityNode):void {
        onStep(node, 0.0001);
    }

    private function onRemoved(node:Box2DASGravityNode):void {
    }

    private function onStep(node:Box2DASGravityNode, timeDelta:Number):void {
        var _body:b2Body = node.physics.getBody();
        if (_body && _body.IsAwake()) {
            var velocity:V2 = _body.GetLinearVelocity();
            velocity.x += node.gravity.x;
            velocity.y += node.gravity.y;
            _body.SetLinearVelocity(velocity);
            node.display.x = node.physics.x;
            node.display.y = node.physics.y;
            node.display.rotation = node.physics.rotation;
        }
    }
}
}
