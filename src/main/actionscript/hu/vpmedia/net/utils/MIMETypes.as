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
import hu.vpmedia.errors.StaticClassError;

/**
 * TBD
 */
public final class MIMETypes {
    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function MIMETypes() {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static const APPLICATION_OCTET_STREAM:String = "application/octet-stream";
    /**
     * TBD
     */
    public static const APPLICATION_ZIP:String = "application/zip";
    /**
     * TBD
     */
    public static const APPLICATION_PDF:String = "application/pdf";
    /**
     * TBD
     */
    public static const APPLICATION_ADOBE_APOLLO_APPLICATION:String = "application/vnd.adobe.apollo-application-installer-package+zip";
    /**
     * TBD
     */
    public static const APPLICATION_XHTML_XML:String = "application/xhtml+xml";
    /**
     * TBD
     */
    public static const APPLICATION_XML:String = "application/xml";
    /**
     * TBD
     */
    public static const APPLICATION_XML_DTD:String = "application/xml-dtd";
    /**
     * TBD
     */
    public static const APPLICATION_XSLT_XML:String = "application/xslt+xml";
    /**
     * TBD
     */
    public static const AUDIO_MP4:String = "audio/mp4";
    /**
     * TBD
     */
    public static const AUDIO_MPEG:String = "audio/mpeg";
    /**
     * TBD
     */
    public static const IMAGE_BMP:String = "image/bmp";
    /**
     * TBD
     */
    public static const IMAGE_GIF:String = "image/gif";
    /**
     * TBD
     */
    public static const IMAGE_JPEG:String = "image/jpeg";
    /**
     * TBD
     */
    public static const IMAGE_PNG:String = "image/png";
    /**
     * TBD
     */
    public static const IMAGE_MP4:String = "video/mp4";
    /**
     * TBD
     */
    public static const VIDEO_X_FLV:String = "video/x-flv";
    /**
     * TBD
     */
    public static const APPLICATION_URLENCODED:String = "application/x-www-form-urlencoded";
}
}
