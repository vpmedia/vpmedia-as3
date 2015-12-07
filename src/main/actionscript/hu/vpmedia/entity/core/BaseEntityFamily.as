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
import flash.utils.getDefinitionByName;

import hu.vpmedia.utils.ClassUtil;

/**
 * TBD
 */
public class BaseEntityFamily implements IBaseEntityFamily {

    /**
     * @private
     */
    protected var _nodeClass:Class;

    /**
     * @private
     */
    protected var _entities:Dictionary;

    /**
     * @private
     */
    protected var _components:Dictionary;

    /**
     * @private
     */
    protected var _nodes:BaseEntityNodeList;

    /**
     * @private
     */
    protected var _nodePool:BaseEntityNodePool;

    /**
     * Constructor
     *
     * @param nodeClass The class type of instances to collect.
     */
    public function BaseEntityFamily(nodeClass:Class) {
        _nodeClass = nodeClass;
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        _entities = new Dictionary();
        _components = new Dictionary();
        _nodes = new BaseEntityNodeList();
        _nodePool = new BaseEntityNodePool(_nodeClass);
        var variables:XMLList = ClassUtil.describeType(_nodeClass).factory.variable;
        for each (var atom:XML in variables) {
            // collect public variables except the linked list related
            if (atom.@name != "data" && atom.@name != "previous" && atom.@name != "next") {
                var componentClass:Class = getDefinitionByName(atom.@type) as Class;
                _components[componentClass] = atom.@name.toString();
            }
            // TODO: interface check...
            // var classDescription:XML = describeType(classParam);
            // return (classDescription.factory.implementsInterface.(@type == getQualifiedClassName(IEventDispatcher)).length() != 0);
        }
    }

    /**
     * TBD
     */
    public function addEntityIfMatch(entity:IBaseEntity):void {
        if (!_entities[entity]) {
            var componentClass:*;
            for (componentClass in _components) {
                if (!entity.hasComponent(componentClass)) {
                    return;
                }
            }
            var node:BaseEntityNode = _nodePool.checkOut();
            node.data = entity;
            for (componentClass in _components) {
                node[_components[componentClass]] = entity.getComponent(componentClass);
            }
            _entities[entity] = node;
            _nodes.add(node);
        }
    }

    /**
     * TBD
     */
    public function removeEntity(entity:IBaseEntity):void {
        if (_entities[entity]) {
            var node:BaseEntityNode = _entities[entity];
            delete _entities[entity];
            _nodes.remove(node);
            _nodePool.checkIn(node);
        }
    }

    /**
     * TBD
     */
    public function componentAddedToEntity(entity:IBaseEntity, componentClass:Class):void {
        addEntityIfMatch(entity);
    }

    /**
     * TBD
     */
    public function componentRemovedFromEntity(entity:IBaseEntity, componentClass:Class):void {
        if (_components[componentClass]) {
            removeEntity(entity);
        }
    }

    /**
     * TBD
     */
    public function getNodes():BaseEntityNodeList {
        return _nodes;
    }

    /**
     * TBD
     */
    public function dispose():void {
        for (var node:BaseEntityNode = _nodes.head; node; node = node.next) {
            delete _entities[node.data];
        }
        _nodes.dispose();
        _nodePool.dispose();
        _entities = null;
        _nodes = null;
        _nodePool = null;
        _components = null;
    }
}
}
