/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright(c) 2014 Andras Csizmadia.
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact Andras Csizmadia at andras@vpmedia.eu.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package hu.vpmedia.starlingx {
import starling.display.Image;
import starling.textures.Texture;

/**
 * TBD
 */
public class InfiniteImageTile extends Image {

    /**
     * TBD
     */
    public var col:uint;

    /**
     * TBD
     */
    public var row:uint;

    /**
     * TBD
     */
    public var id:uint;

    /**
     * TBD
     */
    public function InfiniteImageTile(texture:Texture) {
        super(texture);
    }

    /**
     * TBD
     */
    public function toString():String {
        return "InfiniteImageTile"
                + " col=" + col
                + " row=" + row
                + " id=" + id
                + " x=" + x
                + " y=" + y
                + " name=" + name
                + "]";
    }
}
}
