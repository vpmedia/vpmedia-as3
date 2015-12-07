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
package hu.vpmedia.assets.parsers {
import flash.net.URLLoaderDataFormat;
import flash.utils.ByteArray;

import hu.vpmedia.assets.AssetLoaderPlugin;
import hu.vpmedia.assets.AssetLoaderVO;
import hu.vpmedia.assets.loaders.AssetLoaderType;

import nochump.util.zip.ZipEntry;
import nochump.util.zip.ZipFile;

/**
 * The ZIPParser class is an async ZIP parser.
 *
 * @see BaseAsyncAssetParser
 * @see AssetParserType
 */
public class ZIPParser extends BaseAsyncAssetParser {
    /**
     * @private
     */
    private var _zipFile:ZipFile;

    /**
     * @private
     */
    private var _zipName:String;

    /**
     * @private
     */
    private var _currentIndex:uint;

    /**
     * @private
     */
    private var _currentEntryName:String;

    /**
     * @private
     */
    private var _loadedData:Vector.<AssetLoaderVO>;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function ZIPParser() {
        super();
        _type = AssetParserType.ZIP_PARSER;
        _pattern = /^.+\.((zip|cgs))/i;
        _loaderType = AssetLoaderType.BINARY_LOADER;
        _dataType = URLLoaderDataFormat.BINARY;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    override public function parseAsync(data:ByteArray, params:Object):void {
        _progress = 0;
        progressed.dispatch(this);
        try {
            data.position = params.indexOf(".cgs") > -1 ? 1024 : 0;
            _zipFile = new ZipFile(data);
            _zipName = String(params);
        }
        catch (error:Error) {
            trace(error);
            failed.dispatch(this);
            return;
        }

        _loadedData = new Vector.<AssetLoaderVO>();
        _currentIndex = 0;

        if (_zipFile.entries && _zipFile.entries.length) {
            loadZipItem();
        }
        else {
            completed.dispatch(this, null);
        }
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        super.dispose();

        reset();
    }

    /**
     * TBD
     */
    public function reset():void {
        if (_zipFile) {
            _zipFile.dispose();
            _zipFile = null;
        }
        _zipName = null;
        _currentEntryName = null;
        _currentIndex = 0;
        _progress = 0;
        if (_loadedData) {
            _loadedData.length = 0;
        }
    }

    //----------------------------------
    //  Helper methods
    //----------------------------------

    /**
     * @private
     */
    private function loadZipItem():void {
        _currentEntryName = _zipFile.entries[_currentIndex].name;
        var entry:ZipEntry = _zipFile.getEntry(_currentEntryName);
        var entryData:ByteArray = _zipFile.getInput(entry);

        var parser:BaseAssetParser = AssetLoaderPlugin.getParserByUrl(_currentEntryName);

        if (parser is BaseAsyncAssetParser && parser.dataType == URLLoaderDataFormat.BINARY) {
            var asyncParser:BaseAsyncAssetParser = BaseAsyncAssetParser(parser);
            asyncParser.completed.addOnce(parserCompletedHandler);
            asyncParser.parseAsync(entryData, null);
        }
        else {
            var data:* = parser.parse(entryData);
            addItemData(data);
        }
    }

    /**
     * @private
     */
    private function parserCompletedHandler(item:BaseAssetParser, data:*):void {
        addItemData(data);
    }

    /**
     * @private
     */
    private function addItemData(data:*):void {
        var vo:AssetLoaderVO = new AssetLoaderVO(_zipName + "/" + _currentEntryName, 0, data);
        _loadedData.push(vo);
        loadNext();
    }

    /**
     * @private
     */
    private function loadNext():void {
        var n:int = _zipFile.entries.length;

        _currentIndex++

        _progress = (_currentIndex / n) * 100;
        progressed.dispatch(this);

        if (_currentIndex < n) {
            loadZipItem();
        }
        else {
            completed.dispatch(this, _loadedData.concat());
            reset();
        }
    }

}
}
