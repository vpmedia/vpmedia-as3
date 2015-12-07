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
//--------------------------------------
//  Imports
//--------------------------------------

import flash.display.DisplayObjectContainer;
import flash.display.Shape;

import hu.vpmedia.errors.StaticClassError;

//--------------------------------------
// Class Definition(s)
//--------------------------------------

/**
 * TBD
 */
public final class ShapeUtil {
    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * @private
     */
    public function ShapeUtil():void {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static function createRectangleShape(target:DisplayObjectContainer, x:Number, y:Number, w:int, h:int, color:uint, alpha:Number = 1):Shape {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(color, alpha);
        shape.graphics.drawRect(0, 0, w, h);
        shape.graphics.endFill();
        shape.x = x;
        shape.y = y;
        if(target)
            target.addChild(shape);
        return shape;
    }

    /**
     * TBD
     */
    public static function createRoundedRectangleShape(target:DisplayObjectContainer, x:Number, y:Number, w:int, h:int, color:uint, alpha:Number = 1, radius:Number = 0):Shape {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(color, alpha);
        shape.graphics.drawRoundRect(0, 0, w, h, radius);
        shape.graphics.endFill();
        shape.x = x;
        shape.y = y;
        target.addChild(shape);
        return shape;
    }

    /**
     * TBD
     */
    public static function createEllipseShape(target:DisplayObjectContainer, x:Number, y:Number, w:int, h:int, color:uint, alpha:Number = 1):Shape {
        var shape:Shape = new Shape();
        shape.graphics.beginFill(color, alpha);
        shape.graphics.drawEllipse(0, 0, w, h);
        shape.graphics.endFill();
        shape.x = x;
        shape.y = y;
        if(target)
            target.addChild(shape);
        return shape;
    }
}
}
