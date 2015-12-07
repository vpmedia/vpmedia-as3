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
package hu.vpmedia.assets.parsers.properties {
/**
 * TBD
 */
public class Properties {
    /**
     * TBD
     */
    public var values:Object;

    /**
     * TBD
     */
    public function Properties(props:String = "") {
        this.properties = props;
    }

    /**
     * TBD
     */
    public function set properties(props:String):void {
        values = Properties.parseProperties(props, values);
    }

    /**
     * TBD
     */
    public function hasProperty(name:String):Boolean {
        return values.hasOwnProperty(name);
    }

    /**
     * TBD
     */
    public function getProperty(name:String):String {
        if (values.hasOwnProperty(name))
            return values[name];

        return null;
    }

    /**
     * TBD
     */
    public function serialize():String {
        return Properties.serializeProperties(values);
    }

    /**
     * TBD
     */
    public static function serializeProperties(values:Object):String {
        var serialized:String = "";

        if (values == null)
            return serialized;

        for (var property:String in values) {
            serialized += property + "=" + String(values[property]) + "\n";
        }

        return serialized;
    }

    /**
     * TBD
     */
    public static function parseProperties(properties:String, values:Object =
            null):Object {
        if (values == null)
            values = {};

        if (properties == null || properties == "")
            return values;

        var lines:Array = properties.split("\n");

        for each (var line:String in lines) {
            if (line != "") {
                var parts:Array = line.split("=");

                var property:String = parts[0];
                var value:String = (parts.length > 1) ? parts[1] : "";

                if (property.charAt(0) != "#" && property.length > 0)
                    values[property] = trim(value);
            }
        }

        return values;
    }

    /**
     * @private
     */
    private static function trim(string:String):String {
        return string.replace(/^\s+|\s+$/g, "");
    }

}
}
