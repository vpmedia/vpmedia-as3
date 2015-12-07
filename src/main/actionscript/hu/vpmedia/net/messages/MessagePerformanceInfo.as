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
package hu.vpmedia.net.messages {
[RemoteClass(alias="flex.messaging.messages.MessagePerformanceInfo")]
public class MessagePerformanceInfo {
    public function MessagePerformanceInfo() {
        super();
    }

    public var messageSize:int;
    public var sendTime:Number = 0;
    private var _receiveTime:Number;
    public var overheadTime:Number;
    private var _infoType:String;
    public var pushedFlag:Boolean;
    public var serverPrePushTime:Number;
    public var serverPreAdapterTime:Number;
    public var serverPostAdapterTime:Number;
    public var serverPreAdapterExternalTime:Number;
    public var serverPostAdapterExternalTime:Number;
    public var recordMessageTimes:Boolean;
    public var recordMessageSizes:Boolean;

    public function set infoType(type:String):void {
        _infoType = type;
        if (_infoType == "OUT") {
            var curDate:Date = new Date();
            this._receiveTime = curDate.getTime();
        }
    }

    public function get infoType():String {
        return this._infoType;
    }

    public function set receiveTime(time:Number):void {
        // Check whether infoType is out and receiveTime would already set
        // If it is the case, we should skip the reset the receive time of the message
        if (_infoType == null || _infoType != "OUT") {
            //var curDate:Date = new Date();
            this._receiveTime = time;
        }
    }

    public function get receiveTime():Number {
        return this._receiveTime;
    }
}
}
