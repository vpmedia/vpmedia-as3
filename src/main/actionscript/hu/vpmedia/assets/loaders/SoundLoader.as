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
import flash.media.Sound;
import flash.net.URLRequest;

/**
 * The SoundLoader class is used to load sound files (MP3, WAV).
 *
 * @see BaseAssetLoader
 */
public final class SoundLoader extends BaseAssetLoader {
    /**
     * @private
     */
    private var _loader:Sound;

    /**
     * Constructor
     *
     * @param urlRequest TBD
     */
    public function SoundLoader(urlRequest:URLRequest = null) {
        super(urlRequest);
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        _type = AssetLoaderType.SOUND_LOADER;
        _loader = new Sound();
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
        detachListeners(_loader);
    }

}
}
