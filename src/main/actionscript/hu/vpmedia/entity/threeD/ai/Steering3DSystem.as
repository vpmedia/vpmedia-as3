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
import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;

import ru.inspirit.steering.SteerVector3D;
import ru.inspirit.steering.VehicleGroup;
import ru.inspirit.steering.behavior.BehaviorList;
import ru.inspirit.steering.behavior.Seek;
import ru.inspirit.steering.behavior.Wander;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Steering3DSystem extends BaseEntityStepSystem {
    private var _group:VehicleGroup = new VehicleGroup(new Wander());

    public function Steering3DSystem(world:BaseEntityWorld) {
        super(world, Steering3DNode, onStep, onAdded, onRemoved);
    }

    private function onAdded(node:Steering3DNode):void {
        //node.vehicle.position.x=node.display.x;
        //node.vehicle.position.y=node.display.y;
        node.vehicle.position.setUnitRandom();
        node.vehicle.position.scaleBy(200);
        node.vehicle.velocity.setUnitRandom();
        node.vehicle.boundsRadius = 500;
        node.vehicle.behaviorList = new BehaviorList();
        //node.vehicle.behaviorList.addBehavior(new Flee(new SteerVector3D(0, 400, 0)));
        node.vehicle.behaviorList.addBehavior(new Seek(new SteerVector3D(100, 100, 0)));
        //node.vehicle.behaviorList.addBehavior(new Flee(new SteerVector3D(50, 50, 0)));
        //node.vehicle.behaviorList.addBehavior(new Arrival(new SteerVector3D(50, 50, 0)));
        _group.addVehicle(node.vehicle);
    }

    private function onRemoved(node:Steering3DNode):void {
        _group.removeVehicle(node.vehicle);
    }

    override public function step(timeDelta:Number):void {
        _group.update();
        super.step(timeDelta);
    }

    private function onStep(node:Steering3DNode, timeDelta:Number):void {
        //
        // UPDATE SKIN
        //
        //trace(node.vehicle.position);
        node.display.x = node.vehicle.position.x + 400;
        node.display.y = node.vehicle.position.y + 300;
        // node.display.rotation=Math.atan2(node.display.y, node.display.x) * RAD_TO_DEG;
    }
}
}
