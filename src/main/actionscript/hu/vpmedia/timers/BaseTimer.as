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
import flash.events.EventDispatcher;
import flash.utils.getTimer;

/**
 * TBD
 */
public class BaseTimer extends EventDispatcher implements IBaseTimer {
    /**
     * TBD
     */
    protected var _currentCount:int;
    /**
     * TBD
     */
    protected var _delay:Number;
    /**
     * TBD
     */
    protected var _startTime:int;
    /**
     * TBD
     */
    protected var _lastTime:int;
    /**
     * TBD
     */
    protected var _deltaTime:int;
    /**
     * TBD
     */
    protected var _repeatCount:int;
    /**
     * TBD
     */
    protected var _running:Boolean;
    /**
     * TBD
     */
    protected var _paused:Boolean;

    /**
     * TBD
     */
    public function BaseTimer(delay:Number, repeatCount:int = 0) {
        _running = false;
        _repeatCount = repeatCount;
        _delay = delay;
    }

    // PROPERTIES
    /**
     * TBD
     */
    public function get currentCount():int {
        return _currentCount;
    }

    /**
     * TBD
     */
    public function get delay():Number {
        return _delay;
    }

    /**
     * TBD
     */
    public function get deltaTime():int {
        return _deltaTime;
    }

    /**
     * TBD
     */
    public function get startTime():int {
        return _startTime;
    }

    /**
     * TBD
     */
    public function get repeatCount():int {
        return _repeatCount;
    }

    /**
     * TBD
     */
    public function get running():Boolean {
        return _running;
    }

    /**
     * TBD
     */
    public function get paused():Boolean {
        return _paused;
    }

    /**
     * TBD
     */
    public function pause():void {
        _paused = _running ? !_paused : _running;
    }

    /**
     * TBD
     */
    public function reset():void {
        _currentCount = 0;
        _deltaTime = 0;
        _startTime = 0;
    }

    /**
     * TBD
     */
    public function start():void {
        _running = true;
    }

    /**
     * TBD
     */
    public function stop():void {
        _running = false;
    }

    /**
     * TBD
     */
    protected function calculateDeltaTime():void {
        var _currentTime:int = getTimer();
        _deltaTime = _currentTime - _lastTime;
        _lastTime = _currentTime;
    }

    /**
     * TBD
     */
    override public function toString():String {
        return "[BaseTimer]" + " deltaTime:" + _deltaTime + ", currentCount:" + _currentCount + ", repeatCount:" + _repeatCount + ", delay:" + _delay + ", running:" + _running;
    }
}
}
