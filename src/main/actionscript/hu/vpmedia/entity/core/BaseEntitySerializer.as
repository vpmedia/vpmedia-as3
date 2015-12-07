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
import flash.utils.getQualifiedClassName;

import hu.vpmedia.serializers.Serializer;

/**
 * TBD
 */
public class BaseEntitySerializer {

    /**
     * TBD
     */
    private var _factory:Serializer;

    /**
     * TBD
     */
    public function BaseEntitySerializer(factory:Serializer) {
        _factory = factory;
    }

    /**
     * TBD
     */
    public function encode(entity:BaseEntity):Object {
        var components:Dictionary = entity.getAllComponent();
        var list:Array = [];
        for each (var component:Object in components)
            list.push(_factory.encode(component));
        var output:Object = {__type: getQualifiedClassName(entity), __list: list};
        if (entity.name) {
            output.name = entity.name;
        }
        if (entity.disposable) {
            output.disposable = true;
        }
        return output;
    }

    /**
     * TBD
     */
    public function decode(object:Object):BaseEntity {
        var entity:BaseEntity = new BaseEntity();
        var list:Array = object.__list;
        for each (var encodedComponent:Object in list) {
            var decodedComponent:Object = _factory.decode(encodedComponent);
            entity.addComponent(decodedComponent);
        }
        if (object.name) {
            entity.name = object.name;
        }
        if (object.disposable) {
            entity.disposable = true;
        }
        return entity;
    }
}
}
