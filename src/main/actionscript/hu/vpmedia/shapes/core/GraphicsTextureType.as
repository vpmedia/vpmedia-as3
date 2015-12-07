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
package hu.vpmedia.shapes.core {
import hu.vpmedia.errors.StaticClassError;

/**
 * TBD
 */
public final class GraphicsTextureType {

    /**
     * TBD
     */
    public static const SOLID:uint = 0;

    /**
     * TBD
     */
    public static const GRADIENT:uint = 1;

    /**
     * TBD
     */
    public static const BITMAP:uint = 2;

    /**
     * TBD
     */
    public static const SHADER:uint = 3;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * @private
     */
    public function GraphicsTextureType():void {
        throw new StaticClassError();
    }
}
}
