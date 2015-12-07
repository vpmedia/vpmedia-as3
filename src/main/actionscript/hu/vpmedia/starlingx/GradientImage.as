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
import starling.display.Quad;

/**
 * @inheritDoc
 */
public class GradientImage extends Quad {

    /**
     * Constructor
     */
    public function GradientImage(width:Number, height:Number, topColor:uint, bottomColor:uint) {
        super(width, height);
        setVertexColor(0, topColor);
        setVertexColor(1, topColor);
        setVertexColor(2, bottomColor);
        setVertexColor(3, bottomColor);
    }
}
}
