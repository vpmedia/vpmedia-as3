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
package hu.vpmedia.renderqueue {
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import hu.vpmedia.framework.BaseConfig;

/**
 * TBD
 */
public class BaseDrawPassVars extends BaseConfig {
    /**
     * TBD
     */
    public var matrix:Matrix;

    /**
     * TBD
     */
    public var colorTransform:ColorTransform;

    /**
     * TBD
     */
    public var clipRectangle:Rectangle;

    /**
     * TBD
     */
    public var smoothing:Boolean;

    /**
     * TBD
     */
    public var blendMode:String;

    /**
     * TBD
     */
    public function BaseDrawPassVars(parameters:Object = null) {
        super(parameters);
    }
}
}
