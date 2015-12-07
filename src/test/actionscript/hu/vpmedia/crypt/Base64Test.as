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
/* Some test entropies taken from http://en.wikipedia.org/wiki/Base64 */

import flash.display.BitmapData;
import flash.utils.ByteArray;

import flexunit.framework.Assert;

public class Base64Test {

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
    public function encode_test():void {
        var inputStr:String = "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.";

        Assert.assertEquals(Base64.encodeUTF(inputStr), "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGludWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=");
        Assert.assertEquals(Base64.encodeUTF("pleasure."), "cGxlYXN1cmUu");
        Assert.assertEquals(Base64.encodeUTF("leasure."), "bGVhc3VyZS4=");
        Assert.assertEquals(Base64.encodeUTF("easure."), "ZWFzdXJlLg==");
        Assert.assertEquals(Base64.encodeUTF("asure."), "YXN1cmUu");
        Assert.assertEquals(Base64.encodeUTF("sure."), "c3VyZS4=");
    }

    [Test]
    public function decode_test():void {
        var inputStr:String = "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.";
        var encodedStr:String = Base64.encodeUTF(inputStr);
        var decodedStr:String = Base64.decodeUTF(encodedStr);
        Assert.assertTrue(inputStr == decodedStr);
    }

    [Test]
    public function encode_decode_utf_test():void {
        var originalString:String = "http://childsub.sub.domain.com/q=test&n=2&m=2+3&z=%20";
        var encodedString:String = Base64.encodeUTF(originalString);
        var decodedString:String = Base64.decodeUTF(encodedString);
        Assert.assertStrictlyEquals(originalString, decodedString);
    }

    [Test]
    public function encode_decode_url_test():void {
        var originalString:String = "http://childsub.sub.domain.com/q=test&n=2&m=2+3&z=%20";
        var encodedString:String = Base64.encodeURL(originalString);
        var decodedString:String = Base64.decodeURL(encodedString);
        Assert.assertStrictlyEquals(originalString, decodedString);
    }

    [Test]
    public function encode_decode_bitmap_test():void {
        // Create the BitmapData
        var vBitmapDataToWrite:BitmapData = new BitmapData(64, 64, true, 0xFFFF00FF);
        // Encode picels in a Base64 string
        var encoded:String = Base64.encode(vBitmapDataToWrite.getPixels(vBitmapDataToWrite.rect));
        // Create a new BitmapData for read baxk
        var vBitmapDataToRead:BitmapData = new BitmapData(64, 64, true, 0);
        // Decode string in a ByteArray
        var decoded:ByteArray = Base64.decode(encoded);
        decoded.position = 0;
        //Set the bitmapdata pixels
        vBitmapDataToRead.setPixels(vBitmapDataToRead.rect, decoded);
        Assert.assertEquals(vBitmapDataToRead.getPixel(0, 0), vBitmapDataToWrite.getPixel(0, 0));
    }
}
}
