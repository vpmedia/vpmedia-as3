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
import hu.vpmedia.crypt.SecureZipParserAsync;

/**
 * Secure Zip Asynchronous Parser
 */
public class ZIPSecureParser extends BaseAsyncAssetParser {
    /**
     * @private
     */
    private var _zipFile:SecureZipParserAsync;

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
    private var _key:String;

    /**
     * Constructor
     */
    public function ZIPSecureParser(key:String) {
        super();
        _key = key;
        _type = AssetParserType.SECURE_ZIP_PARSER;
        _pattern = /^.+\.((szip))/i;
        _loaderType = AssetLoaderType.BINARY_LOADER;
        _dataType = URLLoaderDataFormat.BINARY;
    }

    override public function parseAsync(data:ByteArray, params:Object):void {
        _progress = 0;
        progressed.dispatch(this);
        _zipFile = new SecureZipParserAsync();
        _zipFile.parse(data, _key);
        _zipFile.completed.addOnce(onParsed);
        _zipFile.failed.addOnce(onFailed);
        _zipName = String(params);
    }

    private function onFailed():void {
        failed.dispatch(this);
    }

    private function onParsed():void {
        _currentIndex = 0;
        if (_zipFile.hasItems())
            loadZipItem();
        else
            completed.dispatch(this, null);
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
        _currentIndex = 0;
        _progress = 0;
    }

    //----------------------------------
    //  Helper methods
    //----------------------------------

    /**
     * @private
     */
    private function loadZipItem():void {
        const entry:AssetLoaderVO = _zipFile.getItems()[_currentIndex];
        const parser:BaseAssetParser = AssetLoaderPlugin.getParserByUrl(entry.url);
        if (parser is BaseAsyncAssetParser && parser.dataType == URLLoaderDataFormat.BINARY) {
            var asyncParser:BaseAsyncAssetParser = BaseAsyncAssetParser(parser);
            asyncParser.completed.addOnce(parserCompletedHandler);
            asyncParser.failed.addOnce(parserFailedHandler);
            asyncParser.parseAsync(entry.data, null);
        } else {
            var data:*;
            try {
                data = parser.parse(entry.data);
            } catch (error:Error) {
                trace(this, error);
            }
            entry.url = _zipName + "/" + entry.url;
            entry.data = data;
            loadNext();
        }
    }

    /**
     * @private
     */
    private function parserCompletedHandler(item:BaseAssetParser, data:*):void {
        BaseAsyncAssetParser(item).completed.remove(parserCompletedHandler);
        BaseAsyncAssetParser(item).failed.remove(parserFailedHandler);
        var entry:AssetLoaderVO = _zipFile.getItems()[_currentIndex];
        entry.url = _zipName + "/" + entry.url;
        entry.data = data;
        loadNext();
    }

    /**
     * @private
     */
    private function parserFailedHandler(item:BaseAssetParser):void {
        BaseAsyncAssetParser(item).completed.remove(parserCompletedHandler);
        BaseAsyncAssetParser(item).failed.remove(parserFailedHandler);
        loadNext();
    }

    /**
     * @private
     */
    private function loadNext():void {
        var n:int = _zipFile.getFileNumber();

        _currentIndex++

        _progress = (_currentIndex / n) * 100;
        progressed.dispatch(this);

        if (_currentIndex < n) {
            loadZipItem();
        }
        else {
            completed.dispatch(this, _zipFile.getItems().concat());
            reset();
        }
    }
}
}
