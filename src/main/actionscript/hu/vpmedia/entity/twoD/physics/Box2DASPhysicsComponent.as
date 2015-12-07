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
import Box2DAS.Dynamics.b2Body;
import Box2DAS.Dynamics.b2Fixture;

import hu.vpmedia.entity.core.BaseEntityComponent;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASShapeFactory;
import hu.vpmedia.framework.IBaseDisposable;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASPhysicsComponent extends BaseEntityComponent implements IBaseDisposable {
    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    private static const RAD_AREA:Number = Math.PI * 2;

    private static const DEG_AREA:Number = 360;

    private var _x:Number;

    private var _y:Number;

    private var _width:Number;

    private var _height:Number;

    private var _rotation:Number;

    private var _scale:Number;

    // A body, which has a mass and a position.
    private var _body:b2Body;

    // A fixture binds a shape to a body and adds material properties such as density, friction, and restitution.
    private var _fixtures:Vector.<b2Fixture>; /// An array of b2Fixtures - Get the shape by fixture.m_shape.

    // fixture params
    private var _friction:Number;

    private var _restitution:Number; // Restitution measures how 'bouncy' a fixture is.

    private var _density:Number;

    private var _isSensor:Boolean;

    private var _reportBeginContact:Boolean;

    private var _reportEndContact:Boolean;

    private var _reportPreSolve:Boolean;

    private var _reportPostSolve:Boolean;

    private var _bubbleContacts:Boolean;

    private var _conveyorBeltSpeed:Number;

    // body cats.
    private var _categoryBits:int;

    private var _maskBits:int;

    private var _groupIndex:int;

    // body params
    private var _bodyType:int;

    private var _isAllowSleep:Boolean;

    private var _isBullet:Boolean;

    private var _isAwake:Boolean;

    private var _isActive:Boolean;

    private var _fixedRotation:Boolean;

    private var _linearDamping:Number;

    private var _angularDamping:Number;

    private var _angularVelocity:Number;

    private var _inertiaScale:Number;

    // shape params
    public var shapeData:Array;

    public var shapeType:int;

    //----------------------------------
    //  Constructor
    //----------------------------------
    public function Box2DASPhysicsComponent(params:Object = null) {
        //gravity = new V2(0,int(Math.random()*10));
        _scale = Box2DASRegistry.scale;
        super(params);
        initialize();
    }

    override protected function setupDefaults():void {
        // body cats.
        _categoryBits = BasePhysics2DCollisionCategories.get(BasePhysics2DCollisionCategories.CATEGORY_LEVEL);
        _maskBits = BasePhysics2DCollisionCategories.getAll();
        _groupIndex = 0;
        //
        _bodyType = b2Body.b2_dynamicBody
        shapeType = BasePhysics2DShapeTypes.BOX
        //
        _x = 0;
        _y = 0;
        _width = 0;
        _height = 0;
        _rotation = 0;
        //
        _linearDamping = 0;
        _angularDamping = 0;
        _angularVelocity = 0;
        //
        _friction = 1;
        _restitution = 0;
        _density = 1;
        //
        _inertiaScale = 1;
        _conveyorBeltSpeed = 0;
        //
        _bubbleContacts = true;
        _isAllowSleep = true;
        _isAwake = true;
        _isActive = true;
        _isBullet = false;
        //
    }

    //----------------------------------
    //  Methods
    //----------------------------------
    private function initialize():void {
        _fixtures = new Vector.<b2Fixture>();
        // define
        b2Def.body.userData = this;
        b2Def.body.type = _bodyType;
        b2Def.body.active = _isActive;
        b2Def.body.allowSleep = _isAllowSleep;
        b2Def.body.awake = _isAwake;
        b2Def.body.bullet = _isBullet;
        b2Def.body.position.x = _x;
        b2Def.body.position.y = _y;
        b2Def.body.angle = rotation;
        b2Def.body.fixedRotation = _fixedRotation;
        b2Def.body.linearDamping = _linearDamping;
        b2Def.body.angularDamping = _angularDamping;
        b2Def.body.angularVelocity = _angularVelocity
        b2Def.body.inertiaScale = _inertiaScale;
        // create body
        _body = Box2DASRegistry.world.CreateBody(b2Def.body);
        // create shape
        if (shapeData) {
            Box2DASShapeFactory.polys(this, shapeData);
            shapeType = BasePhysics2DShapeTypes.DECOMPOSED
        }
        else if (shapeType == BasePhysics2DShapeTypes.CIRCLE) {
            Box2DASShapeFactory.circle(this, width);
        }
        else if (shapeType == BasePhysics2DShapeTypes.BOX) {
            Box2DASShapeFactory.box(this, width, height);
        }
    }

    //----------------------------------
    //  Public Methods
    //----------------------------------
    /*public function transformByMatrix(matrix:Matrix):void
     {
     var nx:Number=matrix.tx / _scale;
     var ny:Number=matrix.ty / _scale;
     var angle:Number=Math.atan2(matrix.b, matrix.a);
     _body.SetTransform(new V2(nx, ny), angle);
     }*/
    public function dispose():void {
        //trace(this, "dispose");
        if (_body && _body.valid) {
            _body.destroy();
            _body = null;
        }
        _fixtures.length = 0;
        //  super.dispose();
    }

    //----------------------------------
    //  Get body
    //----------------------------------
    public function getBody():b2Body {
        return _body;
    }

    /*public function getTransformMatrix():Matrix
     {
     var matrix:Matrix=new Matrix();
     if (_body)
     {
     matrix.rotate(_body.GetAngle() % RAD_AREA);
     matrix.translate(_body.m_xf.position.x * _scale, _body.m_xf.position.y * _scale);
     }
     else
     {
     matrix.rotate(_rotation % RAD_AREA);
     matrix.translate(_x * _scale, _y * _scale);
     }
     return matrix;
     }*/
    //----------------------------------
    //  Getter/Setter
    //----------------------------------
    public function get width():Number {
        return _width * _scale;
    }

    public function set width(value:Number):void {
        _width = value / _scale;
    }

    //
    public function get height():Number {
        return _height * _scale;
    }

    public function set height(value:Number):void {
        _height = value / _scale;
    }

    //----------------------------------
    //  Fixture getters/setters
    //----------------------------------
    public function hasFixture():Boolean {
        return Boolean(_fixtures && _fixtures.length > 0);
    }

    public function getFirstFixture():b2Fixture {
        return _fixtures[0];
    }

    public function getFixtures():Vector.<b2Fixture> {
        return _fixtures;
    }

    public function get friction():Number {
        if (hasFixture())
            return _fixtures[0].GetFriction();
        else
            return _friction;
    }

    public function set friction(value:Number):void {
        _friction = value;
        setFixtureProperty("friction", value);
    }

    // restitution
    public function get restitution():Number {
        if (hasFixture())
            return _fixtures[0].GetRestitution();
        else
            return _restitution;
    }

    public function set restitution(value:Number):void {
        _restitution = value;
        setFixtureProperty("restitution", value);
    }

    // density
    public function get density():Number {
        if (hasFixture())
            return getFirstFixture().GetDensity();
        else
            return _density;
    }

    public function set density(value:Number):void {
        _density = value;
        setFixtureProperty("density", value);
    }

    // sensor
    public function get isSensor():Boolean {
        if (hasFixture())
            return getFirstFixture().IsSensor();
        else
            return _isSensor;
    }

    public function set isSensor(value:Boolean):void {
        _isSensor = value;
        setFixtureProperty("isSensor", value);
    }

    // category bits
    public function set categoryBits(value:int):void {
        _categoryBits = value;
        if (hasFixture()) {
            var n:int = _fixtures.length;
            var i:int;
            for (i = 0; i < n; ++i) {
                _fixtures[i].m_filter.categoryBits = _categoryBits;
                _fixtures[i].Refilter();
            }
        }
    }

    public function get categoryBits():int {
        if (hasFixture())
            return getFirstFixture().m_filter.categoryBits;
        else
            return _categoryBits;
    }

    // maskBits
    public function set maskBits(value:int):void {
        _maskBits = value;
        if (hasFixture()) {
            var n:int = _fixtures.length;
            var i:int;
            for (i = 0; i < n; ++i) {
                _fixtures[i].m_filter.maskBits = _maskBits;
                _fixtures[i].Refilter();
            }
        }
    }

    public function get maskBits():int {
        if (hasFixture()) {
            return getFirstFixture().m_filter.maskBits;
        }
        else {
            return _maskBits;
        }
    }

    // ground index
    public function set groupIndex(value:int):void {
        _maskBits = value;
        if (hasFixture()) {
            var n:int = _fixtures.length;
            var i:int;
            for (i = 0; i < n; ++i) {
                _fixtures[i].m_filter.groupIndex = _groupIndex;
                _fixtures[i].Refilter();
            }
        }
    }

    public function get groupIndex():int {
        if (hasFixture()) {
            return getFirstFixture().m_filter.groupIndex;
        }
        else {
            return _groupIndex;
        }
    }

    //
    public function set reportBeginContact(value:Boolean):void {
        _reportBeginContact = value;
        setFixtureProperty("reportBeginContact", value);
    }

    public function get reportBeginContact():Boolean {
        if (hasFixture()) {
            return getFirstFixture().m_reportBeginContact;
        }
        else {
            return _reportBeginContact;
        }
    }

    /// Dispatch "onContactEnd" events?
    public function set reportEndContact(value:Boolean):void {
        _reportEndContact = value;
        setFixtureProperty("reportEndContact", value);
    }

    public function get reportEndContact():Boolean {
        if (hasFixture()) {
            return getFirstFixture().m_reportEndContact;
        }
        else {
            return _reportEndContact;
        }
    }

    /// Dispatch "onPreSolve" events?
    public function set reportPreSolve(value:Boolean):void {
        _reportPreSolve = value;
        setFixtureProperty("reportPreSolve", value);
    }

    public function get reportPreSolve():Boolean {
        if (hasFixture()) {
            return getFirstFixture().m_reportPreSolve;
        }
        else {
            return _reportPreSolve;
        }
    }

    /// Dispatch "onPostSolve" events?
    public function set reportPostSolve(value:Boolean):void {
        _reportPostSolve = value;
        setFixtureProperty("reportPostSolve", value);
    }

    public function get reportPostSolve():Boolean {
        if (hasFixture()) {
            return getFirstFixture().m_reportPostSolve;
        }
        else {
            return _reportPostSolve;
        }
    }

    /// Bubble contact events?
    public function set bubbleContacts(value:Boolean):void {
        _bubbleContacts = value;
        setFixtureProperty("bubbleContacts", value);
    }

    public function get bubbleContacts():Boolean {
        if (hasFixture()) {
            return getFirstFixture().m_bubbleContacts;
        }
        else {
            return _bubbleContacts;
        }
    }

    //  conveyorBeltSpeed
    public function get conveyorBeltSpeed():Number {
        return _conveyorBeltSpeed;
    }

    public function set conveyorBeltSpeed(value:Number):void {
        _conveyorBeltSpeed = value;
    }

    // Helper
    public function setFixtureProperty(propertyName:String, value:*):void {
        if (hasFixture()) {
            var n:int = _fixtures.length;
            var i:int;
            for (i = 0; i < n; ++i) {
                _fixtures[i]["m_" + propertyName] = value;
            }
        }
    }

    public function addFixtureListener(type:String, listener:Function):void {
        if (_fixtures) {
            var n:int = _fixtures.length;
            var i:int;
            for (i = 0; i < n; ++i) {
                // trace(this, i, "addFixtureListener", type, listener, _fixtures[i], _fixtures[i].m_reportBeginContact, _fixtures[i].m_reportEndContact);
                _fixtures[i].addEventListener(type, listener, false, 0, true);
            }
        }
    }

    public function removeFixtureListener(type:String, listener:Function):void {
        if (_fixtures) {
            var n:int = _fixtures.length;
            var i:int;
            for (i = 0; i < n; ++i) {
                // trace(this, i, "removeFixtureListener", type, listener, _fixtures[i], _fixtures[i].m_reportBeginContact, _fixtures[i].m_reportEndContact);
                _fixtures[i].removeEventListener(type, listener);
            }
        }
    }

    //----------------------------------
    //  Body getters/setters
    //----------------------------------
    public function move(nX:Number, nY:Number):void {
        _x = nX / _scale;
        _y = nY / _scale;
        if (_body) {
            var pos:V2 = _body.GetPosition();
            pos.x = _x;
            pos.y = _y;
            _body.SetTransform(pos, _body.GetAngle());
        }
    }

    public function get x():Number {
        if (_body)
            return _body.GetPosition().x * _scale;
        else
            return _x * _scale;
    }

    public function set x(value:Number):void {
        _x = value / _scale;
        if (_body) {
            var pos:V2 = _body.GetPosition();
            pos.x = _x;
            _body.SetTransform(pos, _body.GetAngle());
        }
    }

    //
    public function get y():Number {
        if (_body)
            return _body.GetPosition().y * _scale;
        else
            return _y * _scale;
    }

    public function set y(value:Number):void {
        _y = value / _scale;
        if (_body) {
            var pos:V2 = _body.GetPosition();
            pos.y = _y;
            _body.SetTransform(pos, _body.GetAngle());
        }
    }

    //
    public function get rotation():Number {
        if (_body)
            return _body.GetAngle() * RAD_TO_DEG % DEG_AREA; // TO TEST: % DEG_AREA is ok?
        else
            return _rotation * RAD_TO_DEG;
    }

    public function set rotation(value:Number):void {
        _rotation = value * DEG_TO_RAD;
        if (_body)
            _body.SetTransform(_body.GetPosition(), _rotation);
    }

    //
    public function get fixedRotation():Boolean {
        if (_body)
            return _body.IsFixedRotation();
        else
            return _fixedRotation;
    }

    public function set fixedRotation(value:Boolean):void {
        _fixedRotation = value;
        if (_body)
            _body.SetFixedRotation(value);
    }

    // allow sleeping
    public function get isAllowSleep():Boolean {
        if (_body)
            return _body.IsSleepingAllowed();
        else
            return _isAllowSleep;
    }

    public function set isAllowSleep(value:Boolean):void {
        _isAllowSleep = value;
        if (_body)
            _body.SetSleepingAllowed(value);
    }

    // bullet
    public function get isBullet():Boolean {
        if (_body)
            return _body.IsBullet();
        else
            return _isBullet;
    }

    public function set isBullet(value:Boolean):void {
        _isBullet = value;
        if (_body)
            _body.SetBullet(value);
    }

    // bodyType
    public function get bodyType():int {
        if (_body)
            return _body.GetType();
        else
            return _bodyType;
    }

    public function set bodyType(value:int):void {
        _bodyType = value;
        if (_body)
            _body.SetType(value);
    }

    // angularVelocity
    public function get angularVelocity():Number {
        if (_body)
            return _body.GetAngularVelocity();
        else
            return _angularVelocity;
    }

    public function set angularVelocity(value:Number):void {
        _angularVelocity = value;
        if (_body)
            _body.SetAngularVelocity(value);
    }

    // angularDamping
    public function get angularDamping():Number {
        if (_body)
            return _body.GetAngularDamping();
        else
            return _angularDamping;
    }

    public function set angularDamping(value:Number):void {
        _angularDamping = value;
        if (_body)
            _body.SetAngularDamping(value);
    }

    //  linearDamping
    public function get linearDamping():Number {
        if (_body)
            return _body.GetLinearDamping();
        else
            return _linearDamping;
    }

    public function set linearDamping(value:Number):void {
        _linearDamping = value;
        if (_body)
            _body.SetLinearDamping(value);
    }
}
}
