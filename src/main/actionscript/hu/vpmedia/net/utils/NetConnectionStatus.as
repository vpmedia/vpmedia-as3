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
public final class NetConnectionStatus {
    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function NetConnectionStatus() {
        throw new StaticClassError();
    }

    public static const NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";

    public static const NETCONNECTION_CONNECT_FAILED:String = "NetConnection.Connect.Failed";

    public static const NETCONNECTION_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";

    public static const NETCONNECTION_CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";

    public static const NETCONNECTION_CONNECT_APPSHUTDOWN:String = "NetConnection.Connect.AppShutdown";

    public static const NETCONNECTION_CONNECT_INVALIDAPP:String = "NetConnection.Connect.InvalidApp";

    public static const NETCONNECTION_CONNECT_SECURITYERROR:String = "NetConnection.Connect.SecurityError";

    public static const NETGROUP_CONNECT_SUCCESS:String = "NetGroup.Connect.Success";

    public static const NETGROUP_CONNECT_REJECTED:String = "NetGroup.Connect.Rejected";

    public static const NETGROUP_CONNECT_FAILED:String = "NetGroup.Connect.Failed";

    public static const NETGROUP_REPLICATION_FETCH_SENDNOTIFY:String = "NetGroup.Replication.Fetch.SendNotify";

    public static const NETGROUP_REPLICATION_FETCH_FAILED:String = "NetGroup.Replication.Fetch.Failed";

    public static const NETGROUP_REPLICATION_FETCH_RESULT:String = "NetGroup.Replication.Fetch.Result";

    public static const NETGROUP_REPLICATION_FETCH_REQUEST:String = "NetGroup.Replication.Request";

    public static const NETGROUP_POSTING_NOTIFY:String = "NetGroup.Posting.Notify";

    public static const NETGROUP_NEIGHBOUR_CONNECT:String = "NetGroup.Neighbor.Connect";

    public static const NETGROUP_NEIGHBOUR_DISCONNECT:String = "NetGroup.Neighbor.Disconnect";
}
}
