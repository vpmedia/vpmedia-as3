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
package nochump.util.zip {

import flash.utils.ByteArray;

import flexunit.framework.Assert;

public class CRC32Test {
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
    public function encodeDecode_test():void {
        // PHP5: 2191738434
        const input:ByteArray = new ByteArray();
        input.writeUTF("The quick brown fox jumped over the lazy dog.");
        input.position = 0;
        const crc32:CRC32 = new CRC32();
        crc32.update(input);
        Assert.assertEquals(crc32.getValue(), 1258299198);
    }
}
}