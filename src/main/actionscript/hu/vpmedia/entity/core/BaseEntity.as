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
import flash.utils.Dictionary;

import hu.vpmedia.framework.IBaseDisposable;
import hu.vpmedia.utils.ObjectUtil;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * TBD
 */
public class BaseEntity implements IBaseEntity, IBaseDisposable {

    /**
     * TBD
     */
    protected var _components:Dictionary;

    /**
     * TBD
     */
    public var previous:BaseEntity;

    /**
     * TBD
     */
    public var next:BaseEntity;

    /**
     * TBD
     */
    public var name:String;

    /**
     * TBD
     */
    public var disposable:Boolean;

    /**
     * TBD
     */
    public var componentAdded:ISignal;

    /**
     * TBD
     */
    public var componentRemoved:ISignal;

    /**
     * TBD
     */
    public function BaseEntity(parameters:Object = null) {
        componentAdded = new Signal(IBaseEntity, Class);
        componentRemoved = new Signal(IBaseEntity, Class);
        _components = new Dictionary();
        setupDefaults();
        ObjectUtil.copyProperties(parameters, this);
    }

    /**
     * TBD
     */
    protected function setupDefaults():void {
        // abstract
    }

    /**
     * TBD
     */
    public function addComponent(component:Object, componentClass:Class = null):void {
        if (!componentClass) {
            componentClass = Class(Object(component).constructor);
        }
        if (_components[componentClass]) {
            removeComponent(componentClass);
        }
        _components[componentClass] = component;
        componentAdded.dispatch(this, componentClass);
    }

    /**
     * TBD
     */
    public function removeComponent(componentClass:Class):void {
        if (_components[componentClass]) {
            delete _components[componentClass];
        }
        componentRemoved.dispatch(this, componentClass);
    }

    /**
     * TBD
     */
    public function getComponent(componentClass:Class):Object {
        return _components[componentClass];
    }

    /**
     * TBD
     */
    public function removeAllComponent():void {
        for (var p:Object in _components) {
            if (_components[p] is IBaseDisposable) {
                IBaseDisposable(_components[p]).dispose();
            }
        }
        _components = new Dictionary();
    }

    /**
     * TBD
     */
    public function getAllComponent():Dictionary {
        return _components;
    }

    /**
     * TBD
     */
    public function hasComponent(componentClass:Class):Boolean {
        return _components[componentClass] != null;
    }

    /**
     * TBD
     */
    public function dispose():void {
        removeAllComponent();
    }
}
}
