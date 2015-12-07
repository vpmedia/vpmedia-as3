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
import flash.media.Sound;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.utils.Dictionary;

/**
 * SoundService class is a helper class managing sound playback control.
 */
public final class SoundService {
    /**
     * SoundPlayer data provider map.
     */
    private var _sounds:Dictionary;

    /**
     * Flag for muting the SoundService.
     */
    private var _isMuted:Boolean;

    /**
     * Creates a new SoundService object.
     */
    public function SoundService() {
        _sounds = new Dictionary(false);
    }

    //----------------------------------
    //  API : Core
    //----------------------------------

    /**
     * Adds a map of SoundPlayer object.
     *
     * @param value TBD
     */
    public function addDict(value:Dictionary):void {
        for (var key:String in value) {
            add(key, value[key]);
        }
    }

    /**
     * Adds a Sound as a SoundPlayer object.
     *
     * @param id The SoundPlayer object identifier
     * @param value The loaded Sound object
     * @param volume The default SoundPlayer volume
     */
    public function add(id:String, value:Sound, volume:Number = 1):void {
        if (!id || !value || exists(id)) {
            return;
        }
        const item:SoundPlayer = new SoundPlayer(value, volume);
        item.isMuted = _isMuted;
        item.name = id;
        _sounds[id] = item;
    }

    /**
     * Removes a SoundPlayer object.
     *
     * @param id The SoundPlayer object identifier
     */
    public function remove(id:String):void {
        if (exists(id)) {
            var sound:SoundPlayer = SoundPlayer(_sounds[id]);
            sound.dispose();
            delete _sounds[id];
            sound = null;
        }
    }

    /**
     * Checks for a registered SoundPlayer object.
     *
     * @param id The SoundPlayer object identifier
     */
    public function exists(id:String):Boolean {
        return _sounds.hasOwnProperty(id);
    }

    /**
     * Gets a SoundPlayer object.
     *
     * @param id The SoundPlayer object identifier
     *
     * @return A SoundPlayer object.
     */
    public function getSound(id:String):SoundPlayer {
        var result:SoundPlayer;
        if (exists(id)) {
            result = SoundPlayer(_sounds[id]);
        }
        return result;
    }


    //----------------------------------
    //  API : Sound Control
    //----------------------------------

    /**
     * Plays a SoundPlayer sound.
     *
     * @param id The SoundPlayer object identifier
     * @param startTime TBD
     * @param loops TBD
     *
     * @return The length of the sound object
     */
    public function play(id:String, startTime:Number = 0.0, loops:uint = 0):Number {
        var result:Number = 0;
        if (exists(id)) {
            var sound:SoundPlayer = SoundPlayer(_sounds[id]);
            if (sound.isPlaying())
                sound.stop();
            sound.isMuted = _isMuted;
            result = sound.play(startTime, loops);
        }
        return result;
    }

    /**
     * Pauses a SoundPlayer object.
     *
     * @param id The SoundPlayer object identifier
     */
    public function pause(id:String):void {
        if (exists(id)) {
            _sounds[id].pause();
        }
    }

    /**
     * Stops playback of SoundPlayer.
     *
     * @param id The SoundPlayer object identifier
     */
    public function stop(id:String):void {
        if (exists(id)) {
            _sounds[id].stop();
        }
    }

    /**
     * Stops all playing SoundPlayer objects.
     *
     * @filter Optional sound name filter.
     */
    public function stopAll(filter:String = null):void {
        for each (var sound:SoundPlayer in _sounds) {
            if (!filter || sound.name.indexOf(filter) > -1) {
                sound.stop();
            }
        }
    }

    //----------------------------------
    //  API : Sound Info
    //----------------------------------

    /**
     * Returns Sound duration.
     *
     * @param id The SoundPlayer object identifier
     *
     * @return A duration (Number) in milliseconds.
     */
    public function getDuration(id:String):Number {
        var result:Number = 0;
        if (exists(id)) {
            result = _sounds[id].getLength();
        }
        return result;
    }

    /**
     * Return whether the SoundService object is muted.
     *
     * @return The mute flag.
     */
    public function isMuted():Boolean {
        return _isMuted;
    }

    //----------------------------------
    //  API : Sound Volume
    //----------------------------------

    /**
     * Sets a SoundPlayer volume by identifier.
     *
     * @param id The SoundPlayer object identifier
     * @param volume The SoundPlayer sound volume (0..1)
     */
    public function setVolume(id:String, volume:Number):void {
        if (exists(id)) {
            _sounds[id].setVolume(volume);
        }
    }

    /**
     * Sets all SoundPlayers volume.
     *
     * @param volume The SoundService global sound volume (0..1)
     */
    public function setAllVolume(volume:Number):void {
        for each (var sound:SoundPlayer in _sounds) {
            sound.setVolume(volume);
        }
    }

    /**
     * Mute a SoundPlayer by identifier.
     *
     * @param id The SoundPlayer object identifier
     */
    public function mute(id:String):void {
        if (exists(id)) {
            _sounds[id].mute();
        }
    }

    /**
     * Mute all SoundPlayer objects.
     */
    public function muteAll():void {
        _isMuted = !_isMuted;
        for each (var sound:SoundPlayer in _sounds) {
            // reset mute status
            sound.isMuted = !_isMuted;
            // switch mute
            sound.mute();
        }
    }

    //----------------------------------
    //  API : SoundMixer
    //----------------------------------

    /**
     * Switches sound mixer mute state
     *
     * @return True if the mixer is muted
     */
    public function switchGlobalMute():Boolean {
        const soundTransform:SoundTransform = SoundMixer.soundTransform;
        soundTransform.volume = soundTransform.volume ? 0 : 1;
        SoundMixer.soundTransform = soundTransform;
        return soundTransform.volume <= 0;
    }

    /**
     * Sets sound mixer volume
     */
    public function setGlobalVolume(value:Number):void {
        const soundTransform:SoundTransform = SoundMixer.soundTransform;
        soundTransform.volume = value;
        SoundMixer.soundTransform = soundTransform;
    }

    //----------------------------------
    //  API : Lifecycle
    //----------------------------------

    /**
     * Destroys all SoundPlayer objects.
     */
    public function dispose():void {
        if (_sounds) {
            for (var id:String in _sounds) {
                remove(id);
            }
            _sounds = null;
        }
    }
}
}
