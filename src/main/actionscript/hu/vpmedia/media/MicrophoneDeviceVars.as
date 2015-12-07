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
/**
 * TBD
 */
public class MicrophoneDeviceVars extends BaseDeviceVars {
    public var gain:Number;
    public var rate:int;
    public var useEchoSupression:Boolean;
    public var silenceLevel:int;
    public var silenceTimeout:int;
    public var isLoopback:Boolean;
    public var noiseSuppressionLevel:int;

    public function MicrophoneDeviceVars(defaultIndex:int = -1, defaultName:String = null) {
        gain = 50;
        rate = 11;
        useEchoSupression = true;
        silenceLevel = 0;
        silenceTimeout = 2000;
        isLoopback = false;
        noiseSuppressionLevel = -30;
        super(defaultIndex, defaultName);
    }
}
}
