/*
 nochump.util.zip.ZipEntry
 Copyright (c) 2008 David Chang (dchang@nochump.com)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
package nochump.util.zip {

import flash.utils.ByteArray;

/**
 * This class represents a member of a zip archive.  ZipFile
 * will give you instances of this class as information
 * about the members in an archive.  On the other hand ZipOutput
 * needs an instance of this class to create a new member.
 *
 * @author David Chang
 * @contributor Andras Csizmadia - http://www.vpmedia.eu
 */
public final class ZipEntry {

    //----------------------------------
    //  Private properties
    //----------------------------------

    /**
     * @private
     *
     * some members are internal as ZipFile will need to set these directly
     * where their accessor does type conversion
     */
    private var _name:String;

    //----------------------------------
    //  Public properties
    //----------------------------------

    /**
     * The size of the uncompressed data.
     */
    public var size:int = -1;

    /**
     * The size of the compressed data.
     */
    public var compressedSize:int = -1;

    /**
     * The crc of the uncompressed data.
     */
    public var crc:uint;

    /**
     * The compression method.
     */
    public var method:int = -1;

    /**
     * Optional extra field data for entry
     */
    public var extra:ByteArray;

    /**
     * Optional comment string for entry
     */
    public var comment:String;

    //----------------------------------
    //  Internal properties
    //----------------------------------

    /**
     * @private
     */
    internal var dostime:uint;

    //----------------------------------
    //  Flags used only by ZipOutput
    //----------------------------------

    /**
     * @private
     *
     * bit flags
     */
    internal var flag:int;

    /**
     * @private
     *
     * version needed to extract
     */
    internal var version:int;

    /**
     * @private
     *
     * offset of loc header
     */
    internal var offset:int;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Creates a zip entry with the given name.
     * @param name the name. May include directory components separated
     * by '/'.
     */
    public function ZipEntry(name:String) {
        _name = name;
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * Clears object references.
     */
    public function dispose():void {
        extra = null;
        size = -1;
        compressedSize = -1;
        method = -1;
    }

    //----------------------------------
    //  Getters/setters
    //----------------------------------

    /**
     * Returns the entry name.  The path components in the entry are
     * always separated by slashes ('/').
     */
    public function get name():String {
        return _name;
    }

    /**
     * Gets the time of last modification of the entry.
     * @return the time of last modification of the entry, or -1 if unknown.
     */
    public function get time():Number {
        var d:Date = new Date(((dostime >> 25) & 0x7f) + 1980, ((dostime >> 21) & 0x0f) - 1, (dostime >> 16) & 0x1f, (dostime >> 11) & 0x1f, (dostime >> 5) & 0x3f, (dostime & 0x1f) << 1);
        return d.time;
    }

    /**
     * Sets the time of last modification of the entry.
     * @time the time of last modification of the entry.
     */
    public function set time(time:Number):void {
        var d:Date = new Date(time);
        dostime = (d.fullYear - 1980 & 0x7f) << 25 | (d.month + 1) << 21 | d.day << 16 | d.hours << 11 | d.minutes << 5 | d.seconds >> 1;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Gets true, if the entry is a directory.  This is solely
     * determined by the name, a trailing slash '/' marks a directory.
     */
    public function isDirectory():Boolean {
        return _name.charAt(_name.length - 1) == '/';
    }

    /**
     * Gets the string representation of this ZipEntry.  This is just
     * the name as returned by name.
     */
    public function toString():String {
        return _name;
    }

}

}
