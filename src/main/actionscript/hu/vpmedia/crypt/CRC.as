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

import flash.utils.ByteArray;

import hu.vpmedia.errors.StaticClassError;

/**
 * A <a href="http://en.wikipedia.org/wiki/Cyclic_redundancy_check">cyclic redundancy check (CRC)</a> is a non-secure hash function designed to detect accidental changes to raw computer data, and is commonly used in digital networks and storage devices such as hard disk drives.
 * This algorithm is used in the GZIP file format specification version 4.3 defines in the RFC 1952.
 * trace("CRC32 : " + sum + " 0x" + sum.toString( 16 ).toUpperCase() ) ;
 */
public class CRC {

    /**
     * @private
     */
    private static var _crcTable:Vector.<uint> = initialize();

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function CRC() {
        throw new StaticClassError();
    }

    /**
     * Generates checksum in hex format.
     *
     * @see CRC.crc32
     */
    public static function crc32Hex(buffer:ByteArray, index:uint = 0, length:uint = 0):String {
        var crc:uint = crc32(buffer, index, length);
        return "0x" + crc.toString(16).toUpperCase();
    }

    /**
     * Generates the checksum of the specified ByteArray with the CRC32 algorithm.
     *
     * @param buffer the buffer ByteArray object which contains the datas.
     * @param index The index to begin the buffering (default 0).
     * @param length The length value to limit the buffering (if this value is 0, the length of the ByteArray is used).
     *
     * @return The calculated crc32 value in unsigned integer format.
     */
    public static function crc32(buffer:ByteArray, index:uint = 0, length:uint = 0):uint {
        var c:uint = uint.MAX_VALUE; // = 0xFFFFFF ;
        if (index >= buffer.length) {
            index = buffer.length;
        }
        if (length == 0) {
            length = buffer.length - index;
        }
        if (( length + index ) > buffer.length) {
            length = buffer.length - index;
        }
        for (var off:int = index; off < length; off++) {
            c = _crcTable[ ( c ^ buffer[off] ) & 0xFF ] ^ (c >>> 8);
        }
        return ~c;
    }

    /**
     * @private
     */
    private static function initialize():Vector.<uint> {
        var result:Vector.<uint> = new Vector.<uint>(256);
        var c:uint;
        var i:int;
        var j:int;
        for (i = 0; i < 256; i++) {
            c = i;
            for (j = 0; j < 8; j++) {
                c = ( ( c & 1 ) != 0) ? ( 0xEDB88320 ^ ( c >>> 1 ) ) : ( c >>> 1 );
            }
            result[i] = c;
        }
        return result;
    }
}

}
