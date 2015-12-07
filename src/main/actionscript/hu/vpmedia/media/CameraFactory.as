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
import flash.media.Camera;

/**
 * TBD
 */
public class CameraFactory {
    public function CameraFactory() {
    }

    public static function getCameraByPosition(position:String):Camera {        
        RUNTIME::AIR {    
            var camera:Camera;
            const n:uint = Camera.names.length;
            for (var i:uint = 0; i < n; ++i) {
                camera = Camera.getCamera(String(i));
                if (camera.position == position)
                    return camera;
            }
        }
        return Camera.getCamera();
    }

    public static function getSupportedCameraResolutions(camera:Camera = null):Vector.<Object> {
        var result:Vector.<Object> = new Vector.<Object>();
        var fps:int = 24; //Try other values
        if (!camera) {
            camera = Camera.getCamera();
        }
        var w:int;
        var h:int;
        for (w = 100; w < 1000; w = w + 20) {
            for (h = 100; h < 1000; h = h + 20) {
                camera.setMode(w, h, fps);
                if (w == camera.width && h == camera.height) {
                    result.push({width: camera.width, height: camera.height, fps: camera.fps});
                }
            }
        }
        return result;
    }
}
}
