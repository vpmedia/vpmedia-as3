/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2015 Andras Csizmadia
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

/**
 * Created by Andras Csizmadia
 */
package hu.vpmedia.errors {
import flash.utils.Dictionary;

public class RuntimeErrorCode {
    private static const TABLE:Dictionary = generateTable();

    public function RuntimeErrorCode() {
        throw new StaticClassError();
    }

    public static function getErrorMessage(code:String):String {
        if (code) {
            // filter standard error message string (Message: #1000)
            if (code.indexOf("#") > -1) {
                code = code.split("#")[1];
            }
            // remove whitespace
            code = code.split(" ").join("");
        }
        //trace("RuntimeErrorCode::getErrorMessage: " + code);
        return TABLE[code];
    }

    private static function generateTable():Dictionary {
        const result:Dictionary = new Dictionary(false);
        // source: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/runtimeErrors.html
        result["0"] = "Unknown exception.";
        result["1000"] = "The system is out of memory.";
        result["1009"] = "null has no properties.";
        result["1010"] = "undefined has no properties.";
        result["1090"] = "XML parser failure: element is malformed.";
        result["3694"] = "The object was disposed by an earlier call of dispose() on it.";
        result["3669"] = "Bad input size.";
        return result;
    }
}
}
