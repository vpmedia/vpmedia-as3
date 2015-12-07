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
package hu.vpmedia.analytics.core {
import hu.vpmedia.errors.StaticClassError;

/**
 * Google Analytics Tracker Tag Enumerations
 *
 * @see https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
 */
public class TrackerTag {

    //----------------------------------
    //  Core
    //----------------------------------

    /**
     * The Protocol version. The current value is '1'.
     * This will only change when there are changes made that are not backwards compatible.
     */
    public static const VERSION:String = "v";

    /**
     * The tracking ID / web property ID.
     * The format is UA-XXXX-Y. All collected data is associated by this ID.
     */
    public static const TRACKING_ID:String = "tid";

    /**
     * This anonymously identifies a particular user, device, or browser instance.
     * For the web, this is generally stored as a first-party cookie with a two-year expiration.
     * For mobile apps, this is randomly generated for each particular instance of an application install.
     * The value of this field should be a random UUID (version 4) as described in http://www.ietf.org/rfc/rfc4122.txt
     */
    public static const CLIENT_ID:String = "cid";

    /**
     * The type of hit. Must be one of 'pageview', 'screenview', 'event', 'transaction', 'item', 'social', 'exception', 'timing'.
     */
    public static const HIT_TYPE:String = "t";

    //----------------------------------
    //  User
    //----------------------------------

    /**
     * This is intended to be a known identifier for a user provided by the site owner/tracking library user.
     * It may not itself be PII (personally identifiable information).
     * The value should never be persisted in GA cookies or other Analytics provided storage.
     */
    public static const USER_ID:String = "uid";

    /**
     * The IP address of the user.
     * This should be a valid IP address.
     * It will always be anonymized just as though &aip (anonymize IP) had been used.
     */
    public static const USER_IP:String = "uip";

    /**
     * The User Agent of the browser.
     * Note that Google has libraries to identify real user agents.
     * Hand crafting your own agent could break at any time.
     */
    public static const USER_AGENT:String = "ua";

    /**
     * Specifies the language.
     */
    public static const USER_LANGUAGE:String = "ul";

    //----------------------------------
    //  Document
    //----------------------------------

    /**
     * Specifies the character set used to encode the page / document.
     */
    public static const DOCUMENT_ENCODING:String = "de";

    /**
     * The title of the page / document.
     */
    public static const DOCUMENT_TITLE:String = "dt";

    /**
     * Specifies the hostname from which content was hosted.
     */
    public static const DOCUMENT_HOST:String = "dh";

    /**
     * Use this parameter to send the full URL (document location) of the page on which content resides.
     * You can use the &dh and &dp parameters to override the hostname and path + query portions of the document location, accordingly.
     * The JavaScript clients determine this parameter using the concatenation of the document.location.origin + document.location.pathname + document.location.search browser parameters.
     * Be sure to remove any user authentication or other private information from the URL if present.
     */
    public static const DOCUMENT_LOCATION:String = "dl";

    /**
     * The path portion of the page URL. Should begin with '/'.
     */
    public static const DOCUMENT_PATH:String = "dp";

    /**
     * Specifies which referral source brought traffic to a website.
     * This value is also used to compute the traffic source. The format of this value is a URL.
     */
    public static const DOCUMENT_REFERRER:String = "dr";

    //----------------------------------
    //  Common
    //----------------------------------

    /**
     * When present, the IP address of the sender will be anonymized.
     * For example, the IP will be anonymized if any of the following parameters are present in the payload: &aip=, &aip=0, or &aip=1
     */
    public static const ANONYMIZE_IP:String = "aip";

    /**
     * Used to send a random number in GET requests to ensure browsers and proxies don't cache hits.
     * It should be sent as the final parameter of the request since we've seen some 3rd party internet filtering software add additional parameters to HTTP requests incorrectly.
     * This value is not used in reporting.
     */
    public static const CACHE_BUSTER:String = "z";

    /**
     * Specifies the screen resolution.
     */
    public static const SYSTEM_RESOLUTION:String = "sr";

    /**
     * Specifies the viewable area of the browser / device.
     */
    public static const VIEW_PORT_SIZE:String = "vp";

    /**
     * Specifies the screen color depth.
     */
    public static const SCREEN_COLORS:String = "sd";

    /**
     * Specifies whether Java was enabled.
     */
    public static const JAVA_ENABLED:String = "je";

    /**
     * Specifies the flash version.
     */
    public static const FLASH_VERSION:String = "fl";

    /**
     * Specifies that a hit be considered non-interactive.
     */
    public static const NON_INTERACTION:String = "ni";

    //----------------------------------
    //  Screen / Application
    //----------------------------------

    /**
     * If not specified, this will default to the unique URL of the page by either using the &dl parameter as-is or assembling it from &dh and &dp.
     * App tracking makes use of this for the 'Screen Name' of the screenview hit.
     */
    public static const SCREEN_NAME:String = "cd";

    /**
     * Specifies the application name.
     */
    public static const APP_NAME:String = "an";

    /**
     * Application identifier.
     */
    public static const APP_ID:String = "aid";

    /**
     * Specifies the application version.
     */
    public static const APP_VERSION:String = "av";

    /**
     * Application installer identifier.
     */
    public static const APP_INSTALLER_ID:String = "aiid";

    //----------------------------------
    //  Event
    //----------------------------------

    /**
     * TBD
     */
    public static const EVENT_CATEGORY:String = "ec";

    /**
     * TBD
     */
    public static const EVENT_ACTION:String = "ea";

    /**
     * TBD
     */
    public static const EVENT_LABEL:String = "el";

    /**
     * TBD
     */
    public static const EVENT_VALUE:String = "ev";

    //----------------------------------
    //  Exception
    //----------------------------------

    /**
     * Specifies the description of an exception.
     */
    public static const EXCEPTION_DESCRIPTION:String = "exd";

    /**
     * Specifies whether the exception was fatal.
     */
    public static const EXCEPTION_IS_FATAL:String = "exf";

    //----------------------------------
    //  Social
    //----------------------------------

    /**
     * Specifies the social interaction action.
     * For example on Google Plus when a user clicks the +1 button, the social action is 'plus'.
     */
    public static const SOCIAL_ACTION:String = "sa";

    /**
     * Specifies the social network, for example Facebook or Google Plus.
     */
    public static const SOCIAL_NETWORK:String = "sn";

    /**
     * Specifies the target of a social interaction. This value is typically a URL but can be any text.
     */
    public static const SOCIAL_TARGET:String = "st";

    //----------------------------------
    //  Timing
    //----------------------------------

    /**
     * TBD
     */
    public static const USER_TIMING_CATEGORY:String = "utc";

    /**
     * TBD
     */
    public static const USER_TIMING_VAR_NAME:String = "utv";

    /**
     * TBD
     */
    public static const USER_TIMING_TIME:String = "utt";

    /**
     * TBD
     */
    public static const USER_TIMING_LABEL:String = "utl";

    /**
     * TBD
     */
    public static const PAGE_LOAD_TIME:String = "plt";

    /**
     * TBD
     */
    public static const DNS_TIME:String = "dns";

    /**
     * TBD
     */
    public static const PAGE_DOWNLOAD_TIME:String = "pdt";

    /**
     * TBD
     */
    public static const REDIRECT_RESPONSE_TIME:String = "rrt";

    /**
     * TBD
     */
    public static const TCP_CONNECT_TIME:String = "tcp";

    /**
     * TBD
     */
    public static const SERVER_RESPONSE_TIME:String = "srt";

    /**
     * TBD
     */
    public static const DOM_INTERACTIVE_TIME:String = "dit";

    //----------------------------------
    //  Transaction
    //----------------------------------

    /**
     * TBD
     */
    public static const TRANSACTION_ID:String = "ti";

    //----------------------------------
    //  Experiment
    //----------------------------------

    /**
     * This parameter specifies that this user has been exposed to an experiment with the given ID.
     * It should be sent in conjunction with the Experiment Variant parameter.
     */
    public static const EXPERIMENT_ID:String = "xid";

    /**
     * This parameter specifies that this user has been exposed to a particular variation of an experiment.
     * It should be sent in conjunction with the Experiment ID parameter.
     */
    public static const EXPERIMENT_VARIANT:String = "xvar";

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function TrackerTag() {
        throw new StaticClassError();
    }
}
}
