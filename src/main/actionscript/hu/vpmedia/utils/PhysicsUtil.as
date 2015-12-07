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
/**
 * Contains reusable methods for Physics calculations.
 */
public class PhysicsUtil {

    //--------------------------------------
    //  Physics Units
    //--------------------------------------

    /**
     * TBD
     */
    public static const SECONDS_PER_HOUR:Number = 3600.0;

    /**
     * TBD
     */
    public static const SECONDS_PER_MINUTE:Number = 60.0

    /**
     * TBD
     */
    public static const WATTS_TO_HORSEPOWER:Number = 745.699;

    /**
     * TBD
     */
    public static const RADIANS_PER_REVOLUTION:Number = 2 * Math.PI;

    /**
     * TBD
     */
    public static const MILES_PER_METER:Number = 0.000621371192;

    /**
     * TBD
     */
    public static const PIXELS_TO_METER:Number = 30;

    /**
     * TBD
     */
    public static const TO_DEG:Number = 180.0 / Math.PI;

    /**
     * TBD
     */
    public static const TO_RAD:Number = Math.PI / 180.0;

    //--------------------------------------------------------------------------
    //
    //  Physics Simulations
    //
    //--------------------------------------------------------------------------

    /**
     * TBD
     */
    public static function metersPerSecond_to_pixelsPerFrame(velocity:Number, pixelsPerMeter:Number, timeStep:Number):Number {
        return velocity * pixelsPerMeter * timeStep;
    }

    /**
     * TBD
     */
    public static function pixelsPerFrame_to_metersPerSecond(velocity:Number, pixelsPerMeter:Number, timeStep:Number):Number {
        return velocity / pixelsPerMeter / timeStep;
    }

    /**
     * TBD
     */
    public static function metersPerSecond_to_milesPerHour(velocity:Number):Number {
        return velocity * SECONDS_PER_HOUR * MILES_PER_METER;
    }

    /**
     * TBD
     */
    public static function milesPerHour_to_metersPerSecond(velocity:Number):Number {
        return velocity / SECONDS_PER_HOUR / MILES_PER_METER;
    }

    /**
     * TBD
     */
    public static function radsPerSec_to_RPM(radsPerSec:Number):Number {
        return radsPerSec * SECONDS_PER_MINUTE / RADIANS_PER_REVOLUTION;
    }

    /**
     * TBD
     */
    public static function RPM_to_radsPerSec(rpm:Number):Number {
        return rpm / SECONDS_PER_MINUTE * RADIANS_PER_REVOLUTION;
    }
}
}
