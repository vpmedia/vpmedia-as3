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
import Box2DAS.Dynamics.Joints.b2PrismaticJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * The prismatic joint allows only one degree of freedom. For example, if we attached a dynamic body to a static body with a prismatic joint then we can slide it along an axis (similar to the moving levels in a platformer). If we attached a dynamic body to another dynamic body, then you will notice that both boxes rotate relative to each other.
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASPrismaticJointComponent extends Box2DASBaseJointComponent {
    public var maxForce:Number = 0.0;

    public var enableMotor:Boolean = false;

    public var motorSpeed:Number = 0.0

    public var enableLimit:Boolean = false;

    public var upperLimit:Number = 0.0;

    public var lowerLimit:Number = 0.0;

    public function Box2DASPrismaticJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.PRISMATIC;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.prismaticJoint);
        b2Def.prismaticJoint.enableLimit = enableLimit;
        b2Def.prismaticJoint.lowerTranslation = lowerLimit;
        b2Def.prismaticJoint.upperTranslation = upperLimit;
        b2Def.prismaticJoint.enableMotor = enableMotor;
        b2Def.prismaticJoint.maxMotorForce = maxForce;
        b2Def.prismaticJoint.motorSpeed = motorSpeed;
        b2Def.prismaticJoint.Initialize(b2body1, b2body2, anchor1, offset2);
        joint = new b2PrismaticJoint(world, b2Def.prismaticJoint, dispatcher);
    }
}
}
