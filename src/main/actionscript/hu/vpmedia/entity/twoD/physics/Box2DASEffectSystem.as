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
import Box2DAS.Controllers.b2BuoyancyEffect;
import Box2DAS.Controllers.b2Controller;
import Box2DAS.Controllers.b2Effect;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASEffectSystem extends BaseEntityStepSystem {
    private var _controller:b2Controller;

    private var _effect:b2Effect;

    public function Box2DASEffectSystem(world:BaseEntityWorld) {
        super(world, Box2DASGravityNode, onStep, onAdded, onRemoved);
        initialize();
    }

    protected function initialize():void {
        _effect = new b2BuoyancyEffect();
        _controller = new b2Controller(Box2DASRegistry.world, _effect);
    }

    private function onAdded(node:Box2DASGravityNode):void {
        trace(this, "onAdded", node);
        _controller.AddBody(node.physics.getBody());
    }

    private function onRemoved(node:Box2DASGravityNode):void {
        trace(this, "onRemoved", node);
        _controller.RemoveBody(node.physics.getBody());
    }

    private function onStep(node:Box2DASGravityNode, timeDelta:Number):void {
        _controller.Step();
    }
}
}
