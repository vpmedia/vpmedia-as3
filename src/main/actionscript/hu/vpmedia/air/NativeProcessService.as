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
package hu.vpmedia.air {

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.utils.IDataInput;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * NativeProcess runner service
 */
public class NativeProcessService {

    /**
     * @private
     */
    public var completed:ISignal = new Signal(String);

    /**
     * @private
     */
    public var failed:ISignal = new Signal(String);

    /**
     * @private
     */
    private var process:NativeProcess;

    /**
     * @private
     */
    private var exePath:String;

    /**
     * @private
     */
    private var exeFile:File;

    /**
     * @private
     */
    private var nextArgs:Vector.<Vector.<String>>;

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("NativeProcessService");

    /**
     * @private
     */
    public function NativeProcessService(exePath:String) {
        this.exePath = exePath;
        exeFile = File.applicationDirectory.resolvePath(this.exePath);
    }

    /**
     * @private
     */
    public function start(args:Vector.<String> = null):void {
        if (!args) {
            args = new Vector.<String>();
        }
        if (process && process.running) {
            LOG.debug("queue: " + args);
            if (!nextArgs) {
                nextArgs = new Vector.<Vector.<String>>();
            }
            nextArgs.push(args);
        } else {
            LOG.debug("start: " + args);
            const startup:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            startup.executable = exeFile;
            startup.workingDirectory = File.applicationDirectory;
            startup.arguments = args;
            process = new NativeProcess();
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData, false, 0, true);
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onError, false, 0, true);
            process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError, false, 0, true);
            process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, onIOError, false, 0, true);
            process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError, false, 0, true);
            process.start(startup);
        }
    }

    /**
     * @private
     */
    public function dispose():void {
        if (process) {
            process.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            process.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, onError);
            process.removeEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
            process.removeEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, onIOError);
            process.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            process.exit(true);
            process = null;
        }
    }

    /**
     * @private
     */
    private function postProcess():void {
        dispose();
        if (nextArgs && nextArgs.length) {
            start(nextArgs.shift());
        }
    }

    /**
     * @private
     */
    private function onError(event:Event):void {
        const bytes:IDataInput = process.standardError;
        const data:String = bytes.readUTFBytes(process.standardOutput.bytesAvailable);
        failed.dispatch(data);
        postProcess();
    }

    /**
     * @private
     */
    private function onIOError(event:IOErrorEvent):void {
        failed.dispatch(event.text);
        postProcess();
    }

    /**
     * @private
     */
    private function onOutputData(event:ProgressEvent):void {
        const bytes:IDataInput = process.standardOutput;
        const data:String = bytes.readUTFBytes(process.standardOutput.bytesAvailable);
        completed.dispatch(data);
        postProcess();
    }
}
}
