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
import Box2DAS.Dynamics.Joints.b2LineJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * A line joint. This joint provides one degree of freedom: translation along an axis fixed in body1.
 * You can use a joint limit to restrict the range of motion and a joint motor to drive the motion or to model joint friction.
 * If you are wanting to create a suspension for a model of a car then the line joint is what you will be after.
 * It was created specifically for this purpose. It is like the prismatic joint but with the rotation restriction removed.
 * For example, a wheel can slide along an axis (the shock absorber) while rotating.
 * The spring portion of the shock absorber can be modelled by creating friction using the motor variables.
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASLineJointComponent extends Box2DASBaseJointComponent {
    public var dampingRatio:Number = 0.7;

    public var frequencyHz:Number = 5.0;

    public var maxTorque:Number = 0.0;

    public var enableMotor:Boolean = false;

    public var motorSpeed:Number = 0.0

    public function Box2DASLineJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.LINE;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.lineJoint);
        b2Def.lineJoint.enableMotor = enableMotor;
        b2Def.lineJoint.maxMotorTorque = maxTorque;
        b2Def.lineJoint.motorSpeed = motorSpeed;
        b2Def.lineJoint.frequencyHz = frequencyHz;
        b2Def.lineJoint.dampingRatio = dampingRatio;
        b2Def.lineJoint.Initialize(b2body1, b2body2, anchor1, offset2);
        joint = new b2LineJoint(world, b2Def.lineJoint, dispatcher);
    }
}
}
