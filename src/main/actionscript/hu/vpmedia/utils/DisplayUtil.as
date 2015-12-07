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
//--------------------------------------
//  Imports
//--------------------------------------

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.utils.getDefinitionByName;

import hu.vpmedia.errors.StaticClassError;

//--------------------------------------
// Class Definition(s)
//--------------------------------------

/**
 * TBD
 */
public final class DisplayUtil {
    //--------------------------------------
    //  Constructor
    //--------------------------------------

    public function DisplayUtil():void {
        throw new StaticClassError();
    }

    //--------------------------------------------------------------------------
    //
    //  Display Object Utils
    //
    //--------------------------------------------------------------------------

    /**
     * TBD
     */
    public static function getDisplayObjectInstance(skin:Object, loaderInfo:LoaderInfo):DisplayObject {
        var ClassDef:Object = null;
        if (skin is Class) {
            return (new skin()) as DisplayObject;
        }
        else if (skin is DisplayObject) {
            (skin as DisplayObject).x = 0;
            (skin as DisplayObject).y = 0;
            return skin as DisplayObject;
        }
        try {
            ClassDef = getDefinitionByName(skin.toString());
        }
        catch (e:Error) {
            trace(e);
            try {
                ClassDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
            }
            catch (e:Error) {
                trace(e);
                // Nothing
            }
        }
        if (ClassDef == null) {
            return null;
        }
        return (new ClassDef()) as DisplayObject;
    }

    //--------------------------------------------------------------------------
    //
    //  Display Container Utils
    //
    //--------------------------------------------------------------------------

    /**
     * Traverses up the display object hierarchy until parent = null.
     */
    public static function getRoot(o:DisplayObject):DisplayObject {
        while (o.parent) {
            o = o.parent;
        }
        return o;
    }

    /**
     * Like DisplayObject::getObjectsUnderPoint, but will also check parents of found objects, filters by class, can
     * exclude objects to be found, and can stop collecting at a maximum amount.
     */
    public static function getObjectsUnderPointByClass(o:DisplayObjectContainer, p:Point, c:Class, max:int = 0, exclude:Array = null, noAncestors:Boolean = true):Array {
        // According to Adobe's documentation I should be able to call getObjectsUnderPoint directly on "o", but it doesn't seem to work
        // in certain cases?
        var objs:Array = o.stage.getObjectsUnderPoint(p);
        var found:Array = [];
        if (!exclude)
            exclude = [];
        for (var i:int = objs.length - 1; i >= 0; i--) {
            var obj:DisplayObject = objs[i];
            var f:Boolean = false;
            while (obj) {
                if (exclude.indexOf(obj) == -1) {
                    if (obj is c) {
                        found.push(obj);
                        f = true && noAncestors;
                        if (max > 0 && found.length == max) {
                            return found;
                        }
                        exclude.push(obj);
                    }
                }
                obj = f ? null : obj.parent;
            }
        }
        return found;
    }


    /**
     * TBD
     */
    public static function getChildByFullName(root:DisplayObjectContainer, value:String, separator:String = "."):DisplayObject {
        var result:DisplayObject = root;
        var nameArray:Array = value.split(separator);
        var n:uint = nameArray.length;
        var namePointer:uint = 0;
        while (namePointer < n) {
            if (result is DisplayObjectContainer) {
                result = DisplayObjectContainer(result).getChildByName(nameArray[namePointer]);
            }
            else {
                return null;
            }
            namePointer++;
        }
        return result;
    }

    /**
     * TBD
     */
    public static function findChild(dispobj:DisplayObjectContainer, childname:String):DisplayObject {
        if (dispobj == null) {
            return null;
        }

        for (var j:int = 0; j < dispobj.numChildren; ++j) {
            var obj:DisplayObject = dispobj.getChildAt(j) as DisplayObject;
            if (obj.name == childname) {
                return obj;
            }
            if (obj is DisplayObjectContainer) {
                var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
                if (doc.numChildren > 0) {
                    var ret:DisplayObject = findChild(doc, childname);
                    if (ret != null) {
                        return ret;
                    }
                }
            }
        }
        return null;
    }

    /**
     * TBD
     */
    public static function swapChildren(child1:DisplayObject, child2:DisplayObject):void {
        var parent1:DisplayObjectContainer = child1.parent;
        var parent2:DisplayObjectContainer = child2.parent;
        var index1:int = parent1.getChildIndex(child1);
        var index2:int = parent2.getChildIndex(child2);
        moveChild(child1, parent2, index2);
        moveChild(child2, parent1, index1);
    }

    /**
     * TBD
     */
    public static function removeChildren(container:DisplayObjectContainer):void {
        while (container.numChildren > 0) {
            container.removeChildAt(0);
        }
    }

    /**
     * TBD
     */
    public static function removeFromParent(child:DisplayObject):void {
        if (child.parent != null && child.parent.contains(child)) {
            child.parent.removeChild(child);
        }
    }

