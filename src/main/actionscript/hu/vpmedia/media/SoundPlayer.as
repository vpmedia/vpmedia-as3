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
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

/**
 * SoundPlayer is a sound playback helper object.
 *
 * @see flash.media.Sound
 */
public final class SoundPlayer {
    //----------------------------------
    //  Properties
    //----------------------------------
    /**
     * TBD
     */
    public var name:String;

    /**
     * TBD
     */
    public var sound:Sound;

    /**
     * TBD
     */
    public var lastPosition:int;

    /**
     * TBD
     */
    public var channel:SoundChannel;

    /**
     * TBD
     */
    public var state:int;

    /**
     * TBD
     */
    public var volume:Number;

    /**
     * TBD
     */
    public var isMuted:Boolean;

    //----------------------------------
    //  Consts
    //----------------------------------

    /**
     * TBD
     */
    public static const STATE_PLAYING:int = 0x01;

    /**
     * TBD
     */
    public static const STATE_PAUSED:int = 0x02;

    /**
     * TBD
     */
    public static const STATE_STOPPED:int = 0x03;

    /**
     * TBD
     */
    public static const STATE_DISPOSED:int = 0x04;

    /**
     * Constructor
     */
    public function SoundPlayer(sound:Sound, volume:Number = 1) {
        this.sound = sound;
        this.volume = volume;
        initialize();
    }

    private function initialize():void {
        channel = new SoundChannel();
        lastPosition = 0;
        state = STATE_STOPPED;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Plays the sound object
     *
     * @param startTime TBD
     * @param loops TBD
     *
     * @return The length of the sound object in seconds.
     */
    public function play(startTime:Number = 0, loops:int = 0):Number {
        if (!sound) {
            return 0;
        } else if (isPlaying()) {
            return sound.length / 1000;
        }
        if (isPaused()) {
            startTime = lastPosition;
        }
        state = STATE_PLAYING;
        var soundTransform:SoundTransform = new SoundTransform(isMuted ? 0 : volume);
        channel = sound.play(startTime, loops, soundTransform);
        if (channel)
            channel.addEventListener(Event.SOUND_COMPLETE, onChannelChange, false, 0, true);
        else
            return 0;
        return sound.length / 1000;
    }

    /**
     * Pauses the sound.
     */
    public function pause():void {
        if (isPaused()) {
            return;
        }
        state = STATE_PAUSED;
        if (channel) {
            lastPosition = channel.position;
            channel.stop();
            channel.removeEventListener(Event.SOUND_COMPLETE, onChannelChange);
        }
    }

    /**
     * Stops the sound and resets position to 0.
     */
    public function stop():void {
        if (isStopped()) {
            return;
        }
        state = STATE_STOPPED;
        lastPosition = 0;
        if (channel) {
            channel.stop();
            channel.removeEventListener(Event.SOUND_COMPLETE, onChannelChange);
        }
    }

    //----------------------------------
    //  API : Info
    //----------------------------------

    /**
     * TBD
     */
    public function getPlayPercent():Number {
        if (!channel) {
            return 0;
        }
        return (channel.position / sound.length) * 100;
    }

    /**
     * TBD
     */
    public function getLength():Number {
        return sound.length;
    }

    /**
     * TBD
     */
    public function getPosition():Number {
        return channel.position;
    }

    //----------------------------------
    //  API : States
    //----------------------------------

    /**
     * TBD
     */
    public function isPlaying():Boolean {
        return state == STATE_PLAYING;
    }

    /**
     * TBD
     */
    public function isPaused():Boolean {
        return state == STATE_PAUSED;
    }

    /**
     * TBD
     */
    public function isStopped():Boolean {
        return state == STATE_STOPPED;
    }

    /**
     * TBD
     */
    public function isDisposed():Boolean {
        return state == STATE_DISPOSED;
    }


    //----------------------------------
    //  API : Lifecycle
    //----------------------------------

    /**
     * TBD
     */
    public function dispose():void {
        if (isDisposed()) {
            return;
        }

        state = STATE_DISPOSED;

        channel.removeEventListener(Event.SOUND_COMPLETE, onChannelChange);

        if (sound && sound.bytesLoaded < sound.bytesTotal) {
            try {
                sound.close();
            }
            catch (error:Error) {
                // IOError - The stream could not be closed, or the stream was not open.
                trace(error);
            }
        }
        if (channel) {
            channel.stop();
        }
        sound = null;
        channel = null;
    }

    //----------------------------------
    //  API : Volume
    //----------------------------------

    /**
     * TBD
     */
    public function getVolume():Number {
        var result:Number = volume;
        if (channel) {
            result = channel.soundTransform.volume;
        }
        return result;
    }

    /**
     * TBD
     */
    public function setVolume(value:Number):void {
        if (value > 0)
            volume = value;

        isMuted = (value <= 0);
        var soundTransform:SoundTransform = channel.soundTransform;
        soundTransform.volume = value;
        channel.soundTransform = soundTransform;
    }

    /**
     * TBD
     */
    public function mute():void {
        if (!isMuted) {
            setVolume(0);
        }
        else {
            setVolume(volume);
        }
    }


    //----------------------------------
    //  Event Handlers
    //----------------------------------

    /**
     * TBD
     */
    private function onChannelChange(event:Event):void {
        if (event.type == Event.SOUND_COMPLETE) {
            stop();
        }
    }
}
}
