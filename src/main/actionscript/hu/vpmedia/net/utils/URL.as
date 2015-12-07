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
package hu.vpmedia.net.utils {

/**
 * TBD
 */
public class URL {
    /**
     * TBD
     */
    public var rawString:String;

    /**
     * TBD
     */
    public var protocol:String;

    /**
     * TBD
     */
    public var port:int;

    /**
     * TBD
     */
    public var host:String;

    /**
     * TBD
     */
    public var path:String;

    /**
     * TBD
     */
    public var queryString:String;

    /**
     * TBD
     */
    public var queryObject:Object;

    /**
     * TBD
     */
    public var queryLength:int;

    /**
     * TBD
     */
    public var fileName:String;

    /**
     * TBD
     */
    public function URL(rawString:String) {
        this.rawString = rawString;
        initialize();
    }

    /**
     * TBD
     */
    private final function initialize():void {
        var URL_RE:RegExp = /((?P<protocol>[a-zA-Z]+:\/\/) (?P<host>[^:\/]*) (:(?P<port>\d+))?)? (?P<path>[^?]*)? ((?P<query>.*))? /x;
        var match:* = URL_RE.exec(rawString);
        if (match) {
            protocol = Boolean(match.protocol) ? match.protocol : "http://";
            protocol = protocol.substr(0, protocol.indexOf("://"));
            host = match.host || null;
            port = match.port ? int(match.port) : 80;
            path = match.path;
            fileName = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));
            queryString = match.query;
            if (queryString) {
                queryObject = {};
                queryString = queryString.substr(1);
                var value:String;
                var varName:String;
                var queryArray:Array = queryString.split("&");
                for each (var pair:String in queryArray) {
                    varName = pair.split("=")[0];
                    value = pair.split("=")[1];
                    queryObject[varName] = value;
                    queryLength++;
                }
            }
        }
    }

    /** If called as <code>toString(true)</code> will output a verbose version of this URL.
     **/
    public function toString(...rest):String {
        if (rest.length > 0 && rest[0] == true) {
            return "[URL] rawString :" + rawString + ", protocol: " + protocol + ", port: " + port + ", host: " + host + ", path: " + path + ". queryLength: " + queryLength;
        }
        return rawString;
    }
}
}
