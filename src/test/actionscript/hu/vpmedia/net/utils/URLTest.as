/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013 Docmet Systems
 *  http://www.docmet.com
 *
 *  For information about the licensing and copyright please
 *  contact us at info@docmet.com
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
package hu.vpmedia.net.utils {
import flash.display.Sprite;

import flexunit.framework.Assert;

public class URLTest extends Sprite {
    private var url:URL;

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
        url = null;
    }

    [Test]
    public function test_instantiate():void {
        url = new URL("http://localhost");
        Assert.assertNotNull(url);
    }
}
}
