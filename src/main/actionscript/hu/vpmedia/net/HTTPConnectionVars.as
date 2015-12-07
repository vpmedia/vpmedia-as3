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
package hu.vpmedia.net {
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequestMethod;

import hu.vpmedia.framework.BaseConfig;
import hu.vpmedia.net.utils.ConcurrencyTypes;

/**
 * TBD
 */
public class HTTPConnectionVars extends BaseConfig {

    /**
     * TBD
     */
    public var name:String;

    /**
     * TBD
     */
    public var url:String;

    /**
     * TBD
     *
     * "application/x-www-form-urlencoded"
     */
    public var contentType:String; //

    /**
     * TBD
     *
     * single,multiple,last
     */
    public var concurrency:String = ConcurrencyTypes.CONCURRENCY_LAST;

    /**
     * TBD
     *
     * get,post
     */
    public var method:String = URLRequestMethod.POST;

    /**
     * TBD
     *
     * binary,text,variables
     */
    public var resultFormat:String = URLLoaderDataFormat.VARIABLES; //

    /**
     * TBD
     */
    public var timeout:int = 0;

    /**
     * TBD
     */
    public var requestHeaders:Array;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * TBD
     */
    public function HTTPConnectionVars(parameters:Object = null) {
        super(parameters);
    }
}
}
