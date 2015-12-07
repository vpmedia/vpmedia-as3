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
public class CameraDeviceVars extends BaseDeviceVars {
    public var bandwidth:int;
    public var quality:int;
    public var fps:Number;
    public var kfi:uint;
    public var width:int;
    public var height:int;
    public var motionLevel:int;
    public var motionTimeout:int;
    public var isLoopback:Boolean;

    public function CameraDeviceVars(defaultIndex:int = -1, defaultName:String = null) {
        bandwidth = 0;
        quality = 0;
        fps = 24;
        kfi = 24;
        width = 320;
        height = 240;
        motionLevel = 0;
        motionTimeout = 2000;
        isLoopback = false;
        super(defaultIndex, defaultName);
    }
}
}
