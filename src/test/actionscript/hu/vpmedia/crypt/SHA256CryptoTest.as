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
/* Some test entropies taken from http://en.wikipedia.org/wiki/Sha256 */

import flash.utils.ByteArray;

import flexunit.framework.Assert;

public class SHA256CryptoTest {

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [BeforeClass]
    public static function setUpBeforeClass():void {
    }

    [AfterClass]
    public static function tearDownAfterClass():void {
    }

    [Test]
    public function hash_test():void {
        // from the spec ( http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf )
        assertSHA256("abc", "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
        assertSHA256("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1");

        // from wikipedia
        assertSHA256("The quick brown fox jumps over the lazy dog", "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592");
        assertSHA256("The quick brown fox jumps over the lazy cog", "e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be");
        assertSHA256("", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");

    }

    private function assertSHA256(value:String, expected:String):void {
        var result:String = SHA256.hashString(value);

        Assert.assertTrue("Hash of '" + value + "' returned wrong value ('" + result + "')",
                        result == expected);
    }

    private function assertSHA256Binary(value:String, expected:String):void {

        var byteArray:ByteArray = new ByteArray();
        byteArray.writeUTFBytes(value);

        var output:ByteArray = new ByteArray();
        SHA256.hash(byteArray, output);
        var result:String = output.readUTF();
        Assert.assertTrue("Hash of '" + value + "' returned wrong value ('" + result + "')",
                        result == expected);
    }

    private function assertSHA256Base64(value:String, expected:String):void {
        var result:String = SHA256.hashStringToBase64(value);

        Assert.assertTrue("Hash of '" + value + "' returned wrong value ('" + result + "')",
                        result == expected);
    }
}
}
