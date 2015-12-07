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

package hu.vpmedia.starlingx {
import flash.utils.Dictionary;

import hu.vpmedia.framework.IBaseDisposable;
import hu.vpmedia.utils.DictionaryUtil;

import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

/**
 * TBD
 */
public class MovieClipGroup extends Sprite implements IBaseDisposable {

    /**
     * @private
     */
    private var textureAtlas:TextureAtlas;

    /**
     * @private
     */
    private var sequences:Dictionary;

    /**
     * @private
     */
    private var currentSequenceName:String;

    /**
     * TBD
     */
    public function MovieClipGroup(textureAtlas:TextureAtlas, animations:Vector.<String>) {
        super();
        this.textureAtlas = textureAtlas;
        if (animations && animations.length) {
            addSequences(animations);
        }
    }

    /**
     * TBD
     */
    public function addSequences(animations:Vector.<String>):void {
        if (!sequences)
            sequences = new Dictionary();
        const n:uint = animations.length;
        for (var i:uint = 0; i < n; i++) {
            const animation:String = animations[i];
            if (textureAtlas.getTextures(animation).length) {
                const mc:MovieClip = new MovieClip(textureAtlas.getTextures(animation));
                sequences[animation] = mc;
                mc.name = "m_" + animation;
            }
        }
    }

    /**
     * TBD
     */
    public function playSequence(animation:String, fps:Number, isLoop:Boolean = true):MovieClip {
        removeCurrentSequence();
        const mc:MovieClip = MovieClip(sequences[animation]);
        addChild(mc);
        Starling.juggler.add(mc);
        mc.fps = fps;
        mc.loop = isLoop;
        currentSequenceName = animation;
        return mc;
    }

    /**
     * TBD
     */
    public function getSequenceByName(sequenceName:String):MovieClip {
        return MovieClip(sequences[sequenceName]);
    }

    /**
     * TBD
     */
    public function getCurrentSequence():MovieClip {
        return MovieClip(sequences[currentSequenceName]);
    }

    /**
     * TBD
     */
    public function removeCurrentSequence():void {
        if (currentSequenceName) {
            removeChild(sequences[currentSequenceName]);
            Starling.juggler.remove(sequences[currentSequenceName]);
        }
    }

    /**
     * TBD
     */
    override public function dispose():void {
        removeCurrentSequence();
        if(sequences)
            DictionaryUtil.clear(sequences);
        sequences = null;
        currentSequenceName = null;
        super.dispose();
    }
}
}
