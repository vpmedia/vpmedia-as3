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
package hu.vpmedia.mvc {
import hu.vpmedia.errors.StaticClassError;

/**
 * The RouterUtil class provides static helper methods for the MVC routing.
 */
public final class RouterUtil {
    /**
     * @private
     */
    public function RouterUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Public static helper methods
    //----------------------------------

    /**
     * getParentPath
     * @param path
     * @return array
     */
    public static function getParentPath(path:String):String {
        var result:String;
        var parentPathNames:Array = getParentPathNames(path);
        if (parentPathNames) {
            var parentPath:String = parentPathNames.toString().split(",").join("/");
            result = formatPath(parentPath);
        }
        return result;
    }

    //----------------------------------
    //  Private static helper methods
    //----------------------------------

    /**
     * @private
     */
    internal static function getParentPathNames(path:String):Array {
        var result:Array = getPathNames(path);
        result.pop();
        if (!result.length) {
            result = null;
        }
        return result;
    }

    /**
     * @private
     */
    internal static function getPathNames(path:String):Array {
        if (!path || path.length <= 1) {
            return [ "/" ];
        }
        var result:Array = path.split("/");
        if (path.substr(0, 1) == "/" || path.length == 0) {
            result.splice(0, 1);
        }
        if (path.substr(path.length - 1, 1) == "/") {
            result.splice(result.length - 1, 1);
        }
        return result;
    }

    /**
     * @private
     */
    internal static function formatPath(path:String):String {
        var result:String = path;
        if (path && path.length > 1) {
            result = "/" + path + "/";
        }
        return result;
    }

}
}
