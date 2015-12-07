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
import flash.display.Shape;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.utils.ByteArray;
import flash.utils.CompressionAlgorithm;

import hu.vpmedia.assets.AssetLoaderVO;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * Encrypted zip parser class
 */
public class SecureZipParserAsync {
    //----------------------------------
    //  Properties
    //----------------------------------

    /**
     * @private
     */
    private var _loadedData:Vector.<AssetLoaderVO>;

    /**
     * @private
     */
    private var _version:uint;

    /**
     * @private
     */
    private var _fileNumber:uint;

    /**
     * @private
     */
    private var _fileSize:uint;

    /**
     * @private
     */
    private var _crc32:uint;

    /**
     * @private
     */
    private var _crc32Int:uint;

    /**
     * @private
     */
    private var _verbose:Boolean;

    /**
     * @private
     */
    private var sourceData:ByteArray;

    /**
     * @private
     */
    private var decryptedData:ByteArray;

    /**
     * @private
     */
    private var outputData:ByteArray;

    /**
     * @private
     */
    private var cipher:ARC4;

    /**
     * @private
     */
    private var dispatcher:Shape;

    /**
     * @private
     */
    private var currentPage:int;

    /**
     * @private
     */
    public var completed:ISignal = new Signal();

    /**
     * @private
     */
    public var failed:ISignal = new Signal();

