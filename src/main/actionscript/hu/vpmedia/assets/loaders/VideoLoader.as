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
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.net.URLRequest;

/**
 * The VideoLoader class is used to load video files progressively (FLV, F4V, MP4).
 *
 * @see BaseAssetLoader
 */
public final class VideoLoader extends BaseAssetLoader {
    /**
     * @private
     */
    private var _connection:NetConnection;

    /**
     * @private
     */
    private var _loader:NetStream;

    /**
     * Constructor
     *
     * @param urlRequest TBD
     */
    public function VideoLoader(urlRequest:URLRequest = null) {
        super(urlRequest);
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        _type = AssetLoaderType.VIDEO_LOADER;
        _connection = new NetConnection();
        _connection.client = this;
        _connection.connect(null);
        _loader = new NetStream(_connection);
        _loader.client = this;
        attachListeners(_loader);
    }

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        detachListeners(_loader);
    }

    /**
     * @inheritDoc
     */
    override public function load(urlRequest:URLRequest):void {
        super.load(urlRequest);

        _loader.play(urlRequest.url);
    }
}
}
