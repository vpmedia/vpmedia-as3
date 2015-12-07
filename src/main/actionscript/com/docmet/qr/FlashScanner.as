/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013 Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package com.docmet.qr {

import com.logosware.qr.IQRDetector;
import com.logosware.qr.QRDecoder;
import com.logosware.qr.QRDetector;
import com.logosware.qr.QRImage;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.media.Camera;
import flash.media.Video;
import flash.utils.Timer;
import flash.utils.getTimer;

import hu.vpmedia.media.CameraFactory;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

public class FlashScanner extends Sprite {

    private var detector:IQRDetector;

    private var reader:QRImage;

    private var decoder:QRDecoder;

    private var camera:Camera;

    private var video:Video;

    private var timer:Timer;

    private var isSingleScan:Boolean;

    private var cameraLocation:String;

    public var recognized:ISignal = new Signal(String);

    public var launched:Boolean;

    public function FlashScanner(isSingleScan:Boolean, cameraLocation:String = "back"):void {
        this.isSingleScan = isSingleScan;
        this.cameraLocation = cameraLocation;
        addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
    }

    private function onAdded(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
        camera = CameraFactory.getCameraByPosition(cameraLocation);
        if (camera) {
            camera.setMode(320, 240, 24);
            video = new Video(camera.width, camera.height);
            video.attachCamera(camera);
            var holder:Sprite = new Sprite();
            addChild(holder);
            holder.addChild(video);
            holder.width = stage.stageWidth;
            holder.scaleY = holder.scaleX;
            holder.x = (stage.fullScreenWidth * 0.5) - (holder.width * 0.5);
            holder.y = (stage.fullScreenHeight * 0.5) - (holder.height * 0.5);
            detector = new QRDetector(video);
            reader = new QRImage();
            decoder = new QRDecoder();
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER, onCameraActivity, false, 0, true);
            timer.start();
            launched = true;
        } else {
            //"Error: Camera not found");
        }
    }

    public function pause(isPause:Boolean):void {
        if (isPause) {
            timer.reset();
            timer.stop();
            video.attachCamera(null);
            video.clear();
        }
        else {
            video.attachCamera(camera);
            timer.start();
        }
        video.visible = !isPause;
    }

    private function onRemoved(event:Event):void {
        if (timer) {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER, onCameraActivity);
            timer = null;
        }
        if (video) {
            video.attachCamera(null);
            video = null;
        }
        if (camera) {
            camera = null;
        }
    }

    private function onCameraActivity(event:Event):void {
        const readerResult:Array = reader.process(detector.detect());
        if (readerResult) {
            const decodeStart:int = getTimer();
            decoder.setQR(readerResult);
            const decodeResult:String = decoder.startDecode();
            if (decodeResult) {
                //var decodedDataNew:String = event.data;
                //var compare:int = decodedDataNew.localeCompare(qrDecodedDataOld);
                recognized.dispatch(decodeResult);
                timer.reset();
                timer.start();
            }
        }
    }
}
}