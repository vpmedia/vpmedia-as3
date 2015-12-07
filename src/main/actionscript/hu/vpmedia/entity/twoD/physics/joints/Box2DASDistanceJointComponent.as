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
import Box2DAS.Dynamics.Joints.b2DistanceJoint;

import hu.vpmedia.entity.twoD.physics.BasePhysics2DJointTypes;

/**
 * The next joint we will look at is the distance joint. It is pretty simple to create. All it does is maintain a distance between two bodies. For each of the two bodies we specify the anchor point in world coordinates. FYI wherever you see box1, box2 etc – those are dynamic bodies. _groundBody which I use later on is a static body.
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASDistanceJointComponent extends Box2DASBaseJointComponent {
    public var dampingRatio:Number = 0.7;

    public var frequencyHz:Number = 5.0;

    public function Box2DASDistanceJointComponent(parameters:Object = null) {
        jointType = BasePhysics2DJointTypes.DISTANCE;
        super(parameters);
    }

    override protected function createJoint():void {
        initJointDef(b2Def.distanceJoint);
        b2Def.distanceJoint.frequencyHz = frequencyHz;
        b2Def.distanceJoint.dampingRatio = dampingRatio;
        b2Def.distanceJoint.Initialize(b2body1, b2body2, anchor1, anchor2);
        joint = new b2DistanceJoint(world, b2Def.distanceJoint, dispatcher);
    }
}
}
