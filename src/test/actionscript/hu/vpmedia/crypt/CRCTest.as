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
 * HexTest
 *
 * Tests for hex utility
 *
 * @author    Tim Kurvers <tim@moonsphere.net>
 */
package hu.vpmedia.crypt {
import flash.utils.ByteArray;

import flexunit.framework.Assert;

public class CRCTest {


    [Test]
    public function test_crc32():void {
        // PHP5: 2191738434
        const input:ByteArray = new ByteArray();
        input.writeUTF("The quick brown fox jumped over the lazy dog.");
        input.position = 0;
        Assert.assertEquals(CRC.crc32(input), 1258299198);
    }
}

}
