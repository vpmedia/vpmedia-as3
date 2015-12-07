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
import Box2DAS.Dynamics.ContactEvent;
import Box2DAS.Dynamics.b2Body;

import flash.ui.Keyboard;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.utils.KeyboardUtil;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASControlSystem extends BaseEntityStepSystem {
    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;


    // config
    private var acceleration:Number = 1;

    private var maxVelocity:Number = 8;

    private var jumpHeight:Number = 10;

    private var jumpAcceleration:Number = 2;

    // base
    private var _groundContacts:Array = []; //Used to determine if he's on ground or not.

    private var _lastFriction:Number = 0;

    private var _isOnGround:Boolean = false;

    private var _isMoving:Boolean = false;

    private var _isMovePressed:Boolean = false;

    public function Box2DASControlSystem(world:BaseEntityWorld, params:Object = null) {
        super(world, Box2DASControlNode, onStep, onAdded, onRemoved);
        initialize();
    }

    protected function initialize():void {
    }

    private function onAdded(node:Box2DASControlNode):void {
        node.physics.isAllowSleep = false;
        node.physics.reportBeginContact = true;
        node.physics.reportEndContact = true;
        node.physics.addFixtureListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
        node.physics.addFixtureListener(ContactEvent.END_CONTACT, handleEndContact);
    }

    private function onRemoved(node:Box2DASControlNode):void {
        node.physics.removeFixtureListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
        node.physics.removeFixtureListener(ContactEvent.END_CONTACT, handleEndContact);
    }

    private function handleBeginContact(e:ContactEvent):void {
        //trace(MovieEntityComponent(_world.getEntityList().getByComponent(e.fixture.m_body.m_userData).getComponent(MovieEntityComponent)).skin)
        //trace(e.fixture.m_body.m_userData); //Box2DASPhysicsComponent
        //Collision angle
        if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
        {
            var collisionAngle:Number = Math.atan2(e.normal.y, e.normal.x) * RAD_TO_DEG;
            if (collisionAngle > 45 && collisionAngle < 135) {
                _groundContacts.push(e.other);
                _isOnGround = true;
            }
        }
    }

    private function handleEndContact(e:ContactEvent):void {
        //trace(e.relatedObject, e.userData);
        //Remove from ground contacts, if it is one.
        var index:int = _groundContacts.indexOf(e.other);
        if (index != -1) {
            _groundContacts.splice(index, 1);
            if (_groundContacts.length == 0)
                _isOnGround = false;
        }
    }

    private function onStep(node:Box2DASControlNode, timeDelta:Number):void {
        if (node.control.allowKeyboard) {
            var body:b2Body = node.physics.getBody();
            var velocity:V2 = body.GetLinearVelocity();
            _isMovePressed = false;
            if (KeyboardUtil.isDown(Keyboard.RIGHT)) {
                velocity.x += (acceleration);
                _isMovePressed = true;
            }
            if (KeyboardUtil.isDown(Keyboard.LEFT)) {
                velocity.x -= (acceleration);
                _isMovePressed = true;
            }
            if (KeyboardUtil.isDown(Keyboard.DOWN)) {
                velocity.y += (acceleration);
                _isMovePressed = true;
            }
            if (KeyboardUtil.isDown(Keyboard.UP)) {
                velocity.y -= (acceleration);
                _isMovePressed = true;
            }
            //If player just started moving the hero this tick.
            if (_isMovePressed && !_isMoving) {
                _isMoving = true;
                if (node.physics.friction != 0)
                    _lastFriction = node.physics.friction;
                node.physics.friction = 0; //Take away friction so he can accelerate.
            }
            //Player just stopped moving the hero this tick.
            else if (!_isMovePressed && _isMoving) {
                _isMoving = false;
                node.physics.friction = _lastFriction;
            }
            if (_isOnGround && KeyboardUtil.justPressed(Keyboard.SPACE)) {
                velocity.y = -jumpHeight;
            }
            if (KeyboardUtil.isDown(Keyboard.SPACE) && !_isOnGround && velocity.y < 0) {
                velocity.y -= jumpAcceleration;
            }
            //Cap velocities
            if (velocity.x > (maxVelocity))
                velocity.x = maxVelocity;
            else if (velocity.x < (-maxVelocity))
                velocity.x = -maxVelocity;
            //update physics with new velocity
            // trace(_isDucking, _isMovePressed, _isMoving, _isOnGround);
            body.SetLinearVelocity(velocity);
            // update position
            node.display.x = node.physics.x;
            node.display.y = node.physics.y;
            node.display.rotation = node.physics.rotation;
        }
    }
}
}
