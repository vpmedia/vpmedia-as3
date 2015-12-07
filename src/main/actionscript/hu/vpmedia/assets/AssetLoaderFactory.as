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
package hu.vpmedia.assets {
import hu.vpmedia.assets.loaders.AssetLoaderType;
import hu.vpmedia.assets.loaders.BaseAssetLoader;
import hu.vpmedia.assets.loaders.BinaryLoader;
import hu.vpmedia.assets.loaders.DisplayLoader;
import hu.vpmedia.assets.loaders.SoundLoader;
import hu.vpmedia.assets.loaders.TextLoader;
import hu.vpmedia.assets.loaders.VideoLoader;
import hu.vpmedia.errors.StaticClassError;

/**
 * The AssetLoaderFactory class provides static methods creating various type of loaders.
 *
 * @see hu.vpmedia.assets.loaders.AssetLoaderType
 * @see hu.vpmedia.assets.loaders.BaseAssetLoader
 */
public final class AssetLoaderFactory {
    /**
     * @private
     */
    public function AssetLoaderFactory() {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static function createByUrl(url:String):BaseAssetLoader {
        return createByType(AssetLoaderPlugin.getParserByUrl(url).loaderType);
    }

    /**
     * TBD
     */
    public static function createByType(type:String):BaseAssetLoader {
        var result:BaseAssetLoader = null;
        switch (type) {
            case AssetLoaderType.BINARY_LOADER:
            {
                result = new BinaryLoader();
                break;
            }
            case AssetLoaderType.DISPLAY_LOADER:
            {
                result = new DisplayLoader();
                break;
            }
            case AssetLoaderType.SOUND_LOADER:
            {
                result = new SoundLoader();
                break;
            }
            case AssetLoaderType.TEXT_LOADER:
            {
                result = new TextLoader();
                break;
            }
            case AssetLoaderType.VIDEO_LOADER:
            {
                result = new VideoLoader();
                break;
            }
            default:
            {
                throw new Error("Unknown loader type: " + type)
                break;
            }
        }
        return result;
    }
}
}