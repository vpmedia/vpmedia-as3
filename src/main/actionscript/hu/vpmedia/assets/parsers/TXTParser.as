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
 * The TXTParser class is a pure text parser.
 *
 * @see BaseAssetParser
 * @see AssetParserType
 */
public class TXTParser extends BaseAssetParser {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function TXTParser() {
        super();
        _type = AssetParserType.TXT_PARSER;
        _pattern = /^.+\.((txt))/i;
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
        return String(data);
    }
}
}
