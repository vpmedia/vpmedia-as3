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
import hu.vpmedia.errors.StaticClassError;

/**
 * The AssetLoaderTypes provides constants for the various loader types.
 *
 * @see BaseAssetLoader
 */
public final class AssetLoaderType {
    /**
     * Binary loader
     *
     * @see BinaryLoader
     */
    public static const BINARY_LOADER:String = "BINARY_LOADER";

    /**
     * Text loader
     *
     * @see TextLoader
     * @see flash.display.Loader
     */
    public static const TEXT_LOADER:String = "TEXT_LOADER";

    /**
     * Display object (SWF) loader
     *
     * @see DisplayLoader
     * @see flash.display.Loader
     */
    public static const DISPLAY_LOADER:String = "DISPLAY_LOADER";

    /**
     * Sound loader
     *
     * @see SoundLoader
     * @see flash.media.Sound
     */
    public static const SOUND_LOADER:String = "SOUND_LOADER";

    /**
     * Video loader
     *
     * @see VideoLoader
     * @see flash.media.Video
     */
    public static const VIDEO_LOADER:String = "VIDEO_LOADER";

    /**
     * @private
     */
    public function AssetLoaderType() {
        throw new StaticClassError();
    }
}
}
