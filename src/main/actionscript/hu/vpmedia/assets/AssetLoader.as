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
package hu.vpmedia.assets {
import flash.net.URLRequestHeader;
import flash.utils.ByteArray;

import hu.vpmedia.assets.loaders.BaseAssetLoader;
import hu.vpmedia.assets.parsers.BaseAssetParser;
import hu.vpmedia.assets.parsers.BaseAsyncAssetParser;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

/**
 * The AssetLoader class provides a simple API to load and parse various external assets.
 *
 * @see AssetLoaderPlugin
 * @see AssetLoaderVO
 * @see IAssetLoader
 */
public final class AssetLoader implements IAssetLoader {

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("AssetLoader");

    /**
     * @private
     */
    private var _progress:Number;

    /**
     * @private
     */
    private var _currentProgress:Number;

    /**
     * @private
     */
    private var _itemsToLoad:Vector.<AssetLoaderVO> = new Vector.<AssetLoaderVO>();

    /**
     * @private
     */
    private var _failedToLoad:Vector.<AssetLoaderVO> = new Vector.<AssetLoaderVO>();

    /**
     * @private
     */
    private var _itemsLoaded:Vector.<AssetLoaderVO> = new Vector.<AssetLoaderVO>();

    /**
     * @private
     */
    private var _loaderList:Vector.<BaseAssetLoader> = new Vector.<BaseAssetLoader>();

    /**
     * The loader objects name
     */
    public var name:String;

    /**
     * The base url to prepend
     */
    public var baseURL:String;

    /**
     * The URLRequestHeader to send with every request
     */
    public var authHeader:URLRequestHeader;

    /**
     * Will return the signal set collection
     */
    public var signalSet:AssetLoaderSignalSet;


    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor.
     */
    public function AssetLoader() {
        baseURL = "";
        signalSet = new AssetLoaderSignalSet();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will add an item into the loading queue
     */
    public function add(url:String, priority:uint = 0):AssetLoaderVO {
        // guard for null URI
        if (url == null) {
            throw new Error("Invalid parameter(s).");
        }
        // check for existing URI
        if (!has(url)) {
            var vo:AssetLoaderVO = new AssetLoaderVO(baseURL + url, priority, null);
            // add optional auth. header
            if(authHeader) {
                vo.urlRequest.requestHeaders.push(authHeader);
            }
            _itemsToLoad.push(vo);
            _itemsToLoad.sort(AssetLoaderVO.compareByPriority);
        } else {
            LOG.warn("Already loaded: " + url);
        }
        return vo;
    }

    /**
     * Will return a loaded item data
     */
    public function get(url:String):* {
        if (url == null) {
            throw new Error("Invalid parameter(s).");
        }
        for (var i:int = 0; i < _itemsLoaded.length; i++) {
            if (_itemsLoaded[i].url == url) {
                return _itemsLoaded[i];
            }
        }
        return null;
    }

    /**
     * Will cache an url with data
     */
    public function cache(url:String, data:*):Boolean {
        if (!has(url)) {
            _itemsLoaded.push(new AssetLoaderVO(url, 0, data))
            return true;
        }
        return false;
    }

    /**
     * Will return if loader has the url cached
     */
    public function has(url:String):* {
        return get(url) != null;
    }

    /**
     * Will start loading the queue
     */
    public function execute():void {
        _currentProgress = 0;
        _progress = 0;

        signalSet.started.dispatch(this);

        loadNext();
    }

    /**
     * Will close loading the queue
     */
    public function close():void {
        if (_loaderList && _loaderList.length) {
            _loaderList[0].close();
        }
    }

    /**
     * Will release the object members
     */
    public function reset():void {
        _currentProgress = 0;
        _progress = 0;

        _itemsToLoad.length = 0;
        _failedToLoad.length = 0;
        _itemsLoaded.length = 0;
        _loaderList.length = 0;
    }

    /**
     * Will destroy the object
     */
    public function dispose():void {
        signalSet.dispose();
        signalSet = null;
        _itemsToLoad = null;
        _failedToLoad = null;
        _itemsLoaded = null;
        _loaderList = null;
        name = null;
    }

    /**
     * Will return the object as a string
     */
    public function toString():String {
        return "[AssetLoader" + " name=" + name + "]";
    }

    //----------------------------------
    //  Getters
    //----------------------------------

    /**
     * Will return the number of processed items
     */
    public function get numProcessed():uint {
        return (_itemsLoaded.length + _failedToLoad.length);
    }

    /**
     * Will return the number of failed items
     */
    public function get numFailed():uint {
        return _failedToLoad.length;
    }

    /**
     * Will return the number of total items
     */
    public function get numTotal():uint {
        return (_itemsToLoad.length + _itemsLoaded.length + _failedToLoad.length);
    }

    /**
     * Will return the total progress of loading in percentage
     */
    public function get progress():Number {
        _progress = (numProcessed / numTotal) * 100;
        return _progress + currentProgress;
    }

    /**
     * Will return the current progress of loading in percentage
     */
    public function get currentProgress():Number {
        return _currentProgress / numTotal;
    }

    /**
     * Will return the loaded item value object list
     */
    public function get itemsLoaded():Vector.<AssetLoaderVO> {
        return _itemsLoaded;
    }

    /**
     * Will return the failed item value object list
     */
    public function get itemsFailed():Vector.<AssetLoaderVO> {
        return _failedToLoad;
    }

    //----------------------------------
    //  Private Methods
    //----------------------------------

    /**
     * @private
     */
    private function loadNext():void {
        // clear last finished loader
        var finishedLoader:BaseAssetLoader = _loaderList.shift();
        if (finishedLoader)
            finishedLoader.dispose();
        finishedLoader = null;
        // get progress
        _currentProgress = 0;
        if (!_itemsToLoad.length) {
            signalSet.completed.dispatch(this);
            return;
        } else {
            updateProgress();
        }
        // get loading data
        const vo:AssetLoaderVO = _itemsToLoad[0];
        // create loader
        const loader:BaseAssetLoader = AssetLoaderFactory.createByUrl(vo.urlRequest.url);
        // save loader
        _loaderList.push(loader);
        // attach signal handlers
        loader.completed.add(loaderCompletedHandler);
        loader.progressed.add(loaderProgressedHandler);
        loader.failed.add(loaderFailedHandler);
        // load item
        loader.load(vo.urlRequest);
    }

    /**
     * @private
     */
    private function addItemData(data:*):void {
        var vo:AssetLoaderVO = _itemsToLoad.shift();
        //LOG.debug("addItemData: " + vo);
        if (data == null || data == undefined) {
            LOG.warn("Adding a null object to " + vo);
        }
        if (data is Vector.<AssetLoaderVO>) {
            var n:uint = data.length;
            for (var i:int = 0; i < n; i++) {
                _itemsLoaded.push(data[i]);
            }
        } else if (data is AssetLoaderVO) {
            _itemsLoaded.push(data);
        } else if (vo) {
            vo.data = data;
            _itemsLoaded.push(vo);
        }
        loadNext();
    }

    /**
     * @private
     */
    private function updateProgress():void {
        signalSet.progressed.dispatch(this);
    }

    //----------------------------------
    //  Loader Event Handlers
    //----------------------------------

    /**
     * @private
     */
    private function loaderCompletedHandler(item:BaseAssetLoader):void {
        // get parser by item
        const parser:BaseAssetParser = AssetLoaderPlugin.getParserByUrl(item.urlRequest.url);
        // save parser type to loaded item
        _itemsToLoad[0].type = parser.type;
        //LOG.debug("loaderCompletedHandler: " + item + " by " + parser);
        if (parser is BaseAsyncAssetParser && item.data is ByteArray) {
            // asynchronous
            var asyncParser:BaseAsyncAssetParser = BaseAsyncAssetParser(parser);
            asyncParser.completed.add(parserCompletedHandler);
            asyncParser.progressed.add(parserProgressedHandler);
            asyncParser.failed.add(parserFailedHandler);
            asyncParser.parseAsync(item.data, item.urlRequest.url);
        } else {
            // serial
            var data:* = null;
            try {
                data = parser.parse(item.data);
            } catch (error:Error) {
                LOG.debug(error);
            }
            addItemData(data);
        }
    }

    /**
     * @private
     */
    private function loaderFailedHandler(item:BaseAssetLoader):void {
        LOG.debug("loaderFailedHandler: " + item);
        if (!_itemsToLoad[0].numRetries) {
            _itemsToLoad[0].numRetries++;
        } else {
            _failedToLoad.push(_itemsToLoad.shift());
        }
        loadNext();
    }

    /**
     * @private
     */
    private function loaderProgressedHandler(item:BaseAssetLoader):void {
        _currentProgress = item.progress;
        updateProgress();
    }

    //----------------------------------
    //  Parser Event Handlers
    //----------------------------------

    /**
     * @private
     */
    private function parserCompletedHandler(item:BaseAssetParser, data:*):void {
        //LOG.debug("parserCompletedHandler: " + item + " (" + progress + "%)");
        addItemData(data);
    }

    /**
     * @private
     */
    private function parserFailedHandler(item:BaseAssetParser):void {
        LOG.warn("parserFailedHandler: " + item + " (" + progress + "%)");
        if (!_itemsToLoad[0].numRetries) {
            _itemsToLoad[0].numRetries++;
            loadNext();
        } else {
            addItemData(null);
        }
    }

    /**
     * @private
     */
    private function parserProgressedHandler(item:BaseAssetParser):void {
        _currentProgress = BaseAsyncAssetParser(item).progress;
        updateProgress();
    }
}
}