    /**
     * @private
     */
    private static const BLOCK_SIZE:uint = 1024 * 1024;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function SecureZipParserAsync() {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Parser
     *
     * @param ba ByteArray
     * @param key String
     */
    public function parse(ba:ByteArray, key:String):void {
        //LOG.debug("parse: " + ba.length + " (" + ba.endian + ")");
        if (!_loadedData)
            _loadedData = new Vector.<AssetLoaderVO>();
        // Decrypt data if key is available (it's possible that it's a stream loaded and pre-decrypted)
        if (key) {
            const keyByteArray:ByteArray = Hex.toArray(Hex.fromString(key));
            cipher = new ARC4(keyByteArray);
            sourceData = ba;
            outputData = new ByteArray();
            decryptedData = new ByteArray();
            dispatcher = new Shape();
            dispatcher.addEventListener(Event.ENTER_FRAME, processBlocks, false, 0, true);
        } else {
            process(ba);
        }
    }

    private function processBlocks(event:Event):void {
        outputData.length = 0;
        const n:uint = sourceData.length;
        const left:int = n - ((currentPage) * BLOCK_SIZE);
        const size:int = Math.min(left, BLOCK_SIZE);
        if (size >= 0) {
            //trace("PROCESSING: " + currentPage + " => " + left + "<>" + size);
            sourceData.readBytes(outputData, 0, size);
            // xor is two-way (encrypt==decrypt)
            cipher.encrypt(outputData);
            decryptedData.writeBytes(outputData, 0, size);
            currentPage++;
        } else {
            //trace("COMPLETED");
            if (sourceData.length != decryptedData.length) {
                failed.dispatch();
            }
            // clear source
            sourceData.length = 0;
            sourceData = null;
            // clear temp
            outputData.length = 0;
            outputData = null;
            // clear listener
            dispatcher.removeEventListener(Event.ENTER_FRAME, processBlocks);
            dispatcher = null;
            // process decrypted
            decryptedData.position = 0;
            process(decryptedData);
            // notify subscribers
            completed.dispatch();
        }

    }

    /**
     * Parser
     *
     * @param ba ByteArray
     */
    private function process(ba:ByteArray):void {
        // Split sizes
        const totalBlockSize:uint = ba.length;
        const crcBlockSize:uint = 4;
        const contentBlockSize:uint = totalBlockSize - crcBlockSize;
        //trace(totalBlockSize, crcBlockSize, contentBlockSize);
        // Content (T-4 byte)
        var contentByteArray:ByteArray = new ByteArray();
        ba.readBytes(contentByteArray, 0, contentBlockSize);
        ba.position = 0;
        // CRC32 (last 4 byte)
        const crcByteArray:ByteArray = new ByteArray();
        ba.position = contentBlockSize;
        ba.readBytes(crcByteArray, 0, crcBlockSize);
        crcByteArray.position = 0;
        if (crcByteArray.length != crcBlockSize && crcByteArray.bytesAvailable != crcBlockSize)
            throw new IllegalOperationError("Checksum Error");
        //trace(Hex.fromArray(crcByteArray, true));
        _crc32Int = crcByteArray.readUnsignedInt();
        _crc32 = CRC.crc32(contentByteArray);
        // Un-compress content with ZLIB
        contentByteArray.uncompress(CompressionAlgorithm.ZLIB);
        _fileSize = contentByteArray.length;
        // Header version (1 byte)
        _version = contentByteArray.readUnsignedByte();
        // Header files (1 byte)
        _fileNumber = contentByteArray.readUnsignedByte();
        // Content
        contentByteArray.position = 2;
        var fileLength:uint;
        var fileNameLength:uint;
        var fileName:String;
        var fileContent:ByteArray;
        var i:int;
        //fileNumber = 1;
        for (i = 0; i < _fileNumber; i++) {
            // 4 byte of file content length
            fileLength = contentByteArray.readUnsignedInt();
            /*var ba:ByteArray = new ByteArray();
             _contentByteArray.readBytes(ba,0,4);
             fileLength = toInt(ba);
             LOG.debug(fileLength);*/
            // 1 byte of file name length
            fileNameLength = contentByteArray.readUnsignedByte();
            // x byte of file name string
            fileName = contentByteArray.readUTFBytes(fileNameLength);
            // save
            //_loadedData[i] = { idx: i, fileLength: fileLength, fileNameLength: fileNameLength, fileName: fileName };
            _loadedData[i] = new AssetLoaderVO(fileName, i, null);
            _loadedData[i].fileLength = fileLength;
        }
        // Get files BAs
        for (i = 0; i < _fileNumber; i++) {
            // x byte of file content bytes
            fileContent = new ByteArray();
            contentByteArray.readBytes(fileContent, 0, _loadedData[i].fileLength);
            fileContent.position = 0;
            _loadedData[i].data = fileContent;
        }
        // Free memory
        ba.length = 0;
        ba = null;
        contentByteArray.length = 0;
        contentByteArray = null;
        // Log
        if (_verbose) {
            trace("Version: " + _version);
            trace("File number: " + _fileNumber);
            trace("File size: " + _fileSize);
            trace("CRC32: " + _crc32);
            trace("CRC32Int: " + _crc32Int);
            trace("Items: " + _loadedData);
        }
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will return the decrypted file list
     */
    public function getItems():Vector.<AssetLoaderVO> {
        return _loadedData;
    }

    /**
     * Will return whether has files
     */
    public function hasItems():Boolean {
        return _loadedData && _loadedData.length && _fileNumber > 0 && _version > 0;
    }

    /**
     * Will return the number of files
     */
    public function getFileNumber():uint {
        return _fileNumber;
    }

    /**
     * Will return the tool version
     */
    public function getVersion():uint {
        return _version;
    }

    /**
     * Will return the internal CRC32 value
     */
    public function getCRC32Int():uint {
        return _crc32Int;
    }

    /**
     * Will return the calculated CRC32 value
     */
    public function getCRC32():uint {
        return _crc32;
    }

    /**
     * Will reset the object
     */
    public function dispose():void {
        //trace("dispose");
        _crc32Int = 0;
        _version = 0;
        _fileNumber = 0;
        if (_loadedData)
            _loadedData.length = 0;
        _loadedData = null;
    }

    /**
     * Gets item by file name
     *
     * @param fileName String
     *
     * @return ByteArray
     */
    public function getItem(fileName:String):ByteArray {
        var result:ByteArray;
        const n:uint = _loadedData.length;
        for (var i:uint = 0; i < n; i++) {
            if (_loadedData[i].url == fileName) {
                result = ByteArray(_loadedData[i].data);
            }
        }
        return result;
    }
}
}
