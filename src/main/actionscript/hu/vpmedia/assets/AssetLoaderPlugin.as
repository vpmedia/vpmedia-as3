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
import hu.vpmedia.assets.parsers.BaseAssetParser;
import hu.vpmedia.assets.parsers.BinaryParser;
import hu.vpmedia.assets.parsers.CSSParser;
import hu.vpmedia.assets.parsers.FontSWFParser;
import hu.vpmedia.assets.parsers.ImageParser;
import hu.vpmedia.assets.parsers.JSONParser;
import hu.vpmedia.assets.parsers.PropertiesParser;
import hu.vpmedia.assets.parsers.SWCParser;
import hu.vpmedia.assets.parsers.SWFParser;
import hu.vpmedia.assets.parsers.SoundParser;
import hu.vpmedia.assets.parsers.TXTParser;
import hu.vpmedia.assets.parsers.XMLParser;
import hu.vpmedia.errors.StaticClassError;

/**
 * The AssetLoaderPlugin class provides plug-in extensions for the AssetLoader.
 *
 * @see AssetLoader
 */
public final class AssetLoaderPlugin {
    /**
     * @private
     */
    private static const DEFAULT_PARSER:BaseAssetParser = new BinaryParser();

    /**
     * @private
     */
    private static const PARSERS:Vector.<BaseAssetParser> = new <BaseAssetParser>[ new CSSParser(), new ImageParser(), new JSONParser(), new SWCParser(), new SWFParser(), new SoundParser(), new TXTParser(), new XMLParser(), new PropertiesParser(), new FontSWFParser()];

    /**
     * @private
     */
    public function AssetLoaderPlugin() {
        throw new StaticClassError();
    }

    /**
     * Will register a new parser object
     *
     * @see hu.vpmedia.assets.parsers.BaseAssetParser
     */
    public static function register(parser:BaseAssetParser):Boolean {
        const n:uint = PARSERS.length;
        for (var i:int = 0; i < n; i++) {
            if (PARSERS[i].patternSource == parser.patternSource) {
                return false;
            }
        }

        PARSERS.push(parser);

        return true;
    }

    /**
     * Will return a parser by URL.
     * @param url The url which needs a parser.
     *
     * @see hu.vpmedia.assets.parsers.BaseAssetParser
     */
    public static function getParserByUrl(url:String):BaseAssetParser {
        const n:uint = PARSERS.length;
        for (var i:int = 0; i < n; i++) {
            if (PARSERS[i].canParse(url)) {
                return PARSERS[i];
            }
        }
        return DEFAULT_PARSER;
    }

    /**
     * Will return a parser by strict type.
     * @param type The AssetParserType value.
     *
     * @see hu.vpmedia.assets.parsers.AssetParserType
     */
    public static function getParserByType(type:String):BaseAssetParser {
        const n:uint = PARSERS.length;
        for (var i:int = 0; i < n; i++) {
            if (PARSERS[i].type == type) {
                return PARSERS[i];
            }
        }
        return DEFAULT_PARSER;
    }

}
}

