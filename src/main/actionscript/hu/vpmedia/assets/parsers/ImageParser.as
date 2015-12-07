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
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoaderDataFormat;
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

import hu.vpmedia.assets.loaders.AssetLoaderType;

/**
 * The ImageParser class is an image (JPG/PNG) parser.
 *
 * @see BaseAssetParser
 * @see AssetParserType
 */
public class ImageParser extends BaseAsyncAssetParser {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function ImageParser() {
        super();
        _type = AssetParserType.IMAGE_PARSER;
        _pattern = /^.+\.((png)|(jpg)|(jpeg)|(gif))/i;
        _loaderType = AssetLoaderType.DISPLAY_LOADER;
        _dataType = URLLoaderDataFormat.BINARY;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    override public function parse(data:*):* {
        return DisplayObject(data);
    }

    /**
     * @inheritDoc
     */
    override public function parseAsync(data:ByteArray, params:Object):void {
        _progress = 0;
        progressed.dispatch(this);
        // create loader context
        const loaderContext:LoaderContext = new LoaderContext();
        loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
        // create loader
        const loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderFailedHandler);
        loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderFailedHandler);
        loader.loadBytes(data, loaderContext);
    }

    //----------------------------------
    //  Event handler(s)
    //----------------------------------

    /**
     * @private
     */
    private function loaderCompleteHandler(event:Event):void {
        removeListeners(IEventDispatcher(event.target));
        completed.dispatch(this, event.target.loader.content);
    }

    /**
     * @private
     */
    private function loaderFailedHandler(event:Event):void {
        removeListeners(IEventDispatcher(event.target));
        failed.dispatch(this);
    }

    /**
     * @private
     */
    private function removeListeners(target:IEventDispatcher):void {
        target.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
        target.removeEventListener(IOErrorEvent.IO_ERROR, loaderFailedHandler);
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderFailedHandler);
    }


}
}
