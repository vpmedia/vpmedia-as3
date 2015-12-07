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

package hu.vpmedia.framework {
import hu.vpmedia.utils.ObjectUtil;

/**
 * The BaseConfig class provides template methods for various configuration objects.
 */
public class BaseConfig implements IBaseDisposable {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     * @param parameters TBD
     */
    public function BaseConfig(parameters:Object) {
        setupDefaults();
        copyProperties(parameters);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will destroy object references to let garbage collect parent object.
     */
    public function dispose():void {
        // clear object references
        ObjectUtil.dispose(this);
        // setup default values
        setupDefaults();
    }

    /**
     * Will setup default property values.
     */
    public function setupDefaults():void {
        // abstract template
    }

    /**
     * Will copy property values from source object to target object,
     * optionally using special serializers.
     *
     * @param parameters TBD
     */
    public function copyProperties(parameters:Object):void {
        ObjectUtil.copyProperties(parameters, this);
    }
}
}
