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
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Contains reusable methods for Math and Physics calculations.
 *
 * @see Number
 */
public class MathUtil {

    //--------------------------------------
    //  Geom Units
    //--------------------------------------

    public static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    public static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    private static const RAD_AREA:Number = Math.PI * 2;

    private static const DEG_AREA:Number = 360;

    //--------------------------------------------------------------------------
    //
    //  Math Helpers
    //
    //--------------------------------------------------------------------------

    /**
     * Convert <code>Number</code> to an <code>int</code>. 10% faster than letting Flash handle it automatically.
     */
    public static function toInt(value:Number):int {
        return int(value);
    }

    /**
     * Flip sign of an integer, 300% faster than <code>i = -i</code>.
     */
    public static function flip(value:int):int {
        return (value ^ -1) + 1;
    }

    /**
     * Modulo operation. 600% faster than <code>a % b</code>.
     *
     * @param a Dividend
     * @param b Divisor
     */
    public static function mod(a:int, n:int):int {
        return a & (n - 1);
    }

    /**
     * Absolute value. 3000% faster than <code>Math.abs()</code>.
     */
    public static function abs(value:int):int {
        //return value < 0 ? -value : value; // 2500% faster than Math.abs()
        return (value ^ (value >> 31)) - (value >> 31); // 20% faster than the above
    }

    /*public static function abs(value:Number):Number
     {
     return value < 0 ? -value : value;
     }*/

    /**
     * Compare to integers for equal sign. 35% faster than <code>(a * b) > 0</code>.
     */
    public static function equalSign(a:int, b:int):Boolean {
        return (a ^ b) >= 0;
    }

    /**
     * Get sign of an integer.
     *
     * @return 1 or -1 depending on integer's sign.
     */
    public static function getSign(value:int):int {
        return value < 0 ? -1 : 1;
    }

    /**
     * Faster max function.
     */
    public static function max(val1:Number, val2:Number):Number {
        if ((!(val1 <= 0) && !(val1 > 0)) || (!(val2 <= 0) && !(val2 > 0))) {
            return NaN;
        }
        return val1 > val2 ? val1 : val2;
    }

    /**
     * Faster min function.
     */
    public static function min(val1:Number, val2:Number):Number {
        if ((!(val1 <= 0) && !(val1 > 0)) || (!(val2 <= 0) && !(val2 > 0))) {
            return NaN;
        }
        return val1 < val2 ? val1 : val2;
    }

    /**
     * Faster ceil function.
     */
    public static function ceil(val:Number):Number {
        return (!(val <= 0) && !(val > 0)) ? NaN : val == int(val) ? val : val >= 0 ? int(val + 1) : int(val);
    }

    /*public static function ceil(value:Number):Number
     {
     return (value % 1) ? int(value) + 1 : value;
     }*/

    /**
     * Faster floor function.
     */
    public static function floor(val:Number):Number {
        return (!(val <= 0) && !(val > 0)) ? NaN : val == int(val) ? val : val < 0 ? int(val - 1) : int(val);
    }

    /**
     * tests a number against a range and if out of range, locks to the closest extreme
     * @param value test value
     * @param min
     * @param max
     * @return
     */
    public static function clamp(val:Number, min:Number, max:Number):Number {
        return Math.max(Math.min(val, max), min);
    }

    /**
     * TBD
     */
    public static function abs_bitwise(value:Number):Number {
        //http://lab.polygonal.de/2007/05/10/bitwise-gems-fast-integer-math/
        return (value ^ (value >> 31)) - (value >> 31);
    }

    /**
     * TBD
     */
    public static function round(value:Number, digits:int):Number {
        digits = Math.pow(10, digits);
        return Math.round(value * digits) / digits;
    }

    /**
     * TBD
     */
    public static function roundDecimalToPlace(value:Number, place:uint):Number {
        const p:Number = Math.pow(10, place);
        return Math.round(value * p) / p;
    }

    /**
     * TBD
     */
    public static function getWeightedAverage(value:Number, dest:Number, n:Number):Number {
        return value + (dest - value) / n;
    }

    /**
     * TBD
     */
    public static function isEqual(val1:Number, val2:Number, precision:Number = 0):Boolean {
        return Math.abs(val1 - val2) <= Math.abs(precision);
    }

    /**
     * TBD
     */
    public static function isInteger(value:Number):Boolean {
        return (value % 1) == 0;
    }

    /**
     * returns whether or not a is equal to be within a specified tolerance
     * @param a
     * @param b
     * @param tolerance
     * @return
     */
    public static function nearEquals(a:Number, b:Number, tolerance:Number = .1):Boolean {
        return Math.abs(a - b) < tolerance;
    }

    /**
     * returns a value between the current and target based on the easing value
     * @param current
     * @param target
     * @param easeAmount
     * @return
     */
    public static function ease(current:Number, target:Number, easeAmount:Number):Number {
        return current + (target - current) * easeAmount;
    }

