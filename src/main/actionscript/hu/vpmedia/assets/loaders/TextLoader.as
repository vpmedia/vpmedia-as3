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
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

/**
 * The TextLoader class is used to load pure text files.
 *
 * @see BaseAssetLoader
 */
public class TextLoader extends BaseAssetLoader {
    /**
     * @private
     */
    protected var _loader:URLLoader;

    /**
     * @private
     */
    protected var _dataFormat:String;

    /**
     * Constructor
     *
     * @param urlRequest TBD
     */
    public function TextLoader(urlRequest:URLRequest = null) {
        super(urlRequest);
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        _type = AssetLoaderType.TEXT_LOADER;
        if (_dataFormat == null) {
            _dataFormat = URLLoaderDataFormat.TEXT;
        }
        _loader = new URLLoader();
        _loader.dataFormat = _dataFormat;
        attachListeners(_loader);
    }

    /**
     * @inheritDoc
     */
    override public function load(urlRequest:URLRequest):void {
        super.load(urlRequest);
        _loader.load(urlRequest);
    }

    /**
     * @inheritDoc
     */
    override public function close():void {
        try {
            _loader.close();
        }
        catch (error:Error) {
        }
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        super.dispose();
        detachListeners(_loader);
    }
}
}
