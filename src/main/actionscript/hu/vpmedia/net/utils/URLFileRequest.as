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
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;

/**
 * @example
 * <pre>
 * // Construct variables (name-value pairs) to be sent to sever
 * var variables:URLVariable = new URLVariables();
 * variables.userImage = new URLFileData(jpegEncodedData, "user_image.jpg");
 * variables.userPDF = new URLFileData(pdfEncodedData, "user_doc.pdf");
 * variables.userName = "Mike";
 * // Build the request which houses these variables
 * var request:URLRequest = new URLFileRequest(variables).build();
 * request.url = "some.web.address.php";
 * // Create the loader and use it to send the request off to the server
 * var loader:URLLoader = new URLLoader();
 * loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
 * loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onError);
 * loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
 * loader.addEventListener(Event.COMPLETE, onServerResponse);
 * loader.load(request);
 * function onServerResponse(event:Event):void
 * {
     *     trace("Variables uploaded successfully");
     * }
 * function onError(event:Event):void
 * {
     *     trace("An error occurred while trying to upload data to the server: \n" + event);
     * }
 * </pre>
 *
 * @author Mike Stead
 * @see URLFileData
 */
public class URLFileRequest {

    private static const MULTIPART_BOUNDARY:String = "----------196f00b77b968397849367c61a2080";

    private static const MULTIPART_MARK:String = "--";

    private static const LF:String = "\r\n";
    /** The variables to encode within a URLRequest */
    private var variables:URLVariables;

    /**
     * Constructor.
     *
     * @param variables The URLVariables to encode within a URLRequest.
     */
    public function URLFileRequest(variables:URLVariables) {
        this.variables = variables;
    }

    /**
     * Build a URLRequest instance with the correct encoding given the URLVariables
     * provided to the constructor.
     *
     * @return URLRequest instance primed and ready for submission
     */
    public function getRequest():URLRequest {
        var request:URLRequest = new URLRequest();
        if (isMultipartData) {
            request.data = buildMultipartBody();
            addMultipartHeadersTo(request);
        }
        else {
            request.data = variables;
        }
        return request;
    }

    /**
     * Determines whether, given the URLVariables instance provided to the constructor, the
     * URLRequest should be encoded using <code>multipart/form-data</code>.
     */
    private function get isMultipartData():Boolean {
        for each (var variable:* in variables) {
            if (variable is URLFileData)
                return true;
        }
        return false;
    }

    /**
     * Build a ByteArray instance containing the <code>multipart/form-data</code> encoded URLVariables.
     *
     * @return ByteArray containing the encoded variables
     */
    private function buildMultipartBody():ByteArray {
        var body:ByteArray = new ByteArray();
        // Write each encoded field into the request body
        for (var id:String in variables)
            body.writeBytes(encodeMultipartVariable(id, variables[id]));
        // Mark the end of the request body
        // Note, we writeUTFBytes and not writeUTF because it can corrupt parsing on the server
        body.writeUTFBytes(MULTIPART_MARK + MULTIPART_BOUNDARY + MULTIPART_MARK + LF);
        return body;
    }

    /**
     * Encode a variable using <code>multipart/form-data</code>.
     *
     * @param id    The unique id of the variable
     * @param value The value of the variable
     */
    private function encodeMultipartVariable(id:String, variable:Object):ByteArray {
        if (variable is URLFileData)
            return encodeMultipartFile(id, URLFileData(variable));
        else
            return encodeMultipartString(id, variable.toString());
    }

    /**
     * Encode a file using <code>multipart/form-data</code>.
     *
     * @param id   The unique id of the file variable
     * @param file The URLFileData containing the file name and file data
     *
     * @return The encoded variable
     */
    private function encodeMultipartFile(id:String, file:URLFileData):ByteArray {
        var field:ByteArray = new ByteArray();
        // Note, we writeUTFBytes and not writeUTF because it can corrupt parsing on the server
        field.writeUTFBytes(MULTIPART_MARK + MULTIPART_BOUNDARY + LF + "Content-Disposition: form-data; name=\"" + id + "\"; " + "filename=\"" + file.name + "\"" + LF + "Content-Type: application/octet-stream" + LF + LF);
        field.writeBytes(file.data);
        field.writeUTFBytes(LF);
        return field;
    }

    /**
     * Encode a string using <code>multipart/form-data</code>.
     *
     * @param id   The unique id of the string
     * @param text The value of the string
     *
     * @return The encoded variable
     */
    private function encodeMultipartString(id:String, text:String):ByteArray {
        var field:ByteArray = new ByteArray();
        // Note, we writeUTFBytes and not writeUTF because it can corrupt parsing on the server
        field.writeUTFBytes(MULTIPART_MARK + MULTIPART_BOUNDARY + LF + "Content-Disposition: form-data; name=\"" + id + "\"" + LF + LF + text + LF);
        return field;
    }

    /**
     * Add the relevant <code>multipart/form-data</code> headers to a URLRequest.
     */
    private function addMultipartHeadersTo(request:URLRequest):void {
        request.method = URLRequestMethod.POST;
        request.contentType = "multipart/form-data; boundary=" + MULTIPART_BOUNDARY;
        request.requestHeaders = [new URLRequestHeader("Accept", "*/*")]; // Allow any type of data in response
        // Note, the headers: Content-Length and Connection:Keep-Alive are auto set by URLRequest
    }
}
}
