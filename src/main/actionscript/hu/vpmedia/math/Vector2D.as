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
package hu.vpmedia.math {
import flash.geom.Matrix;

/**
 * 2D vector class
 */
public class Vector2D {
    /**
     * @private
     */
    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    /**
     * @private
     */
    private var _x:Number;

    /**
     * @private
     */
    private var _y:Number;

    /**
     * Constructor
     */
    public function Vector2D(x:Number = 0, y:Number = 0) {
        _x = x;
        _y = y;
    }

    /**
     * Creates an exact copy of this Vector2D
     * @return Vector2D A copy of this Vector2D
     */
    public function clone():Vector2D {
        return new Vector2D(_x, _y);
    }

    /**
     * @private
     */
    public function copy():Vector2D {
        return clone();
    }

    /**
     *  Transforms Vector2D based on the given Matrix
     * @param matrix The matrix to use to transform this vector.
     * @return Vector2D returns a new, transformed Vector2D.
     */
    public function transform(matrix:Matrix):Vector2D {
        var v:Vector2D = clone();
        v.x = _x * matrix.a + _y * matrix.c + matrix.tx;
        v.y = _x * matrix.b + _y * matrix.d + matrix.ty;
        return v;
    }

    /**
     * Makes x and y zero.
     * @return Vector2D This vector.
     */
    public function zero():Vector2D {
        _x = 0;
        _y = 0;
        return this;
    }

    /**
     * Is this vector zeroed?
     * @return Boolean Returns true if zeroed, else returns false.
     */
    public function isZero():Boolean {
        return _x == 0 && _y == 0;
    }

    /**
     * Is the vector's length = 1?
     * @return Boolean If length is 1, true, else false.
     */
    public function isNormalized():Boolean {
        return length == 1.0;
    }

    /**
     * Does this vector have the same location as another?
     * @param vector2 The vector to test.
     * @return Boolean True if equal, false if not.
     */
    public function equals(vector2:Vector2D):Boolean {
        return _x == vector2.x && _y == vector2.y;
    }

    /**
     * Sets the length which will change x and y, but not the angle.
     */
    public function set length(value:Number):void {
        var _angle:Number = angle;
        _x = Math.cos(_angle) * value;
        _y = Math.sin(_angle) * value;
        if (Math.abs(_x) < 0.00000001)
            _x = 0;
        if (Math.abs(_y) < 0.00000001)
            _y = 0;
    }

    /**
     * Returns the length of the vector.
     **/
    public function get length():Number {
        return Math.sqrt(lengthSquared);
    }

    /**
     * Returns the length of this vector, before square root. Allows for a faster check.
     */
    public function get lengthSquared():Number {
        return _x * _x + _y * _y;
    }

    /**
     * Changes the angle of the vector. X and Y will change, length stays the same.
     */
    public function set angle(value:Number):void {
        var len:Number = length;
        _x = Math.cos(value) * len;
        _y = Math.sin(value) * len;
    }

    /**
     * Get the angle of this vector (radians).
     **/
    public function get angle():Number {
        return Math.atan2(_y, _x);
    }

    /**
     * Get the rotation of this vector (degrees).
     **/
    public function get rotation():Number {
        return angle * RAD_TO_DEG;
    }

    /**
     * Sets the vector's length to 1.
     * @return Vector2D This vector.
     */
    public function normalize():Vector2D {
        if (length == 0) {
            _x = 1;
            return this;
        }
        var len:Number = length;
        _x /= len;
        _y /= len;
        return this;
    }

    /**
     * Sets the vector's length to len.
     * @param len The length to set it to.
     * @return Vector2D This vector.
     */
    public function normalcate(len:Number):Vector2D {
        length = len;
        return this;
    }

    /**
     * Sets the length under the given value. Nothing is done if the vector is already shorter.
     * @param max The max length this vector can be.
     * @return Vector2D This vector.
     */
    public function truncate(max:Number):Vector2D {
        length = Math.min(max, length);
        return this;
    }

    /**
     * Makes the vector face the opposite way.
     * @return Vector2D This vector.
     */
    public function reverse():Vector2D {
        _x = -_x;
        _y = -_y;
        return this;
    }

    /**
     * Calculate the dot product of this vector and another.
     * @param vector2 Another vector2D.
     * @return Number The dot product.
     */
    public function dotProduct(vector2:Vector2D):Number {
        return _x * vector2.x + _y * vector2.y;
    }

    /**
     * Calculate the cross product of this and another vector.
     * @param vector2 Another Vector2D.
     * @return Number The cross product.
     */
    public function crossProd(vector2:Vector2D):Number {
        return _x * vector2.y - _y * vector2.x;
    }

    /**
     * Calculate angle between any two vectors.
     * @param vector1 First vector2d.
     * @param vector2 Second vector2d.
     * @return Number Angle between vectors.
     */
    public static function angleBetween(vector1:Vector2D, vector2:Vector2D):Number {
        if (!vector1.isNormalized())
            vector1 = vector1.clone().normalize();
        if (!vector2.isNormalized())
            vector2 = vector2.clone().normalize();
        return Math.acos(vector1.dotProduct(vector2));
    }

    /**
     * Is the vector to the right or left of this one?
     * @param vector2 The vector to test.
     * @return Boolean If left, returns true, if right, false.
     */
    public function sign(vector2:Vector2D):int {
        return perpendicular.dotProduct(vector2) < 0 ? -1 : 1;
    }

    /**
     * Get the vector that is perpendicular.
     * @return Vector2D The perpendicular vector.
     */
    public function get perpendicular():Vector2D {
        return new Vector2D(-y, x);
    }

    /**
     * Calculate between two vectors.
     * @param vector2 The vector to find distance.
     * @return Number The distance.
     */
    public function distance(vector2:Vector2D):Number {
        return Math.sqrt(distSQ(vector2));
    }

    /**
     * Calculate squared distance between vectors. Faster than distance.
     * @param vector2 The other vector.
     * @return Number The squared distance between the vectors.
     */
    public function distSQ(vector2:Vector2D):Number {
        var dx:Number = vector2.x - x;
        var dy:Number = vector2.y - y;
        return dx * dx + dy * dy;
    }

    /**
     * Add a vector to this vector.
     * @param vector2 The vector to add to this one.
     * @return Vector2D This vector.
     */
    public function add(vector2:Vector2D):Vector2D {
        _x += vector2.x;
        _y += vector2.y
        return this;
    }

    /**
     * Subtract a vector from this one.
     * @param vector2 The vector to subtract.
     * @return Vector2D This vector.
     */
    public function subtract(vector2:Vector2D):Vector2D {
        _x -= vector2.x;
        _y -= vector2.y
        return this;
    }

    /**
     * Mutiplies this vector by another one.
     * @param scalar The scalar to multiply by.
     * @return Vector2D This vector, multiplied.
     */
    public function multiply(scalar:Number):Vector2D {
        _x *= scalar;
        _y *= scalar;
        return this;
    }

    /**
     * Divide this vector by a scalar.
     * @param scalar The scalar to divide by.
     * @return Vector2D This vector.
     */
    public function divide(scalar:Number):Vector2D {
        _x /= scalar;
        _y /= scalar;
        return this;
    }

    /**
     * Set and get y component.
     */
    public function set y(value:Number):void {
        _y = value;
    }

    /**
     * @private
     */
    public function get y():Number {
        return _y;
    }

    /**
     * Set and get x component.
     */
    public function set x(value:Number):void {
        _x = value;
    }

    /**
     * @private
     */
    public function get x():Number {
        return _x;
    }

    /**
     * Turn this vector into a string.
     * @return String This vector in string form.
     */
    public function toString():String {
        return "[Vector2D"
                + " x=" + _x
                + " y=" + _y
                + "]";
    }
}
}
