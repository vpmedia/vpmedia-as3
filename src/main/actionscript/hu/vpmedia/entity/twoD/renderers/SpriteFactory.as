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
package hu.vpmedia.entity.twoD.renderers {
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.LoaderInfo;
import flash.display.Sprite;

import hu.vpmedia.utils.DisplayUtil;

/**
 * TBD
 */
public class SpriteFactory {

    /**
     * TBD
     */
    public function SpriteFactory() {
    }

    /**
     * TBD
     */
    public static function create(skinClass:Object, loaderInfo:LoaderInfo):DisplayObject {
        var result:DisplayObject;
        // get skin instance
        var skinInstance:DisplayObject = DisplayUtil.getDisplayObjectInstance(skinClass, loaderInfo);
        // add skin to container if not interactive object
        if (skinInstance is InteractiveObject) {
            result = skinInstance;
        }
        else {
            var skinContainer:Sprite = new Sprite();
            skinContainer.addChild(skinInstance);
            result = skinContainer;
        }
        // save skin reference
        return result;
    }
}
}
