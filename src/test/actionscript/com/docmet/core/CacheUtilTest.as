/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013 Andras Csizmadia
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

package com.docmet.core {
import flexunit.framework.Assert;

/**
 * TBD
 * @author Andras Csizmadia
 */
public class CacheUtilTest {

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_set_get_text():void {
        CacheUtil.addItem("testText", "test_text");
        Assert.assertTrue(CacheUtil.getText("testText") == "test_text");
    }
}
}
