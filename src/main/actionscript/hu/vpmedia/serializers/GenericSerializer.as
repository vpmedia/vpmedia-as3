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
package hu.vpmedia.serializers {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import hu.vpmedia.utils.ClassUtil;

/**
 * TBD
 */
public class GenericSerializer implements ISerializer {

    /**
     * @private
     */
    private var _factory:Serializer;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function GenericSerializer(factory:Serializer) {
        _factory = factory;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * TBD
     */
    public function encode(source:*):Object {
        var target:Object = {};
        if (!source) {
            return null;
        }
        var sourceType:String = getQualifiedClassName(source);
        //trace("\t", sourceType);
        if (!sourceType) {
            return null;
        }
        var nodeClass:Class = Class(getDefinitionByName(sourceType));
        //copies data from commonly named properties and getter/setter pairs
        var sourceInfo:XMLList = ClassUtil.describeType(nodeClass).factory;
        var prop:XML;
        for each (prop in sourceInfo.variable) {
            if (ClassUtil.isNativeType(prop.@type)) {
                target[prop.@name] = source[prop.@name];
            }
            else {
                var serializer1:Object = _factory.getSerializerByType(prop.@type);
                if (serializer1)
                    target[prop.@name] = {__type: prop.@type, __value: serializer1.encode(source[prop.@name])};
            }
        }
        for each (prop in sourceInfo.accessor) {
            if (prop.@access == "readwrite") {
                if (ClassUtil.isNativeType(prop.@type)) {
                    target[prop.@name] = source[prop.@name];
                }
                else {
                    var serializer2:Object = _factory.getSerializerByType(prop.@type);
                    if (serializer2)
                        target[prop.@name] = {__type: prop.@type, __value: serializer2.encode(source[prop.@name])};
                }
            }
        }
        ////////////
        /* var variables:XMLList=ClassUtil.describeType(nodeClass).factory.variable;
         //trace("\t", nodeClass, variables);
         for each (var atom:XML in variables)
         {
         // trace(atom);
         var type:String=atom.@type;
         var property:String=atom.@name.toString();
         var value:*=source[property];
         if (ClassUtil.isNativeType(type))
         {
         target[property]=value;
         }
         else
         {
         var serializer:Object=_factory.getSerializerByType(type);
         if (serializer)
         target[property]={__type: type, __value: serializer.encode(value)};
         }
         } */
        var result:Object = {__type: sourceType, __value: target}
        return result;
    }

    /**
     * TBD
     */
    public function decode(source:Object):* {
        if (ClassUtil.isNative(source) || source == null) {
            return source;
        }
        var resultClass:Class = Object;
        var result:*;
        if (source.__type) {
            resultClass = Class(getDefinitionByName(source.__type));
        }
        result = new resultClass();
        for (var p:String in source.__value) {
            var value:Object = source.__value[p];
            if (result.hasOwnProperty(p)) {
                if (ClassUtil.isNative(value) || value == null) {
                    result[p] = value;
                }
                else {
                    var serializer:Object = _factory.getSerializerByType(value.__type);
                    if (serializer) {
                        result[p] = serializer.decode(value.__value);
                    }
                }
            }
        }
        return result;
    }
}
}
