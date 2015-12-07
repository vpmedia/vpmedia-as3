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
package hu.vpmedia.utils {
import flash.display.DisplayObject;
import flash.net.registerClassAlias;
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import hu.vpmedia.errors.StaticClassError;

/**
 * Type/Reflection utility
 * In computer science, reflection is the process by which a computer program can observe and modify its own structure and behavior.
 * The programming paradigm driven by reflection is called reflective programming. - wikipedia
 */
public class ClassUtil {
    /**
     * @private
     */
    public function ClassUtil() {
        throw new StaticClassError();
    }

    // global cache improves reflection performance significantly
    private static var typeCache:Dictionary = new Dictionary();

    //----------------------------------
    //  Class Helpers
    //----------------------------------

    /**
     * Extended type validation.
     */
    public static function isType(value:Object, type:Class):Boolean {
        if (!(value is Class)) {
            return value is type;
        }
        if (value == type) {
            return true;
        }
        var inheritance:XMLList = describeInheritance(value);
        var qcn:String = getQualifiedClassName(type);
        return Boolean(inheritance.(@type == qcn).length() > 0);
    }

    /**
     * Gets a property class type.
     */
    public static function getPropertyType(value:Object, property:String):Class {
        if (!(value is Class) && !(property in value)) {
            return null;
        }
        // retrieve the correct property from the property list
        var propList:XMLList = describeProperties(value).(@name == property);
        return (propList.length() > 0) ? getDefinitionByName(propList[0].@type) as Class : null;
    }

    /**
     * Registers a new class type.
     */
    public static function registerType(value:Object):Boolean {
        if (!(value is Class)) {
            value = getConstructor(value);
        }
        // if not already registered
        var alias:String = describeType(value).@alias;
        if (alias.length) {
            return false;
        }
        registerClassAlias(getQualifiedClassName(value).split("::").join("."), value as Class);
        return true;
    }

    //----------------------------------
    //  Describe Type Helpers
    //----------------------------------

    /**
     * Cached describe type.
     */
    public static function describeType(value:Object, refreshCache:Boolean = false):XML {
        if (!(value is Class)) {
            value = getConstructor(value);
        }
        if (refreshCache || typeCache[value] == null) {
            typeCache[value] = flash.utils.describeType(value);
        }
        return typeCache[value];
    }

    /**
     * Cached describe inheritance.
     */
    public static function describeInheritance(value:Object):XMLList {
        return describeType(value).factory.*.(localName() == "extendsClass" || localName() == "implementsInterface");
    }

    /**
     * Cached describe properties.
     */
    public static function describeProperties(value:Object, metadataType:String = null):XMLList {
        var properties:XMLList = describeType(value).factory.*.(localName() == "accessor" || localName() == "variable");
        return (metadataType == null) ? properties : properties.(child("metadata").(@name == metadataType).length() > 0);
    }

    /**
     * Cached describe methods.
     */
    public static function describeMethods(value:Object, metadataType:String = null):XMLList {
        var methods:XMLList = describeType(value).factory.method;
        return (metadataType == null) ? methods : methods.(child("metadata").(@name == metadataType).length() > 0);
    }

    //----------------------------------
    //  Class Helpers
    //----------------------------------

    /**
     * TBD
     */
    public static function getConstructor(value:Object):Class {
        if (value is Proxy || value is Number || value is XML || value is XMLList) {
            var fqcn:String = getQualifiedClassName(value);
            return Class(getDefinitionByName(fqcn));
        }
        if (value is DisplayObject && value.loaderInfo) {
            return getDisplayObjectClass(DisplayObject(value));
        }
        return Class(value.constructor);
    }

    /**
     * TBD
     */
    public static function getDisplayObjectClass(value:DisplayObject):Class {
        try {
            var fqcn:String = getQualifiedClassName(value);
            return Class(value.loaderInfo.applicationDomain.getDefinition(fqcn));
        }
        catch (error:Error) {
        }
        return null;
    }

    /**
     * TBD
     */
    public static function getClassName(value:Object):String {
        return getQualifiedClassName(value).split("::").pop();
    }

    /**
     * TBD
     */
    public static function getClassFromName(className:String):Class {
        return getDefinitionByName(className) as Class;
    }

    //----------------------------------
    //  Enum Helpers
    //----------------------------------

    /**
     * TBD
     */
    public static function getConstNameByValue(target:Object, value:*):String {
        var description:XML = describeType(target);
        for each (var typeName:String in description..constant.@name) {
            if (target[typeName] == value)
                return typeName;
        }
        return null;
    }

    //----------------------------------
    //  Type Helpers
    //----------------------------------

    /**
     * TBD
     */
    public static function isNativeType(type:String):Boolean {
        return type == "int" || type == "uint" || type == "Number" || type == "String" || type == "Boolean";
    }

    /**
     * TBD
     */
    public static function isNative(object:*):Boolean {
        return object is Number || object is int || object is uint || object is String || object is Boolean;
    }

    /**
     * TBD
     */
    public static function isDynamic(object:*):Boolean {
        if (object is Class) {
            return true;
        }

        var typeXml:XML = describeType(object);
        return typeXml.@isDynamic == "true";
    }
}
}
