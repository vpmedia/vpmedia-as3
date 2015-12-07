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
package hu.vpmedia.assets.loaders {
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The BaseAssetLoader is the template abstract class for all various loaders.
 *
 * @see BaseAssetLoader
 */
public class BaseAssetLoader {
    /**
     * @private
     */
    protected var _progress:Number = 0;

    /**
     * @private
     */
    protected var _urlRequest:URLRequest;

    /**
     * @private
     */
    protected var _data:*;

    /**
     * @private
     */
    protected var _type:String;

    /**
     * TBD
     */
    public var completed:ISignal = new Signal(BaseAssetLoader);

    /**
     * TBD
     */
    public var progressed:ISignal = new Signal(BaseAssetLoader);

    /**
     * TBD
     */
    public var failed:ISignal = new Signal(BaseAssetLoader);

    /**
     * Creates a BaseAssetLoader object.
     *
     * @param urlRequest A URLRequest object specifying the URL to download. If this parameter is omitted, no load operation begins. If specified, the load operation begins immediately (see the load entry for more information).
     */
    public function BaseAssetLoader(urlRequest:URLRequest = null) {
        initialize();
        if (urlRequest != null) {
            load(urlRequest);
        }
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * Will initialize the loader object.
     */
    protected function initialize():void {
        throw new Error("Not implemented: initialize()");
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Loads data from the specified URL.
     *
     * @param urlRequest The absolute or relative URL of file to be loaded.
     */
    public function load(urlRequest:URLRequest):void {
        _progress = 0;
        progressed.dispatch(this);
        _urlRequest = urlRequest;
    }

    /**
     * Cancels a load() method operation that is currently in progress.
     */
    public function close():void {
        throw new Error("Not implemented: close()");
    }

    /**
     * Will destroy the object and it's properties freeing memory
     */
    public function dispose():void {
        close();

        completed.removeAll();
        completed = null;

        failed.removeAll();
        failed = null;

        progressed.removeAll();
        progressed = null;

        _urlRequest = null;
        _data = null;
    }

    //----------------------------------
    //  Getters / setters
    //----------------------------------

    /**
     * The loading progress percentage
     */
    public function get progress():Number {
        return _progress;
    }

    /**
     * The loaders type property
     */
    public function get type():String {
        return _type;
    }

    /**
     * The loaders data object
     */
    public function get data():* {
        return _data;
    }

    /**
     * The loaders data object
     */
    public function set data(data:*):void {
        _data = data;
    }

    /**
     * The loaders url request object
     */
    public function get urlRequest():URLRequest {
        return _urlRequest;
    }


    //----------------------------------
    //  Event wiring
    //----------------------------------

    /**
     *  Registers the default event listeners with an EventDispatcher object.
     *
     * @see IEventDispatcher
     */
    protected function attachListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, loaderFailedHandler, false, 0, true);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderFailedHandler, false, 0, true);
        dispatcher.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler, false, 0, true);
    }

    /**
     * Unregisters the default event listeners with an EventDispatcher object.
     *
     * @see IEventDispatcher
     */
    protected function detachListeners(dispatcher:IEventDispatcher):void {
        dispatcher.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
        dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, loaderFailedHandler);
        dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderFailedHandler);
        dispatcher.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
    }

    //----------------------------------
    //  Event listeners
    //----------------------------------

    /**
     * @private
     */
    protected function loaderCompleteHandler(event:Event):void {
        if (event.target is LoaderInfo) {
            data = LoaderInfo(event.target).loader.content;
        } else if (event.target is Sound) {
            data = Sound(event.target);
        } else if (event.target is URLLoader) {
            data = URLLoader(event.target).data;
        } else if (event.target.hasOwnProperty("data")) {
            data = event.target.data;
        } else {
            data = event.target;
        }
        completed.dispatch(this);
    }

    /**
     * @private
     */
    protected function loaderFailedHandler(event:Event):void {
        trace(this, event);
        failed.dispatch(this);
    }

    /**
     * @private
     */
    protected function loaderProgressHandler(event:ProgressEvent):void {
        _progress = (event.bytesLoaded / event.bytesTotal) * 100;
        progressed.dispatch(this);
    }


    /**
     * TBD
     */
    public function toString():String {
        return "[BaseAssetLoader"
                + " url=" + _urlRequest.url
                + " type=" + _type
                + " progress=" + _progress
                + "]";
    }
}
}
