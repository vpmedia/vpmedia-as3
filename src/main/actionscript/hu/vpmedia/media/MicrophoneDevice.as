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
import flash.media.Microphone;

/**
 * TBD
 */
public class MicrophoneDevice {
    public static const MICROPHONE_MUTED:String = "Microphone.Muted";
    public static const MICROPHONE_UNMUTED:String = "Microphone.Unmuted";
    private var _microphone:Microphone;
    private var _config:MicrophoneDeviceVars;
    private var _available:Boolean;

    public function MicrophoneDevice(vars:MicrophoneDeviceVars = null) {
        if (!vars) {
            vars = new MicrophoneDeviceVars();
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
        _microphone = Microphone.getMicrophone(newIndex);
        trace(this, "initialize", newIndex, _microphone);
        if (_microphone) {
            update();
            _microphone.addEventListener(StatusEvent.STATUS, eventHandler, false, 0, true);
        }
    }

    public function update():void {
        _microphone.gain = _config.gain;
        _microphone.rate = _config.rate;
        _microphone.setSilenceLevel(_config.silenceLevel);
        _microphone.setUseEchoSuppression(_config.useEchoSupression);
        _microphone.setLoopBack(_config.isLoopback);
        _microphone.noiseSuppressionLevel = _config.noiseSuppressionLevel;
    }

    private function eventHandler(event:StatusEvent):void {
        trace(this, event.code);
        _available = event.code == MICROPHONE_UNMUTED;
    }

    public function dispose():void {
        _microphone = null;
    }

    public function getIndexByName(value:String):int {
        return Microphone.names.indexOf(value);
    }

    public function getNameByIndex(value:int):String {
        return Microphone.names[value];
    }

    public function getMicrophone():Microphone {
        return _microphone;
    }

    public function getName():String {
        return _microphone.name;
    }

    public function getIndex():int {
        return _microphone.index;
    }

    public function isMuted():Boolean {
        return _microphone.muted;
    }

    public function isAvailable():Boolean {
        return _microphone && !_microphone.muted && _available;
    }

    public function getNumDevices():uint {
        return Microphone.names.length;
    }

    public function isSupported():Boolean {
        return Microphone.isSupported;
    }

    public function getNames():Array {
        return Microphone.names;
    }

    public function getConfig():MicrophoneDeviceVars {
        return _config;
    }
}
}
