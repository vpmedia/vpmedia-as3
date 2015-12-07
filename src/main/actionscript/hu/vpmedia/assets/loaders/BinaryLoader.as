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
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

/**
 * The BinaryLoader class is used to load binary files.
 *
 * @see BaseAssetLoader
 */
public final class BinaryLoader extends TextLoader {
    /**
     * Constructor
     *
     * @param urlRequest TBD
     */
    public function BinaryLoader(urlRequest:URLRequest = null) {
        super(urlRequest);
    }

    /**
     * @inheritDoc
     */
    override protected function initialize():void {
        _dataFormat = URLLoaderDataFormat.BINARY;
        super.initialize();
        _type = AssetLoaderType.BINARY_LOADER;
    }
}
}
