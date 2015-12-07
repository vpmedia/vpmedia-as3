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

/**
 * Analytics tracker interface based on low-level Google API
 *
 * @see https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
 */
public interface ITracker {

    /**
     * Initialize tracker
     */
    function initialize(trackingID:String, clientID:String):void;

    /**
     * Page view tracker
     *
     * @param page The page path and query string of the page (e.g. /homepage?id=10). This value must start with a / character.
     * @param location URL of the page being tracked. By default, analytics.js sets this to the full document URL, excluding the fragment identifier.
     * @param title The title of the page (e.g. homepage)
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/pages
     */
    function pageView(page:String, location:String = null, title:String = null):void;

    /**
     * Event tracker
     *
     * @param category The name you supply for the group of objects you want to track.
     * @param action A string that is uniquely paired with each category, and commonly used to define the type of user interaction for the web object.
     * @param label An optional string to provide additional dimensions to the event data.
     * @param value An integer that you can use to provide numerical data about the user event.
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/events
     */
    function event(category:String, action:String, label:String, value:int):void;

    /**
     * Social tracker
     *
     * @param network The network on which the action occurs (e.g. Facebook, Twitter)
     * @param action The type of action that happens (e.g. Like, Send, Tweet).
     * @param target Specifies the target of a social interaction. This value is typically a URL but can be any text. (e.g. http://mycoolpage.com)
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/social-interactions
     */
    function social(network:String, action:String, target:String):void;

    /**
     * Exception tracker
     *
     * @param description A description of the exception.
     * @param isFatal    Indicates whether the exception was fatal. true indicates fatal.
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/exceptions
     */
    function exception(description:String, isFatal:Boolean):void;

    /**
     * Screen tracker
     *
     * @param name The name of the screen or application.
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/screens
     */
    function screenView(name:String):void;

    /**
     * App tracker
     *
     * @param name The name of the screen or application.
     * @param version The Id of the application.
     * @param id The application version.
     * @param installerId The Id of the application installer.
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/screens
     */
    function appView(name:String, version:String, id:String, installerId:String):void;

    /**
     * Timing tracker
     *
     * @param category A string for categorizing all user timing variables into logical groups (e.g jQuery).
     * @param key A string to identify the variable being recorded. (e.g. JavaScript Load).
     * @param value The number of milliseconds in elapsed time to report to Google Analytics. (e.g. 20)
     * @param label A string that can be used to add flexibility in visualizing user timings in the reports. (e.g. Google CDN)
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/user-timings
     */
    function timing(category:String, key:String, value:int, label:String = null):void;

    /**
     * Transaction tracker
     *
     * @param id
     * @param affiliation
     * @param revenue
     * @param shipping
     * @param tax
     *
     * @see https://developers.google.com/analytics/devguides/collection/analyticsjs/ecommerce
     */
    function transaction(id:String):void;

    /**
     * Sets common data key value pairs
     */
    function setData(kv:Object):void;
}
}
