/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013-2014 Andras Csizmadia
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
import hu.vpmedia.errors.StaticClassError;

public class XXTEA {
    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function XXTEA() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    public static function encrypt(char:String, key:String):String {
        if (char == "") {
            return "";
        }
        var v:Array = str2long(utf16to8(char), true);
        var k:Array = str2long(key, false);
        var n:uint = v.length - 1;

        var z:Number = v[n];
        var y:Number = v[0];
        var delta:Number = 0x9E3779B9;
        var mx:Number;
        var q:Number = Math.floor(6 + 52 / (n + 1))
        var sum:Number = 0;
        while (q-- > 0) {
            sum = sum + delta & 0xffffffff;
            var e:Number = sum >>> 2 & 3;
            for (var p:uint = 0; p < n; p++) {
                y = v[p + 1];
                mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
                z = v[p] = v[p] + mx & 0xffffffff;
            }
            y = v[0];
            mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
            z = v[n] = v[n] + mx & 0xffffffff;
        }
        return long2str(v, false);
    }

    public static function decrypt(char:String, key:String):String {
        if (char == "") {
            return "";
        }
        var v:Array = str2long(char, false);
        var k:Array = str2long(key, false);
        var n:uint = v.length - 1;

        var z:Number = v[n - 1];
        var y:Number = v[0];
        var delta:Number = 0x9E3779B9;
        var mx:Number;
        var q:Number = Math.floor(6 + 52 / (n + 1));
        var sum:Number = q * delta & 0xffffffff;
        while (sum != 0) {
            var e:Number = sum >>> 2 & 3;
            for (var p:uint = n; p > 0; p--) {
                z = v[p - 1];
                mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
                y = v[p] = v[p] - mx & 0xffffffff;
            }
            z = v[n];
            mx = (z >>> 5 ^ y << 2) + (y >>> 3 ^ z << 4) ^ (sum ^ y) + (k[p & 3 ^ e] ^ z);
            y = v[0] = v[0] - mx & 0xffffffff;
            sum = sum - delta & 0xffffffff;
        }

        return utf8to16(long2str(v, true));
    }


    private static function long2str(v:Array, w:Boolean):String {
        var vl:uint = v.length;
        var sl:uint = v[vl - 1] & 0xffffffff;
        for (var i:uint = 0; i < vl; i++) {
            v[i] = String.fromCharCode(v[i] & 0xff,
                            v[i] >>> 8 & 0xff,
                            v[i] >>> 16 & 0xff,
                            v[i] >>> 24 & 0xff);
        }
        if (w) {
            return v.join('').substring(0, sl);
        }
        else {
            return v.join('');
        }
    }

    private static function str2long(s:String, w:Boolean):Array {
        var len:uint = s.length;
        var v:Array = [];
        for (var i:uint = 0; i < len; i += 4) {
            v[i >> 2] = s.charCodeAt(i)
                    | s.charCodeAt(i + 1) << 8
                    | s.charCodeAt(i + 2) << 16
                    | s.charCodeAt(i + 3) << 24;
        }
        if (w) {
            v[v.length] = len;
        }
        return v;
    }

    private static function utf16to8(char:String):String {
        var out:Vector.<String> = new Vector.<String>();
        var len:uint = char.length;
        for (var i:uint = 0; i < len; i++) {
            var c:int = char.charCodeAt(i);
            if (c >= 0x0001 && c <= 0x007F) {
                out[i] = char.charAt(i);
            } else if (c > 0x07FF) {
                out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),
                                0x80 | ((c >> 6) & 0x3F),
                                0x80 | ((c >> 0) & 0x3F));
            } else {
                out[i] = String.fromCharCode(0xC0 | ((c >> 6) & 0x1F),
                                0x80 | ((c >> 0) & 0x3F));
            }
        }
        return out.join('');
    }

    private static function utf8to16(char:String):String {
        var out:Vector.<String> = new Vector.<String>();
        var len:uint = char.length;
        var i:uint = 0;
        while (i < len) {
            var c:int = char.charCodeAt(i++);
            switch (c >> 4) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                    // 0xxxxxxx
                    out[out.length] = char.charAt(i - 1);
                    break;
                case 12:
                case 13:
                    // 110x xxxx   10xx xxxx
                    var char2:int = char.charCodeAt(i++);
                    out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
                    break;
                case 14:
                    // 1110 xxxx  10xx xxxx  10xx xxxx
                    var char3:int = char.charCodeAt(i++);
                    var char4:int = char.charCodeAt(i++);
                    out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |
                            ((char3 & 0x3F) << 6) | ((char4 & 0x3F) << 0));
                    break;
            }
        }
        return out.join('');
    }
}
}
