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
package hu.vpmedia.components {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

import hu.vpmedia.components.core.BaseComponent;
import hu.vpmedia.components.skins.ImageSkin;
import hu.vpmedia.utils.DisplayUtil;

/**
 * TBD
 */
public class Image extends BaseComponent {
    private var _source:Object;
    private var _autoLoad:Boolean = true;
    private var _scaleMode:String;
    private var _loader:Loader;
    private var _content:DisplayObject;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function Image(parent:DisplayObjectContainer, config:Object = null) {
        super(parent, config);
    }

    //----------------------------------
    //  Public
    //----------------------------------

    /**
     * TBD
     */
    public function load(request:URLRequest = null, context:LoaderContext = null):void {
        if ((!request || !request.url) && (!_source || _source == "")) {
            return;
        }
        var asset:DisplayObject = DisplayUtil.getDisplayObjectInstance(_source, loaderInfo);
        if (asset) {
            initContent();
            DisplayObjectContainer(_content).addChild(asset);
            _currentWidth = _content.width;
            _currentHeight = _content.height;
            return;
        }
        if (!request) {
            request = new URLRequest(_source.toString());
        }
        if (!context) {
            context = new LoaderContext(false, ApplicationDomain.currentDomain);
        }
        initLoader();
        _loader.load(request, context);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @private
     */
    protected function initContent():void {
        if (_content) {
            var doc:DisplayObjectContainer = DisplayObjectContainer(_content);
            while (doc.numChildren > 0) {
                doc.removeChildAt(0);
            }
        }
        else if (!_content) {
            _content = new Sprite();
            addChild(_content);
        }
    }

    /**
     * @private
     */
    protected function initLoader():void {
        if (_loader) {
            return;
        }
        _loader = new Loader();
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderHandler, false, 0, true);
        addChild(_loader);
    }

    /**
     * @private
     */
    private function loaderHandler(event:Event):void {
        _content = _loader.contentLoaderInfo.content;
    }

    //----------------------------------
    //  Private
    //----------------------------------

    /**
     * @inheritDoc
     */
    override protected function preInitialize():void {
        if (!_skinClass)
            _skinClass = ImageSkin;
        if (!_currentWidth)
            _currentWidth = 100;
        if (!_currentHeight)
            _currentHeight = 100;
        super.preInitialize();
    }

    //----------------------------------
    //  Getter/setter
    //----------------------------------

    /**
     * TBD
     */
    public function get source():Object {
        return _source;
    }

    /**
     * TBD
     */
    public function set source(value:Object):void {
        _source = value;
        if (_autoLoad) {
            load();
        }
    }
}
}
