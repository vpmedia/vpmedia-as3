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
import flash.display.Loader;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

/**
 * The DisplayLoader class is used to load SWF files.
 *
 * @see BaseAssetLoader
 */
public final class DisplayLoader extends BaseAssetLoader {
    /**
     * @private
     */
    private var _loader:Loader;

    /**
     * Constructor
     *
     * @param urlRequest TBD
     */
    public function DisplayLoader(urlRequest:URLRequest = null) {
        super(urlRequest);
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        _type = AssetLoaderType.DISPLAY_LOADER;

        _loader = new Loader();

        attachListeners(_loader.contentLoaderInfo);
    }

    /**
     * @inheritDoc
     */
    override public function load(urlRequest:URLRequest):void {
        super.load(urlRequest);

        var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
        context.allowCodeImport = true;
        try {
            context.allowLoadBytesCodeExecution = true;
        }
        catch (error:Error) {
        }
        _loader.load(urlRequest, context);
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

        detachListeners(_loader.contentLoaderInfo);
    }
}
}
