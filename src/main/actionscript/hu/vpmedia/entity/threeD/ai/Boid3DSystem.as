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
package hu.vpmedia.entity.threeD.ai {
import flash.geom.Vector3D;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.utils.RandomUtil;

/**
 * TBD
 */
public class Boid3DSystem extends BaseEntityStepSystem {
    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;
    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    public function Boid3DSystem(world:BaseEntityWorld) {
        super(world, Boid3DNode, onStep, onAdded, onRemoved);
        initialize();
    }

    private function initialize():void {
    }

    protected var _config:Object = {minForce: 3.0, maxForce: 6.0, minSpeed: 6.0, maxSpeed: 12.0, minWanderDistance: 10.0, maxWanderDistance: 100.0, minWanderRadius: 5.0, maxWanderRadius: 20.0, minWanderStep: 0.1, maxWanderStep: 0.9, boundsRadius: 250};

    private function onAdded(node:Boid3DNode):void {
        //trace(this, "onAdded", node);
        node.steering.edgeBehavior = Boid3DComponent.EDGE_BOUNCE;
        node.steering.maxForce = RandomUtil.float(_config.minForce, _config.maxForce);
        node.steering.maxSpeed = RandomUtil.float(_config.minSpeed, _config.maxSpeed);
        node.steering.wanderDistance = RandomUtil.float(_config.minWanderDistance, _config.maxWanderDistance);
        node.steering.wanderRadius = RandomUtil.float(_config.minWanderRadius, _config.maxWanderRadius);
        node.steering.wanderStep = RandomUtil.float(_config.minWanderStep, _config.maxWanderStep);
        node.steering.boundsRadius = _world.camera.bounds.height * 0.5;
        node.steering.boundsCentre = new Vector3D(_world.camera.bounds.width >> 1, _world.camera.bounds.height >> 1, 0.0);
        node.steering.x = node.display.x;
        node.steering.y = node.display.y;
        node.steering.z = 0;
        var vel:Vector3D = new Vector3D(RandomUtil.float(-2, 2), RandomUtil.float(-2, 2), RandomUtil.float(-2, 2));
        node.steering.velocity.incrementBy(vel);
        var rad:Number = node.display.width > node.display.height ? node.display.width : node.display.height;
        //  node.steering.renderData=node.steering.createDebugShape(Math.random() * 0xFFFFFF, rad, 1);
        //  _world.context.addChild(node.steering.renderData);
    }

    private function onRemoved(node:Boid3DNode):void {
        //trace(this, "onRemoved", node);
    }

    private function onStep(node:Boid3DNode, timeDelta:Number):void {
        // trace(this, "onStep", node, timeDelta);
        node.steering.update();
        node.steering.render();
        //
        // TEST BEHAVIORS!
        //
        node.steering.arrive(new Vector3D(400, 300, 0));
        node.steering.wander();
        //
        // UPDATE SKIN
        //
        node.display.x = node.steering.position.x;
        node.display.y = node.steering.position.y;
        node.display.rotation = Math.atan2(node.display.y, node.display.x) * RAD_TO_DEG;
    }
}
}
