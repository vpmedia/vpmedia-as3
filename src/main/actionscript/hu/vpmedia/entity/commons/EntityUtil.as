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
package hu.vpmedia.entity.commons {
import flash.display.MovieClip;

import hu.vpmedia.entity.core.BaseEntity;
import hu.vpmedia.errors.StaticClassError;
import hu.vpmedia.utils.ClassUtil;

/**
 * TBD
 */
public class EntityUtil {
    /**
     * TBD
     */
    public function EntityUtil() {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static function clone(source:BaseEntity):BaseEntity {
        var newEntity:BaseEntity = new BaseEntity();
        for each (var component:Object in source.getAllComponent()) {
            var names:XMLList = ClassUtil.describeType(component).variable.@name;
            var klass:Class = component.constructor;
            var newComponent:Object = new klass();
            for each (var key:String in names) {
                newComponent[key] = component[key];
            }
            newEntity.addComponent(newComponent);
        }
        return newEntity;
    }


    public static function createFromMovieClip(source:MovieClip):Vector.<BaseEntity> {
        var result:Vector.<BaseEntity> = new Vector.<BaseEntity>();
        var n:Number = source.numChildren;
        var child:MovieClip;
        for (var i:int = 0; i < n; i++) {
            child = MovieClip(source.getChildAt(i));
            if (child) {
                var classParam:Object = {};
                //
                classParam.x = child.x;
                classParam.y = child.y;
                //We need to unrotate the object to get its true width/height. Then rotate it back.
                var rotation:Number = child.rotation;
                child.rotation = 0;
                classParam.width = child.width;
                classParam.height = child.height;
                child.rotation = rotation;
                classParam.rotation = child.rotation;
                //
                var instance:BaseEntity = new BaseEntity();
                instance.name = child.name;
                //
                result.push(instance);
            }
        }
        return result;
    }
}
}
