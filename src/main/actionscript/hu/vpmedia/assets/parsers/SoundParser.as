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
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.net.URLLoaderDataFormat;
import flash.utils.ByteArray;

import hu.vpmedia.assets.loaders.AssetLoaderType;

/**
 * The SoundParser class is a sound parser.
 *
 * @see BaseAssetParser
 * @see AssetParserType
 */
public class SoundParser extends BaseAsyncAssetParser {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function SoundParser() {
        super();
        _type = AssetParserType.SOUND_PARSER;
        _pattern = /^.+\.((mp3)|(mp2)|(mp2)|(aiff))/i;
        _loaderType = AssetLoaderType.SOUND_LOADER;
        _dataType = URLLoaderDataFormat.BINARY;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    override public function parse(data:*):* {
        return Sound(data);
    }

    /**
     * @inheritDoc
     */
    override public function parseAsync(data:ByteArray, params:Object):void {
        _progress = 0;
        progressed.dispatch(this);

        var loader:Sound = new Sound();

        attachListeners(loader);

        loader.loadCompressedDataFromByteArray(data, data.length);
    }

    //----------------------------------
    //  Event handlers
    //----------------------------------

    /**
     * @private
     */
    private function loaderProgressHandler(event:ProgressEvent):void {
        if (event.bytesLoaded == event.bytesTotal) {
            detachListeners(IEventDispatcher(event.target));
            completed.dispatch(this, event.target);
        }
    }

    /**
     * @private
     */
    private function loaderErrorHandler(event:Event):void {
        detachListeners(IEventDispatcher(event.target));
        completed.dispatch(this, null);
    }

    /**
     * @private
     */
    private function attachListeners(source:IEventDispatcher):void {
        source.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
        source.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
    }

    /**
     * @private
     */
    private function detachListeners(source:IEventDispatcher):void {
        source.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
        source.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
    }
}
}
