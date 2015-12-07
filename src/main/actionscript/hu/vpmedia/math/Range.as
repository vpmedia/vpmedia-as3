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

/**
 * TBD
 */
public class Range {

    /**
     * TBD
     */
    protected var _end:Number;

    /**
     * TBD
     */
    protected var _start:Number;

    /**
     * TBD
     */
    public function Range(start:Number = 0, end:Number = 1) {
        super();
        this.setRange(start, end);
    }

    /**
     * TBD
     */
    public function setRange(start:Number, end:Number):void {
        this.start = start;
        this.end = end;
    }

    /**
     * TBD
     */
    public function get start():Number {
        return this._start;
    }

    /**
     * TBD
     */
    public function set start(value:Number):void {
        this._start = value;
    }

    /**
     * TBD
     */
    public function get end():Number {
        return this._end;
    }

    /**
     * TBD
     */
    public function set end(value:Number):void {
        this._end = value;
    }

    /**
     * TBD
     */
    public function get min():Number {
        return Math.min(this.start, this.end);
    }

    /**
     * TBD
     */
    public function get max():Number {
        return Math.max(this.start, this.end);
    }

    /**
     * TBD
     */
    public function isWithinRange(value:Number):Boolean {
        return (value <= this.max && value >= this.min);
    }

    /**
     * TBD
     */
    public function normalizeInRange(value:Number):Number {
        return Math.max(min, Math.min(max, value));
    }

    /**
     * TBD
     */
    public function getValueOfPercent(percent:Percent):Number {
        var min:Number;
        var max:Number;
        var val:Number;
        var per:Percent = percent.clone();
        if (this.start <= this.end) {
            min = this.start;
            max = this.end;
        }
        else {
            per.decimalPercentage = 1 - per.decimalPercentage;
            min = this.end;
            max = this.start;
        }
        val = Math.abs(max - min) * per.decimalPercentage + min;
        return val;
    }

    /**
     * TBD
     */
    public function getPercentOfValue(value:Number):Percent {
        return new Percent((value - this.min) / (this.max - this.min));
    }

    /**
     * TBD
     */
    public function equals(range:Range):Boolean {
        return this.start == range.start && this.end == range.end;
    }

    /**
     * TBD
     */
    public function overlaps(range:Range):Boolean {
        if (this.equals(range) || this.contains(range) || range.contains(Range(this)) || this.isWithinRange(range.start) || this.isWithinRange(range.end))
            return true;
        return false;
    }

    /**
     * TBD
     */
    public function contains(range:Range):Boolean {
        return this.start <= range.start && this.end >= range.end;
    }

    /**
     * TBD
     */
    public function clone():Range {
        return new Range(this.start, this.end);
    }
}
}
