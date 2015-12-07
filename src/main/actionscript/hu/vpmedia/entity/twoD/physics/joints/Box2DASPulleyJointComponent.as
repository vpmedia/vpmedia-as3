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
import Box2DAS.Common.V2;
import Box2DAS.Common.b2Def;
import Box2DAS.Dynamics.Joints.b2PulleyJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * Next up is the pulley joint. As the name suggests it is used for creating a pulley system. You can specify a ratio of how far one side changes compared to the other. The pulley does take a bit of tweaking to get it set up correctly for how you want it to function.
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASPulleyJointComponent extends Box2DASBaseJointComponent {
    public var pulleyGearRatio:Number = 0;

    public var upperLimit:Number = 0.0;

    public var lowerLimit:Number = 0.0;

    public var groundAnchor1:V2 = new V2();

    public var groundAnchor2:V2 = new V2();

    public function Box2DASPulleyJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.PULLEY;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.pulleyJoint);
        b2Def.pulleyJoint.maxLengthA = lowerLimit;
        b2Def.pulleyJoint.maxLengthB = upperLimit;
        b2Def.pulleyJoint.ratio = pulleyGearRatio;
        b2Def.pulleyJoint.Initialize(b2body1, b2body2, groundAnchor1, groundAnchor2, anchor1, anchor2, 1);
        joint = new b2PulleyJoint(world, b2Def.pulleyJoint, dispatcher);
    }
}
}
