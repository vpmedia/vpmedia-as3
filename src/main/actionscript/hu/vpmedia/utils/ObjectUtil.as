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
import flash.display.Shape;
import flash.events.Event;
import flash.utils.describeType;

import hu.vpmedia.errors.StaticClassError;

import hu.vpmedia.framework.IBaseDisposable;

import org.osflash.signals.ISignal;

/**
 * Contains reusable methods for Object manipulation.
 *
 * @see Object
 */
public final class ObjectUtil {

    //----------------------------------
    //  Private properties
    //----------------------------------

    /**
     * @private
     */
    private static const DISPATCHER:Shape = new Shape();

    /**
     * @private
     */
    public function ObjectUtil():void {
        throw new StaticClassError();
    }


    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * Will call the method after one frame
     *
     * @param method
     * @param args
     */
    public static function nextFrameCall(method:Function, ...args):void {
        var newMethod:Function = function (event:Event):void {
            //trace(arguments.callee, event.target);
            DISPATCHER.removeEventListener(Event.ENTER_FRAME, arguments.callee);
            method.apply(null, args);
            newMethod = null;
        };
        DISPATCHER.addEventListener(Event.ENTER_FRAME, newMethod);
    }

    /**
     * TBD
     */
    public static function call(context:*, methodName:String, ...args):* {
        var method:Function = context[methodName];
        var returnValue:* = method.apply(context, args);
        method = null;
        return returnValue;
    }

    /**
     * Will copy property values from source object to target object.
     *
     * @param source
     * @param target
     */
    public static function copyProperties(source:Object, target:Object):void {
        if (source && target) {
            for (var key:String in source) {
                if (target.hasOwnProperty(key)) {
                    try {
                        target[key] = source[key];
                    } catch (error:Error) {
                        //trace(error);
                    }
                }
            }
        }
    }

    /**
     * Will null the given target object values.
     *
     * @param target
     */
    public static function dispose(target:Object):void {
        // dispose only if needed
        if (target == null)
            return;
        // get public variable map
        var description:XML = describeType(target);
        var numPropertyDisposed:uint = 0;
        for each(var v:XML in description.variable) {
            const p:String = String(v.@name);
            if (target[p] != null && target[p] is ISignal) {
                //trace("REMOVING SIGNAL", target, p, target[p]);
                ISignal(target[p]).removeAll();
            }
            if (target[p] != null && target[p] is IBaseDisposable) {
                //trace("REMOVING DISPOSABLE", target, p, target[p]);
                IBaseDisposable(target[p]).dispose();
            }
            target[p] = null;
            numPropertyDisposed++;
            //trace("DISPOSING", target, p, target[p]);
        }
        //if(!numPropertyDisposed) {
        // TODO: null as object
        //}
    }


    /**
     * Will copy property values from source object to target object.
     *
     * @param source
     */
    public static function toString(source:Object):String {
        if (source) {
            var xml:XML = describeType(source);
            var key:String;
            var values:Vector.<String> = new <String>[];
            // variables
            for each(var v:XML in xml.variable) {
                key = String(v.@name);
                values.push(key + "=" + source[key]);
            }
            // getters
            var list:XMLList = xml..accessor.( attribute("access") == "readwrite" || attribute("access") == "readonly")
            for each(var item:XML in list) {
                key = item.attribute("name").toString();
                values.push(key + "=" + source[key]);
            }
            return xml.attribute("name").toString().split("::")[1] + "[ " + values.join(", ") + " ]";
        }
        return "null";
    }

    /**
     * Trace Object
     *
     * @param obj
     * @param level
     */
    public static function deepTrace(obj:*, level:int = 0):void {
        if (!obj)
            return;
        var tabs:String = "";
        for (var i:int = 0; i < level; i++, tabs += "\t");

        for (var prop:String in obj) {
            trace(tabs + "[" + prop + "] -> " + obj[ prop ]);
            deepTrace(obj[ prop ], level + 1);
        }
    }


}
}
