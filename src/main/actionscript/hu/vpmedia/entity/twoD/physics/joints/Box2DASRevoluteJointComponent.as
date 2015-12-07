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
import Box2DAS.Dynamics.Joints.b2RevoluteJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * The next joint is the revolute joint. I find this one pretty useful. We attach this joint to two bodies. If one is a static body and the other is a dynamic body then the dynamic body will spin as if someone nailed a paper plate to a wall. Two dynamic bodies can also be attached together and will rotate around each other. There are various properties we can set such as limiting the range to revolve around. One thing you might like to do is add some friction to the joint. If you just create a bare bones revolute joint then if something causes it spin then it will never stop. By enabling the motor and setting a max torque to something like 1.0, then it will eventually come to a rest thus resembling friction.
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASRevoluteJointComponent extends Box2DASBaseJointComponent {
    public var maxTorque:Number = 0.0;

    public var enableMotor:Boolean = false;

    public var motorSpeed:Number = 0.0

    public var enableLimit:Boolean = false;

    public var upperLimit:Number = 0.0;

    public var lowerLimit:Number = 0.0;

    public function Box2DASRevoluteJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.REVOLUTE;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.revoluteJoint);
        b2Def.revoluteJoint.enableLimit = enableLimit;
        b2Def.revoluteJoint.lowerAngle = lowerLimit;
        b2Def.revoluteJoint.upperAngle = upperLimit;
        b2Def.revoluteJoint.enableMotor = enableMotor;
        b2Def.revoluteJoint.maxMotorTorque = maxTorque;
        b2Def.revoluteJoint.motorSpeed = motorSpeed;
        b2Def.revoluteJoint.Initialize(b2body1, b2body2, anchor2);
        joint = new b2RevoluteJoint(world, b2Def.revoluteJoint, dispatcher);
    }
}
}
