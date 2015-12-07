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
import flash.filters.BevelFilter;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.filters.GradientBevelFilter;
import flash.filters.GradientGlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.getDefinitionByName;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for native type serialization.
 */
public final class SerializerUtil {
    /**
     * @private
     */
    private static const AVAILABLE_FILTERS:Vector.<Class> = Vector.<Class>([BlurFilter, DropShadowFilter, GlowFilter, GradientGlowFilter, BevelFilter, GradientBevelFilter]);

    /**
     * @private
     */
    public function SerializerUtil() {
        throw new StaticClassError();
    }

    /**
     * Parse list of filter description objects into class instances
     * @param source Array
     * @return Array
     *
     */
    public static function decode(source:Object):Object {
        var result:Object = null;
        if (source && source.__type) {
            var clazz:Class = Class(getDefinitionByName(source.__type));
            result = new clazz();
            if (result) {
                for (var key:String in source) {
                    if (result.hasOwnProperty(key)) {
                        result[key] = source[key];
                    }
                }
            }
        }
        return result;
    }

    /**
     * Parse list of description objects into class instances
     * @param source Array
     * @return Array
     *
     */
    public static function decodeList(source:Array):Array {
        var result:Array = null;
        if (source) {
            result = [];
            var n:uint = source.length;
            for (var i:uint = 0; i < n; i++) {
                var instance:Object = decode(source[i]);
                if (instance) {
                    result.push(instance);
                }
            }
        }
        return result;
    }

    /**
     * Serializes an XML document to an object
     * @param xml The XML document to be serialized
     * @return The serialized Object
     */
    public static function xmlToObj(xml:XML):Object {
        var obj:Object = {};

        // Check if xml has no child nodes:
        if (xml.hasSimpleContent()) {
            return String(xml); // Return its value
        }

        // Parse out attributes:
        for each (var attr:XML in xml.@*) {
            obj[String(attr.name())] = attr;
        }

        // Parse out nodes:
        for each (var node:XML in xml.*) {
            obj[String(node.localName())] = xmlToObj(node);
        }

        return obj;
    }

    /**
     * Parse '(x=2, y=6)' formatted string to Point
     * @param source
     * @return Point
     *
     */
    public static function pointFromString(source:String):Point {
        var result:Point = new Point();
        if (isPointString(source)) {
            var trimmedStr:String = source.substr(1, source.length - 2);
            var tempArray:Array = trimmedStr.split(", ");
            result.x = String(tempArray[0]).split("=")[1];
            result.y = String(tempArray[1]).split("=")[1];
        }
        return result;
    }

    /**
     * Validates whether the input is a serializable Point string
     * @return Boolean
     *
     */
    public static function isPointString(source:String):Boolean {
        return source.indexOf("(") > -1 && source.indexOf(")") > -1 && source.indexOf("x=") > -1 && source.indexOf("y=") > -1;
    }

    /**
     * Parse '(x=2, y=6, w=47, h=45)' formatted string to Rectangle
     * @param source
     * @return Rectangle
     *
     */
    public static function rectangleFromString(source:String):Rectangle {
        var result:Rectangle = new Rectangle();
        if (isRectangleString(source)) {
            var trimmedStr:String = source.substr(1, source.length - 2);
            var tempArray:Array = trimmedStr.split(", ");
            result.x = String(tempArray[0]).split("=")[1];
            result.y = String(tempArray[1]).split("=")[1];
            result.width = String(tempArray[2]).split("=")[1];
            result.height = String(tempArray[3]).split("=")[1];
        }
        return result;
    }

    /**
     * Validates whether the input is a serializable Rectangle string
     * @return Boolean
     */
    public static function isRectangleString(source:String):Boolean {
        return source.indexOf("(") > -1 && source.indexOf(")") > -1 && source.indexOf("x=") > -1 && source.indexOf("y=") > -1 && source.indexOf("w=") > -1 && source.indexOf("h=") > -1;
    }

    /**
     * TBD
     */
    public static function parseRectangleList(source:Array):Vector.<Rectangle> {
        var result:Vector.<Rectangle> = new <Rectangle>[];
        var n:uint = source.length;
        for (var i:uint = 0; i < n; i++) {
            result.push(SerializerUtil.rectangleFromString(source[i]));
        }
        return result;
    }

    /**
     * TBD
     */
    public static function parsePointList(source:Array):Vector.<Point> {
        var result:Vector.<Point> = new <Point>[];
        var n:uint = source.length;
        for (var i:uint = 0; i < n; i++) {
            result.push(SerializerUtil.pointFromString(source[i]));
        }
        return result;
    }


}
}