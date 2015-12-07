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
import flash.net.URLRequest;
import flash.net.URLRequestMethod;

/**
 * The AssetLoaderVO class is a Value Object representing loading or loaded data.
 */
public final class AssetLoaderVO {
    /**
     * @private
     */
    private var _urlRequest:URLRequest;

    /**
     * The source url of the asset
     */
    public var url:String;

    /**
     * The priority level which should help to order loading items
     */
    public var priority:uint;

    /**
     * The type of the loader
     *
     * @see AssetLoaderType
     */
    public var type:String;

    /**
     * The optional file length (size)
     */
    public var fileLength:uint;

    /**
     * The optional retry counter
     */
    public var numRetries:uint;

    /**
     * The optional load time
     */
    public var loadTime:uint;

    /**
     * The parsed data
     */
    public var data:*;

    /**
     * Constructor
     */
    public function AssetLoaderVO(url:String, priority:uint, data:*) {
        this.url = url;
        this.priority = priority;
        this.data = data;
    }

    /**
     * The URLRequest object
     */
    public function get urlRequest():URLRequest {
        if (!_urlRequest) {
            _urlRequest = new URLRequest();
            _urlRequest.method = URLRequestMethod.POST;
            _urlRequest.url = url;
            _urlRequest.data = "anticache=" + new Date().getTime();
        }
        return _urlRequest;
    }

    /**
     * Handles URLRequest parameters
     */
    public function configure(requestParams:Object):AssetLoaderVO {
        for (var k:String in requestParams) {
            if (urlRequest.hasOwnProperty(k))
                urlRequest[k] = requestParams[k];
        }
        return this;
    }

    /**
     * Will return the description of the object including public properties.
     */
    public function toString():String {
        return "[AssetVO"
                + " url=" + url
                + " priority=" + priority
                + " hasData=" + (data != null)
                + " type=" + type
                + " numRetries=" + numRetries
                + " loadTime=" + loadTime
                + "]";
    }

    /**
     * Static helper method to sort AssetLoaderVO objects in an Array / Vector.
     */
    public static function compareByPriority(a:AssetLoaderVO, b:AssetLoaderVO):Number {
        if (a.priority < b.priority) {
            return -1;
        }
        else if (a.priority > b.priority) {
            return 1;
        }
        else {
            return 0;
        }
    }
}


}