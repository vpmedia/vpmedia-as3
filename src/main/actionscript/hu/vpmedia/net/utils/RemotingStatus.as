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
public final class RemotingStatus {

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function RemotingStatus() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Consts
    //----------------------------------

    public static const MIME_AMF:String = "application/x-amf";
    // AbstractMessage
    public static const DESTINATION_CLIENT_ID_HEADER:String = "DSDstClientId";
    public static const ENDPOINT_HEADER:String = "DSEndpoint";
    public static const FLEX_CLIENT_ID_HEADER:String = "DSId";
    public static const PRIORITY_HEADER:String = "DSPriority";
    public static const REMOTE_CREDENTIALS_HEADER:String = "DSRemoteCredentials";
    public static const REMOTE_CREDENTIALS_CHARSET_HEADER:String = "DSRemoteCredentialsCharset";
    public static const REQUEST_TIMEOUT_HEADER:String = "DSRequestTimeout";
    public static const STATUS_CODE_HEADER:String = "DSStatusCode";
    // CommandMessage
    public static const SUBSCRIBE_OPERATION:uint = 0;
    public static const UNSUBSCRIBE_OPERATION:uint = 1;
    public static const POLL_OPERATION:uint = 2;
    public static const CLIENT_SYNC_OPERATION:uint = 4;
    public static const CLIENT_PING_OPERATION:uint = 5;
    public static const CLUSTER_REQUEST_OPERATION:uint = 7;
    public static const LOGIN_OPERATION:uint = 8;
    public static const LOGOUT_OPERATION:uint = 9;
    public static const SUBSCRIPTION_INVALIDATE_OPERATION:uint = 10;
    public static const MULTI_SUBSCRIBE_OPERATION:uint = 11;
    public static const DISCONNECT_OPERATION:uint = 12;
    public static const TRIGGER_CONNECT_OPERATION:uint = 13;
    public static const UNKNOWN_OPERATION:uint = 10000;
    public static const AUTHENTICATION_MESSAGE_REF_TYPE:String = "flex.messaging.messages.AuthenticationMessage";
    public static const MESSAGING_VERSION:String = "DSMessagingVersion";
    public static const SELECTOR_HEADER:String = "DSSelector";
    public static const PRESERVE_DURABLE_HEADER:String = "DSPreserveDurable";
    public static const NEEDS_CONFIG_HEADER:String = "DSNeedsConfig";
    public static const ADD_SUBSCRIPTIONS:String = "DSAddSub";
    public static const REMOVE_SUBSCRIPTIONS:String = "DSRemSub";
    public static const SUBTOPIC_SEPARATOR:String = "_;_";
    public static const POLL_WAIT_HEADER:String = "DSPollWait";
    public static const NO_OP_POLL_HEADER:String = "DSNoOpPoll";
    public static const CREDENTIALS_CHARSET_HEADER:String = "DSCredentialsCharset";
    public static const MAX_FREQUENCY_HEADER:String = "DSMaxFrequency";
    public static const HEARTBEAT_HEADER:String = "DS<3";
    // ErrorMessage
    public static const MESSAGE_DELIVERY_IN_DOUBT:String = "Client.Error.DeliveryInDoubt";
    public static const RETRYABLE_HINT_HEADER:String = "DSRetryableErrorHint";
    // SOAPMessage
    public static const SOAP_ACTION_HEADER:String = "SOAPAction";
    public static const CONTENT_TYPE_SOAP_XML:String = "text/xml; charset=utf-8";
    // HTTPRequestMessage
    public static const CONTENT_TYPE_XML:String = "application/xml";
    public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
    public static const POST_METHOD:String = "POST";
    public static const GET_METHOD:String = "GET";
    public static const PUT_METHOD:String = "PUT";
    public static const HEAD_METHOD:String = "HEAD";
    public static const DELETE_METHOD:String = "DELETE";
    public static const OPTIONS_METHOD:String = "OPTIONS";
    public static const TRACE_METHOD:String = "TRACE";
    public static const VALID_METHODS:String = "POST,PUT,GET,HEAD,DELETE,OPTIONS,TRACE";
    public static const SAFE_METHODS:String = "POST,GET";
}
}
