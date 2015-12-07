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
package hu.vpmedia.entity.twoD.physics {
import Box2DAS.Common.V2;
import Box2DAS.Common.b2Def;
import Box2DAS.Dynamics.Joints.b2MouseJoint;
import Box2DAS.Dynamics.b2Body;
import Box2DAS.Dynamics.b2Fixture;

import flash.events.MouseEvent;

import hu.vpmedia.entity.core.BaseEntitySystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASDragDropSystem extends BaseEntitySystem {
    private var _mouseJoint:b2MouseJoint;

    private var _world:BaseEntityWorld;

    private var _isMouseDown:Boolean;

    public function Box2DASDragDropSystem(world:BaseEntityWorld) {
        _world = world;
        initialize();
    }

    protected function initialize():void {
        _world.context.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
        _world.context.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler, false, 0, true);
    }

    public function mouseHandler(event:MouseEvent):void {
        if (event.type == MouseEvent.MOUSE_DOWN) {
            _isMouseDown = true;
            return;
        }
        _isMouseDown = false;
    }

    override public function step(timeDelta:Number):void {
        var mp:V2 = new V2(_world.context.stage.mouseX / Box2DASRegistry.scale, _world.context.stage.mouseY / Box2DASRegistry.scale);
        var body:b2Body;
        if (_isMouseDown && !_mouseJoint) {
            body = getBodyAtMouse(mp, false);
            if (body) {
                b2Def.mouseJoint.bodyA = Box2DASRegistry.world.m_groundBody;
                b2Def.mouseJoint.bodyB = body;
                b2Def.mouseJoint.target.v2 = mp;
                b2Def.mouseJoint.collideConnected = true;
                b2Def.mouseJoint.maxForce = 300.0 * body.GetMass();
                _mouseJoint = Box2DASRegistry.world.CreateJoint(b2Def.mouseJoint) as b2MouseJoint;
                body.SetAwake(true);
            }
        }
        if (!_isMouseDown && _mouseJoint) {
            Box2DASRegistry.world.DestroyJoint(_mouseJoint);
            _mouseJoint = null;
        }
        if (_mouseJoint) {
            _mouseJoint.SetTarget(mp);
        }
    }

    public function getBodyAtMouse(mp:V2, includeStatic:Boolean = false):b2Body {
        var body:b2Body = null;
        Box2DASRegistry.world.QueryPoint(function (f:b2Fixture):Boolean {
            var b:b2Body = f.GetBody();
            if (b.IsDynamic() || includeStatic) {
                body = b;
                return false;
            }
            return true;
        }, mp);
        return body;
    }
}
}
