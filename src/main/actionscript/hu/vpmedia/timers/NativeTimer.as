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
public class NativeTimer extends BaseTimer {
    /**
     * TBD
     */
    protected var _dispatcher:Timer;

    /**
     * TBD
     */
    public function NativeTimer(delay:Number, repeatCount:int = 0) {
        super(delay, repeatCount);
        _dispatcher = new Timer(delay, repeatCount);
    }

    /**
     * TBD
     */
    override public function reset():void {
        _dispatcher.reset();
        _dispatcher.removeEventListener(TimerEvent.TIMER, timerHandler);
        _dispatcher.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
        super.reset();
    }

    /**
     * TBD
     */
    override public function start():void {
        _lastTime = getTimer();
        _startTime = _lastTime;
        _dispatcher.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
        _dispatcher.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler, false, 0, true);
        _dispatcher.start();
    }

    /**
     * TBD
     */
    override public function stop():void {
        _dispatcher.stop();
        _dispatcher.removeEventListener(TimerEvent.TIMER, timerHandler);
        _dispatcher.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
    }

    /**
     * TBD
     */
    override public function get currentCount():int {
        return _dispatcher.currentCount;
    }

    /**
     * TBD
     */
    override public function get repeatCount():int {
        return _dispatcher.repeatCount;
    }

    /**
     * TBD
     */
    override public function get running():Boolean {
        return _dispatcher.running;
    }

    /**
     * TBD
     */
    protected function timerHandler(event:TimerEvent):void {
        calculateDeltaTime();
        dispatchEvent(event);
    }

    /**
     * TBD
     */
    override public function toString():String {
        return "[NativeTimer]" + " deltaTime:" + _deltaTime + ", currentCount:" + _dispatcher.currentCount + ", repeatCount:" + _dispatcher.repeatCount + ", delay:" + _delay + ", running:" + _dispatcher.running;
    }
}
}
