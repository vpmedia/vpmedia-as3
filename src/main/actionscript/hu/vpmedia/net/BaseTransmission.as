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
/**
 * TBD
 */
public class BaseTransmission {

    /**
     * TBD
     */
    protected var _code:String;

    /**
     * TBD
     */
    protected var _data:Object;

    /**
     * TBD
     */
    protected var _level:String;

    /**
     * TBD
     */
    protected var _source:Object;

    //----------------------------------
    //  Constructor
    //----------------------------------
    /**
     * Constructor.
     */
    public function BaseTransmission(code:String, data:Object = null, level:String = null, source:Object = null) {
        _code = code;
        _data = data;
        _level = level;
        _source = source;
    }

    //
    /**
     * code
     * @return String
     */
    public function get code():String {
        return _code;
    }

    /**
     * code
     * @param value String
     */
    public function set code(value:String):void {
        _code = code;
    }

    //
    /**
     * data
     * @return Object
     */
    public function get data():Object {
        return _data;
    }

    /**
     * data
     * @param value Object
     */
    public function set data(value:Object):void {
        _data = value;
    }

    //
    /**
     * level
     * @return String
     */
    public function get level():String {
        return _level;
    }

    /**
     * level
     * @param value String
     */
    public function set level(value:String):void {
        _level = value;
    }

    //
    /**
     * source
     * @return Object
     */
    public function get source():Object {
        return _source;
    }

    /**
     * source
     * @param value Object
     */
    public function set source(value:Object):void {
        _source = value;
    }

    //
    /**
     * toString
     */
    public function toString():String {
        return "[BaseTransmission code=" + _code + " level=" + _level + " source=" + _source + "]";
    }
}
}
