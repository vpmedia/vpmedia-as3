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
/**
 * TBD
 */
public class BaseEntityStepSystem extends BaseEntitySystem implements IBaseEntityStepSystem {
    /**
     * @private
     */
    protected var _nodeClass:Class;

    /**
     * @private
     */
    protected var _nodeAddedFunction:Function;

    /**
     * @private
     */
    protected var _nodeRemovedFunction:Function;

    /**
     * @private
     */
    protected var _nodeUpdateFunction:Function;

    /**
     * @private
     */
    protected var _world:BaseEntityWorld;

    /**
     * @private
     */
    protected var _nodeList:BaseEntityNodeList;

    /**
     * TBD
     */
    public function BaseEntityStepSystem(world:BaseEntityWorld, nodeClass:Class, nodeUpdateFunction:Function, nodeAddedFunction:Function = null, nodeRemovedFunction:Function = null, priority:int = 1) {
        _world = world;
        _nodeClass = nodeClass;
        _nodeAddedFunction = nodeAddedFunction;
        _nodeRemovedFunction = nodeRemovedFunction;
        _nodeUpdateFunction = nodeUpdateFunction;
        initNodeList();
        super(priority);
    }

    /**
     * @private
     */
    private function initNodeList():void {
        _nodeList = _world.getNodeList(_nodeClass);
        if (_nodeAddedFunction != null) {
            for (var node:BaseEntityNode = _nodeList.head; node; node = node.next) {
                _nodeAddedFunction(node);
            }
            _nodeList.nodeAdded.add(_nodeAddedFunction);
        }
        if (_nodeRemovedFunction != null) {
            _nodeList.nodeRemoved.add(_nodeRemovedFunction);
        }
    }

    /**
     * TBD
     */
    public function getNodeClass():Class {
        return _nodeClass;
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        if (_nodeAddedFunction != null) {
            _nodeList.nodeAdded.remove(_nodeAddedFunction);
        }
        if (_nodeRemovedFunction != null) {
            _nodeList.nodeRemoved.remove(_nodeRemovedFunction);
        }
        _nodeList = null;
    }

    /**
     * @inheritDoc
     */
    override public function step(timeDelta:Number):void {
        for (var node:BaseEntityNode = _nodeList.head; node; node = node.next) {
            _nodeUpdateFunction(node, timeDelta); // if (!entity.disposable) nodeUpdateFunction.call(null, entity, timeDelta);
        }
    }
}
}
