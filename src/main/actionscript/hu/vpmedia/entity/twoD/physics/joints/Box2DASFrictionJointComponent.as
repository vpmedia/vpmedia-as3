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
import Box2DAS.Dynamics.Joints.b2FrictionJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASFrictionJointComponent extends Box2DASBaseJointComponent {
    public var maxForce:Number = 0.0;

    public var maxTorque:Number = 0.0;

    public function Box2DASFrictionJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.FRICTION;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.frictionJoint);
        b2Def.frictionJoint.maxForce = maxForce;
        b2Def.frictionJoint.maxTorque = maxTorque;
        b2Def.frictionJoint.Initialize(b2body1, b2body2, offset1);
        joint = new b2FrictionJoint(world, b2Def.frictionJoint, dispatcher);
    }
}
}
