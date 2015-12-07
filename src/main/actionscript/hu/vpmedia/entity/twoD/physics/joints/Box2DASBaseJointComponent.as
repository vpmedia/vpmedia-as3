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
import Box2DAS.Dynamics.Joints.b2Joint;
import Box2DAS.Dynamics.Joints.b2JointDef;
import Box2DAS.Dynamics.b2Body;
import Box2DAS.Dynamics.b2World;

import flash.events.EventDispatcher;

import hu.vpmedia.entity.core.BaseEntityComponent;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;
import hu.vpmedia.framework.IBaseDisposable;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASBaseJointComponent extends BaseEntityComponent implements IBaseDisposable {
    public var joint:b2Joint;

    public var b2body1:b2Body;

    public var b2body2:b2Body;

    public var anchor1:V2;

    public var anchor2:V2;

    public var offset1:V2;

    public var offset2:V2;

    public var world:b2World;

    public var dispatcher:EventDispatcher;

    public var collideConnected:Boolean;

    public var jointType:String;

    public function Box2DASBaseJointComponent(parameters:Object = null) {
        super(parameters);
    }

    override protected function setupDefaults():void {
        collideConnected = false;
        world = Box2DASRegistry.world;
        dispatcher = new EventDispatcher();
    }

    protected function initJointDef(def:b2JointDef):void {
        def.collideConnected = collideConnected;
        def.userData = this;
    }

    public function initialize():void {
        if (!b2body1) {
            b2body1 = world.m_groundBody;
        }
        if (!offset1) {
            offset1 = new V2();
        }
        if (!offset2) {
            offset2 = new V2();
        }
        if (!anchor1 && b2body1) {
            anchor1 = b2body1.GetWorldCenter();
        }
        if (!anchor2 && b2body2) {
            anchor2 = b2body2.GetWorldCenter();
        }
        if (anchor1) {
            anchor1.add(offset1);
        }
        if (anchor2) {
            anchor2.add(offset2);
        }
        createJoint();
    }

    public function dispose():void {
        //trace(this, "dispose");
        if (joint && joint.valid) {
            joint.destroy();
            joint = null;
        }
    }

    protected function createJoint():void {
        // abstract
    }
}
}