    /**
     * TBD
     */
    public static function moveChild(child:DisplayObject, container:DisplayObjectContainer, index:int = -1):void {
        // remove child from old parent:
        child.parent.removeChild(child);
        // add child to new parent:
        if (index == -1) {
            child = container.addChild(child);
        }
        else {
            child = container.addChildAt(child, index);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Display Resize Utils
    //
    //--------------------------------------------------------------------------

    /**
     * TBD
     */
    public static function resizeDisplayObject(target:DisplayObject, maxWidth:Number, maxHeight:Number, allowStretching:Boolean = true):void {
        var displayObject:DisplayObject = (target is Loader) ? (target as Loader).content : target;
        displayObject.scaleX = displayObject.scaleY = 1;
        var originalRect:Rectangle = new Rectangle(0, 0, displayObject.width, displayObject.height);
        //trace("resize() Image Rect = "+originalRect);
        var resizedRect:Rectangle = resizeRectangle(originalRect, new Rectangle(0, 0, maxWidth, maxHeight), allowStretching);
        //trace("resize() New Size = "+resizedRect);
        displayObject.width = resizedRect.width;
        displayObject.scaleY = displayObject.scaleX;
    }

    /**
     * TBD
     */
    public static function resizeRectangle(original:Rectangle, bounds:Rectangle, allowStretching:Boolean = false):Rectangle {
        var size:Rectangle = original.clone();
        var aspectRatio:Number = original.width / original.height;
        // first we size based on width
        // check for max width, resize if necessary
        if (allowStretching || size.width > bounds.width) {
            size.width = bounds.width;
            size.height = size.width / aspectRatio;
        }
        // after size by width, check height
        // make it even smaller if necessary
        if (size.height > bounds.height) {
            size.height = bounds.height;
            size.width = size.height * aspectRatio;
        }
        return size;
    }

    //--------------------------------------------------------------------------
    //
    //  Display Geom Utils
    //
    //--------------------------------------------------------------------------

    /**
     * TBD
     */
    public static function localToLocal(point:Point, child1:DisplayObject, child2:DisplayObject):Point {
        point = child1.localToGlobal(point);
        return child2.globalToLocal(point);
    }

    /**
     * TBD
     */
    public static function getBounds(o:DisplayObject, stroke:Boolean = false):Rectangle {
        return stroke ? o.getBounds(o) : o.getRect(o);
    }

    /**
     * Returns a matrix that reflects what "from"'s transform looks like from the perspective of "to".
     */
    public static function localizeMatrix(to:DisplayObject, from:DisplayObject):Matrix {
        var m:Matrix = from.transform.concatenatedMatrix;
        var m2:Matrix = to.transform.concatenatedMatrix;
        m2.invert();
        m.concat(m2);
        if (from.cacheAsBitmap || to.cacheAsBitmap) {
            var p:Point = localizePoint(to, from);
            m.tx = p.x;
            m.ty = p.y;
        }
        return m;
    }

    /**
     * Takes a point in "from" and finds the cooresponding point in "to".
     */
    public static function localizePoint(to:DisplayObject, from:DisplayObject, p:Point = null):Point {
        return to.globalToLocal(from.localToGlobal(p ? p : new Point(0, 0)));
    }

    /**
     * Gets the rotation of "from" relative to "to".
     */
    public static function localizeRotation(to:DisplayObject, from:DisplayObject, r:Number = 0):Number {
        return r + globalRotation(from) - globalRotation(to);
    }

    /**
     * Returns the rotation of the object in global coordinate space.
     */
    public static function globalRotation(o:DisplayObject):Number {
        var r:Number = o.rotation;
        while (o = o.parent) {
            r += o.rotation;
        }
        return r;
    }

    //--------------------------------------------------------------------------
    //
    //  Display Debug Utils
    //
    //--------------------------------------------------------------------------

    /**
     * TBD
     */
    public static function deepTrace(obj:DisplayObjectContainer, level:int = 0):void {
        //trace("DebugUtil::deepTrace", obj, obj.name)
        var tabs:String = "";
        var i:int;
        var n:int = level;
        for (i = 0; i < n; i++) {
            tabs += "\t";
        }

        // get numchildren
        n = obj.numChildren;

        // trace
        trace(tabs + obj + " : " + obj.name + " : " + obj.x + "," + obj.y);

        // get child texts
        for (i = 0; i < n; i++) {
            if (obj.getChildAt(i) is TextField) {
                trace(tabs + "\t" + obj.getChildAt(i) + " : " + obj.getChildAt(i).name);
            }
        }

        // get child mcs
        for (i = 0; i < n; i++) {
            if (obj.getChildAt(i) is DisplayObjectContainer) {
                deepTrace(obj.getChildAt(i) as DisplayObjectContainer, level + 1);
            }
        }
    }

}
}
