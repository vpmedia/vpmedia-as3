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
package hu.vpmedia.assets.parsers {
import hu.vpmedia.errors.StaticClassError;

/**
 * The AssetParserTypes provides constants for the various parser types.
 *
 * @see BaseAssetParser
 */
public final class AssetParserType {
    /**
     * Text parser
     *
     * @see TXTParser
     */
    public static const TXT_PARSER:String = "TXT_PARSER";

    /**
     * Properties parser
     *
     * @see PropertiesParser
     */
    public static const PROPERTIES_PARSER:String = "PROPERTIES_PARSER";

    /**
     * XML parser
     *
     * @see XMLParser
     */
    public static const XML_PARSER:String = "XML_PARSER";

    /**
     * CSS parser
     *
     * @see CSSParser
     */
    public static const CSS_PARSER:String = "CSS_PARSER";

    /**
     * JSON parser
     *
     * @see JSONParser
     */
    public static const JSON_PARSER:String = "JSON_PARSER";

    /**
     * Binary parser
     *
     * @see BinaryParser
     */
    public static const BINARY_PARSER:String = "BINARY_PARSER";

    /**
     * PBJ (Pixel Bender) parser
     *
     * @see PBJParser
     */
    public static const PBJ_PARSER:String = "PBJ_PARSER";

    /**
     * Sound (MP3) parser
     *
     * @see SoundParser
     */
    public static const SOUND_PARSER:String = "SOUND_PARSER";

    /**
     * Image (JPG, PNG) parser
     *
     * @see ImageParser
     */
    public static const IMAGE_PARSER:String = "IMAGE_PARSER";

    /**
     * SWC parser
     *
     * @see SWCParser
     */
    public static const SWC_PARSER:String = "SWC_PARSER";

    /**
     * SWF parser
     *
     * @see SWFParser
     */
    public static const SWF_PARSER:String = "SWF_PARSER";

    /**
     * Font SWF parser
     *
     * @see FontSWFParser
     */
    public static const FONT_SWF_PARSER:String = "FONT_SWF_PARSER";

    /**
     * ZIP parser
     *
     * @see ZIPParser
     */
    public static const ZIP_PARSER:String = "ZIP_PARSER";

    /**
     * Secure ZIP parser
     *
     * @see ZIPSecureParser
     */
    public static const SECURE_ZIP_PARSER:String = "SECURE_ZIP_PARSER";

    /**
     * @private
     */
    public function AssetParserType() {
        throw new StaticClassError();
    }
}
}
