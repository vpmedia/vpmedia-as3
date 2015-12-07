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

import hu.vpmedia.framework.IBaseSteppable;

/**
 * TBD
 */
public class BlitGroup implements IBaseSteppable {
    /**
     * TBD
     */
    public var currentSequence:BlitClip;

    /**
     * TBD
     */
    public var sequences:Vector.<BlitClip>;

    /**
     * TBD
     */
    public function BlitGroup(defaultSequence:BlitClip = null) {
        sequences = new Vector.<BlitClip>();
        if (defaultSequence)
            addSequence(defaultSequence);
    }

    /**
     * TBD
     */
    public function play(animationName:String):void {
        var newSequence:BlitClip = getSequenceByName(animationName);
        if (!newSequence || newSequence.name == currentSequence.name)
            return;
        currentSequence = newSequence;
        currentSequence.currentFrame = 0;
    }

    /**
     * TBD
     */
    public function addSequence(bitmapSequence:BlitClip):void {
        sequences.push(bitmapSequence);
        if (!currentSequence)
            currentSequence = bitmapSequence;
    }

    /**
     * TBD
     */
    public function getSequenceByName(name:String):BlitClip {
        for each (var sequence:BlitClip in sequences) {
            if (sequence.name == name)
                return sequence;
        }
        return null;
    }

    /**
     * TBD
     */
    public function setCanvas(value:BitmapData):void {
        for each (var sequence:BlitClip in sequences) {
            sequence.canvas = value;
        }
    }

    /**
     * TBD
     */
    public function step(timeDelta:Number):void {
        currentSequence.step(timeDelta);
    }
}
}
