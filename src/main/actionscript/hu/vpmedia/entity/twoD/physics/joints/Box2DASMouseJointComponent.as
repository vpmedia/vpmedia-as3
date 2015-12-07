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
import Box2DAS.Dynamics.Joints.b2MouseJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * The mouse joint simply allows us to click on, and manipulate the bodies in the world. This is useful for interacting with the Box2D world, so we will learn about it first.
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASMouseJointComponent extends Box2DASBaseJointComponent {
    public var maxForce:Number = 0.0;

    public var frequencyHz:Number = 0.0;

    public var dampingRatio:Number = 0.0;

    public function Box2DASMouseJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.MOUSE;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.mouseJoint);
        b2Def.mouseJoint.frequencyHz = frequencyHz;
        b2Def.mouseJoint.dampingRatio = dampingRatio;
        b2Def.mouseJoint.maxForce = maxForce;
        joint = new b2MouseJoint(world, b2Def.mouseJoint, dispatcher);
    }
}
}
