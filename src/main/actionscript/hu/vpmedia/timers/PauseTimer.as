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
package hu.vpmedia.timers {
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

/**
 * TBD
 */
public class PauseTimer extends Timer {
    private var _lastTime:Number;
    private var _thisTime:Number = 0;

    private var _normalTimerDelay:Number;
    private var _setToNormalDelay:Boolean;

    private var _paused:Boolean = false;

    /**
     * Constructs a new Timer object with the specified delay
     * and repeatCount states with the option to pause and resume.
     *
     * The timer does not start automatically; you must call the start() method to start it.
     * @param    delay    The delay between timer events, in milliseconds.
     * @param    repeatCount    Specifies the number of repetitions.
     *             If zero, the timer repeats infinitely.
     *             If nonzero, the timer runs the specified number of times and then stops.
     */
    public function PauseTimer(delay:Number, repeatCount:int = 0) {
        _normalTimerDelay = delay;
        super(delay, repeatCount);
        super.addEventListener(TimerEvent.TIMER, onTimerInterval, false, 0, true);

    }

    /**
     * Need to check if the delay was changed due to a pause state, it
     * will need to be reset to the userset timer delay.
     */
    private function onTimerInterval(e:TimerEvent):void {
        if (_setToNormalDelay) {
            super.delay = _normalTimerDelay;
            _setToNormalDelay = false;
        }
        _lastTime = getTimer();
    }

    /// Starts the timer, if it is not already running. If paused will just call resume.
    override public function start():void {
        if (_paused) {
            resume();
        }
        else {
            _lastTime = getTimer();
            super.start();
        }
    }

    // need to note keep track of the user set dealy

    override public function get delay():Number {
        return super.delay;
    }

    override public function set delay(value:Number):void {
        _lastTime = getTimer();
        super.delay = value;
        _normalTimerDelay = value;
    }

    // for seeing if this timer is paused.
    public function get paused():Boolean {
        return _paused;
    }

    /**
     * will pause the timer, with out reseting the current delay tick
     */
    public function pause():void {
        _paused = true;

        super.stop();
        _thisTime = getTimer() - _lastTime;
    }

    /**
     * will continue the timers delay tick from where it was paused.
     */
    public function resume():void {
        _paused = false;

        if (_thisTime > super.delay) {
            _thisTime = super.delay;
        }

        super.delay = super.delay - _thisTime;
        _lastTime = getTimer();
        _setToNormalDelay = true;
        super.start();

        _thisTime = 0;
    }
}

}