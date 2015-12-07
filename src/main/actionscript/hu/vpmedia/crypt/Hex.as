/*
 * Copyright (c) 2007 Henri Torgemane
 * All Rights Reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer. Redistributions in binary form must
 * reproduce the above copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the author nor the names of its contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY
 * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
 *
 * IN NO EVENT SHALL TOM WU BE LIABLE FOR ANY SPECIAL, INCIDENTAL,
 * INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND, OR ANY DAMAGES WHATSOEVER
 * RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER OR NOT ADVISED OF
 * THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF LIABILITY, ARISING OUT
 * OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */
package hu.vpmedia.crypt {

import flash.utils.ByteArray;

import hu.vpmedia.errors.StaticClassError;

/**
 * Converts byte-array from and to hexadecimal
 */
public class Hex {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function Hex() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * Generates byte-array from given hexadecimal string
     *
     * Supports straight and colon-laced hex (that means 23:03:0e:f0, but *NOT* 23:3:e:f0)
     * The first nibble (hex digit) may be omitted.
     * Any whitespace characters are ignored.
     */
    public static function toArray(hex:String):ByteArray {
        hex = hex.replace(/^0x|\s|:/gm, '');
        var array:ByteArray = new ByteArray();
        if ((hex.length & 1) == 1)
            hex = "0" + hex;
        const n:uint = hex.length;
        for (var i:uint = 0; i < n; i += 2) {
            array[i / 2] = parseInt(hex.substr(i, 2), 16);
        }
        return array;
    }

    /**
     * Generates lowercase hexadecimal string from given byte-array
     */
    public static function fromArray(array:ByteArray, colons:Boolean = false):String {
        var s:String = "";
        const n:uint = array.length;
        for (var i:uint = 0; i < n; i++) {
            s += ("0" + array[i].toString(16)).substr(-2, 2);
            if (colons && i < n - 1) {
                s += ":";
            }
        }
        return s;
    }

    /**
     * Generates string from given hexadecimal string
     */
    public static function toString(hex:String, charSet:String = 'utf-8'):String {
        var array:ByteArray = toArray(hex);
        return array.readMultiByte(array.length, charSet);
    }

    /**
     * Convenience method for generating string using iso-8859-1
     */
    public static function toRawString(hex:String):String {
        return toString(hex, 'iso-8859-1');
    }

    /**
     * Generates hexadecimal string from given string
     */
    public static function fromString(str:String, colons:Boolean = false, charSet:String = 'utf-8'):String {
        var array:ByteArray = new ByteArray;
        array.writeMultiByte(str, charSet);
        return fromArray(array, colons);
    }

    /**
     * Convenience method for generating hexadecimal string using iso-8859-1
     */
    public static function fromRawString(str:String, colons:Boolean = false):String {
        return fromString(str, colons, 'iso-8859-1');
    }

}
}
