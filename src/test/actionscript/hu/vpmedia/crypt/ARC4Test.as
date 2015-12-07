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
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import flexunit.framework.Assert;

import hu.vpmedia.utils.ByteArrayUtil;

public class ARC4Test {
    [Test]
    public function vectors_test():void {
        var keys:Array = [
            Hex.fromString("Key"),
            Hex.fromString("Wiki"),
            Hex.fromString("Secret")
        ];
        var pts:Array = [
            Hex.fromString("Plaintext"),
            Hex.fromString("pedia"),
            Hex.fromString("Attack at dawn")
        ];
        var cts:Array = [
            "BBF316E8D940AF0AD3",
            "1021BF0420",
            "45A01F645FC35B383552544B9BF5"
        ];

        for (var i:uint = 0; i < keys.length; i++) {
            var key:ByteArray = Hex.toArray(keys[i]);
            var pt:ByteArray = Hex.toArray(pts[i]);
            var rc4:ARC4 = new ARC4(key);
            rc4.encrypt(pt);
            var out:String = Hex.fromArray(pt).toUpperCase();
            Assert.assertEquals(cts[i], out);
            // now go back to plaintext
            rc4.setKey(key);
            rc4.decrypt(pt);
            out = Hex.fromArray(pt);
            Assert.assertEquals(pts[i], out);
        }
    }

    [Test]
    public function encode_decode_byte_array_test():void {
        const input:ByteArray = new ByteArray();
        while (input.length <= ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH)
            input.writeUTF("Secret" + getTimer());
        const key:String = "abcdefghijklmnop";
        const encoded:ByteArray = ARC4.encrypt(key, ByteArrayUtil.clone(input));
        Assert.assertFalse(ByteArrayUtil.equals(input, encoded));
        const decoded:ByteArray = ARC4.encrypt(key, encoded);
        Assert.assertTrue(ByteArrayUtil.equals(input, decoded));
    }

    /*[Test]
     public function encode_decode_bitmap_data_test():void {
     const bitmapData:BitmapData = new BitmapData(320, 240);
     const input:ByteArray = new ByteArray();
     bitmapData.copyPixelsToByteArray(new Rectangle(0, 0, 320, 240), input);
     input.writeUTF("Secret");
     const key:String = "$e3ReT12345abcde%!=()+''";
     const encoded:ByteArray = ARC4.encrypt(key, input);
     const decoded:ByteArray = ARC4.decrypt(key, encoded);
     Assert.assertTrue(ByteArrayUtil.equals(input, decoded));
     }*/

}

}
