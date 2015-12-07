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
import Box2DAS.Dynamics.Joints.b2WeldJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * Finally, we come to the last joint, the weld joint. The weld joint allows us to weld two bodies together. Pretty simple. If you are wanting to use it for setting up breakable structures then you should take note of the Box2D manual comment “It is tempting to use the weld joint to define breakable structures. However, the Box2D solver is iterative so the joints are a bit soft. So chains of bodies connected by weld joints will flex. Instead it is better to create breakable bodies starting with a single body with multiple fixtures. When the body breaks, you can destroy a fixture and recreate it on a new body.”
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASWeldJointComponent extends Box2DASBaseJointComponent {
    public function Box2DASWeldJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.WELD;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.weldJoint);
        b2Def.weldJoint.Initialize(b2body1, b2body2, anchor1);
        joint = new b2WeldJoint(world, b2Def.weldJoint, dispatcher);
    }
}
}
