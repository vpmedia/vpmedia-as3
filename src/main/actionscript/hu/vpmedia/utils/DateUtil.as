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
import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for Date manipulation
 *
 * @see Date
 */
public final class DateUtil {
    /**
     * TBD
     */
    public static const current:Date = new Date();

    /**
     * TBD
     */
    public function DateUtil():void {
        throw new StaticClassError();
    }

    /**
     * Parses string date to object
     * @param source The source string (example: 19700101T000000)
     */
    public static function parseCDate(source:String):Date {
        const yy:int = int(source.substr(0, 4));
        const mm:int = int(source.substr(4, 2)) - 1;
        const dd:int = int(source.substr(6, 2));
        const hh:int = int(source.substr(9, 2));
        const mn:int = int(source.substr(11, 2));
        const ss:int = int(source.substr(13, 2));
        const mss:int = 0;
        const result:Date = new Date(yy, mm, dd, hh, mn, ss, mss);
        return result;
    }

    /**
     * TBD
     */
    public static function timeCode(sec:Number):String {
        var h:Number = Math.floor(sec / 3600);
        var m:Number = Math.floor((sec % 3600) / 60);
        var s:Number = Math.floor((sec % 3600) % 60);
        return (h == 0 ? "" : (h < 10 ? "0" + String(h) + ":" : String(h) + ":")) + (m < 10 ? "0" + String(m) : String(m)) + ":" + (s < 10 ? "0" + String(s) : String(s));
    }

    /**
     * TBD
     */
    public static function timeCodeShort(sec:Number):String {
        var h:Number = Math.floor(sec / 3600);
        var m:Number = Math.floor((sec % 3600) / 60);
        return ((h < 10 ? "0" + String(h) + ":" : String(h) + ":")) + (m < 10 ? "0" + String(m) : String(m));
    }

    /**
     * TBD
     */
    public static function getUnixTimestamp():String {
        return String(Math.floor(new Date().time / 1000));
    }

    /**
     * TBD
     */
    public static function getDateByString(value:String):Date {
        var result:Date;
        var cDate:Date = new Date();
        var dateArray:Array;
        if (value && value.indexOf(" ") > -1 && value.indexOf("-") > -1 && value.indexOf(":") > -1) {
            // 2013-10-24 16:36:55
            var dateTimePair:Array = value.split(" ");
            dateArray = dateTimePair[0].split("-");
            var timeArray:Array = dateTimePair[1].split(":");
            result = new Date(int(dateArray[0]), int(dateArray[1]) - 1, int(dateArray[2]), int(timeArray[0]), int(timeArray[1]), int(timeArray[2]));
        } else if (value.indexOf("-") > -1) {
            // 2013-10-24
            dateArray = value.split("-");
            result = new Date(int(dateArray[0]), int(dateArray[1]) - 1, int(dateArray[2]), cDate.hours, cDate.minutes, cDate.seconds, cDate.milliseconds);
        } else if (value.indexOf(".") > -1) {
            // 2013.10.24.
            dateArray = value.split(".");
            result = new Date(int(dateArray[0]), int(dateArray[1]) - 1, int(dateArray[2]), cDate.hours, cDate.minutes, cDate.seconds, cDate.milliseconds);
        }
        if (!result)
            result = cDate;
        return result;
    }

    /**
     * TBD
     */
    public static function millisecondsToWallclock(milliseconds:Number):String {
        var result:Array = [];

        var seconds:int = millisecondsToSeconds(milliseconds);
        var minutes:int = millisecondsToMinutes(milliseconds);
        var hours:int = millisecondsToHours(milliseconds);

        seconds = seconds % 60;
        minutes = minutes % 60;

        if (hours != 0) {
            result.push(zeroPad(hours, 2));
        }

        result.push(zeroPad(minutes, 2));

        if (hours == 0) {
            result.push(zeroPad(seconds, 2));
        }


        return result.join(":");
    }

    /**
     * TBD
     */
    public static function zeroPad(number:int, length:int):String {
        var ret:String = "" + number.toString();
        while (ret.length < length) {
            ret = "0" + ret;
        }
        return ret;
    }

    /**
     * TBD
     */
    public static function millisecondsToHours(milliseconds:Number):int {
        return int(millisecondsToMinutes(milliseconds) / 60);
    }

    /**
     * TBD
     */
    public static function millisecondsToMinutes(milliseconds:Number):int {
        return int(millisecondsToSeconds(milliseconds) / 60);
    }

    /**
     * TBD
     */
    public static function millisecondsToSeconds(milliseconds:Number):int {
        return int(milliseconds / 1000);
    }

    /**
     * TBD
     */
    public static function smilTimeToMilliseconds(timeString:String):int {
        var milliseconds:int = 0;

        if (timeString == null || timeString == "") {
            milliseconds = -100;
        }
        // parse clock values
        else if (timeString.indexOf(":") != -1) {
            var split:Array = timeString.split(":");

            var hours:uint = 0;
            var minutes:uint = 0;
            var seconds:uint = 0;

            // half clock
            if (split.length < 3) {
                minutes = uint(split[0]);
                seconds = uint(split[1]);
            }
            // full wall clock
            else {
                hours = uint(split[0]);
                minutes = uint(split[1]);
                seconds = uint(split[2]);
            }

            milliseconds = ((hours * 60 * 60 * 1000) + (minutes * 60 * 1000) + (seconds * 1000));
        }
        else {
            // hours
            if (timeString.indexOf("h") != -1) {
                milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("h"))) * 60 * 60 * 1000;
            }
            // minutes
            else if (timeString.indexOf("min") != -1) {
                milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("min"))) * 60 * 1000;
            }
            // milliseconds value
            else if (timeString.indexOf("ms") != -1) {
                milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("ms")));
            }
            // seconds
            else if (timeString.indexOf("s") != -1) {
                milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("s"))) * 1000;
            }
            // minutes (similar to .at)
            else if (timeString.indexOf("m") != -1) {
                milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("m"))) * 60 * 1000;
            }
            // assume the time is declared in seconds
            else {
                milliseconds = parseFloat(timeString) * 1000;
            }
        }

        return milliseconds;
    }
}
}
