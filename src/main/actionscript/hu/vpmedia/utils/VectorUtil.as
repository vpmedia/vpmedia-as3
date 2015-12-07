/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
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
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for Vector manipulation.
 */
public final class VectorUtil {

    //----------------------------------
    //  Constructor (private)
    //----------------------------------

    /**
     * @private
     */
    public function VectorUtil() {
        throw new StaticClassError();
    }

    /**
     * Dynamically instantiate a typed one dimensional Vector from function argument.
     *
     * @return Vector result
     */
    public static function create(type:String, length:uint = 0, fixed:Boolean = false):Vector.<*> {
        const className:String = getQualifiedClassName(type);
        if (!className)
            return null;
        const VectorClass:Class = Class(getDefinitionByName("Vector.<" + className + ">"));
        if (!VectorClass)
            return null;
        return new VectorClass(length, fixed);
    }

    /**
     * @private
     */
    private static function objectCloner(item:*, index:int, vector:Vector.<*>):* {
        return item.clone();
    }

    /**
     * Copy vector instance
     *
     * @return Vector result
     */
    public static function copy(source:Vector.<*>):Vector.<*> {
        return source.map(objectCloner);
    }

    /**
     * Will parse a 2D vector from a delimited string.
     *
     * @param source Delimited string source
     * @param delimA Delimiter 1
     * @param delimB Delimiter 2
     *
     * @return Vector result
     */
    public static function parse2DIntVector(source:String, delimA:String, delimB:String):Vector.<Vector.<int>> {
        const result:Vector.<Vector.<int>> = new <Vector.<int>>[];
        const a:Array = source.split(delimA);
        const n:uint = a.length;
        for (var i:uint = 0; i < n; i++) {
            result[i] = Vector.<int>(a[i].split(delimB));
        }
        return result;
    }

    /**
     * Will parse a 3D vector from a delimited string.
     *
     * @param source Delimited string source
     * @param delimA Delimiter 1
     * @param delimB Delimiter 2
     * @param delimC Delimiter 3
     *
     * @return Vector result
     */
    public static function parse3DIntVector(source:String, delimA:String, delimB:String, delimC:String):Vector.<Vector.<Vector.<int>>> {
        const result:Vector.<Vector.<Vector.<int>>> = new Vector.<Vector.<Vector.<int>>>();
        const a:Array = source.split(delimA);
        const n:uint = a.length;
        for (var i:uint = 0; i < n; i++) {
            result[i] = parse2DIntVector(a[i], delimB, delimC);
        }
        return result;
    }

    /**
     * Will parse a 4D vector from a delimited string.
     *
     * @param source Delimited string source
     * @param delimA Delimiter 1
     * @param delimB Delimiter 2
     * @param delimC Delimiter 3
     * @param delimD Delimiter 4
     *
     * @return Vector result
     */
    public static function parse4DIntVector(source:String, delimA:String, delimB:String, delimC:String, delimD:String):Vector.<Vector.<Vector.<Vector.<int>>>> {
        const result:Vector.<Vector.<Vector.<Vector.<int>>>> = new Vector.<Vector.<Vector.<Vector.<int>>>>();
        const a:Array = source.split(delimA);
        const n:uint = a.length;
        for (var i:uint = 0; i < n; i++) {
            result[i] = parse3DIntVector(a[i], delimB, delimC, delimD);
        }
        return result;
    }

    /**
     * Will parse a 5D vector from a delimited string.
     *
     * @param source Delimited string source
     * @param delimA Delimiter 1
     * @param delimB Delimiter 2
     * @param delimC Delimiter 3
     * @param delimD Delimiter 4
     * @param delimE Delimiter 5
     *
     * @return Vector result
     */
    public static function parse5DIntVector(source:String, delimA:String, delimB:String, delimC:String, delimD:String, delimE:String):Vector.<Vector.<Vector.<Vector.<Vector.<int>>>>> {
        const result:Vector.<Vector.<Vector.<Vector.<Vector.<int>>>>> = new Vector.<Vector.<Vector.<Vector.<Vector.<int>>>>>();
        const a:Array = source.split(delimA);
        const n:uint = a.length;
        for (var i:uint = 0; i < n; i++) {
            result[i] = parse4DIntVector(a[i], delimB, delimC, delimD, delimE);
        }
        return result;
    }
}
}
