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
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.media.Camera;
import flash.media.Video;
import flash.net.NetStream;
import flash.utils.Timer;
import flash.utils.setTimeout;

[Event(name="Event.RENDER", type="flash.events.Event")]

/**
 * TBD
 */
public class BitmapVideo extends EventDispatcher {
    /**
     * @private
     */
    public var bitmapData:BitmapData;

    /**
     * @private
     */
    protected var _width:int;

    /**
     * @private
     */
    protected var _height:int;

    /**
     * @private
     */
    protected var _active:Boolean;

    /**
     * @private
     */
    protected var _video:Video;

    /**
     * @private
     */
    protected var _refreshRate:int;

    /**
     * @private
     */
    protected var _timer:Timer;

    /**
     * @private
     */
    protected var _paintMatrix:Matrix;

    /**
     * @private
     */
    protected var _smooth:Boolean;

    /**
     * @private
     */
    protected var _colorTransform:ColorTransform;

    /**
     * @private
     */
    protected var _colorMatrix:Array;

    /**
     * @private
     */
    protected var _colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();

    /**
     * @private
     */
    protected const origin:Point = new Point();

    /**
     * @private
     */
    protected var _camera:Camera;

    /**
     * @private
     */
    protected var _netStream:NetStream;

    /**
     * @private
     */
    protected const INIT_DELAY:int = 100;

    /**
     * @private
     */
    protected var _isMirror:Boolean;

    /**
     * @private
     */
    public function BitmapVideo(width:int, height:int, refreshRate:int = 15, mirror:Boolean = true) {
        _isMirror = mirror;

        _width = width;
        _height = height;
        _refreshRate = refreshRate;

        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        bitmapData = new BitmapData(_width, _height, false, 0);

        _timer = new Timer(1000 / _refreshRate);
        _timer.addEventListener(TimerEvent.TIMER, draw, false, 0, true);

        // sharpen video
        /*
         var filter = new flash.filters.ConvolutionFilter();
         filter.matrixX = 3;
         filter.matrixY = 3;
         filter.matrix = [-1, 0, -1, 0, 8, 0, -1, 0, -1];
         filter.bias =  0;
         filter.divisor = 4;
         _video.filters = [filter];
         */

        _paintMatrix = new Matrix(_width / _width, 0, 0, _height / _height, 0, 0);
        if (_isMirror) {
            _paintMatrix.scale(-1, 1);
            _paintMatrix.tx = _width;
        }
        _smooth = _paintMatrix.a != 1 || _paintMatrix.d != 1;
    }

    /**
     * TBD
     */
    public function close():void {
        active = false;
        if (_camera) {
            _video.attachCamera(null);
            _camera = null;
        }
        if (_netStream) {
            _video.attachNetStream(null);
            _netStream = null;
        }
        _video = null;
    }

    /**
     * TBD
     */
    public function attachCamera(camera:Camera):void {
        if (!camera) {
            close();
            return;
        }
        _camera = camera;
        setTimeout(attachSource, INIT_DELAY);
    }

    /**
     * @private
     */
    protected function attachSource():void {
        if (_camera) {
            _video = new Video(_camera.width, _camera.height);
            _video.attachCamera(_camera);
        }
        else if (_netStream) {
            _video = new Video(_width, _height);
            _video.attachNetStream(_netStream);
        }
    }

    /**
     * TBD
     */
    public function attachNetStream(netStream:NetStream):void {
        if (!netStream) {
            close();
            return;
        }
        _netStream = netStream;
        setTimeout(attachSource, INIT_DELAY);
    }

    /**
     * TBD
     */
    public function set active(value:Boolean):void {
        _active = value;

        if (_active) _timer.start() else _timer.stop();
    }

    /**
     * TBD
     */
    public function set refreshRate(value:int):void {
        _refreshRate = value;
        _timer.delay = 1000 / _refreshRate;
    }

    /**
     * TBD
     */
    public function set colorTransform(value:ColorTransform):void {
        _colorTransform = value;
    }

    /**
     * TBD
     */
    public function set colorMatrix(value:Array):void {
        _colorMatrixFilter.matrix = _colorMatrix = value;
    }

    /**
     * @private
     */
    protected function draw(event:TimerEvent = null):void {
        if (!_active) {
            return;
        }

        try {
            bitmapData.lock();
            bitmapData.draw(_video, _paintMatrix, _colorTransform, "normal", null, _smooth);
            if (_colorMatrix != null) {
                bitmapData.applyFilter(bitmapData, bitmapData.rect, origin, _colorMatrixFilter);
            }
            bitmapData.unlock();
        } catch (e:Error) {
        }

        dispatchEvent(new Event(Event.RENDER));
    }

}
}