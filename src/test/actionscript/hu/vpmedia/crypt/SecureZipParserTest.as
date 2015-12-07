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
package hu.vpmedia.crypt {
import app.TestAssets;

import flash.utils.ByteArray;

import flexunit.framework.Assert;

import hu.vpmedia.utils.ByteArrayUtil;

public class SecureZipParserTest {
    private var parser:SecureZipParser;

    [Before]
    public function setUp():void {
        parser = new SecureZipParser();
    }

    [After]
    public function tearDown():void {
        parser.dispose();
        parser = null;
    }

    [BeforeClass]
    public static function setUpBeforeClass():void {
    }

    [AfterClass]
    public static function tearDownAfterClass():void {
    }

    [Test]
    public function decode_test():void {
        const origBA:ByteArray = new TestAssets.TestSZIP();
        const cloneBA:ByteArray = ByteArrayUtil.clone(origBA);
        parser.parse(cloneBA, "key12345");
        Assert.assertEquals(parser.getFileNumber(), 8);
        Assert.assertEquals(parser.getVersion(), 1);
        Assert.assertTrue(parser.getItems());
        Assert.assertTrue(parser.hasItems());
    }

    [Test]
    public function decode_test_crc32():void {
        const origBA:ByteArray = new TestAssets.TestSZIP();
        const cloneBA:ByteArray = ByteArrayUtil.clone(origBA);
        parser.parse(cloneBA, "key12345");
        Assert.assertEquals(parser.getCRC32(), parser.getCRC32Int(), 2082107164);
    }
}
}