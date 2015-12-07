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
package hu.vpmedia.entity.core {
import flash.display.Sprite;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getTimer;

import hu.vpmedia.entity.twoD.renderers.BaseCamera2D;
import hu.vpmedia.framework.IBaseDisposable;
import hu.vpmedia.framework.IBaseSteppable;
import hu.vpmedia.utils.KeyboardUtil;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The BaseEntityWorld class is the heart of all systems.
 */
public class BaseEntityWorld extends Sprite implements IBaseDisposable, IBaseSteppable {
    /**
     * TBD flag
     */
    public var isUpdating:Boolean;

    /**
     * TBD flag
     */
    public var isPaused:Boolean;

    /**
     * Background color, used by blitting views.
     */
    public var backgroundColor:uint;

    /**
     * The native display object context
     */
    public var context:Sprite;

    /**
     * The common 2d camera
     */
    public var camera:BaseCamera2D;

    /**
     * The frame dispatcher signal
     */
    public var signal:ISignal;

    /**
     * The time since last tick in seconds (1..0)
     */
    private var timeDelta:Number;

    /**
     * The calculated optimal delta time by fps.
     */
    private var expectedTimeDelta:Number;

    /**
     * The last frames time in milliseconds
     */
    private var lastFramesTime:int;

    /**
     * @private
     */
    private var _systems:Vector.<BaseEntitySystem>;

    /**
     * @private
     */
    private var _entities:BaseEntityList;

    /**
     * @private
     */
    private var _families:Dictionary;

    /**
     * Constructor
     */
    public function BaseEntityWorld(width:int = 800, height:int = 600, backgroundColor:uint = 0xFF000000) {
        this.backgroundColor = backgroundColor;
        camera = new BaseCamera2D(width, height);
        initialize();
        super();
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * @private
     */
    private function initialize():void {
        signal = new Signal();
        isPaused = true;
        _systems = new Vector.<BaseEntitySystem>();
        _entities = new BaseEntityList();
        _families = new Dictionary();
        lastFramesTime = 0;

        context = new Sprite();
        addChild(context);

        addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, true);

    }

    /**
     * @private
     */
    private function onStageAdded(event:Event):void {
        expectedTimeDelta = 1000 / context.stage.frameRate;
        KeyboardUtil.initialize(stage);
        addEventListener(Event.ENTER_FRAME, onFrameEnter, false, 0, true);
        addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
    }

    /**
     * @private
     */
    private function onStageRemoved(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, onFrameEnter);
    }

    //----------------------------------
    //  Systems / Public
    //----------------------------------

    /**
     * TBD
     */
    public function createSystem(systemClass:Class, priority:int = 1, parameters:Object = null):BaseEntitySystem {
        if (getSystem(systemClass)) {
            throw new IllegalOperationError("System already exists in world: " + systemClass.toString());
        }
        //trace(this, "addSystem", systemClass, priority);
        var system:BaseEntitySystem = (parameters ? new systemClass(this, parameters) : new systemClass(this));
        addSystem(system, priority);
        return system;
    }

    /**
     * TBD
     */
    public function addSystem(system:BaseEntitySystem, priority:int = 1):void {
        var systemClass:Class = Class(Object(system).constructor);
        if (getSystem(systemClass)) {
            throw new IllegalOperationError("System already exists in world: " + systemClass.toString());
        }
        system.priority = priority;
        _systems.push(system);
        _systems = _systems.sort(compareSystemByPriority);
    }

    /**
     * TBD
     */
    public function getSystem(systemClass:Class):BaseEntitySystem {
        var n:int = _systems.length;
        for (var i:int = 0; i < n; i++) {
            if (_systems[i] is systemClass) {
                return _systems[i];
            }
        }
        return null;
    }

    /**
     * TBD
     */
    public function removeSystem(system:Class):void {
        var systemInstance:BaseEntitySystem = getSystem(system);
        if (systemInstance) {
            if (systemInstance is IBaseEntityStepSystem) {
                disposeNodeList(IBaseEntityStepSystem(systemInstance).getNodeClass());
            }
            var listIndex:int = _systems.indexOf(systemInstance);
            if (listIndex > -1) {
                _systems.splice(listIndex, 1);
            }
            else {
                throw new Error("BaseEntityWorld::removeSystem::system_not_found");
            }
            signal.addOnce(systemInstance.dispose);
        }
        else {
            throw new Error("BaseEntityWorld::removeSystem::system_not_found");
        }
    }

    /**
     * System list getter
     */
    public function getSystems():Vector.<BaseEntitySystem> {
        return _systems;
    }

    //----------------------------------
    //  Systems / Private
    //----------------------------------

    /**
     * @private
     */
    private static function compareSystemByPriority(a:BaseEntitySystem, b:BaseEntitySystem):Number {
        if (a.priority < b.priority) {
            return -1;
        }
        else if (a.priority > b.priority) {
            return 1;
        }
        else {
            return 0;
        }
    }

    //----------------------------------
    //  Entities
    //----------------------------------

    /**
     * TBD
     */
    public function addEntity(entity:BaseEntity):void {
        _entities.add(entity);
        entity.componentAdded.add(componentAdded);
        entity.componentRemoved.add(componentRemoved);
        for each (var family:BaseEntityFamily in _families) {
            family.addEntityIfMatch(entity);
        }
    }

    /**
     * TBD
     */
    public function removeEntity(entity:BaseEntity):void {
        entity.componentAdded.remove(componentAdded);
        entity.componentRemoved.remove(componentRemoved);
        for each (var family:BaseEntityFamily in _families) {
            family.removeEntity(entity);
        }
        _entities.remove(entity);
        entity.dispose();
        entity = null;
    }

    /**
     * TBD
     */
    public function hasEntity(value:BaseEntity):Boolean {
        return _entities.has(value);
    }

    /**
     * TBD
     */
    public function getEntityByName(value:String):BaseEntity {
        return _entities.getByName(value);
    }

    /**
     * TBD
     */
    public function getEntityList():BaseEntityList {
        return _entities;
    }

    /**
     * TBD
     */
    public function removeAllEntities():void {
        while (_entities.head) {
            removeEntity(_entities.head);
        }
    }

    //----------------------------------
    //  Families
    //----------------------------------

    /**
     * TBD
     */
    public function getNodeList(nodeClass:Class):BaseEntityNodeList {
        //trace(this, "getNodeList", nodeClass);
        if (_families[nodeClass]) {
            return BaseEntityFamily(_families[nodeClass]).getNodes();
        }
        var family:BaseEntityFamily = new BaseEntityFamily(nodeClass);
        _families[nodeClass] = family;
        for (var entity:BaseEntity = _entities.head; entity; entity = entity.next) {
            family.addEntityIfMatch(entity);
        }
        return family.getNodes();
    }

    /**
     * TBD
     */
    public function getFamilies():Dictionary {
        return _families;
    }

    /**
     * @private
     */
    private function disposeNodeList(nodeClass:Class):void {
        if (_families[nodeClass]) {
            _families[nodeClass].dispose();
        }
        delete _families[nodeClass];
    }

    /**
     * @private
     */
    private function componentAdded(entity:BaseEntity, componentClass:Class):void {
        //trace(this, "componentAdded", entity, componentClass);
        for each(var family:IBaseEntityFamily in _families) {
            family.componentAddedToEntity(entity, componentClass);
        }
    }

    /**
     * @private
     */
    private function componentRemoved(entity:BaseEntity, componentClass:Class):void {
        //trace(this, "componentRemoved", entity, componentClass);
        for each(var family:IBaseEntityFamily in _families) {
            family.componentRemovedFromEntity(entity, componentClass);
        }
    }

    //----------------------------------
    //  Constrols
    //----------------------------------

    /**
     * TBD
     */
    public function dispose():void {
        trace(this, "dispose");

        isPaused = true;
        for (var entity:BaseEntity = _entities.head; entity; entity = entity.next) {
            removeEntity(entity);
        }
    }

    /**
     * TBD
     */
    public function start():void {
        isPaused = false;
    }

    /**
     * TBD
     */
    public function stop():void {
        isPaused = true;
    }

    /**
     * TBD
     */
    public function step(timeDelta:Number):void {
        // remove entities flagged outside the system loop
        for (var entity:BaseEntity = _entities.head; entity; entity = entity.next) {
            if (entity && entity.disposable) {
                removeEntity(entity);
            }
        }
        // start flag
        isUpdating = true;
        // step camera static system
        camera.step(timeDelta);
        // step dynamic systems by priority
        // preUpdate => update => move => resolveCollisions => render
        var n:int = _systems.length;
        for (var i:int = 0; i < n; i++) {
            _systems[i].step(timeDelta);
        }
        // step input static system
        KeyboardUtil.update();
        // stop flag
        isUpdating = false;
        // dispatch step complete signal
        signal.dispatch(timeDelta);
    }

    /**
     * @private
     */
    private function onFrameEnter(event:Event = null):void {
        if (isPaused) {
            return;
        }
        // calc. elapsed time since last tick
        const currentFramesTime:Number = getTimer();
        const calculatedTimeDelta:int = currentFramesTime - lastFramesTime;
        timeDelta = calculatedTimeDelta / 1000;
        //trace(context.stage.frameRate, expectedTimeDelta, calculatedTimeDelta);
        lastFramesTime = currentFramesTime;
        step(timeDelta);
    }
}
}
