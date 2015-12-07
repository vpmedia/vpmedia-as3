/*
 * Copyright (C) 2012 Jean-Philippe Auclair
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 * Base64 library for ActionScript 3.0.
 * By: Jean-Philippe Auclair : http://jpauclair.net
 * Based on article: http://jpauclair.net/2010/01/09/base64-optimized-as3-lib/
 * Benchmark:
 * This version: encode: 260ms decode: 255ms
 * Blog version: encode: 322ms decode: 694ms
 * as3Crypto encode: 6728ms decode: 4098ms
 *
 * Encode: com.sociodox.utils.Base64 is 25.8x faster than as3Crypto Base64
 * Decode: com.sociodox.utils.Base64 is 16x faster than as3Crypto Base64
 *
 * Optimize & Profile any Flash content with TheMiner ( http://www.sociodox.com/theminer )
 *
 * Additional optimizations by Andras Csizmadia ( www.vpmedia.eu )
 */

package hu.vpmedia.crypt {
import flash.utils.ByteArray;

import hu.vpmedia.errors.StaticClassError;

/**
 * Base64 Encoder implementation
 *
 * @see http://tools.ietf.org/html/rfc4648
 */
public class Base64 {
    /**
     * @private
     *
     * Should = not used in the char range?
     */
    private static const CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /**
     * @private
     */
    private static const ENCODE_CHARS:Vector.<int> = InitEncoreChar();
    /**
     * @private
     */
    private static const DECODE_CHARS:Vector.<int> = InitDecodeChar();

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function Base64() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * TBD
     */
    public static function encodeURL(input:String):String {
        var str:String = encodeUTF(input);
        str = str.split("+").join("-");
        str = str.split("/").join("_");
        str = str.split("=").join("");
        return str;
    }

    /**
     * TBD
     */
    public static function decodeURL(input:String):String {
        input = input.split("-").join("+");
        input = input.split("_").join("/");
        return decodeUTF(input);
    }

    /**
     * TBD
     */
    public static function encodeUTF(data:String):String {
        var byteArray:ByteArray = new ByteArray();
        byteArray.writeUTFBytes(data);
        byteArray.position = 0;
        return encode(byteArray);
    }

    /**
     * TBD
     */
    public static function decodeUTF(data:String):String {
        var byteArray:ByteArray = decode(data);
        byteArray.position = 0;
        return byteArray.readUTFBytes(byteArray.length);
    }

    /**
     * TBD
     */
    public static function encode(data:ByteArray):String {
        var out:ByteArray = new ByteArray();
        //Presetting the length keep the memory smaller and optimize speed since there is no "grow" needed
        out.length = (2 + data.length - ((data.length + 2) % 3)) * 4 / 3; //Preset length //1.6 to 1.5 ms
        var i:int = 0;
        var r:int = data.length % 3;
        var len:int = data.length - r;
        var c:uint; //read (3) character AND write (4) characters
        var outPos:int = 0;
        while (i < len) {
            //Read 3 Characters (8bit * 3 = 24 bits)
            c = data[int(i++)] << 16 | data[int(i++)] << 8 | data[int(i++)];

            out[int(outPos++)] = ENCODE_CHARS[int(c >>> 18)];
            out[int(outPos++)] = ENCODE_CHARS[int(c >>> 12 & 0x3f)];
            out[int(outPos++)] = ENCODE_CHARS[int(c >>> 6 & 0x3f)];
            out[int(outPos++)] = ENCODE_CHARS[int(c & 0x3f)];
        }

        if (r == 1) //Need two "=" padding
        {
            //Read one char, write two chars, write padding
            c = data[int(i)];

            out[int(outPos++)] = ENCODE_CHARS[int(c >>> 2)];
            out[int(outPos++)] = ENCODE_CHARS[int((c & 0x03) << 4)];
            out[int(outPos++)] = 61;
            out[int(outPos++)] = 61;
        }
        else if (r == 2) //Need one "=" padding
        {
            c = data[int(i++)] << 8 | data[int(i)];

            out[int(outPos++)] = ENCODE_CHARS[int(c >>> 10)];
            out[int(outPos++)] = ENCODE_CHARS[int(c >>> 4 & 0x3f)];
            out[int(outPos++)] = ENCODE_CHARS[int((c & 0x0f) << 2)];
            out[int(outPos++)] = 61;
        }

        return out.readUTFBytes(out.length);
    }

    /**
     * TBD
     */
    public static function decode(str:String):ByteArray {
        var c1:int;
        var c2:int;
        var c3:int;
        var c4:int;
        var i:int = 0;
        var len:int = str.length;

        var byteString:ByteArray = new ByteArray();
        byteString.writeUTFBytes(str);
        var outPos:int = 0;
        while (i < len) {
            //c1
            c1 = DECODE_CHARS[int(byteString[i++])];
            if (c1 == -1)
                break;

            //c2
            c2 = DECODE_CHARS[int(byteString[i++])];
            if (c2 == -1)
                break;

            byteString[int(outPos++)] = (c1 << 2) | ((c2 & 0x30) >> 4);

            //c3
            c3 = byteString[int(i++)];
            if (c3 == 61) {
                byteString.length = outPos
                return byteString;
            }

            c3 = DECODE_CHARS[int(c3)];
            if (c3 == -1)
                break;

            byteString[int(outPos++)] = ((c2 & 0x0f) << 4) | ((c3 & 0x3c) >> 2);

            //c4
            c4 = byteString[int(i++)];
            if (c4 == 61) {
                byteString.length = outPos
                return byteString;
            }

            c4 = DECODE_CHARS[int(c4)];
            if (c4 == -1)
                break;

            byteString[int(outPos++)] = ((c3 & 0x03) << 6) | c4;
        }
        byteString.length = outPos
        return byteString;
    }

    /**
     * TBD
     */
    public static function InitEncoreChar():Vector.<int> {
        var encodeChars:Vector.<int> = new Vector.<int>(64, true);
        for (var i:int = 0; i < 64; i++) {
            encodeChars[i] = CHARS.charCodeAt(i);
        }
        return encodeChars;
    }

    /**
     * TBD
     */
    public static function InitDecodeChar():Vector.<int> {

        var decodeChars:Vector.<int> = new <int>[
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
            52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
            -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
            -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];

        return decodeChars;
    }

}
}
    