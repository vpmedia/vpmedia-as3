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
package hu.vpmedia.entity.twoD.physics.joints {
import Box2DAS.Common.b2Def;
import Box2DAS.Dynamics.Joints.b2GearJoint;
import Box2DAS.Dynamics.Joints.b2Joint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * Gear joint definition. This definition requires two existing.
 * revolute or prismatic joints (any combination will work).
 * The provided joints must attach a dynamic body to a static body.
 * Gears are the next joint we will look at.
 * A gear could be created by making a body in the shape of a gear and applying a motor, but a gear joint will be much more efficient and simpler to set up.
 * Gear joints are created by using a mixture of either revolute or prismatic joints connected to a static body.
 * As one body changes it subsequently affects the other body. Note, that in the initialization function the static body must be the first parameter .
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASGearJointComponent extends Box2DASBaseJointComponent {
    public var joint1:b2Joint;

    public var joint2:b2Joint;

    public var pulleyGearRatio:Number = 0;

    public function Box2DASGearJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.GEAR;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.gearJoint);
        b2Def.gearJoint.Initialize(joint1, joint2, pulleyGearRatio);
        joint = new b2GearJoint(world, b2Def.gearJoint, dispatcher);
    }
}
}
