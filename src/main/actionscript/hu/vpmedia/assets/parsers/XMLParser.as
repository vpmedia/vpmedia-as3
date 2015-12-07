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
import flash.net.URLLoaderDataFormat;

import hu.vpmedia.assets.loaders.AssetLoaderType;

/**
 * The XMLParser class is an XML parser.
 *
 * @see BaseAssetParser
 * @see AssetParserType
 */
public class XMLParser extends BaseAssetParser {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function XMLParser() {
        super();
        _type = AssetParserType.XML_PARSER;
        _pattern = /^.+\.((xml)|(fnt)|(pex))/i;
        _loaderType = AssetLoaderType.TEXT_LOADER;
        _dataType = URLLoaderDataFormat.TEXT;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * @inheritDoc
     */
    override public function parse(data:*):* {
        var result:XML;
        try {
            result = XML(data);
        } catch (error:Error) {
            trace("[XMLParser][ERROR]: " + error + " " + data);
        }
        return result;
    }
}
}
