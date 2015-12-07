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
import flash.media.SoundMixer;
import flash.utils.ByteArray;

/**
 * @author Matan Uberstein
 */
public class SoundSpectrum {
    /**
     * @private
     *
     * Save SoundMixer.computeSpectrum into 'non-static' variable for speed increase.
     */
    protected var _computeSpectrum:Function;

    /**
     * @private
     */
    protected var _values:Vector.<Number>;

    /**
     * @private
     */
    protected var _combinedValues:Vector.<Number>;

    /**
     * @private
     */
    protected var _detail:uint;

    /**
     * @private
     */
    protected var _halfDetail:uint;

    /**
     * @private
     */
    protected var _iterateAmount:uint;

    /**
     * @private
     */
    protected var _bytes:ByteArray;

    /**
     * @private
     */
    protected var _fftMode:Boolean;

    /**
     * @private
     */
    protected var _stretchFactor:int = 0;

    /**
     * @private
     */
    protected var _combineChannels:Boolean;

    /**
     * Constructs the SoundSpectrum instance.
     *
     * @param detail The amount of values to return. See #detail for more info.
     */
    public function SoundSpectrum(detail:Number = 64) {
        _bytes = new ByteArray();
        _computeSpectrum = SoundMixer.computeSpectrum;

        this.detail = detail;
    }

    /**
     * Populates the #values property with the current sound's value.
     *
     * @return Boolean, will return false if an error occured. See flash's security section for more info.
     */
    public function compute():Boolean {
        try {
            _computeSpectrum(_bytes, _fftMode, _stretchFactor);
        }
        catch (error:Error) {
            return false;
        }

        _values = new Vector.<Number>(_detail, true);

        var i:uint;
        var j:uint;
        for (i = 0; i < 512; i += _iterateAmount) {
            _bytes.position = i;
            _values[j] = _bytes.readFloat();
            j++;
        }

        if (_combineChannels) {
            for (i = 0; i < _halfDetail; i++) {
                _combinedValues[i] = _values[i] + _values[i + _halfDetail - 1] / 2;
            }
        }

        return true;
    }

    /**
     * Returns the left channel's sound values. Requires #compute to update.
     *
     * @return Vector.<Number>
     */
    public function getLeftChannel():Vector.<Number> {
        if (_values)
            return _values.slice(0, _halfDetail - 1);

        return null;
    }

    /**
     * Returns the right channel's sound values. Requires #compute to update.
     *
     * @return Vector.&lt;Number&gt;
     */
    public function getRightChannel():Vector.<Number> {
        if (_values)
            return _values.slice(_halfDetail - 1);

        return null;
    }

    /**
     * Average sound value of both channels.
     *
     * @return Number
     */
    public function getAverage():Number {
        var average:Number = 0;
        if (_values)
            average = calculateAverage(_values);
        return average;
    }

    /**
     * Average sound value of left channel.
     *
     * @return Number
     */
    public function getLeftChannelAverage():Number {
        var average:Number = 0;
        var values:Vector.<Number> = getLeftChannel();
        if (values)
            average = calculateAverage(values);
        return average;
    }

    /**
     * Average sound value of right channel.
     *
     * @return Number
     */
    public function getRightChannelAverage():Number {
        var average:Number = 0;
        var values:Vector.<Number> = getRightChannel();
        if (values)
            average = calculateAverage(values);
        return average;
    }

    /**
     * @private
     *
     * Calculates average value.
     */
    protected function calculateAverage(values:Vector.<Number>):Number {
        var total:Number = 0;
        for (var i:int = 0; i < values.length; i++) {
            total += values[i];
        }

        return total / values.length;
    }

    /**
     * Gets the current level of detail.
     *
     * @return uint
     */
    public function get detail():uint {
        return _detail;
    }

    /**
     * Sets the level of detail. This will determine the length of the Vector.&lt;Number&gt;, the higher you level of
     * detail the more time it will take to calculate all related values.
     * <p>Value set must be divisible by 512, thus acceptible values are: 2,4,8,16,32,64,128,256,512</p>
     *
     * @throws ArgumentError - Parameter 'detail' must be larger than 1.
     * @throws ArgumentError - Parameter 'detail' must be divisible by 512 without any rest value. Acceptible values are: 2,4,8,16,32,64,128,256,512
     *
     * @default 64
     *
     * @param detail uint
     */
    public function set detail(detail:uint):void {
        if (detail < 2)
            throw new ArgumentError("Parameter 'detail' must be larger than 1.");

        else if (512 % detail != 0)
            throw new ArgumentError("Parameter 'detail' must be divisible by 512 without any rest value. Acceptible values are: 2,4,8,16,32,64,128,256,512");

        _detail = detail;
        _halfDetail = _detail / 2;
        _iterateAmount = 512 / _detail;

        _combinedValues = new Vector.<Number>(_halfDetail, true);
    }

    /**
     * The #detail value divided by two, this will come handy when building visualizers.
     *
     * @default 32
     * @return uint
     */
    public function get halfDetail():uint {
        return _halfDetail;
    }

    /**
     * See Adobe help docs.
     */
    public function get fftMode():Boolean {
        return _fftMode;
    }

    /**
     * See Adobe help docs.
     */
    public function set fftMode(fftMode:Boolean):void {
        _fftMode = fftMode;
    }

    /**
     * See Adobe help docs.
     */
    public function get stretchFactor():int {
        return _stretchFactor;
    }

    /**
     * See Adobe help docs.
     */
    public function set stretchFactor(stretchFactor:int):void {
        _stretchFactor = stretchFactor;
    }

    /**
     * Gets combined channels state.
     *
     * @return Boolean
     */
    public function get combineChannels():Boolean {
        return _combineChannels;
    }

    /**
     * Sets the combined channels state. If true, both left and right channels are averaged into one.
     *
     * @param combineChannels Boolean
     */
    public function set combineChannels(combineChannels:Boolean):void {
        _combineChannels = combineChannels;
    }

    /**
     * The result of calling #compute. Will be exactly the length of you #detail value.
     *
     * @return Vector.&lt;Number&gt;
     */
    public function get values():Vector.<Number> {
        return _values;
    }

    /**
     * Will only be populated if #combineChannels is equal to true. Will be exactly half the length of you #detail value.
     * If you are using this try doubling you #detail value.
     *
     * @return Vector.&lt;Number&gt;
     */
    public function get combinedValues():Vector.<Number> {
        return _combinedValues;
    }
}
}
