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
public final class NetStreamStatus {
    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    public function NetStreamStatus() {
        throw new StaticClassError();
    }

    public static const NETSTREAM_BUFFER_EMPTY:String = "NetStream.Buffer.Empty";

    public static const NETSTREAM_BUFFER_FULL:String = "NetStream.Buffer.Full";

    public static const NETSTREAM_BUFFER_FLUSH:String = "NetStream.Buffer.Flush";

    public static const NETSTREAM_FAILED:String = "NetStream.Failed";

    public static const NETSTREAM_PUBLISH_START:String = "NetStream.Publish.Start";

    public static const NETSTREAM_PUBLISH_BADNAME:String = "NetStream.Publish.BadName";

    public static const NETSTREAM_PUBLISH_IDLE:String = "NetStream.Publish.Idle";

    public static const NETSTREAM_UNPUBLISH_SUCCESS:String = "NetStream.Unpublish.Success";

    public static const NETSTREAM_PLAY_START:String = "NetStream.Play.Start";

    public static const NETSTREAM_PLAY_STOP:String = "NetStream.Play.Stop";

    public static const NETSTREAM_PLAY_FAILED:String = "NetStream.Play.Failed";

    public static const NETSTREAM_PLAY_STREAMNOTFOUND:String = "NetStream.Play.StreamNotFound";

    public static const NETSTREAM_PLAY_RESET:String = "NetStream.Play.Reset";

    public static const NETSTREAM_PLAY_PUBLISHNOTIFY:String = "NetStream.Play.PublishNotify";

    public static const NETSTREAM_PLAY_UNPUBLISHNOTIFY:String = "NetStream.Play.UnpublishNotify";

    public static const NETSTREAM_PLAY_INSUFFICIENTBW:String = "NetStream.Play.InsufficientBW";

    public static const NETSTREAM_PLAY_FILESTRUCTUREINVALID:String = "NetStream.Play.FileStructureInvalid";

    public static const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:String = "NetStream.Play.NoSupportedTrackFound";

    public static const NETSTREAM_PLAY_TRANSITION:String = "NetStream.Play.Transition";

    public static const NETSTREAM_PAUSE_NOTIFY:String = "NetStream.Pause.Notify";

    public static const NETSTREAM_UNPAUSE_NOTIFY:String = "NetStream.Unpause.Notify";

    public static const NETSTREAM_RECORD_START:String = "NetStream.Record.Start";

    public static const NETSTREAM_RECORD_NOACCESS:String = "NetStream.Record.NoAccess";

    public static const NETSTREAM_RECORD_STOP:String = "NetStream.Record.Stop";

    public static const NETSTREAM_RECORD_FAILED:String = "NetStream.Record.Failed";

    public static const NETSTREAM_SEEK_FAILED:String = "NetStream.Seek.Failed";

    public static const NETSTREAM_SEEK_INVALIDTIME:String = "NetStream.Seek.InvalidTime";

    public static const NETSTREAM_SEEK_NOTIFY:String = "NetStream.Seek.Notify";

    public static const NETSTREAM_CONNECT_CLOSED:String = "NetStream.Connect.Closed";

    public static const NETSTREAM_CONNECT_FAILED:String = "NetStream.Connect.Failed";

    public static const NETSTREAM_CONNECT_SUCCESS:String = "NetStream.Connect.Success";

    public static const NETSTREAM_CONNECT_REJECTED:String = "NetStream.Connect.Rejected";
}
}
