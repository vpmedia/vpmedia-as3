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
public class Percent {

    /**
     * TBD
     */
    protected var _percent:Number;

    /**
     * TBD
     */
    public function Percent(percentage:Number = 0, isDecimalPercentage:Boolean = true) {
        super();
        if (isDecimalPercentage) {
            this.decimalPercentage = percentage;
        }
        else {
            this.percentage = percentage;
        }
    }

    /**
     * TBD
     */
    public function get percentage():Number {
        return 100 * this._percent;
    }

    /**
     * TBD
     */
    public function set percentage(percent:Number):void {
        this._percent = percent * .01;
    }

    /**
     * TBD
     */
    public function get decimalPercentage():Number {
        return this._percent;
    }

    /**
     * TBD
     */
    public function set decimalPercentage(percent:Number):void {
        this._percent = percent;
    }

    /**
     * TBD
     */
    public function equals(percent:Percent):Boolean {
        return this.decimalPercentage == percent.decimalPercentage;
    }

    /**
     * TBD
     */
    public function clone():Percent {
        return new Percent(this.decimalPercentage);
    }

    /**
     * TBD
     */
    public function valueOf():Number {
        return this.decimalPercentage;
    }

    /**
     * TBD
     */
    public function toString():String {
        return this.decimalPercentage.toString();
    }
}
}
