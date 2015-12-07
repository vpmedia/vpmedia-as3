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
import flash.media.Camera;
import flash.media.Microphone;

/**
 * TBD
 */
public class AVDevice {
    private var _cameraDevice:CameraDevice;
    private var _microphoneDevice:MicrophoneDevice;

    public function AVDevice(cameraConfig:CameraDeviceVars = null, microphoneConfig:MicrophoneDeviceVars = null) {
        _cameraDevice = new CameraDevice(cameraConfig);
        _microphoneDevice = new MicrophoneDevice(microphoneConfig);
    }

    public function initialize():void {
        _cameraDevice.initialize();
        _microphoneDevice.initialize();
    }

    public function getCameraNames():Array {
        return _cameraDevice.getNames();
    }

    public function getCameraDevice():CameraDevice {
        return _cameraDevice;
    }

    public function getCamera():Camera {
        return _cameraDevice.getCamera();
    }

    public function getMicrophoneNames():Array {
        return _microphoneDevice.getNames();
    }

    public function getMicrophoneDevice():MicrophoneDevice {
        return _microphoneDevice;
    }

    public function getMicrophone():Microphone {
        return _microphoneDevice.getMicrophone();
    }
}
}
