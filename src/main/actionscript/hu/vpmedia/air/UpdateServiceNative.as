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
import flash.desktop.NativeApplication;
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLStream;
import flash.system.System;
import flash.utils.ByteArray;

import hu.vpmedia.utils.ObjectUtil;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The class is an AIR only helper class managing application updates.
 */
public final class UpdateServiceNative {
    //----------------------------------
    //  Private Properties
    //----------------------------------

    /**
     * URL pointing to the file with the update descriptor.
     */
    private var updateURL:String;

    /**
     * Downloaded update file
     */
    private var updateFile:File;

    /**
     * FileStream used to write update file downloaded bytes.
     */
    private var fileStream:FileStream;

    /**
     * URLStream used to download update file bytes.
     */
    private var urlStream:URLStream;

    /**
     * URLLoader used to download update xml.
     */
    private var updateDescLoader:URLLoader;

    //----------------------------------
    //  Public Properties
    //----------------------------------

    /**
     * Checked signal
     */
    public var checked:ISignal = new Signal();

    /**
     * Checking signal
     */
    public var checking:ISignal = new Signal();

    /**
     * Downloading signal
     */
    public var downloading:ISignal = new Signal();

    /**
     * Checking signal
     */
    public var progressing:ISignal = new Signal(Number);

    //----------------------------------
    //  Static Properties
    //----------------------------------

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("UpdateService");

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function UpdateServiceNative(updateURL:String) {
        this.updateURL = updateURL;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Initiates update procedure.
     */
    public function update():void {
        LOG.debug("update");
        checking.dispatch();
        updateDescLoader = new URLLoader();
        updateDescLoader.dataFormat = URLLoaderDataFormat.TEXT;
        updateDescLoader.addEventListener(Event.COMPLETE, onURLLoaderComplete, false, 0, true);
        updateDescLoader.addEventListener(IOErrorEvent.IO_ERROR, onURLLoaderIOError, false, 0, true);
        updateDescLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onURLLoaderSecurityError, false, 0, true);
        updateDescLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onURLLoaderHTTPResponse, false, 0, true);
        const request:URLRequest = new URLRequest(updateURL);
        request.method = URLRequestMethod.POST;
        updateDescLoader.load(request);
    }

    /**
     * Destroys the class objects
     */
    public function dispose():void {
        LOG.debug("dispose");
        closeURLLoader();
        closeStreams();
        ObjectUtil.dispose(this);
    }

    //----------------------------------
    //  Private methods
    //----------------------------------

    /**
     * @private
     */
    private function onURLLoaderComplete(event:Event):void {
        LOG.debug("onURLLoaderComplete");
        // Closing update descriptor loader
        closeURLLoader();
        // Getting update descriptor XML from loaded data
        const updateDescriptor:XML = XML(updateDescLoader.data);
        // Getting default namespace of update descriptor
        const udns:Namespace = updateDescriptor.namespace();
        // Getting application descriptor XML
        const applicationDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
        // Getting default namespace of application descriptor
        const adns:Namespace = applicationDescriptor.namespace();
        // Getting versionNumber from update descriptor
        const updateVersion:String = updateDescriptor.udns::versionNumber.toString();
        // Getting versionNumber from application descriptor
        const currentVersion:String = applicationDescriptor.adns::versionNumber.toString();
        // Comparing current version with update version
        if (currentVersion != updateVersion) {
            // Getting update url
            const updateUrl:String = updateDescriptor.udns::url.toString();
            // Clear XML from memory
            System.disposeXML(applicationDescriptor);
            // Downloading update file
            downloadUpdate(updateUrl);
        } else {
            checked.dispatch();
        }
    }

    /**
     * @private
     */
    private function onURLLoaderIOError(event:IOErrorEvent):void {
        LOG.warn("onURLLoaderIOError: " + event.text);
        closeURLLoader();
        checked.dispatch();
    }

    /**
     * @private
     */
    private function onURLLoaderSecurityError(event:SecurityErrorEvent):void {
        LOG.warn("onURLLoaderSecurityError: " + event.text);
        closeURLLoader();
        checked.dispatch();
    }

    /**
     * @private
     */
    private function onURLLoaderHTTPResponse(event:HTTPStatusEvent):void {
        LOG.debug("onURLLoaderHTTPResponse: " + event);
    }

    /**
     * @private
     */
    private function closeURLLoader():void {
        if (updateDescLoader) {
            updateDescLoader.removeEventListener(Event.COMPLETE, onURLLoaderComplete);
            updateDescLoader.removeEventListener(IOErrorEvent.IO_ERROR, onURLLoaderIOError);
            updateDescLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onURLLoaderSecurityError);
            updateDescLoader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onURLLoaderHTTPResponse);
            try {
                updateDescLoader.close();
            } catch (error:Error) {
                // swallow
            }
        }
    }

    /**
     * @private
     */
    private function downloadUpdate(updateUrl:String):void {
        downloading.dispatch();
        // Parsing file name out of the download url
        const fileName:String = updateUrl.substr(updateUrl.lastIndexOf("/") + 1);
        LOG.debug("downloadUpdate: " + updateUrl + " => " + fileName);
        // Creating new file ref in temp directory
        updateFile = File.createTempDirectory().resolvePath(fileName);
        // Using URLStream to download update file
        urlStream = new URLStream();
        urlStream.addEventListener(Event.OPEN, onURLStreamOpen, false, 0, true);
        urlStream.addEventListener(ProgressEvent.PROGRESS, onURLStreamProgress, false, 0, true);
        urlStream.addEventListener(Event.COMPLETE, onURLStreamComplete, false, 0, true);
        urlStream.addEventListener(IOErrorEvent.IO_ERROR, onURLStreamIOError, false, 0, true);
        urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onURLStreamSecurityError, false, 0, true);
        const request:URLRequest = new URLRequest(updateUrl);
        request.method = URLRequestMethod.POST;
        urlStream.load(request);
    }

    /**
     * @private
     */
    private function onURLStreamOpen(event:Event):void {
        // Creating new FileStream to write downloaded bytes into
        fileStream = new FileStream();
        fileStream.open(updateFile, FileMode.WRITE);
    }

    /**
     * @private
     */
    private function onURLStreamProgress(event:ProgressEvent):void {
        // ByteArray with loaded bytes
        const loadedBytes:ByteArray = new ByteArray();
        // Reading loaded bytes
        urlStream.readBytes(loadedBytes);
        // Writing loaded bytes into the FileStream
        fileStream.writeBytes(loadedBytes);
        // notify subscribers
        progressing.dispatch(event.bytesLoaded / event.bytesTotal)
    }

    /**
     * @private
     */
    private function onURLStreamComplete(event:Event):void {
        // Closing URLStream and FileStream
        closeStreams();
        // Installing update
        installUpdate();
    }

    /**
     * @private
     *
     * @see http://help.adobe.com/en_US/air/redist/WS485a42d56cd19641-70d979a8124ef20a34b-8000.html#WS485a42d56cd19641-70d979a8124ef20a34b-7ffb
     */
    private function installUpdate():void {
        LOG.debug("installUpdate");
        // Running the installer using NativeProcess API
        const info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
        //const argv:Vector.<String> = Vector.<String>(["-silent", "-eulaAccepted", "-desktopShortcut", "-programMenu", "-allowDownload"]);
        //info.arguments = argv;
        info.executable = updateFile;
        const process:NativeProcess = new NativeProcess();
        process.start(info);
        // Exit application for the installer to be able to proceed
        NativeApplication.nativeApplication.exit();
    }

    /**
     * @private
     */
    private function onURLStreamIOError(event:IOErrorEvent):void {
        LOG.warn("onURLStreamIOError: " + event.text);
        closeStreams();
        checked.dispatch();
    }

    /**
     * @private
     */
    private function onURLStreamSecurityError(event:SecurityErrorEvent):void {
        LOG.warn("onURLStreamSecurityError: " + event.text);
        closeStreams();
        checked.dispatch();
    }

    /**
     * @private
     */
    private function closeStreams():void {
        if (urlStream) {
            urlStream.removeEventListener(Event.OPEN, onURLStreamOpen);
            urlStream.removeEventListener(ProgressEvent.PROGRESS, onURLStreamProgress);
            urlStream.removeEventListener(Event.COMPLETE, onURLStreamComplete);
            urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onURLStreamIOError);
            urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onURLStreamSecurityError);
            try {
                urlStream.close();
            } catch (error:Error) {
                // swallow
            }
        }
        // Checking if FileStream was instantiated
        if (fileStream) {
            try {
                fileStream.close();
            } catch (error:Error) {
                // swallow
            }
        }
    }
}
}
