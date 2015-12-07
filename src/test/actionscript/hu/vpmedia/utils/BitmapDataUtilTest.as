/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013 Andras Csizmadia
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

package hu.vpmedia.utils {
import flash.display.BitmapData;

import flexunit.framework.Assert;

public class BitmapDataUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_scale():void {
        var scale:Number = 0.5;
        var source:BitmapData = new BitmapData(800, 600);
        var target:BitmapData = BitmapDataUtil.scale(source, scale);
        Assert.assertEquals(target.width, source.width * scale);
        Assert.assertEquals(target.height, source.height * scale);
    }
}
}
