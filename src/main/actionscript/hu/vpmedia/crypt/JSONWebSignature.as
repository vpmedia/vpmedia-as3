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

package hu.vpmedia.crypt {
import hu.vpmedia.errors.StaticClassError;

/**
 * JSON Web Signature implementation
 *
 * @see http://tools.ietf.org/html/draft-ietf-jose-json-web-signature-08#appendix-A
 */
public class JSONWebSignature {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function JSONWebSignature() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * Will encode the provided object
     *
     * @param data The data object to encrypt
     * @param secret The key to use with the encryption
     *
     * return The encrypted string data
     */
    public static function encode(data:Object, secret:String):String {
        // get json
        const json:String = JSON.stringify(data);
        // base64 encode json
        const jsonB64:String = Base64.encodeURL(json);
        // get raw signature
        const signature:String = HMAC.hash(secret, jsonB64);
        // base64 encode signature
        const signatureB64:String = Base64.encodeURL(signature);
        // base64 encode signature + base64 encode json
        const result:String = signatureB64 + "." + jsonB64;
        // return result
        return result;
    }

    /**
     * Will decode the provided string data
     *
     * @param data The encrypted string data
     * @param secret The key to used with the encryption
     *
     * return Parsed JSON result object
     */
    public static function decode(data:String, secret:String):Object {
        var result:Object;
        const splittedData:Array = data.split(".");
        // get data
        const jsonB64:String = splittedData[1];
        var json:String = Base64.decodeURL(jsonB64);
        json = json.split(String.fromCharCode(0)).join("");
        // get signature
        const signatureB64:String = splittedData[0];
        var signature:String = Base64.decodeURL(signatureB64);
        signature = signature.split(String.fromCharCode(0)).join("");
        // generate expected signature
        const expectedSignature:String = HMAC.hash(secret, jsonB64);
        // validate signature
        const isValid:Boolean = (signature == expectedSignature);
        if (isValid) {
            try {
                result = JSON.parse(json);
            }
            catch (error:Error) {
                trace("JSON error: " + error.toString());
            }
        } else {
            trace("Invalid signature");
        }
        //LogUtil.error("JSONWebSignature result: " + result);
        return result;
    }
}
}
