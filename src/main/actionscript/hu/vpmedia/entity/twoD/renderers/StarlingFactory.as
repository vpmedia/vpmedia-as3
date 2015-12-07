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
import flash.display.LoaderInfo;
import flash.utils.getDefinitionByName;

import starling.display.DisplayObject;

/**
 * TBD
 */
public class StarlingFactory {

    /**
     * TBD
     */
    public function StarlingFactory() {
    }

    /**
     * TBD
     */
    public static function create(skinClass:Object, loaderInfo:LoaderInfo = null):DisplayObject {
        // get skin instance
        var result:DisplayObject;
        if (skinClass is Class) {
            result = DisplayObject(new skinClass());
        }
        else if (skinClass is String) {
            var c:Class = getDefinitionByName(String(skinClass)) as Class;
            result = DisplayObject(new c());
        }
        // save skin reference
        return result;
    }
}
}
