/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2014 Andras Csizmadia
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
package hu.vpmedia.media {
import flash.display.Sprite;
import flash.events.NetStatusEvent;
import flash.geom.Rectangle;
import flash.media.StageVideo;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;

import hu.vpmedia.net.utils.NetStreamStatus;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * VideoPlayer
 */
public class VideoPlayer extends Sprite {

    /**
     * @private
     */
    private var nc:NetConnection;

    /**
     * @private
     */
    private var ns:NetStream;

    /**
     * @private
     */
    private var videoWidth:uint;

    /**
     * @private
     */
    private var videoHeight:uint;

    /**
     * @private
     */
    private var isStageVideo:Boolean;

    /**
     * @private
     */
    private var video:Video;

    /**
     * @private
     */
    private var stageVideo:StageVideo;

    /**
     * Dispatched when the video failed or completed the playback
     */
    public var completed:ISignal = new Signal();

    /**
     * Constructor
     */
    public function VideoPlayer(videoWidth:uint = 800, videoHeight:uint = 600, isStageVideo:Boolean = false) {
        this.videoWidth = videoWidth;
        this.videoHeight = videoHeight;
        this.isStageVideo = isStageVideo;
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        //trace(this, "initialize");
        // nc
        nc = new NetConnection();
        nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus, false, 0, true);
        nc.connect(null);
        nc.client = this;
        // ns
        ns = new NetStream(nc);
        ns.client = this;
        ns.addEventListener(NetStatusEvent.NET_STATUS, onStreamStatus, false, 0, true);
        // video
        if (isStageVideo) {
            stageVideo = new StageVideo();
            stageVideo.viewPort = new Rectangle(0, 0, videoWidth, videoHeight);
            stageVideo.attachNetStream(ns);
        } else {
            video = new Video();
            video.width = videoWidth;
            video.height = videoHeight;
            video.attachNetStream(ns);
            video.smoothing = true;
            addChild(video);
        }
    }

    /**
     * @private
     */
    public function play(url:String):void {
        //trace(this, "play", url);
        video.visible = true;
        ns.play(url);
    }

    /**
     * TBD
     */
    public function stop():void {
        //trace(this, "stop");
        video.visible = false;
        ns.play(null);
    }

    /**
     * TBD
     */
    public function dispose():void {
        //trace(this, "dispose");
        try {
            video.parent.removeChild(video);
            nc.close();
            ns.close();
        } catch (error:Error) {
            trace(error);
        }
        nc = null;
        ns = null;
        video = null;
    }

    /**
     * @private
     */
    private function onStreamStatus(event:NetStatusEvent):void {
        trace("onStreamStatus", event.info.code);
        switch (event.info.code) {
            case NetStreamStatus.NETSTREAM_PLAY_STOP:
            case NetStreamStatus.NETSTREAM_PLAY_FAILED:
            case NetStreamStatus.NETSTREAM_PLAY_STREAMNOTFOUND:
                completed.dispatch();
                break;
        }
    }

    /**
     * @private
     */
    private function onConnectionStatus(event:NetStatusEvent):void {
        //trace("onConnectionStatus", event.info.code);
    }

    /**
     * @private
     */
    public function onMetaData(value:Object):void {
        trace("onMetaData", value);
    }

    /**
     * @private
     */
    public function onCuePoint(value:Object):void {
        trace("onCuePoint", value);
    }

    /**
     * @private
     */
    public function close():void {
        trace("close");
    }
}
}
