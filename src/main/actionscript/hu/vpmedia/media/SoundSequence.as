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
package hu.vpmedia.media {
import flash.events.TimerEvent;
import flash.utils.getTimer;

import hu.vpmedia.timers.PauseTimer;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * TBD
 */
public class SoundSequence {
    // base sound controller
    public var soundManager:SoundService;

    // array list

    public var sequenceQueue:Array;

    // timing

    public var timer:PauseTimer;

    public var totalTime:Number;

    public var startTime:Number;

    // signals
    public var changed:ISignal;

    public var completed:ISignal;

    public var isDisposed:Boolean;

    public function SoundSequence(...args) {
        // signals
        completed = new Signal();
        changed = new Signal(Object);
        //
        if (args.length) {
            var newArgs:Array = args as Array;
            sequenceQueue = newArgs;
            resetTotalTime();
        }
        else {
            sequenceQueue = [];
        }
    }

    public function get sequenceLength():int {
        return totalTime;
    }

    public function get currentTime():int {
        var result:int = 0;

        if (startTime) {
            result = getTimer() - startTime;

            if (result > totalTime) {
                result = totalTime;
            }
        }

        return result;
    }

    public function dispose():void {
        trace(this, "dispose");

        changed.removeAll();
        completed.removeAll();
        changed = null;
        completed = null;
        isDisposed = true;
    }

    /**
     * an array that contains strings (SoundService ids) and numbers (delay in milliseconds)
     * @param    psequenceQueue
     * @return
     */
    public function sequenceFromArray(psequenceQueue:Array):int {
        sequenceQueue = psequenceQueue;

        resetTotalTime();
        return totalTime;
    }

    /**
     * SoundService ids
     * @param    p_soundId
     * @return
     */
    public function addSound(p_soundId:String):int {
        sequenceQueue.push(p_soundId);
        resetTotalTime();
        return totalTime;
    }

    /**
     * time in milliseconds
     * @param    p_delay
     * @return
     */
    public function addDelay(p_delay:uint):int {
        sequenceQueue.push(p_delay);
        resetTotalTime();
        return totalTime;
    }

    /**
     * call this when you are ready for the sequence to play
     * @return
     */
    public function playSequence():Number {
        totalTime = 0;

        resetTotalTime();

        startTime = getTimer();

        handleNextItemInSequence(sequenceQueue);

        return totalTime;
    }

    /**
     * this will stop and clear out this sequence, prepping it for garbage collection.
     * @return
     */
    public function stopSequence():void {
        if (sequenceQueue.length) {
            var currentItem:Object = sequenceQueue[0];

            if (currentItem is String) {
                soundManager.stop(currentItem as String);
            }

            if (timer.running) {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, sequenceTimerComplete);
            }

            sequenceQueue = [];
        }
    }

    public function pauseSequence():void {
        if (sequenceQueue.length) {
            var currentItem:Object = sequenceQueue[0];

            if (currentItem is String) {
                soundManager.pause(currentItem as String);
            }

            if (timer.running) {
                timer.pause();
            }
        }
    }

    public function resumeSequence():void {
        if (sequenceQueue.length && timer.paused) {
            var currentItem:Object = sequenceQueue[0];

            if (currentItem is String) {
                soundManager.play(currentItem as String);
            }

            timer.resume();
        }
    }

    private function handleNextItemInSequence(p_sequence:Array):void {
        if (isDisposed) {
            return;
        }
        if (!p_sequence.length) {
            completed.dispatch();
        }
        else {
            var currentItem:Object = sequenceQueue[0];

            changed.dispatch(currentItem);

            if (currentItem is Number) {
                timer = new PauseTimer(uint(currentItem), 1);
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, sequenceTimerComplete);
                timer.start();
            }
            else if (currentItem is String) {

                timer = new PauseTimer(soundManager.getDuration(currentItem as String), 1);

                timer.addEventListener(TimerEvent.TIMER_COMPLETE, sequenceTimerComplete);
                timer.start();
                soundManager.play(currentItem as String);

            }
        }

    }

    private function sequenceTimerComplete(e:TimerEvent):void {
        e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, sequenceTimerComplete);

        var currentItem:Object = sequenceQueue.shift();

        handleNextItemInSequence(sequenceQueue);
    }

    private function resetTotalTime():void {
        totalTime = 0;
        var i:int;
        for (i = 0; i < sequenceQueue.length; i++) {
            if (sequenceQueue[i] is Number) {
                totalTime += uint(sequenceQueue[i]);
            }
            else if (sequenceQueue[i] is String) {
                totalTime += soundManager.getDuration(sequenceQueue[i] as String);
            }
            //trace('total time inc: ' + totalTime);
        }
    }
}
}
