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
/**
 * The BaseAssetParser is the abstract template class for all synchronous parsers.
 */
public class BaseAssetParser {
    //----------------------------------
    //  Protected properties
    //----------------------------------

    /**
     * @private
     */
    protected var _type:String;

    /**
     * @private
     */
    protected var _pattern:RegExp;

    /**
     * @private
     */
    protected var _loaderType:String;

    /**
     * @private
     */
    protected var _dataType:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function BaseAssetParser() {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Parses an object and returns the serialized result.
     *
     * @param data The object to be serialized
     * @return The result data object
     */
    public function parse(data:*):* {
        throw new Error("Not implemented: parse()");
    }

    /**
     * Will validate the URL param as serializable.
     *
     * @param url TBD
     * @return TBD
     */
    public function canParse(url:String):Boolean {
        return url.match(_pattern) != null;
    }

    /**
     * Will destroy the child objects and free memory.
     */
    public function dispose():void {
        // abstract template
    }

    //----------------------------------
    //  Getters / setters
    //----------------------------------

    /**
     * The parser type
     *
     * @see AssetParserType
     */
    public function get type():String {
        return _type;
    }

    /**
     * The loader type
     *
     * @see hu.vpmedia.assets.loaders.AssetLoaderType
     */
    public function get loaderType():String {
        return _loaderType;
    }

    /**
     * The parser data type
     *
     * @see flash.net.URLLoaderDataFormat
     */
    public function get dataType():String {
        return _dataType;
    }

    /**
     * The url pattern accepted by the parser
     */
    public function get pattern():RegExp {
        return _pattern;
    }

    /**
     * The url pattern accepted by the parser
     */
    public function set pattern(value:RegExp):void {
        _pattern = value;
    }

    /**
     * The url pattern source string accepted by the parser
     */
    public function get patternSource():String {
        return _pattern.source;
    }


}
}