    /**
     * Check if an integer is even. 600% faster than <code>(i % 2) == 0</code>.
     */
    public static function isEven(value:int):Boolean {
        return (value % 2 == 0);
    }

    /**
     * TBD
     */
    public static function isOdd(value:Number):Boolean {
        return !isEven(value);
    }

    /**
     * TBD
     */
    public static function isPositive(value:Number):Boolean {
        return Boolean(value >= 0);
    }

    /**
     * TBD
     */
    public static function isNegative(value:Number):Boolean {
        return !isPositive(value);
    }

    /**
     * TBD
     */
    public static function isBetween(value:Number, firstValue:Number, secondValue:Number):Boolean {
        return !(value < Math.min(firstValue, secondValue) || value > Math.max(firstValue, secondValue));
    }

    /**
     * TBD
     */
    public static function getLength(a:int, b:int):int {
        const min:int = Math.min(a, b);
        const max:int = Math.max(a, b);
        return max - min;
    }

    //--------------------------------------------------------------------------
    //
    //  Geom Helpers
    //
    //--------------------------------------------------------------------------

    /**
     * TBD
     */
    public static function normalizeDegrees(value:Number):Number {
        return (DEG_AREA + value % DEG_AREA) % DEG_AREA;
    }

    /**
     * TBD
     */
    public static function normalizeRadians(value:Number):Number {
        return (RAD_AREA + value % RAD_AREA) % RAD_AREA;
    }

    /**
     * TBD
     */
    public static function radiansToDegrees(value:Number):Number {
        return value * RAD_TO_DEG;
    }

    /**
     * TBD
     */
    public static function degreesToRadians(value:Number):Number {
        return value * DEG_TO_RAD;
    }

    //origin means original starting radian, dest destination radian around a circle
    /**
     * Determines which direction a point should rotate to match rotation the quickest
     * @param objectRotationRadians The object you would like to rotate
     * @param radianBetween the angle from the object to the point you want to rotate to
     * @return -1 if left, 0 if facing, 1 if right
     *
     */
    public static function getSmallestRotationDirection(objectRotationRadians:Number, radianBetween:Number, errorRadians:Number = 0):int {
        objectRotationRadians = simplifyRadian(objectRotationRadians);
        radianBetween = simplifyRadian(radianBetween);
        radianBetween += -objectRotationRadians;
        radianBetween = simplifyRadian(radianBetween);
        objectRotationRadians = 0;
        if (radianBetween < -errorRadians) {
            return -1;
        }
        else if (radianBetween > errorRadians) {
            return 1;
        }
        return 0;
    }

    /**
     * TBD
     */
    public static function simplifyRadian(radian:Number):Number {
        if (radian > Math.PI || radian < -Math.PI) {
            var newRadian:Number;
            newRadian = radian - int(radian / RAD_AREA) * RAD_AREA;
            if (radian > 0) {
                if (newRadian < Math.PI) {
                    return newRadian;
                }
                else {
                    newRadian = -(RAD_AREA - newRadian);
                    return newRadian;
                }
            }
            else {
                if (newRadian > -Math.PI) {
                    return newRadian;
                }
                else {
                    newRadian = (RAD_AREA + newRadian);
                    return newRadian;
                }
            }
        }
        return radian;
    }

    /**
     * TBD
     */
    public static function getHypotonuse(side1:Number, side2:Number):Number {
        return getDistance(new Point(0, 0), new Point(side1, side2));
    }

    /**
     * TBD
     */
    public static function getDistance(fromPoint:Point, toPoint:Point):Number {
        const difX:Number = (toPoint.x - fromPoint.x);
        const difY:Number = (toPoint.y - fromPoint.y);
        return Math.sqrt((difX * difX) + (difY * difY));
    }

    /**
     * TBD
     */
    public static function projectPoint(distance:Number, angle:Number, fromPoint:Point = null):Point {
        return new Point(projectX(distance, angle, fromPoint ? fromPoint.x : 0), projectY(distance, angle, fromPoint ? fromPoint.y : 0));
    }

    /**
     * TBD
     */
    public static function projectX(distance:Number, angle:Number, fromX:Number):Number {
        return (distance * Math.cos((angle - 90) * DEG_TO_RAD)) + fromX;
    }

    /**
     * TBD
     */
    public static function projectY(distance:Number, angle:Number, fromY:Number):Number {
        return (distance * Math.sin((angle - 90) * DEG_TO_RAD)) + fromY;
    }

    /**
     * TBD
     */
    public static function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
        var dx:Number = x2 - x1;
        var dy:Number = y2 - y1;
        return Math.atan2(dy, dx);
    }

    /**
     * TBD
     */
    public static function intersectRects(a:Rectangle, b:Rectangle):Boolean {
        return !(a.x > b.x + (b.width - 1) || a.x + (a.width - 1) < b.x || a.y > b.y + (b.height - 1) || a.y + (a.height - 1) < b.y);
    }

}
}
