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
package hu.vpmedia.entity.threeD.physics {
import awayphysics.dynamics.AWPDynamicsWorld;

import flash.geom.Vector3D;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;

/**
 * TBD
 */
public class Away3DPhysicsSystem extends BaseEntityStepSystem {

    /**
     * TBD
     */
    public var physics:AWPDynamicsWorld;

    /**
     * TBD
     */
    public var physicsScale:Number;

    /**
     * TBD
     */
    public function Away3DPhysicsSystem(world:BaseEntityWorld) {
        super(world, Away3DPhysicsNode, onStep, onAdded, onRemoved);
        initialize();
    }

    /**
     * TBD
     */
    private function initialize():void {
        //trace(this, "initialize");
        physicsScale = 1.0 / 60
        physics = AWPDynamicsWorld.getInstance();
        physics.initWithDbvtBroadphase();
        //physics.gravity = new Vector3D(0, -10, 0);
    }

    /**
     * TBD
     */
    override public function dispose():void {
        physics.cleanWorld();
        super.dispose();
    }

    /**
     * TBD
     */
    private function onAdded(node:Away3DPhysicsNode):void {
        physics.addRigidBody(node.body);
    }

    /**
     * TBD
     */
    private function onRemoved(node:Away3DPhysicsNode):void {
        physics.removeRigidBody(node.body);
    }

    /**
     * TBD
     */
    private function onStep(node:Away3DPhysicsNode, timeDelta:Number):void {
    }

    /**
     * TBD
     */
    override public function step(timeDelta:Number):void {
        physics.step(timeDelta, 1, physicsScale);
    }
}
}
