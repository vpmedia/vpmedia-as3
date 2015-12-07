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
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoaderDataFormat;
import flash.system.Capabilities;
import flash.utils.ByteArray;

import hu.vpmedia.assets.loaders.AssetLoaderType;
import hu.vpmedia.assets.parsers.fonts.FontLoader;

/**
 * The SWFParser class is an SWF parser.
 *
 * @see BaseAssetParser
 * @see AssetParserType
 */
public class FontSWFParser extends BaseAsyncAssetParser {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function FontSWFParser() {
        super();
        _type = AssetParserType.FONT_SWF_PARSER;
        _pattern = /^.+\.((fswf))/i;
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
        // iOS does not like runtime SWF with DoABC
        if (Capabilities.manufacturer.toLowerCase().indexOf("ios") > -1) {
            failed.dispatch(this);
            return;
        }
        // Start progress dispatching
        _progress = 0;
        progressed.dispatch(this);
        // Load FontSWF
        var loader:FontLoader = new FontLoader();
        loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
        loader.addEventListener(IOErrorEvent.IO_ERROR, loaderFailedHandler);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderFailedHandler);
        try {
            loader.loadBytes(data, true);
        } catch (error:Error) {
            // TODO: pass error object to the loader context
            removeListeners(IEventDispatcher(loader));
            failed.dispatch(this);
        }
    }

    //----------------------------------
    //  Event handler(s)
    //----------------------------------

    /**
     * @private
     */
    private function loaderCompleteHandler(event:Event):void {
        removeListeners(IEventDispatcher(event.target));
        var fonts:Array = FontLoader(event.target).fonts;
        //trace(fonts);
        completed.dispatch(this, fonts);
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
