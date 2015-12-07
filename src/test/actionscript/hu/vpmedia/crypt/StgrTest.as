/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2014 Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
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

/**
 * Steganography Test
 */
package hu.vpmedia.crypt {
import flash.display.BitmapData;

import flexunit.framework.Assert;

public class StgrTest {


    [Test]
    public function test_embed_extract():void {
        var secret:String = "$eCrEt";
        var source:BitmapData = new BitmapData(320, 240);
        var output:BitmapData = Stgr.embedText(secret, source);
        var result:String = Stgr.extractText(output);
        Assert.assertEquals(secret, result);
    }
}

}
