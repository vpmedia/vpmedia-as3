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

package hu.vpmedia.blitting {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.media.Sound;

import hu.vpmedia.framework.IBaseSteppable;

/**
 * TBD
 */
public class BlitClip implements IBaseSteppable {
    /**
     * TBD
     */
    public var canvas:BitmapData;

    /**
     * @private
     */
    private var _spriteSheet:BitmapData;

    /**
     * @private
     */
    private var _areas:Vector.<BlitArea>;

    /**
     * @private
     */
    private var _defaultFrameDuration:Number;

    /**
     * @private
     */
    private var _totalTime:Number;

    /**
     * @private
     */
    private var _currentTime:Number;

    /**
     * @private
     */
    private var _currentFrame:int;

    /**
     * @private
     */
    private var _loop:Boolean;

    /**
     * @private
     */
    private var _playing:Boolean;

    /**
     * @private
     */
    private var _durations:Vector.<Number>;

    /**
     * @private
     */
    private var _sounds:Vector.<Sound>;

    /**
     * TBD
     */
    public var x:Number;

    /**
     * TBD
     */
    public var y:Number;

    /**
     * TBD
     */
    public var position:Point;

    /**
     * TBD
     */
    public var name:String;

    /**
     * TBD
     */
    public function BlitClip(canvas:BitmapData, atlas:BlitAtlas, prefix:String = "", fps:int = 30) {
        x = 0;
        y = 0;
        position = new Point();
        this.canvas = canvas;
        _spriteSheet = atlas.getBitmapData();
        _defaultFrameDuration = 1.0 / fps;
        _loop = true;
        _playing = true;
        _totalTime = 0.0;
        _currentTime = 0.0;
        _currentFrame = 0;
        _areas = new Vector.<BlitArea>;
        _durations = new Vector.<Number>;
        _sounds = new Vector.<Sound>;
        var areas:Vector.<BlitArea> = atlas.getAreas(prefix);
        for each (var area:BlitArea in areas)
            addFrame(area);
    }

    /**
     * TBD
     */
    public function addFrame(area:BlitArea, sound:Sound = null, duration:Number = -1):void {
        addFrameAt(numFrames, area, sound, duration);
    }

    /**
     * TBD
     */
    public function addFrameAt(index:int, area:BlitArea, sound:Sound = null, duration:Number = -1):void {
        //trace(this, "addFrameAt", index, area, sound, duration);

        if (index < 0 || index > numFrames)
            throw new ArgumentError("Invalid frame index");
        if (duration < 0)
            duration = _defaultFrameDuration;
        _areas.splice(index, 0, area);
        _sounds.splice(index, 0, sound);
        _durations.splice(index, 0, duration);
        _totalTime += duration;
    }

    /**
     * TBD
     */
    public function removeFrameAt(index:int):void {
        if (index < 0 || index >= numFrames)
            throw new ArgumentError("Invalid frame index");
        _totalTime -= getFrameDuration(index);
        _areas.splice(index, 1);
        _sounds.splice(index, 1);
        _durations.splice(index, 1);
    }

    /**
     * TBD
     */
    public function getFrameBlitArea(index:int):BlitArea {
        if (index < 0 || index >= numFrames)
            throw new ArgumentError("Invalid frame index");
        return _areas[index];
    }

    /**
     * TBD
     */
    public function setFrameBlitArea(index:int, area:BlitArea):void {
        if (index < 0 || index >= numFrames)
            throw new ArgumentError("Invalid frame index");
        _areas[index] = area;
    }

    /**
     * TBD
     */
    public function getFrameSound(index:int):Sound {
        if (index < 0 || index >= numFrames)
            throw new ArgumentError("Invalid frame index");
        return _sounds[index];
    }

    /**
     * TBD
     */
    public function setFrameSound(index:int, sound:Sound):void {
        if (index < 0 || index >= numFrames)
            throw new ArgumentError("Invalid frame index");
        _sounds[index] = sound;
    }

    /**
     * TBD
     */
    public function getFrameDuration(index:int):Number {
        if (index < 0 || index >= numFrames)
            throw new ArgumentError("Invalid frame index");
        return _durations[index];
    }

    /**
     * TBD
     */
    public function setFrameDuration(index:int, duration:Number):void {
        if (index < 0 || index >= numFrames)
            throw new ArgumentError("Invalid frame index");
        _totalTime -= getFrameDuration(index);
        _totalTime += duration;
        _durations[index] = duration;
    }

    /**
     * TBD
     */
    public function play():void {
        _playing = true;
    }

    /**
     * TBD
     */
    public function pause():void {
        _playing = false;
    }

    /**
     * TBD
     */
    public function stop():void {
        _playing = false;
        currentFrame = 0;
    }

    /**
     * TBD
     */
    public function step(passedTime:Number):void {
        if (_loop && _currentTime == _totalTime)
            _currentTime = 0.0;
        if (!_playing || passedTime == 0.0 || _currentTime == _totalTime)
            return;
        var i:int = 0;
        var durationSum:Number = 0.0;
        var previousTime:Number = _currentTime;
        var restTime:Number = _totalTime - _currentTime;
        var carryOverTime:Number = passedTime > restTime ? passedTime - restTime : 0.0;
        _currentTime = Math.min(_totalTime, _currentTime + passedTime);
        for each (var duration:Number in _durations) {
            if (durationSum + duration >= _currentTime) {
                //if (_currentFrame != i || numFrames == 1)
                //{
                _currentFrame = i;
                updateCurrentFrame();
                //playCurrentSound();
                //}
                break;
            }
            ++i;
            durationSum += duration;
        }
        /* if (previousTime < _totalTime && _currentTime == _totalTime)
         {
         completeSignal.dispatch();
         }  */
        step(carryOverTime);
    }

    private function updateCurrentFrame():void {
        //trace(canvas, position, _currentFrame, _areas[_currentFrame], _areas[_currentFrame].frame);
        position.x = x - _areas[_currentFrame].frame.x;
        position.y = y - _areas[_currentFrame].frame.y;
        canvas.copyPixels(_spriteSheet, _areas[_currentFrame].region, position, null, null, true);
    }

    private function playCurrentSound():void {
        var sound:Sound = _sounds[_currentFrame];
        if (sound)
            sound.play();
    }

    /**
     * TBD
     */
    public function get isComplete():Boolean {
        return false;
    }

    /**
     * TBD
     */
    public function get totalTime():Number {
        return _totalTime;
    }

    /**
     * TBD
     */
    public function get numFrames():int {
        return _areas.length;
    }

    /**
     * TBD
     */
    public function get loop():Boolean {
        return _loop;
    }

    /**
     * TBD
     */
    public function set loop(value:Boolean):void {
        _loop = value;
    }

    /**
     * TBD
     */
    public function get currentFrame():int {
        return _currentFrame;
    }

    /**
     * TBD
     */
    public function set currentFrame(value:int):void {
        _currentFrame = value;
        _currentFrame = 0.0;
        for (var i:int = 0; i < value; ++i) {
            _currentTime += getFrameDuration(i);
        }
        updateCurrentFrame();
    }

    /**
     * TBD
     */
    public function get fps():Number {
        return 1.0 / _defaultFrameDuration;
    }

    /**
     * TBD
     */
    public function set fps(value:Number):void {
        var newFrameDuration:Number = value == 0.0 ? Number.MAX_VALUE : 1.0 / value;
        var acceleration:Number = newFrameDuration / _defaultFrameDuration;
        _currentTime *= acceleration;
        _defaultFrameDuration = newFrameDuration;
        for (var i:int = 0; i < numFrames; ++i)
            setFrameDuration(i, getFrameDuration(i) * acceleration);
    }

    /**
     * TBD
     */
    public function get isPlaying():Boolean {
        if (_playing)
            return _loop || _currentTime < _totalTime;
        return false;
    }
}
}
