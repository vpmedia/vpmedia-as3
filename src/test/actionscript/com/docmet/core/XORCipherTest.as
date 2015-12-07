/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013-2014. Andras Csizmadia
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
import hu.vpmedia.utils.RandomUtil;

import org.flexunit.Assert;

public class XORCipherTest {
    private var cipher:XORCipher;

    [Before]
    public function setUp():void {
        cipher = new XORCipher("6S6S6S6S", "6S6S");
    }

    [After]
    public function tearDown():void {
        cipher = null;
    }

    [Test]
    public function test_encrypt_decrypt_short():void {
        const source:String = "0|1";
        const encrypted:String = cipher.encrypt(source);
        const decrypted:String = cipher.decrypt(encrypted);
        Assert.assertEquals(source, decrypted);
    }

    [Test]
    public function test_encrypt_decrypt():void {
        const source:String = "The quick brown fox jumps over the lazy dog 123 <>[]{}-_()=+!%/=()|.,;$";
        const encrypted:String = cipher.encrypt(source);
        const decrypted:String = cipher.decrypt(encrypted);
        Assert.assertEquals(source, decrypted);
    }

    [Test]
    public function test_sequence():void {
        for (var i:uint = 2; i <= 512; i += 32) {
            const source:String = RandomUtil.string(i);
            const encrypted:String = cipher.encrypt(source);
            const decrypted:String = cipher.decrypt(encrypted);
            Assert.assertEquals(source, decrypted);
        }
    }
}
}
