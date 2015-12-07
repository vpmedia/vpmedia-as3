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
import flash.display.Shape;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.getTimer;

/**
 * TBD
 */
public class EnterFrameTimer extends BaseTimer {
    /**
     * TBD
     */
    protected var _dispatcher:Shape; // To give us an ENTER_FRAME hook
    /**
     * TBD
     */
    protected var _event:TimerEvent = new TimerEvent(TimerEvent.TIMER);
    /**
     * TBD
     */
    protected var _completeEvent:TimerEvent = new TimerEvent(TimerEvent.TIMER_COMPLETE);
    /**
     * TBD
     */
    protected var _accuredTime:int;

    /**
     * TBD
     */
    public function EnterFrameTimer(delay:Number, repeatCount:int = 0) {
        super(delay, repeatCount);
        _dispatcher = new Shape();
    }

    /**
     * TBD
     */
    override public function reset():void {
        stop();
        _accuredTime = 0;
        super.reset();
    }

    /**
     * TBD
     */
    override public function start():void {
        _running = true;
        _lastTime = getTimer();
        _startTime = _lastTime;
        _dispatcher.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
    }

    /**
     * TBD
     */
    override public function stop():void {
        _running = false;
        _dispatcher.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    /**
     * TBD
     */
    protected function checkRepeatComplete():void {
        if (_repeatCount > 0 && _currentCount >= _repeatCount) {
            stop();
            dispatchEvent(_completeEvent);
        }
    }

    /**
     * TBD
     */
    protected function enterFrameHandler(event:Event):void {
        calculateDeltaTime();
        _accuredTime += _deltaTime;
        while (_accuredTime >= _delay) {
            _accuredTime -= _delay;
            _currentCount++;
            dispatchEvent(_event);
            checkRepeatComplete();
        }
    }
}
}
