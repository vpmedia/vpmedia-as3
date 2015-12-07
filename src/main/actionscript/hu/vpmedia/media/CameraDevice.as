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
import flash.events.StatusEvent;
import flash.media.Camera;

/**
 * TBD
 */
public class CameraDevice {
    public static const CAMERA_MUTED:String = "Camera.Muted";
    public static const CAMERA_UNMUTED:String = "Camera.Unmuted";
    private var _camera:Camera;
    private var _config:CameraDeviceVars;
    private var _available:Boolean;

    public function CameraDevice(vars:CameraDeviceVars = null) {
        if (!vars) {
            vars = new CameraDeviceVars();
        }
        _config = vars;
    }

    public function initialize():void {
        var newIndex:int = -1;
        if (_config.defaultName) {
            newIndex = getIndexByName(_config.defaultName);
        }
        if (_config.defaultIndex > -1 && _config.defaultIndex < getNumDevices()) {
            newIndex = _config.defaultIndex;
        }
        _camera = Camera.getCamera(String(newIndex));
        trace(this, "initialize", newIndex, _camera);
        if (_camera) {
            update();
            _camera.addEventListener(StatusEvent.STATUS, eventHandler, false, 0, true);
        }
    }

    public function update():void {
        _camera.setQuality(_config.bandwidth, _config.quality);
        _camera.setMode(_config.width, _config.height, _config.fps, false);
        _camera.setKeyFrameInterval(_config.kfi);
        _camera.setMotionLevel(_config.motionLevel, _config.motionTimeout);
        _camera.setLoopback(_config.isLoopback);
    }

    private function eventHandler(event:StatusEvent):void {
        trace(this, event.code);
        _available = (event.code == CAMERA_UNMUTED);
    }

    public function dispose():void {
        _camera = null;
    }

    public function getIndexByName(value:String):int {
        return Camera.names.indexOf(value);
    }

    public function getNameByIndex(value:int):String {
        return Camera.names[value];
    }

    public function getCamera():Camera {
        return _camera;
    }

    public function getName():String {
        return _camera.name;
    }

    public function getIndex():int {
        return _camera.index;
    }

    public function isMuted():Boolean {
        return _camera.muted;
    }

    public function isAvailable():Boolean {
        return _camera && !_camera.muted && _available;
    }

    public function getNumDevices():uint {
        return Camera.names.length;
    }

    public function isSupported():Boolean {
        return Camera.isSupported;
    }

    public function getNames():Array {
        return Camera.names;
    }

    public function getConfig():CameraDeviceVars {
        return _config;
    }
}
}
